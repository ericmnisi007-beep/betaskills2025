# 🗄️ Database Deployment Instructions

## ⚠️ Supabase CLI Not Found

The Supabase CLI is not installed on this system. Here are the options to deploy the database changes:

## 🚀 **Option 1: Install Supabase CLI (Recommended)**

### Install via npm:
```bash
npm install -g supabase
```

### Install via Chocolatey (Windows):
```bash
choco install supabase
```

### Install via Scoop (Windows):
```bash
scoop bucket add supabase https://github.com/supabase/scoop-bucket.git
scoop install supabase
```

### Then run the migration:
```bash
supabase db push
```

## 🔧 **Option 2: Manual Database Deployment**

If you can't install the CLI, you can manually apply the migration:

### 1. Access Supabase Dashboard
- Go to your Supabase project dashboard
- Navigate to the SQL Editor

### 2. Execute the Migration SQL
Copy and paste the contents of `supabase/migrations/20241009000000_create_payment_transactions_table.sql` into the SQL Editor and execute it.

### Migration File Location:
```
supabase/migrations/20241009000000_create_payment_transactions_table.sql
```

### Key Tables Created:
- ✅ `payment_transactions` - Main transaction logging table
- ✅ Indexes for efficient querying
- ✅ Row Level Security (RLS) policies
- ✅ Triggers for automatic updates
- ✅ Utility functions for statistics and cleanup

## 🎯 **Option 3: Deploy via Supabase Dashboard**

### 1. Go to Database → Migrations
- Upload the migration file directly
- Or copy/paste the SQL content

### 2. Apply Migration
- Execute the migration in the dashboard
- Verify tables are created successfully

## ✅ **Verification Steps**

After applying the migration, verify:

### 1. Check Tables Exist:
```sql
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name = 'payment_transactions';
```

### 2. Check Indexes:
```sql
SELECT indexname 
FROM pg_indexes 
WHERE tablename = 'payment_transactions';
```

### 3. Check RLS Policies:
```sql
SELECT policyname, cmd, roles 
FROM pg_policies 
WHERE tablename = 'payment_transactions';
```

## 🔒 **Security Verification**

Ensure these security features are active:
- ✅ Row Level Security enabled
- ✅ User access policies in place
- ✅ Admin access policies configured
- ✅ Data encryption at rest

## 📊 **Test the Migration**

After deployment, test with:

```sql
-- Test insert (should work for authenticated users)
INSERT INTO payment_transactions (
  transaction_id, 
  reference_number, 
  user_id, 
  user_email, 
  course_id, 
  course_title, 
  amount, 
  currency
) VALUES (
  'test_txn_123',
  'REF_123',
  auth.uid(),
  'test@example.com',
  'test_course',
  'Test Course',
  100.00,
  'ZAR'
);

-- Test statistics function
SELECT * FROM get_payment_transaction_stats();
```

## 🎉 **Next Steps After Database Deployment**

Once the database migration is complete:

1. **Verify Application Build**:
   ```bash
   npm run build
   ```

2. **Deploy Application**:
   ```bash
   # Use your deployment method
   netlify deploy --prod
   # OR vercel --prod
   # OR your custom deployment
   ```

3. **Set Environment Variables** in your hosting platform:
   ```bash
   VITE_IKHOKHA_API_KEY=your_production_key
   VITE_IKHOKHA_API_SECRET=your_production_secret
   VITE_IKHOKHA_WEBHOOK_SECRET=your_webhook_secret
   VITE_NODE_ENV=production
   ```

4. **Test Payment System**:
   - Verify strict validation is active
   - Test with real card numbers
   - Check transaction logging
   - Confirm audit trails

## 🆘 **Need Help?**

If you encounter issues:
1. Check Supabase project logs
2. Verify database connection
3. Ensure proper permissions
4. Contact support if needed

---

**The production payment validation fix is ready to deploy once the database migration is applied!** 🚀