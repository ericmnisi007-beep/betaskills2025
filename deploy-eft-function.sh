#!/bin/bash

# Deploy EFT Enrollment Edge Function to Supabase
echo "🚀 Deploying EFT Enrollment Edge Function..."

# Check if supabase CLI is installed
if ! command -v supabase &> /dev/null; then
    echo "❌ Supabase CLI not found. Please install it first:"
    echo "npm install -g supabase"
    exit 1
fi

# Deploy the function
echo "📦 Deploying submit-eft-enrollment function..."
supabase functions deploy submit-eft-enrollment --no-verify-jwt

if [ $? -eq 0 ]; then
    echo "✅ Edge Function deployed successfully!"
    echo ""
    echo "🧪 To test the function, run:"
    echo "node test-eft-enrollment.js"
    echo ""
    echo "📝 Make sure to set your SUPABASE_URL and SUPABASE_ANON_KEY environment variables."
else
    echo "❌ Deployment failed!"
    exit 1
fi
