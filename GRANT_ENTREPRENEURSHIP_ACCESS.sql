-- Grant Entrepreneurship course access to mopalamitshepo@gmail.com
-- Run this in Supabase SQL Editor

INSERT INTO enrollments (user_id, course_id, status, enrolled_at, created_at, updated_at)
SELECT 
    id as user_id,
    'entrepreneurship-final' as course_id,
    'active' as status,
    NOW() as enrolled_at,
    NOW() as created_at,
    NOW() as updated_at
FROM auth.users 
WHERE email = 'mopalamitshepo@gmail.com'
ON CONFLICT (user_id, course_id) 
DO UPDATE SET 
    status = 'active',
    updated_at = NOW();
