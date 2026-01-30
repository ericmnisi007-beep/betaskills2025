-- QUICK FIX: Disable RLS temporarily to test
-- Run this in Supabase SQL Editor

ALTER TABLE public.enrollments DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.profiles DISABLE ROW LEVEL SECURITY;

SELECT 'RLS disabled - refresh your admin dashboard now' as status;
