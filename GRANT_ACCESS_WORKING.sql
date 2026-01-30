-- Grant access to all 22 courses for maxmon2@gmail.com
-- This version includes user_email column
-- Run this in Supabase SQL Editor: https://supabase.com/dashboard/project/jpafcmixtchvtrkhltst/sql/new

INSERT INTO public.enrollments (user_id, user_email, course_id, status, enrolled_at, progress)
SELECT (SELECT id FROM auth.users WHERE email = 'maxmon2@gmail.com'), 'maxmon2@gmail.com', 'cybersecurity101', 'active', NOW(), 0
WHERE NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = (SELECT id FROM auth.users WHERE email = 'maxmon2@gmail.com') AND course_id = 'cybersecurity101');

INSERT INTO public.enrollments (user_id, user_email, course_id, status, enrolled_at, progress)
SELECT (SELECT id FROM auth.users WHERE email = 'maxmon2@gmail.com'), 'maxmon2@gmail.com', 'emotional-intelligence', 'active', NOW(), 0
WHERE NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = (SELECT id FROM auth.users WHERE email = 'maxmon2@gmail.com') AND course_id = 'emotional-intelligence');

INSERT INTO public.enrollments (user_id, user_email, course_id, status, enrolled_at, progress)
SELECT (SELECT id FROM auth.users WHERE email = 'maxmon2@gmail.com'), 'maxmon2@gmail.com', 'prophet', 'active', NOW(), 0
WHERE NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = (SELECT id FROM auth.users WHERE email = 'maxmon2@gmail.com') AND course_id = 'prophet');

INSERT INTO public.enrollments (user_id, user_email, course_id, status, enrolled_at, progress)
SELECT (SELECT id FROM auth.users WHERE email = 'maxmon2@gmail.com'), 'maxmon2@gmail.com', 'entrepreneurship-final', 'active', NOW(), 0
WHERE NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = (SELECT id FROM auth.users WHERE email = 'maxmon2@gmail.com') AND course_id = 'entrepreneurship-final');

INSERT INTO public.enrollments (user_id, user_email, course_id, status, enrolled_at, progress)
SELECT (SELECT id FROM auth.users WHERE email = 'maxmon2@gmail.com'), 'maxmon2@gmail.com', 'ai-assisted-programming', 'active', NOW(), 0
WHERE NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = (SELECT id FROM auth.users WHERE email = 'maxmon2@gmail.com') AND course_id = 'ai-assisted-programming');

INSERT INTO public.enrollments (user_id, user_email, course_id, status, enrolled_at, progress)
SELECT (SELECT id FROM auth.users WHERE email = 'maxmon2@gmail.com'), 'maxmon2@gmail.com', 'ai-assisted-web-development', 'active', NOW(), 0
WHERE NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = (SELECT id FROM auth.users WHERE email = 'maxmon2@gmail.com') AND course_id = 'ai-assisted-web-development');

INSERT INTO public.enrollments (user_id, user_email, course_id, status, enrolled_at, progress)
SELECT (SELECT id FROM auth.users WHERE email = 'maxmon2@gmail.com'), 'maxmon2@gmail.com', 'christian-teacher', 'active', NOW(), 0
WHERE NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = (SELECT id FROM auth.users WHERE email = 'maxmon2@gmail.com') AND course_id = 'christian-teacher');

INSERT INTO public.enrollments (user_id, user_email, course_id, status, enrolled_at, progress)
SELECT (SELECT id FROM auth.users WHERE email = 'maxmon2@gmail.com'), 'maxmon2@gmail.com', 'podcast-management-101', 'active', NOW(), 0
WHERE NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = (SELECT id FROM auth.users WHERE email = 'maxmon2@gmail.com') AND course_id = 'podcast-management-101');

INSERT INTO public.enrollments (user_id, user_email, course_id, status, enrolled_at, progress)
SELECT (SELECT id FROM auth.users WHERE email = 'maxmon2@gmail.com'), 'maxmon2@gmail.com', 'sound-engineering-102', 'active', NOW(), 0
WHERE NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = (SELECT id FROM auth.users WHERE email = 'maxmon2@gmail.com') AND course_id = 'sound-engineering-102');

INSERT INTO public.enrollments (user_id, user_email, course_id, status, enrolled_at, progress)
SELECT (SELECT id FROM auth.users WHERE email = 'maxmon2@gmail.com'), 'maxmon2@gmail.com', 'computer-repairs', 'active', NOW(), 0
WHERE NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = (SELECT id FROM auth.users WHERE email = 'maxmon2@gmail.com') AND course_id = 'computer-repairs');

INSERT INTO public.enrollments (user_id, user_email, course_id, status, enrolled_at, progress)
SELECT (SELECT id FROM auth.users WHERE email = 'maxmon2@gmail.com'), 'maxmon2@gmail.com', 'roofing', 'active', NOW(), 0
WHERE NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = (SELECT id FROM auth.users WHERE email = 'maxmon2@gmail.com') AND course_id = 'roofing');

