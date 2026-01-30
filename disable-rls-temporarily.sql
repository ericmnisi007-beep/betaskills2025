-- TEMPORARY: Disable RLS to test if that's the issue
-- WARNING: This removes security - only for debugging!

-- Disable RLS on enrollments
ALTER TABLE public.enrollments DISABLE ROW LEVEL SECURITY;

-- Disable RLS on profiles  
ALTER TABLE public.profiles DISABLE ROW LEVEL SECURITY;

-- Check if there's data
SELECT 'Enrollments count:' as info, COUNT(*) as count FROM public.enrollments;
SELECT 'Profiles count:' as info, COUNT(*) as count FROM public.profiles;

-- Show sample data
SELECT * FROM public.enrollments LIMIT 3;
SELECT * FROM public.profiles LIMIT 3;
