-- VERIFY AND FIX ACCESS FOR maxmon@gmail.com
-- Run this to check current status and fix any missing courses
-- https://supabase.com/dashboard/project/jpafcmixtchvtrkhltst/sql/new

-- Step 1: Check which email you're using
SELECT 'Current users with maxmon in email:' as info;
SELECT id, email, created_at FROM auth.users WHERE email LIKE '%maxmon%';

-- Step 2: Check current enrollments
SELECT 'Current enrollments for maxmon@gmail.com:' as info;
SELECT 
    course_id,
    course_title,
    status,
    enrolled_at
FROM public.enrollments
WHERE user_email = 'maxmon@gmail.com'
ORDER BY course_title;

-- Step 3: Count enrollments
SELECT 'Total count:' as info;
SELECT 
    user_email,
    COUNT(*) as total_courses,
    COUNT(CASE WHEN status = 'approved' THEN 1 END) as approved_courses,
    COUNT(CASE WHEN status = 'pending' THEN 1 END) as pending_courses
FROM public.enrollments
WHERE user_email = 'maxmon@gmail.com'
GROUP BY user_email;

-- Step 4: Insert missing courses (this will add any that don't exist)
DO $$
DECLARE
    v_user_id UUID;
    v_inserted INT := 0;
    v_updated INT := 0;
BEGIN
    SELECT id INTO v_user_id FROM auth.users WHERE email = 'maxmon@gmail.com';
    
    IF v_user_id IS NULL THEN
        RAISE EXCEPTION 'User maxmon@gmail.com not found!';
    END IF;
    
    -- AI and Human Relations
    IF NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = v_user_id AND course_id = 'ai-human-relations') THEN
        INSERT INTO public.enrollments (user_id, user_email, course_id, course_title, status, enrolled_at, progress)
        VALUES (v_user_id, 'maxmon@gmail.com', 'ai-human-relations', 'AI and Human Relations', 'approved', NOW(), 0);
        v_inserted := v_inserted + 1;
    ELSE
        UPDATE public.enrollments SET status = 'approved' WHERE user_id = v_user_id AND course_id = 'ai-human-relations';
        v_updated := v_updated + 1;
    END IF;
    
    -- Roofing
    IF NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = v_user_id AND course_id = 'roofing101') THEN
        INSERT INTO public.enrollments (user_id, user_email, course_id, course_title, status, enrolled_at, progress)
        VALUES (v_user_id, 'maxmon@gmail.com', 'roofing101', 'Roofing', 'approved', NOW(), 0);
        v_inserted := v_inserted + 1;
    ELSE
        UPDATE public.enrollments SET status = 'approved' WHERE user_id = v_user_id AND course_id = 'roofing101';
        v_updated := v_updated + 1;
    END IF;
    
    -- Petrol Motor Mechanic
    IF NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = v_user_id AND course_id = 'motor-mechanic-petrol-02') THEN
        INSERT INTO public.enrollments (user_id, user_email, course_id, course_title, status, enrolled_at, progress)
        VALUES (v_user_id, 'maxmon@gmail.com', 'motor-mechanic-petrol-02', 'Petrol Motor Mechanic', 'approved', NOW(), 0);
        v_inserted := v_inserted + 1;
    ELSE
        UPDATE public.enrollments SET status = 'approved' WHERE user_id = v_user_id AND course_id = 'motor-mechanic-petrol-02';
        v_updated := v_updated + 1;
    END IF;
    
    -- Plumbing
    IF NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = v_user_id AND course_id = 'plumbing101') THEN
        INSERT INTO public.enrollments (user_id, user_email, course_id, course_title, status, enrolled_at, progress)
        VALUES (v_user_id, 'maxmon@gmail.com', 'plumbing101', 'Plumbing', 'approved', NOW(), 0);
        v_inserted := v_inserted + 1;
    ELSE
        UPDATE public.enrollments SET status = 'approved' WHERE user_id = v_user_id AND course_id = 'plumbing101';
        v_updated := v_updated + 1;
    END IF;
    
    -- Diesel Motor Mechanic
    IF NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = v_user_id AND course_id = 'motor-mechanic-diesel') THEN
        INSERT INTO public.enrollments (user_id, user_email, course_id, course_title, status, enrolled_at, progress)
        VALUES (v_user_id, 'maxmon@gmail.com', 'motor-mechanic-diesel', 'Diesel Motor Mechanic', 'approved', NOW(), 0);
        v_inserted := v_inserted + 1;
    ELSE
        UPDATE public.enrollments SET status = 'approved' WHERE user_id = v_user_id AND course_id = 'motor-mechanic-diesel';
        v_updated := v_updated + 1;
    END IF;
    
    -- Landscaping
    IF NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = v_user_id AND course_id = 'landscaping101') THEN
        INSERT INTO public.enrollments (user_id, user_email, course_id, course_title, status, enrolled_at, progress)
        VALUES (v_user_id, 'maxmon@gmail.com', 'landscaping101', 'Landscaping', 'approved', NOW(), 0);
        v_inserted := v_inserted + 1;
    ELSE
        UPDATE public.enrollments SET status = 'approved' WHERE user_id = v_user_id AND course_id = 'landscaping101';
        v_updated := v_updated + 1;
    END IF;
    
    -- Master Electrician
    IF NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = v_user_id AND course_id = 'electrician101') THEN
        INSERT INTO public.enrollments (user_id, user_email, course_id, course_title, status, enrolled_at, progress)
        VALUES (v_user_id, 'maxmon@gmail.com', 'electrician101', 'Master Electrician Online', 'approved', NOW(), 0);
        v_inserted := v_inserted + 1;
    ELSE
        UPDATE public.enrollments SET status = 'approved' WHERE user_id = v_user_id AND course_id = 'electrician101';
        v_updated := v_updated + 1;
    END IF;
    
    -- Solar Energy
    IF NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = v_user_id AND course_id = 'solar101') THEN
        INSERT INTO public.enrollments (user_id, user_email, course_id, course_title, status, enrolled_at, progress)
        VALUES (v_user_id, 'maxmon@gmail.com', 'solar101', 'Solar Energy Systems: Installation & Maintenance', 'approved', NOW(), 0);
        v_inserted := v_inserted + 1;
    ELSE
        UPDATE public.enrollments SET status = 'approved' WHERE user_id = v_user_id AND course_id = 'solar101';
        v_updated := v_updated + 1;
    END IF;
    
    -- Carpentry
    IF NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = v_user_id AND course_id = 'carpentry101') THEN
        INSERT INTO public.enrollments (user_id, user_email, course_id, course_title, status, enrolled_at, progress)
        VALUES (v_user_id, 'maxmon@gmail.com', 'carpentry101', 'Carpentry', 'approved', NOW(), 0);
        v_inserted := v_inserted + 1;
    ELSE
        UPDATE public.enrollments SET status = 'approved' WHERE user_id = v_user_id AND course_id = 'carpentry101';
        v_updated := v_updated + 1;
    END IF;
    
    -- Cellphone Repairs
    IF NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = v_user_id AND course_id = 'cellphone-repairs-101') THEN
        INSERT INTO public.enrollments (user_id, user_email, course_id, course_title, status, enrolled_at, progress)
        VALUES (v_user_id, 'maxmon@gmail.com', 'cellphone-repairs-101', 'Cellphone Repairs and Maintenance', 'approved', NOW(), 0);
        v_inserted := v_inserted + 1;
    ELSE
        UPDATE public.enrollments SET status = 'approved' WHERE user_id = v_user_id AND course_id = 'cellphone-repairs-101';
        v_updated := v_updated + 1;
    END IF;
    
    -- Sound Engineering
    IF NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = v_user_id AND course_id = 'f9e8d7c6-b5a4-9382-c1d0-e9f8a7b6c5d5') THEN
        INSERT INTO public.enrollments (user_id, user_email, course_id, course_title, status, enrolled_at, progress)
        VALUES (v_user_id, 'maxmon@gmail.com', 'f9e8d7c6-b5a4-9382-c1d0-e9f8a7b6c5d5', 'Sound Engineering', 'approved', NOW(), 0);
        v_inserted := v_inserted + 1;
    ELSE
        UPDATE public.enrollments SET status = 'approved' WHERE user_id = v_user_id AND course_id = 'f9e8d7c6-b5a4-9382-c1d0-e9f8a7b6c5d5';
        v_updated := v_updated + 1;
    END IF;
    
    -- Master Chef
    IF NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = v_user_id AND course_id = 'masterchef101') THEN
        INSERT INTO public.enrollments (user_id, user_email, course_id, course_title, status, enrolled_at, progress)
        VALUES (v_user_id, 'maxmon@gmail.com', 'masterchef101', 'Master Chef', 'approved', NOW(), 0);
        v_inserted := v_inserted + 1;
    ELSE
        UPDATE public.enrollments SET status = 'approved' WHERE user_id = v_user_id AND course_id = 'masterchef101';
        v_updated := v_updated + 1;
    END IF;
    
    -- Dog Grooming
    IF NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = v_user_id AND course_id = 'doggrooming101') THEN
        INSERT INTO public.enrollments (user_id, user_email, course_id, course_title, status, enrolled_at, progress)
        VALUES (v_user_id, 'maxmon@gmail.com', 'doggrooming101', 'Dog Grooming & Training', 'approved', NOW(), 0);
        v_inserted := v_inserted + 1;
    ELSE
        UPDATE public.enrollments SET status = 'approved' WHERE user_id = v_user_id AND course_id = 'doggrooming101';
        v_updated := v_updated + 1;
    END IF;
    
    -- Beauty Therapy
    IF NOT EXISTS (SELECT 1 FROM public.enrollments WHERE user_id = v_user_id AND course_id = 'beautyTherapy101') THEN
        INSERT INTO public.enrollments (user_id, user_email, course_id, course_title, status, enrolled_at, progress)
        VALUES (v_user_id, 'maxmon@gmail.com', 'beautyTherapy101', 'Beauty Therapy', 'approved', NOW(), 0);
        v_inserted := v_inserted + 1;
    ELSE
        UPDATE public.enrollments SET status = 'approved' WHERE user_id = v_user_id AND course_id = 'beautyTherapy101';
        v_updated := v_updated + 1;
    END IF;
    
    RAISE NOTICE 'Inserted % new courses, Updated % existing courses', v_inserted, v_updated;
END $$;

-- Step 5: Final verification
SELECT 'FINAL RESULT - All courses for maxmon@gmail.com:' as info;
SELECT 
    course_id,
    course_title,
    status
FROM public.enrollments
WHERE user_email = 'maxmon@gmail.com'
ORDER BY course_title;

SELECT 'FINAL COUNT:' as info;
SELECT 
    COUNT(*) as total_courses,
    COUNT(CASE WHEN status = 'approved' THEN 1 END) as approved_courses
FROM public.enrollments
WHERE user_email = 'maxmon@gmail.com';
