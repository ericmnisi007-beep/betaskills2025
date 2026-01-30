import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { corsHeaders } from '../_shared/cors.ts'

interface EnrollmentData {
  userId: string;
  userEmail: string;
  courseId: string;
  courseTitle?: string;
  paymentRef: string;
  proofOfPayment?: string;
  paymentDate?: string;
  notes?: string;
  transactionId?: string;
}

Deno.serve(async (req) => {
  // This is needed if you're deploying functions from a browser.
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    const body: EnrollmentData = await req.json();
    
    const userId = String(body.userId || '').trim();
    const userEmail = String(body.userEmail || '').trim();
    const courseId = String(body.courseId || '').trim();
    const courseTitle = String(body.courseTitle || courseId || 'Course').trim();
    const paymentRef = String(body.paymentRef || '').trim();

    if (!userId || !courseId) {
      throw new Error('Missing required fields userId or courseId');
    }

    // The admin client has the service_role key and bypasses RLS.
    const supabaseAdmin = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    );

    // First, check if a pending enrollment already exists to prevent duplicates.
    const { data: existing, error: existingError } = await supabaseAdmin
      .from('enrollments')
      .select('*')
      .eq('user_id', userId)
      .eq('course_id', courseId)
      .eq('status', 'pending')
      .limit(1);

    if (existingError) {
      console.error('Edge Function: Error checking for existing enrollment.', existingError);
      throw existingError;
    }

    if (existing && existing.length > 0) {
      console.warn('Edge Function: A pending enrollment already exists.', { userId, courseId });
      // Return the existing enrollment to indicate success without creating a duplicate.
      return new Response(JSON.stringify({ success: true, enrollment: existing[0] }), {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 200,
      });
    }

    // Insert the new pending enrollment record with all required fields.
    const insertPayload = {
      user_id: userId,
      user_email: userEmail || null,
      course_id: courseId,
      course_title: courseTitle,
      status: 'pending',
      enrolled_at: new Date().toISOString(),
      progress: 0,
      payment_ref: paymentRef || null,
      payment_method: 'eft',
      proof_of_payment: body.proofOfPayment || null,
      payment_date: body.paymentDate || null,
    };

    const { data: newEnrollment, error: insertError } = await supabaseAdmin
      .from('enrollments')
      .insert(insertPayload)
      .select()
      .single();

    if (insertError) {
      console.error('Edge Function: CRITICAL - Failed to insert enrollment.', insertError);
      throw insertError;
    }

    console.log('✅ EFT Enrollment created successfully:', newEnrollment);
    console.log('🔍 Enrollment status being written:', newEnrollment?.status);
    console.log('🔍 Enrollment row keys:', Object.keys(newEnrollment || {}));

    return new Response(JSON.stringify({ success: true, enrollment: newEnrollment }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 200,
    });
  } catch (error: any) {
    console.error('❌ Edge Function Error:', error);
    return new Response(JSON.stringify({ error: error.message || String(error) }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 400,
    });
  }
});
