-- Check if there's any data in the database for admin to view

-- Check enrollments count
SELECT 'Total Enrollments:' as info, COUNT(*) as count FROM public.enrollments;

-- Check profiles count
SELECT 'Total Profiles:' as info, COUNT(*) as count FROM public.profiles;

-- Check if current user is authenticated
SELECT 'Current User:' as info, auth.uid() as user_id, auth.email() as email;

-- Check enrollments with details
SELECT 
    'Enrollment Sample:' as info,
    id,
    user_id,
    course_id,
    user_email,
    course_title,
    status,
    enrolled_at
FROM public.enrollments
LIMIT 5;

-- Check profiles with details
SELECT 
    'Profile Sample:' as info,
    id,
    email,
    first_name,
    last_name,
    phone,
    created_at
FROM public.profiles
LIMIT 5;

-- Check RLS policies on enrollments
SELECT 
    'Enrollments Policies:' as info,
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual
FROM pg_policies
WHERE tablename = 'enrollments';

-- Check RLS policies on profiles
SELECT 
    'Profiles Policies:' as info,
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual
FROM pg_policies
WHERE tablename = 'profiles';
