-- RESTORE ALL COURSE ACCESS FOR maxmon@gmail.com
-- Run this in Supabase SQL Editor

-- Step 1: Delete existing enrollments for this user (to avoid duplicates)
DELETE FROM public.enrollments 
WHERE user_email = 'maxmon@gmail.com';

-- Step 2: Re-insert all course enrollments
DO $$
DECLARE
    v_user_id UUID;
BEGIN
    SELECT id INTO v_user_id FROM auth.users WHERE email = 'maxmon@gmail.com';
    
    IF v_user_id IS NULL THEN
        RAISE EXCEPTION 'User maxmon@gmail.com not found';
    END IF;
    
    INSERT INTO public.enrollments (user_id, user_email, course_id, course_title, status, enrolled_at, progress)
    VALUES
        (v_user_id, 'maxmon@gmail.com', 'entrepreneurship-final', 'Entrepreneurship', 'approved', NOW(), 0),
        (v_user_id, 'maxmon@gmail.com', 'ai-human-relations', 'AI and Human Relations', 'approved', NOW(), 0),
        (v_user_id, 'maxmon@gmail.com', 'roofing101', 'Roofing', 'approved', NOW(), 0),
        (v_user_id, 'maxmon@gmail.com', 'plumbing101', 'Plumbing', 'approved', NOW(), 0),
        (v_user_id, 'maxmon@gmail.com', 'tiling-101', 'Tiling 101', 'approved', NOW(), 0),
        (v_user_id, 'maxmon@gmail.com', 'hair-dressing', 'Hair Dressing', 'approved', NOW(), 0),
        (v_user_id, 'maxmon@gmail.com', 'nail-technician', 'Nail Technician', 'approved', NOW(), 0),
        (v_user_id, 'maxmon@gmail.com', 'motor-mechanic-petrol-02', 'Petrol Motor Mechanic', 'approved', NOW(), 0),
        (v_user_id, 'maxmon@gmail.com', 'motor-mechanic-diesel', 'Diesel Motor Mechanic', 'approved', NOW(), 0),
        (v_user_id, 'maxmon@gmail.com', 'landscaping101', 'Landscaping', 'approved', NOW(), 0),
        (v_user_id, 'maxmon@gmail.com', 'social-media-marketing-101', 'Social Media Marketing 101', 'approved', NOW(), 0),
        (v_user_id, 'maxmon@gmail.com', 'electrician101', 'Master Electrician Online', 'approved', NOW(), 0),
        (v_user_id, 'maxmon@gmail.com', 'solar101', 'Solar Energy Systems', 'approved', NOW(), 0),
        (v_user_id, 'maxmon@gmail.com', 'carpentry101', 'Carpentry', 'approved', NOW(), 0),
        (v_user_id, 'maxmon@gmail.com', 'podcast-management-101', 'Mastering Podcast Management', 'approved', NOW(), 0),
        (v_user_id, 'maxmon@gmail.com', 'computer-repairs', 'Computer & Laptop Repairs', 'approved', NOW(), 0),
        (v_user_id, 'maxmon@gmail.com', 'cellphone-repairs-101', 'Cellphone Repairs and Maintenance', 'approved', NOW(), 0),
        (v_user_id, 'maxmon@gmail.com', 'f9e8d7c6-b5a4-9382-c1d0-e9f8a7b6c5d5', 'Sound Engineering', 'approved', NOW(), 0),
        (v_user_id, 'maxmon@gmail.com', 'masterchef101', 'Master Chef', 'approved', NOW(), 0),
        (v_user_id, 'maxmon@gmail.com', 'cybersecurity101', 'Cybersecurity', 'approved', NOW(), 0),
        (v_user_id, 'maxmon@gmail.com', 'doggrooming101', 'Dog Grooming & Training', 'approved', NOW(), 0),
        (v_user_id, 'maxmon@gmail.com', 'beautyTherapy101', 'Beauty Therapy', 'approved', NOW(), 0),
        (v_user_id, 'maxmon@gmail.com', 'emotional-intelligence', 'Emotional Intelligence', 'approved', NOW(), 0),
        (v_user_id, 'maxmon@gmail.com', 'prophet', 'Prophet', 'approved', NOW(), 0),
        (v_user_id, 'maxmon@gmail.com', 'ai-assisted-programming', 'AI Assisted Programming', 'approved', NOW(), 0),
        (v_user_id, 'maxmon@gmail.com', 'ai-assisted-web-development', 'AI Assisted Web Development', 'approved', NOW(), 0),
        (v_user_id, 'maxmon@gmail.com', 'christian-teacher', 'Christian Teacher', 'approved', NOW(), 0),
        (v_user_id, 'maxmon@gmail.com', 'film-production', 'Film Production', 'approved', NOW(), 0);
    
    RAISE NOTICE 'Successfully restored access to all 28 courses for maxmon@gmail.com';
END $$;

-- Verify
SELECT course_id, course_title, status FROM public.enrollments 
WHERE user_email = 'maxmon@gmail.com' ORDER BY course_title;
