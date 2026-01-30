-- UPDATE ALL ENROLLMENTS FOR maxmon2@gmail.com TO APPROVED STATUS
-- This gives FULL ACCESS to all courses
-- Run this in Supabase SQL Editor: https://supabase.com/dashboard/project/jpafcmixtchvtrkhltst/sql/new

UPDATE public.enrollments
SET status = 'approved'
WHERE user_email = 'maxmon2@gmail.com'
AND status = 'pending';

-- Verify the update
SELECT 
    user_email,
    course_id,
    course_title,
    status,
    enrolled_at
FROM public.enrollments
WHERE user_email = 'maxmon2@gmail.com'
ORDER BY course_title;
