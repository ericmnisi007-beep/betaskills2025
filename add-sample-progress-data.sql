-- Add sample progress data for testing
-- Run this AFTER creating the user_progress table

-- 1. First, make sure the user_progress table exists
-- If this fails, run create-user-progress-table.sql first
SELECT COUNT(*) as table_exists FROM information_schema.tables 
WHERE table_name = 'user_progress' AND table_schema = 'public';

-- 2. Add sample progress data for Max Mormal (maxmon2@gmail.com)
-- Replace the user_id with the actual ID from your profiles table
INSERT INTO public.user_progress (
    user_id,
    course_id,
    current_module,
    current_lesson,
    completed_lessons,
    progress_percentage,
    total_time_spent,
    last_visited
) VALUES (
    '11c3f5cb-a50a-4071-87ca-7b6e9d15df22',  -- Max Mormal's user ID
    'entrepreneurship-final',
    1,
    3,
    ARRAY['lesson1', 'lesson2'],
    25,
    1800,  -- 30 minutes in seconds
    NOW()
) ON CONFLICT (user_id, course_id) 
DO UPDATE SET
    progress_percentage = EXCLUDED.progress_percentage,
    completed_lessons = EXCLUDED.completed_lessons,
    last_visited = EXCLUDED.last_visited,
    updated_at = NOW();

-- 3. Verify the progress data was added
SELECT 
    up.user_id,
    p.email,
    up.course_id,
    up.progress_percentage,
    up.completed_lessons,
    up.last_visited
FROM public.user_progress up
JOIN public.profiles p ON up.user_id = p.id
WHERE p.email = 'maxmon2@gmail.com';

-- 4. Show all progress data
SELECT 
    up.user_id,
    p.email,
    up.course_id,
    up.progress_percentage,
    up.completed_lessons,
    up.last_visited
FROM public.user_progress up
JOIN public.profiles p ON up.user_id = p.id
ORDER BY up.updated_at DESC;
