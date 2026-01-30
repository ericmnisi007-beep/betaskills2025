import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type, ik-appid, ik-sign',
}

interface IKhokhaWebhookPayload {
  paylinkID: string
  status: string // SUCCESS or FAILURE
  externalTransactionID: string
  responseCode: string
}

// Verify iKhokha webhook signature
async function verifySignature(
  appId: string,
  signature: string,
  requestBody: string,
  appSecret: string
): Promise<boolean> {
  const encoder = new TextEncoder()
  const keyData = encoder.encode(appSecret)
  const dataToSign = encoder.encode('/api/ikhokha-webhook' + requestBody)
  
  const key = await crypto.subtle.importKey(
    'raw',
    keyData,
    { name: 'HMAC', hash: 'SHA-256' },
    false,
    ['sign']
  )
  
  const expectedSignature = await crypto.subtle.sign('HMAC', key, dataToSign)
  const hashArray = Array.from(new Uint8Array(expectedSignature))
  const expectedHex = hashArray.map(b => b.toString(16).padStart(2, '0')).join('')
  
  return expectedHex === signature
}

serve(async (req) => {
  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const IKHOKHA_APP_ID = Deno.env.get('IKHOKHA_APPLICATION_ID')
    const IKHOKHA_APP_SECRET = Deno.env.get('IKHOKHA_APPLICATION_SECRET')

    if (!IKHOKHA_APP_ID || !IKHOKHA_APP_SECRET) {
      throw new Error('iKhokha credentials not configured')
    }

    // Get headers
    const ikAppId = req.headers.get('ik-appid')
    const ikSign = req.headers.get('ik-sign')

    // Get request body
    const requestBody = await req.text()
    const webhookPayload: IKhokhaWebhookPayload = JSON.parse(requestBody)

    console.log('Webhook received:', webhookPayload)
    console.log('Headers - IK-APPID:', ikAppId, 'IK-SIGN:', ikSign)

    // Verify the webhook signature
    if (ikAppId !== IKHOKHA_APP_ID) {
      console.error('Invalid App ID')
      return new Response('Invalid App ID', { status: 401 })
    }

    if (!ikSign || !(await verifySignature(ikAppId, ikSign, requestBody, IKHOKHA_APP_SECRET))) {
      console.error('Invalid signature')
      return new Response('Invalid signature', { status: 401 })
    }

    // Initialize Supabase client
    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    // Update payment status in database
    const paymentStatus = webhookPayload.status === 'SUCCESS' ? 'completed' : 'failed'
    
    const { data: payment, error: paymentError } = await supabaseClient
      .from('payments')
      .update({
        status: paymentStatus,
        gateway_response: webhookPayload,
        updated_at: new Date().toISOString()
      })
      .eq('transaction_reference', webhookPayload.externalTransactionID)
      .select()
      .single()

    if (paymentError) {
      console.error('Error updating payment:', paymentError)
      return new Response('Error updating payment', { status: 500 })
    }

    // If payment successful, auto-approve enrollment
    if (webhookPayload.status === 'SUCCESS' && payment) {
      console.log('Payment successful, updating enrollment for course:', payment.course_id)
      
      // Find and approve the enrollment
      const { error: enrollmentError } = await supabaseClient
        .from('enrollments')
        .update({
          status: 'approved',
          payment_status: 'completed',
          payment_method: 'card',
          updated_at: new Date().toISOString()
        })
        .eq('user_id', payment.user_id)
        .eq('course_id', payment.course_id)
        .eq('status', 'pending')

      if (enrollmentError) {
        console.error('Error updating enrollment:', enrollmentError)
      } else {
        console.log('Enrollment approved successfully')
      }
    }

    return new Response(
      JSON.stringify({ 
        success: true, 
        message: 'Webhook processed successfully' 
      }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 200
      }
    )
  } catch (error) {
    console.error('Webhook processing error:', error)
    
    return new Response(
      JSON.stringify({
        success: false,
        error: 'WEBHOOK_ERROR',
        message: error.message || 'An error occurred processing webhook'
      }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 500
      }
    )
  }
})

