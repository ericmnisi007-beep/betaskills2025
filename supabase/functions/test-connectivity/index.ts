import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const results: Record<string, any> = {}

    // Test general outbound connectivity
    const httpbinStart = Date.now()
    const httpbin = await fetch('https://httpbin.org/get')
    results.httpbin = {
      status: httpbin.status,
      durationMs: Date.now() - httpbinStart
    }

    // Test DNS and TLS handshake to iKhokha root
    const ikhStart = Date.now()
    let ikhStatus = 0
    let ikhError: string | undefined
    try {
      const ikh = await fetch('https://api.ikhokha.com', { method: 'GET' })
      ikhStatus = ikh.status
    } catch (e: any) {
      ikhError = e?.message || String(e)
    }
    results.ikhokha_root = {
      status: ikhStatus,
      error: ikhError,
      durationMs: Date.now() - ikhStart
    }

    // Test payment endpoint reachability (no body)
    const endpStart = Date.now()
    let endpStatus = 0
    let endpError: string | undefined
    try {
      const resp = await fetch('https://api.ikhokha.com/public-api/v1/api/payment', { method: 'POST', body: '{}' })
      endpStatus = resp.status
    } catch (e: any) {
      endpError = e?.message || String(e)
    }
    results.ikhokha_payment_endpoint = {
      status: endpStatus,
      error: endpError,
      durationMs: Date.now() - endpStart
    }

    return new Response(JSON.stringify({ success: true, results }, null, 2), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 200
    })
  } catch (error: any) {
    return new Response(JSON.stringify({ success: false, message: error?.message || String(error) }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 500
    })
  }
})
