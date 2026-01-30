# Deploy EFT Enrollment Edge Function to Supabase (PowerShell)
Write-Host "🚀 Deploying EFT Enrollment Edge Function..." -ForegroundColor Green

# Check if supabase CLI is installed
try {
    $null = Get-Command supabase -ErrorAction Stop
} catch {
    Write-Host "❌ Supabase CLI not found. Please install it first:" -ForegroundColor Red
    Write-Host "npm install -g supabase" -ForegroundColor Yellow
    exit 1
}

# Deploy the function
Write-Host "📦 Deploying submit-eft-enrollment function..." -ForegroundColor Blue
$deployResult = supabase functions deploy submit-eft-enrollment --no-verify-jwt

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Edge Function deployed successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "🧪 To test the function, run:" -ForegroundColor Cyan
    Write-Host "node test-eft-enrollment.js" -ForegroundColor White
    Write-Host ""
    Write-Host "📝 Make sure to set your SUPABASE_URL and SUPABASE_ANON_KEY environment variables." -ForegroundColor Yellow
} else {
    Write-Host "❌ Deployment failed!" -ForegroundColor Red
    exit 1
}
