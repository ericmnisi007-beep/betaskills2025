import { corsHeaders } from '../_shared/cors.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

Deno.serve(async (req) => {
  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // Create a Supabase client with the admin role
    const supabaseAdmin = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    if (req.method === 'POST') {
      const body = await req.json().catch(() => ({} as any));
      const enrollmentId = body?.enrollmentId;
      const status = body?.status;

      // Student progress update (used by UI to persist progress for admin monitoring)
      const courseId = body?.courseId;
      const progressRaw = body?.progress;

      if (enrollmentId && status) {
        const nextStatus = String(status).toLowerCase();
        if (nextStatus !== 'approved' && nextStatus !== 'rejected' && nextStatus !== 'pending') {
          return new Response(JSON.stringify({ error: 'Invalid status' }), {
            headers: { ...corsHeaders, 'Content-Type': 'application/json' },
            status: 400,
          })
        }

        const patch = {
          status: nextStatus,
          approved_at: nextStatus === 'approved' ? new Date().toISOString() : null,
        };

        const [lowerResp, upperResp] = await Promise.all([
          supabaseAdmin.from('enrollments').update(patch).eq('id', enrollmentId).select('*').maybeSingle(),
          supabaseAdmin.from('Enrollment').update(patch).eq('id', enrollmentId).select('*').maybeSingle(),
        ]);

        if (lowerResp.error && upperResp.error) {
          throw (lowerResp.error || upperResp.error)
        }

        return new Response(
          JSON.stringify({
            success: true,
            enrollment: lowerResp.data || upperResp.data || null,
          }),
          {
            headers: { ...corsHeaders, 'Content-Type': 'application/json' },
            status: 200,
          }
        )
      }

      // Progress update path: requires authenticated user JWT
      if (courseId && (progressRaw === 0 || progressRaw)) {
        const authHeader = req.headers.get('authorization') || req.headers.get('Authorization') || '';
        const token = authHeader.toLowerCase().startsWith('bearer ')
          ? authHeader.slice(7)
          : authHeader;

        if (!token) {
          return new Response(JSON.stringify({ error: 'Missing auth token' }), {
            headers: { ...corsHeaders, 'Content-Type': 'application/json' },
            status: 401,
          })
        }

        const userResp = await supabaseAdmin.auth.getUser(token);
        const user = userResp.data?.user || null;
        if (userResp.error || !user) {
          return new Response(JSON.stringify({ error: 'Invalid auth token' }), {
            headers: { ...corsHeaders, 'Content-Type': 'application/json' },
            status: 401,
          })
        }

        const pNum = Number(progressRaw);
        const p = Number.isFinite(pNum) ? Math.max(0, Math.min(100, Math.round(pNum))) : 0;
        const cid = String(courseId);

        // Update enrollments progress (authoritative for many dashboards)
        const patch = {
          progress: p,
          updated_at: new Date().toISOString(),
        };

        const [lowerProgressResp, upperProgressResp] = await Promise.all([
          supabaseAdmin.from('enrollments').update(patch).eq('user_id', user.id).eq('course_id', cid).select('*').maybeSingle(),
          supabaseAdmin.from('Enrollment').update(patch).eq('user_id', user.id).eq('course_id', cid).select('*').maybeSingle(),
        ]);

        // Best-effort also write to user_progress if table exists
        try {
          await supabaseAdmin
            .from('user_progress')
            .upsert(
              {
                user_id: user.id,
                course_id: cid,
                progress_percentage: p,
                last_visited: new Date().toISOString(),
                updated_at: new Date().toISOString(),
              },
              { onConflict: 'user_id,course_id' }
            );
        } catch {
          // ignore
        }

        if (lowerProgressResp.error && upperProgressResp.error) {
          return new Response(JSON.stringify({ error: 'Failed to update progress' }), {
            headers: { ...corsHeaders, 'Content-Type': 'application/json' },
            status: 400,
          })
        }

        return new Response(
          JSON.stringify({
            success: true,
            progress: p,
            enrollment: lowerProgressResp.data || upperProgressResp.data || null,
          }),
          {
            headers: { ...corsHeaders, 'Content-Type': 'application/json' },
            status: 200,
          }
        )
      }
    }

    // Fetch profiles and pending enrollments in parallel (from both potential tables)
    const [profilesResponse, lowerEnrollResp, upperEnrollResp, lowerAllResp, upperAllResp] = await Promise.all([
      supabaseAdmin.from('profiles').select('*').order('created_at', { ascending: false }).limit(100),
      supabaseAdmin.from('enrollments').select('*').eq('status', 'pending').order('enrolled_at', { ascending: false }).limit(50),
      supabaseAdmin.from('Enrollment').select('*').eq('status', 'pending').order('enrolled_at', { ascending: false }).limit(50),
      supabaseAdmin.from('enrollments').select('*').order('enrolled_at', { ascending: false }).limit(100),
      supabaseAdmin.from('Enrollment').select('*').order('enrolled_at', { ascending: false }).limit(100)
    ]);

    if (profilesResponse.error) throw profilesResponse.error;
    if (lowerEnrollResp.error && upperEnrollResp.error) throw (lowerEnrollResp.error || upperEnrollResp.error);

    if (lowerAllResp.error && upperAllResp.error) throw (lowerAllResp.error || upperAllResp.error);

    const mergedPending = [
      ...(lowerEnrollResp.data ?? []),
      ...(upperEnrollResp.data ?? [])
    ];

    const mergedAll = [
      ...(lowerAllResp.data ?? []),
      ...(upperAllResp.data ?? [])
    ];

    // Enrich enrollments with true course progress (same source as student UI)
    // Prefer user_progress.progress_percentage when available.
    try {
      const userIds = Array.from(
        new Set((mergedAll ?? []).map((e: any) => e?.user_id).filter(Boolean).map((x: any) => String(x)))
      );
      if (userIds.length > 0) {
        const progressResp = await supabaseAdmin
          .from('user_progress')
          .select('user_id, course_id, progress_percentage')
          .in('user_id', userIds)
          .limit(2000);

        const progressRows = progressResp.data ?? [];
        const progressMap = new Map<string, number>();
        for (const r of progressRows as any[]) {
          const uid = String((r as any)?.user_id || '');
          const cid = String((r as any)?.course_id || '');
          if (!uid || !cid) continue;
          const n = Number((r as any)?.progress_percentage ?? 0);
          if (!Number.isFinite(n)) continue;
          progressMap.set(`${uid}::${cid}`, Math.max(0, Math.min(100, Math.round(n))));
        }

        for (const e of mergedAll as any[]) {
          const uid = String((e as any)?.user_id || '');
          const cid = String((e as any)?.course_id || '');
          if (!uid || !cid) continue;
          const p = progressMap.get(`${uid}::${cid}`);
          if (typeof p === 'number') {
            (e as any).progress = p;
            (e as any).progress_percentage = p;
          }
        }
      }
    } catch {
      // Non-fatal: if progress tables are unavailable, return enrollments as-is
    }

    const data = {
      users: profilesResponse.data,
      enrollments: mergedAll,
      pendingEnrollments: mergedPending,
    };

    return new Response(JSON.stringify(data), {
      headers: { 
        ...corsHeaders, 
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
        'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type'
      },
      status: 200,
    })
  } catch (error) {
    const message = (error as any)?.message || String(error)
    return new Response(JSON.stringify({ error: message }), {
      headers: { 
        ...corsHeaders, 
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
        'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type'
      },
      status: 400,
    })
  }
})