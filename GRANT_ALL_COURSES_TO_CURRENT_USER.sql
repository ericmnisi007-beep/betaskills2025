-- GRANT ALL AVAILABLE COURSES TO BOTH maxmon@gmail.com AND maxmon2@gmail.com
-- This ensures FULL ACCESS regardless of which account you're using
-- Run this in Supabase SQL Editor: https://supabase.com/dashboard/project/jpafcmixtchvtrkhltst/sql/new

-- First, let's see which user you are
SELECT id, email FROM auth.users WHERE email LIKE '%maxmon%';

-- Grant ALL courses to maxmon@gmail.com
DO $$
DECLARE
    user_id_var UUID;
    user_email_var TEXT := 'maxmon@gmail.com';
BEGIN
    -- Get user ID
    SELECT id INTO user_id_var FROM auth.users WHERE email = user_email_var;
    
    IF user_id_var IS NOT NULL THEN
        -- Insert all courses
        INSERT INTO public.enrollments (user_id, user_email, course_id, course_title, status, enrolled_at, progress)
        VALUES
            (user_id_var, user_email_var, 'entrepreneurship-final', 'Entrepreneurship', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'ai-human-relations', 'AI and Human Relations', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'roofing101', 'Roofing', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'plumbing101', 'Plumbing', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'tiling-101', 'Tiling 101', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'hair-dressing', 'Hair Dressing', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'nail-technician', 'Nail Technician', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'motor-mechanic-petrol-02', 'Petrol Motor Mechanic', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'motor-mechanic-diesel', 'Diesel Motor Mechanic', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'landscaping101', 'Landscaping', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'social-media-marketing-101', 'Social Media Marketing 101', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'electrician101', 'Master Electrician Online', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'solar101', 'Solar Energy Systems: Installation & Maintenance', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'carpentry101', 'Carpentry', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'podcast-management-101', 'Mastering Podcast Management', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'computer-repairs', 'Computer & Laptop Repairs', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'cellphone-repairs-101', 'Cellphone Repairs and Maintenance', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'f9e8d7c6-b5a4-9382-c1d0-e9f8a7b6c5d5', 'Sound Engineering', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'masterchef101', 'Master Chef', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'cybersecurity101', 'Cybersecurity', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'doggrooming101', 'Dog Grooming & Training', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'beautyTherapy101', 'Beauty Therapy', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'emotional-intelligence', 'Emotional Intelligence', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'prophet', 'Prophet', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'ai-assisted-programming', 'AI Assisted Programming', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'ai-assisted-web-development', 'AI Assisted Web Development', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'christian-teacher', 'Christian Teacher', 'approved', NOW(), 0)
        ON CONFLICT (user_id, course_id) 
        DO UPDATE SET status = 'approved';
        
        RAISE NOTICE 'Granted access to maxmon@gmail.com';
    END IF;
END $$;

-- Grant ALL courses to maxmon2@gmail.com
DO $$
DECLARE
    user_id_var UUID;
    user_email_var TEXT := 'maxmon2@gmail.com';
BEGIN
    -- Get user ID
    SELECT id INTO user_id_var FROM auth.users WHERE email = user_email_var;
    
    IF user_id_var IS NOT NULL THEN
        -- Insert all courses
        INSERT INTO public.enrollments (user_id, user_email, course_id, course_title, status, enrolled_at, progress)
        VALUES
            (user_id_var, user_email_var, 'entrepreneurship-final', 'Entrepreneurship', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'ai-human-relations', 'AI and Human Relations', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'roofing101', 'Roofing', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'plumbing101', 'Plumbing', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'tiling-101', 'Tiling 101', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'hair-dressing', 'Hair Dressing', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'nail-technician', 'Nail Technician', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'motor-mechanic-petrol-02', 'Petrol Motor Mechanic', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'motor-mechanic-diesel', 'Diesel Motor Mechanic', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'landscaping101', 'Landscaping', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'social-media-marketing-101', 'Social Media Marketing 101', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'electrician101', 'Master Electrician Online', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'solar101', 'Solar Energy Systems: Installation & Maintenance', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'carpentry101', 'Carpentry', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'podcast-management-101', 'Mastering Podcast Management', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'computer-repairs', 'Computer & Laptop Repairs', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'cellphone-repairs-101', 'Cellphone Repairs and Maintenance', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'f9e8d7c6-b5a4-9382-c1d0-e9f8a7b6c5d5', 'Sound Engineering', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'masterchef101', 'Master Chef', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'cybersecurity101', 'Cybersecurity', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'doggrooming101', 'Dog Grooming & Training', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'beautyTherapy101', 'Beauty Therapy', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'emotional-intelligence', 'Emotional Intelligence', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'prophet', 'Prophet', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'ai-assisted-programming', 'AI Assisted Programming', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'ai-assisted-web-development', 'AI Assisted Web Development', 'approved', NOW(), 0),
            (user_id_var, user_email_var, 'christian-teacher', 'Christian Teacher', 'approved', NOW(), 0)
        ON CONFLICT (user_id, course_id) 
        DO UPDATE SET status = 'approved';
        
        RAISE NOTICE 'Granted access to maxmon2@gmail.com';
    END IF;
END $$;

-- Verify both accounts
SELECT 
    user_email,
    COUNT(*) as total_courses,
    COUNT(CASE WHEN status = 'approved' THEN 1 END) as approved_courses
FROM public.enrollments
WHERE user_email IN ('maxmon@gmail.com', 'maxmon2@gmail.com')
GROUP BY user_email
ORDER BY user_email;

-- Show all enrollments for verification
SELECT 
    user_email,
    course_id,
    course_title,
    status
FROM public.enrollments
WHERE user_email IN ('maxmon@gmail.com', 'maxmon2@gmail.com')
ORDER BY user_email, course_title;
