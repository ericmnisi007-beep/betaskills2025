-- GRANT ADDITIONAL COURSES TO maxmon@gmail.com (NOT maxmon2)
-- All courses with APPROVED status for immediate full access
-- Run this in Supabase SQL Editor: https://supabase.com/dashboard/project/jpafcmixtchvtrkhltst/sql/new

INSERT INTO public.enrollments (user_id, user_email, course_id, course_title, status, enrolled_at, progress)
SELECT (SELECT id FROM auth.users WHERE email = 'maxmon@gmail.com'), 'maxmon@gmail.com', 'ai-human-relations', 'AI and Human Relations', 'approved', NOW(), 0
WHERE NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = (SELECT id FROM auth.users WHERE email = 'maxmon@gmail.com') AND course_id = 'ai-human-relations');

INSERT INTO public.enrollments (user_id, user_email, course_id, course_title, status, enrolled_at, progress)
SELECT (SELECT id FROM auth.users WHERE email = 'maxmon@gmail.com'), 'maxmon@gmail.com', 'roofing101', 'Roofing', 'approved', NOW(), 0
WHERE NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = (SELECT id FROM auth.users WHERE email = 'maxmon@gmail.com') AND course_id = 'roofing101');

INSERT INTO public.enrollments (user_id, user_email, course_id, course_title, status, enrolled_at, progress)
SELECT (SELECT id FROM auth.users WHERE email = 'maxmon@gmail.com'), 'maxmon@gmail.com', 'motor-mechanic-petrol-02', 'Petrol Motor Mechanic', 'approved', NOW(), 0
WHERE NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = (SELECT id FROM auth.users WHERE email = 'maxmon@gmail.com') AND course_id = 'motor-mechanic-petrol-02');

INSERT INTO public.enrollments (user_id, user_email, course_id, course_title, status, enrolled_at, progress)
SELECT (SELECT id FROM auth.users WHERE email = 'maxmon@gmail.com'), 'maxmon@gmail.com', 'plumbing101', 'Plumbing', 'approved', NOW(), 0
WHERE NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = (SELECT id FROM auth.users WHERE email = 'maxmon@gmail.com') AND course_id = 'plumbing101');

INSERT INTO public.enrollments (user_id, user_email, course_id, course_title, status, enrolled_at, progress)
SELECT (SELECT id FROM auth.users WHERE email = 'maxmon@gmail.com'), 'maxmon@gmail.com', 'motor-mechanic-diesel', 'Diesel Motor Mechanic', 'approved', NOW(), 0
WHERE NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = (SELECT id FROM auth.users WHERE email = 'maxmon@gmail.com') AND course_id = 'motor-mechanic-diesel');

INSERT INTO public.enrollments (user_id, user_email, course_id, course_title, status, enrolled_at, progress)
SELECT (SELECT id FROM auth.users WHERE email = 'maxmon@gmail.com'), 'maxmon@gmail.com', 'landscaping101', 'Landscaping', 'approved', NOW(), 0
WHERE NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = (SELECT id FROM auth.users WHERE email = 'maxmon@gmail.com') AND course_id = 'landscaping101');

INSERT INTO public.enrollments (user_id, user_email, course_id, course_title, status, enrolled_at, progress)
SELECT (SELECT id FROM auth.users WHERE email = 'maxmon@gmail.com'), 'maxmon@gmail.com', 'electrician101', 'Master Electrician Online', 'approved', NOW(), 0
WHERE NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = (SELECT id FROM auth.users WHERE email = 'maxmon@gmail.com') AND course_id = 'electrician101');

INSERT INTO public.enrollments (user_id, user_email, course_id, course_title, status, enrolled_at, progress)
SELECT (SELECT id FROM auth.users WHERE email = 'maxmon@gmail.com'), 'maxmon@gmail.com', 'solar101', 'Solar Energy Systems: Installation & Maintenance', 'approved', NOW(), 0
WHERE NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = (SELECT id FROM auth.users WHERE email = 'maxmon@gmail.com') AND course_id = 'solar101');

INSERT INTO public.enrollments (user_id, user_email, course_id, course_title, status, enrolled_at, progress)
SELECT (SELECT id FROM auth.users WHERE email = 'maxmon@gmail.com'), 'maxmon@gmail.com', 'carpentry101', 'Carpentry', 'approved', NOW(), 0
WHERE NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = (SELECT id FROM auth.users WHERE email = 'maxmon@gmail.com') AND course_id = 'carpentry101');

INSERT INTO public.enrollments (user_id, user_email, course_id, course_title, status, enrolled_at, progress)
SELECT (SELECT id FROM auth.users WHERE email = 'maxmon@gmail.com'), 'maxmon@gmail.com', 'cellphone-repairs-101', 'Cellphone Repairs and Maintenance', 'approved', NOW(), 0
WHERE NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = (SELECT id FROM auth.users WHERE email = 'maxmon@gmail.com') AND course_id = 'cellphone-repairs-101');

INSERT INTO public.enrollments (user_id, user_email, course_id, course_title, status, enrolled_at, progress)
SELECT (SELECT id FROM auth.users WHERE email = 'maxmon@gmail.com'), 'maxmon@gmail.com', 'f9e8d7c6-b5a4-9382-c1d0-e9f8a7b6c5d5', 'Sound Engineering', 'approved', NOW(), 0
WHERE NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = (SELECT id FROM auth.users WHERE email = 'maxmon@gmail.com') AND course_id = 'f9e8d7c6-b5a4-9382-c1d0-e9f8a7b6c5d5');

INSERT INTO public.enrollments (user_id, user_email, course_id, course_title, status, enrolled_at, progress)
SELECT (SELECT id FROM auth.users WHERE email = 'maxmon@gmail.com'), 'maxmon@gmail.com', 'masterchef101', 'Master Chef', 'approved', NOW(), 0
WHERE NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = (SELECT id FROM auth.users WHERE email = 'maxmon@gmail.com') AND course_id = 'masterchef101');

INSERT INTO public.enrollments (user_id, user_email, course_id, course_title, status, enrolled_at, progress)
SELECT (SELECT id FROM auth.users WHERE email = 'maxmon@gmail.com'), 'maxmon@gmail.com', 'doggrooming101', 'Dog Grooming & Training', 'approved', NOW(), 0
WHERE NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = (SELECT id FROM auth.users WHERE email = 'maxmon@gmail.com') AND course_id = 'doggrooming101');

INSERT INTO public.enrollments (user_id, user_email, course_id, course_title, status, enrolled_at, progress)
SELECT (SELECT id FROM auth.users WHERE email = 'maxmon@gmail.com'), 'maxmon@gmail.com', 'beautyTherapy101', 'Beauty Therapy', 'approved', NOW(), 0
WHERE NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = (SELECT id FROM auth.users WHERE email = 'maxmon@gmail.com') AND course_id = 'beautyTherapy101');

-- Verify the enrollments
SELECT 
    user_email,
    course_id,
    course_title,
    status,
    enrolled_at
FROM public.enrollments
WHERE user_email = 'maxmon@gmail.com'
ORDER BY course_title;

-- Count total courses
SELECT 
    user_email,
    COUNT(*) as total_courses
FROM public.enrollments
WHERE user_email = 'maxmon@gmail.com'
GROUP BY user_email;