INSERT INTO public.enrollments (user_id, user_email, course_id, status, enrolled_at, progress)
SELECT (SELECT id FROM auth.users WHERE email = 'maxmon2@gmail.com'), 'maxmon2@gmail.com', 'plumbing', 'active', NOW(), 0
WHERE NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = (SELECT id FROM auth.users WHERE email = 'maxmon2@gmail.com') AND course_id = 'plumbing');

INSERT INTO public.enrollments (user_id, user_email, course_id, status, enrolled_at, progress)
SELECT (SELECT id FROM auth.users WHERE email = 'maxmon2@gmail.com'), 'maxmon2@gmail.com', 'tiling-101', 'active', NOW(), 0
WHERE NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = (SELECT id FROM auth.users WHERE email = 'maxmon2@gmail.com') AND course_id = 'tiling-101');

INSERT INTO public.enrollments (user_id, user_email, course_id, status, enrolled_at, progress)
SELECT (SELECT id FROM auth.users WHERE email = 'maxmon2@gmail.com'), 'maxmon2@gmail.com', 'hair-dressing', 'active', NOW(), 0
WHERE NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = (SELECT id FROM auth.users WHERE email = 'maxmon2@gmail.com') AND course_id = 'hair-dressing');

INSERT INTO public.enrollments (user_id, user_email, course_id, status, enrolled_at, progress)
SELECT (SELECT id FROM auth.users WHERE email = 'maxmon2@gmail.com'), 'maxmon2@gmail.com', 'nail-technician', 'active', NOW(), 0
WHERE NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = (SELECT id FROM auth.users WHERE email = 'maxmon2@gmail.com') AND course_id = 'nail-technician');

INSERT INTO public.enrollments (user_id, user_email, course_id, status, enrolled_at, progress)
SELECT (SELECT id FROM auth.users WHERE email = 'maxmon2@gmail.com'), 'maxmon2@gmail.com', 'petrol-motor-mechanic', 'active', NOW(), 0
WHERE NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = (SELECT id FROM auth.users WHERE email = 'maxmon2@gmail.com') AND course_id = 'petrol-motor-mechanic');

INSERT INTO public.enrollments (user_id, user_email, course_id, status, enrolled_at, progress)
SELECT (SELECT id FROM auth.users WHERE email = 'maxmon2@gmail.com'), 'maxmon2@gmail.com', 'diesel-motor-mechanic', 'active', NOW(), 0
WHERE NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = (SELECT id FROM auth.users WHERE email = 'maxmon2@gmail.com') AND course_id = 'diesel-motor-mechanic');

INSERT INTO public.enrollments (user_id, user_email, course_id, status, enrolled_at, progress)
SELECT (SELECT id FROM auth.users WHERE email = 'maxmon2@gmail.com'), 'maxmon2@gmail.com', 'landscaping', 'active', NOW(), 0
WHERE NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = (SELECT id FROM auth.users WHERE email = 'maxmon2@gmail.com') AND course_id = 'landscaping');

INSERT INTO public.enrollments (user_id, user_email, course_id, status, enrolled_at, progress)
SELECT (SELECT id FROM auth.users WHERE email = 'maxmon2@gmail.com'), 'maxmon2@gmail.com', 'social-media-marketing-101', 'active', NOW(), 0
WHERE NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = (SELECT id FROM auth.users WHERE email = 'maxmon2@gmail.com') AND course_id = 'social-media-marketing-101');

INSERT INTO public.enrollments (user_id, user_email, course_id, status, enrolled_at, progress)
SELECT (SELECT id FROM auth.users WHERE email = 'maxmon2@gmail.com'), 'maxmon2@gmail.com', 'master-electrician-online', 'active', NOW(), 0
WHERE NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = (SELECT id FROM auth.users WHERE email = 'maxmon2@gmail.com') AND course_id = 'master-electrician-online');

INSERT INTO public.enrollments (user_id, user_email, course_id, status, enrolled_at, progress)
SELECT (SELECT id FROM auth.users WHERE email = 'maxmon2@gmail.com'), 'maxmon2@gmail.com', 'beauty-therapy-101', 'active', NOW(), 0
WHERE NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = (SELECT id FROM auth.users WHERE email = 'maxmon2@gmail.com') AND course_id = 'beauty-therapy-101');

INSERT INTO public.enrollments (user_id, user_email, course_id, status, enrolled_at, progress)
SELECT (SELECT id FROM auth.users WHERE email = 'maxmon2@gmail.com'), 'maxmon2@gmail.com', 'dog-grooming-101', 'active', NOW(), 0
WHERE NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = (SELECT id FROM auth.users WHERE email = 'maxmon2@gmail.com') AND course_id = 'dog-grooming-101');

-- Verify the enrollments
SELECT 
    u.email,
    COUNT(e.course_id) as total_courses
FROM public.enrollments e
JOIN auth.users u ON e.user_id = u.id
WHERE u.email = 'maxmon2@gmail.com'
GROUP BY u.email;
