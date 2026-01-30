-- FIX: Grant maxmon@gmail.com access to ALL courses in the database
-- This ensures the user has access on ALL devices (PC, mobile, etc.)

-- First, get the user's ID
DO $$
DECLARE
    target_user_id UUID;
    target_email TEXT := 'maxmon@gmail.com';
BEGIN
    -- Get user ID from profiles
    SELECT id INTO target_user_id FROM profiles WHERE email = target_email;
    
    IF target_user_id IS NULL THEN
        -- Try auth.users
        SELECT id INTO target_user_id FROM auth.users WHERE email = target_email;
    END IF;
    
    IF target_user_id IS NULL THEN
        RAISE NOTICE 'User not found: %', target_email;
        RETURN;
    END IF;
    
    RAISE NOTICE 'Found user ID: %', target_user_id;
END $$;

-- List of all course IDs in the system
-- Insert enrollments for each course

-- First, let's see what enrollments exist for this user
SELECT * FROM enrollments WHERE user_email = 'maxmon@gmail.com' OR user_id IN (
    SELECT id FROM profiles WHERE email = 'maxmon@gmail.com'
);

-- Insert approved enrollments for all courses
-- Using INSERT ... ON CONFLICT to avoid duplicates

INSERT INTO enrollments (user_id, user_email, course_id, course_title, status, enrolled_at, approved_at)
SELECT 
    p.id,
    'maxmon@gmail.com',
    course_id,
    course_title,
    'approved',
    NOW(),
    NOW()
FROM profiles p
CROSS JOIN (VALUES 
    ('entrepreneurship-101', 'Entrepreneurship 101'),
    ('emotional-intelligence', 'Emotional Intelligence'),
    ('prophet', 'Prophet Training'),
    ('cybersecurity-101', 'Cybersecurity 101'),
    ('dog-grooming-101', 'Dog Grooming 101'),
    ('plumbing-101', 'Plumbing 101'),
    ('beauty-therapy-101', 'Beauty Therapy 101'),
    ('electrical-101', 'Electrical 101'),
    ('project-management-101', 'Project Management 101'),
    ('bookkeeping-101', 'Bookkeeping 101')
) AS courses(course_id, course_title)
WHERE p.email = 'maxmon@gmail.com'
ON CONFLICT (user_id, course_id) DO UPDATE SET 
    status = 'approved',
    approved_at = NOW(),
    updated_at = NOW();

-- Verify the enrollments were created
SELECT 
    e.id,
    e.user_email,
    e.course_id,
    e.course_title,
    e.status,
    e.enrolled_at,
    e.approved_at
FROM enrollments e
WHERE e.user_email = 'maxmon@gmail.com'
ORDER BY e.course_id;
