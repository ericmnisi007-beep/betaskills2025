-- EMERGENCY FIX: Disable RLS for Admin Dashboard Access
-- Run this in Supabase SQL Editor (https://supabase.com/dashboard)
-- Go to: SQL Editor > New Query > Paste this > Run

-- Step 1: Disable RLS on enrollments table
ALTER TABLE enrollments DISABLE ROW LEVEL SECURITY;

-- Step 2: Disable RLS on profiles table  
ALTER TABLE profiles DISABLE ROW LEVEL SECURITY;

-- Step 3: Verify RLS is disabled
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public' 
AND tablename IN ('enrollments', 'profiles');

-- Expected output: rowsecurity should be 'false' for both tables

-- ALTERNATIVE: If you want to keep RLS but allow admin access, use these policies instead:
-- (Only run these if you DON'T want to disable RLS completely)

-- DROP POLICY IF EXISTS "Admin full access enrollments" ON enrollments;
-- CREATE POLICY "Admin full access enrollments" ON enrollments FOR ALL USING (true) WITH CHECK (true);

-- DROP POLICY IF EXISTS "Admin full access profiles" ON profiles;
-- CREATE POLICY "Admin full access profiles" ON profiles FOR ALL USING (true) WITH CHECK (true);
