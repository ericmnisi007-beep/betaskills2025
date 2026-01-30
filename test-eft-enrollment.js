// Test script to verify the EFT enrollment Edge Function
import { createClient } from '@supabase/supabase-js';

// Configuration
const SUPABASE_URL = 'https://jpafcmixtchvtrkhltst.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpwYWZjbWl4dGNodnRya2hsdHN0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTM1MzIzODYsImV4cCI6MjA2OTEwODM4Nn0.dR0-DW8_ekftD9DZjGutGuyh4kiPG338NQ367tC8Pcw';

const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

async function testEFTEnrollment() {
  console.log('🧪 Testing EFT Enrollment Edge Function...');
  
  const testPayload = {
    userId: '00000000-0000-0000-0000-000000000001',
    userEmail: 'test@example.com',
    courseId: '00000000-0000-0000-0000-000000000001',
    courseTitle: 'Test Course',
    paymentRef: 'TEST-REF-001',
    proofOfPayment: 'https://example.com/proof.jpg',
    paymentDate: '2026-01-26',
    notes: 'Test enrollment',
    transactionId: 'TEST-REF-001'
  };

  try {
    console.log('📤 Sending test payload:', testPayload);
    
    const { data, error } = await supabase.functions.invoke('submit-eft-enrollment', {
      body: testPayload,
    });

    if (error) {
      console.error('❌ Edge Function Error:', error);
      // Try to get more details from the error context
      if (error.context && error.context.body) {
        const reader = error.context.body.getReader();
        const text = await reader.read();
        console.error('❌ Response body:', new TextDecoder().decode(text.value || new Uint8Array()));
      }
      return false;
    }

    console.log('✅ Success Response:', data);
    return true;
  } catch (error) {
    console.error('❌ Test Failed:', error);
    return false;
  }
}

// Run the test
testEFTEnrollment().then(success => {
  console.log(success ? '🎉 Test passed!' : '💥 Test failed!');
  process.exit(success ? 0 : 1);
});
