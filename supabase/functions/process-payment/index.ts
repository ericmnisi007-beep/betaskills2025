import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

interface PaymentLinkRequest {
  amount: number
  currency: string
  description: string
  customer_email: string
  customer_name: string
  course_id: string
  user_id: string
}

// Escape string for signature generation (matches iKhokha's format)
function jsStringEscape(str: string): string {
  return str.replace(/[\\"']/g, '\\$&').replace(/\u0000/g, '\\0')
}

// Generate HMAC SHA256 signature for iKhokha API
async function generateSignature(path: string, requestBody: string, appSecret: string): Promise<string> {
  // Create payload to sign: path + escaped JSON body
  const payloadToSign = jsStringEscape(path + requestBody)
  
  const encoder = new TextEncoder()
  const keyData = encoder.encode(appSecret)
  const dataToSign = encoder.encode(payloadToSign)
  
  const key = await crypto.subtle.importKey(
    'raw',
    keyData,
    { name: 'HMAC', hash: 'SHA-256' },
    false,
    ['sign']
  )
  
  const signature = await crypto.subtle.sign('HMAC', key, dataToSign)
  const hashArray = Array.from(new Uint8Array(signature))
  const hashHex = hashArray.map(b => b.toString(16).padStart(2, '0')).join('')
  
  return hashHex
}

serve(async (req) => {
  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const paymentRequest: PaymentLinkRequest = await req.json()
    
    console.log('Creating iKhokha payment link for:', paymentRequest.customer_email)

    // iKhokha API Configuration
    const IKHOKHA_API_ENDPOINT = Deno.env.get('IKHOKHA_API_ENDPOINT') || 'https://api.ikhokha.com'
    const IKHOKHA_APP_ID = Deno.env.get('IKHOKHA_APPLICATION_ID')
    const IKHOKHA_APP_SECRET = Deno.env.get('IKHOKHA_APPLICATION_SECRET')
    const BASE_URL = Deno.env.get('BASE_URL') || 'https://betaskilltraining.netlify.app'

    if (!IKHOKHA_APP_ID || !IKHOKHA_APP_SECRET) {
      throw new Error('iKhokha credentials not configured')
    }

    // Generate unique transaction ID
    const externalTransactionID = `SKILL-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`

    // Create payment link request payload - exact format from iKhokha docs
    const ikhokhaPayload = {
      entityID: IKHOKHA_APP_ID,
      externalEntityID: paymentRequest.user_id,
      amount: Math.round(paymentRequest.amount * 100), // Convert to cents
      currency: 'ZAR',
      requesterUrl: BASE_URL,
      mode: 'live',
      description: paymentRequest.description,
      externalTransactionID: externalTransactionID,
      urls: {
        callbackUrl: `${Deno.env.get('SUPABASE_URL')}/functions/v1/ikhokha-webhook`,
        successPageUrl: `${BASE_URL}/payment-success?course=${paymentRequest.course_id}&ref=${externalTransactionID}`,
        failurePageUrl: `${BASE_URL}/payment-failed?course=${paymentRequest.course_id}`,
        cancelUrl: `${BASE_URL}/courses/${paymentRequest.course_id}`
      }
    }

    const requestBodyString = JSON.stringify(ikhokhaPayload)
    const path = '/public-api/v1/api/payment'
    
    // Generate signature
    const signature = await generateSignature(path, requestBodyString, IKHOKHA_APP_SECRET)

    console.log('Request payload:', requestBodyString)
    console.log('Signature generated:', signature.substring(0, 10) + '...')
    console.log('Calling iKhokha API:', `${IKHOKHA_API_ENDPOINT}${path}`)

    // Call iKhokha Payment Link API with timeout
    const controller = new AbortController()
    const timeoutId = setTimeout(() => controller.abort(), 25000) // 25 second timeout

    let ikhokhaResponse
    try {
      ikhokhaResponse = await fetch(`${IKHOKHA_API_ENDPOINT}${path}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'IK-APPID': IKHOKHA_APP_ID,
          'IK-SIGN': signature,
          'Accept': 'application/json'
        },
        body: requestBodyString,
        signal: controller.signal
      })
    } catch (fetchError: any) {
      clearTimeout(timeoutId)
      console.error('iKhokha API fetch error:', fetchError)
      throw new Error(`Failed to connect to iKhokha: ${fetchError.message}`)
    }
    clearTimeout(timeoutId)

    console.log('iKhokha Response Status:', ikhokhaResponse.status)
    
    let ikhokhaResult
    try {
      ikhokhaResult = await ikhokhaResponse.json()
    } catch (jsonError) {
      console.error('Failed to parse iKhokha response as JSON')
      const textResponse = await ikhokhaResponse.text()
      console.error('Raw response:', textResponse)
      throw new Error('Invalid response from iKhokha')
    }

    console.log('iKhokha Response:', JSON.stringify(ikhokhaResult, null, 2))

    // Log full response for debugging
    console.log('Full iKhokha response:', {
      status: ikhokhaResponse.status,
      statusText: ikhokhaResponse.statusText,
      headers: Object.fromEntries(ikhokhaResponse.headers.entries()),
      body: ikhokhaResult
    })

    // Check if payment link was created successfully
    if (ikhokhaResponse.ok && ikhokhaResult.responseCode === '00') {
      // Store pending payment in database
      const supabaseClient = createClient(
        Deno.env.get('SUPABASE_URL') ?? '',
        Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
      )

      const { error: dbError } = await supabaseClient
        .from('payments')
        .insert({
          user_id: paymentRequest.user_id,
          course_id: paymentRequest.course_id,
          amount: paymentRequest.amount,
          currency: 'ZAR',
          status: 'pending',
          payment_method: 'card',
          transaction_reference: externalTransactionID,
          payment_gateway: 'ikhokha',
          gateway_response: ikhokhaResult
        })

      if (dbError) {
        console.error('Database error:', dbError)
      }

      return new Response(
        JSON.stringify({
          success: true,
          payment_link_url: ikhokhaResult.paylinkUrl,
          payment_link_id: ikhokhaResult.paylinkID,
          transaction_reference: externalTransactionID,
          message: 'Payment link created successfully'
        }),
        {
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
          status: 200
        }
      )
    } else {
      // Payment link creation failed
      const errorMessage = ikhokhaResult.message || 'Failed to create payment link'
      
      console.error('Payment link creation failed:', errorMessage)
      console.error('Full error details:', ikhokhaResult)

      return new Response(
        JSON.stringify({
          success: false,
          error: 'PAYMENT_LINK_FAILED',
          message: errorMessage,
          response_code: ikhokhaResult.responseCode,
          details: ikhokhaResult
        }),
        {
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
          status: 200
        }
      )
    }
  } catch (error) {
    console.error('Payment link creation error:', error)
    
    return new Response(
      JSON.stringify({
        success: false,
        error: 'PROCESSING_ERROR',
        message: error.message || 'An error occurred while creating payment link',
        details: error.toString()
      }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 500
      }
    )
  }
})

