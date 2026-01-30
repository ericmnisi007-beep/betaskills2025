-- WORKING VERSION: GRANT ALL COURSES TO maxmon@gmail.com
-- This version handles conflicts properly
-- Run in Supabase SQL Editor: https://supabase.com/dashboard/project/jpafcmixtchvtrkhltst/sql/new

DO $$
DECLARE
    v_user_id UUID;
    v_course_ids TEXT[] := ARRAY[
        'entrepreneurship-final', 'ai-human-relations', 'roofing101', 'plumbing101',
        'tiling-101', 'hair-dressing', 'nail-technician', 'motor-mechanic-petrol-02',
        'motor-mechanic-diesel', 'landscaping101', 'social-media-marketing-101',
        'electrician101', 'solar101', 'carpentry101', 'podcast-management-101',
        'computer-repairs', 'cellphone-repairs-101', 'f9e8d7c6-b5a4-9382-c1d0-e9f8a7b6c5d5',
        'masterchef101', 'cybersecurity101', 'doggrooming101', 'beautyTherapy101',
        'emotional-intelligence', 'prophet', 'ai-assisted-programming',
        'ai-assisted-web-development', 'christian-teacher'
    ];
    v_course_titles TEXT[] := ARRAY[
        'Entrepreneurship', 'AI and Human Relations', 'Roofing', 'Plumbing',
        'Tiling 101', 'Hair Dressing', 'Nail Technician', 'Petrol Motor Mechanic',
        'Diesel Motor Mechanic', 'Landscaping', 'Social Media Marketing 101',
        'Master Electrician Online', 'Solar Energy Systems: Installation & Maintenance',
        'Carpentry', 'Mastering Podcast Management', 'Computer & Laptop Repairs',
        'Cellphone Repairs and Maintenance', 'Sound Engineering', 'Master Chef',
        'Cybersecurity', 'Dog Grooming & Training', 'Beauty Therapy',
        'Emotional Intelligence', 'Prophet', 'AI Assisted Programming',
        'AI Assisted Web Development', 'Christian Teacher'
    ];
    v_course_id TEXT;
    v_course_title TEXT;
    v_index INT;
BEGIN
    -- Get user ID
    SELECT id INTO v_user_id FROM auth.users WHERE email = 'maxmon@gmail.com';
    
    IF v_user_id IS NULL THEN
        RAISE EXCEPTION 'User maxmon@gmail.com not found';
    END IF;
    
    -- Loop through each course
    FOR v_index IN 1..array_length(v_course_ids, 1) LOOP
        v_course_id := v_course_ids[v_index];
        v_course_title := v_course_titles[v_index];
        
        -- Check if enrollment exists
        IF EXISTS (
            SELECT 1 FROM public.enrollments 
            WHERE user_id = v_user_id AND course_id = v_course_id
        ) THEN
            -- Update existing enrollment
            UPDATE public.enrollments
            SET status = 'approved',
                user_email = 'maxmon@gmail.com',
                course_title = v_course_title
            WHERE user_id = v_user_id AND course_id = v_course_id;
        ELSE
            -- Insert new enrollment
            INSERT INTO public.enrollments (user_id, user_email, course_id, course_title, status, enrolled_at, progress)
            VALUES (v_user_id, 'maxmon@gmail.com', v_course_id, v_course_title, 'approved', NOW(), 0);
        END IF;
    END LOOP;
    
    RAISE NOTICE 'Successfully processed all 27 courses for maxmon@gmail.com';
END $$;

-- Verify results
SELECT 
    user_email,
    COUNT(*) as total_courses,
    COUNT(CASE WHEN status = 'approved' THEN 1 END) as approved_courses
FROM public.enrollments
WHERE user_email = 'maxmon@gmail.com'
GROUP BY user_email;

-- Show all courses
SELECT 
    course_id,
    course_title,
    status
FROM public.enrollments
WHERE user_email = 'maxmon@gmail.com'
ORDER BY course_title;
