-- Prevent duplicate enrollments at database level
-- This script adds a unique constraint to prevent the same user from enrolling in the same course multiple times

-- First, let's clean up existing duplicates by keeping only the latest enrollment per user per course
WITH duplicates AS (
  SELECT 
    id,
    user_id,
    course_id,
    enrolled_at,
    ROW_NUMBER() OVER (
      PARTITION BY user_id, course_id 
      ORDER BY enrolled_at DESC, created_at DESC
    ) as rn
  FROM public.enrollments
)
DELETE FROM public.enrollments 
WHERE id IN (
  SELECT id FROM duplicates WHERE rn > 1
);

-- Add a unique constraint to prevent future duplicates
-- This will prevent the same user from enrolling in the same course multiple times
ALTER TABLE public.enrollments 
ADD CONSTRAINT unique_user_course_enrollment 
UNIQUE (user_id, course_id);

-- Optional: Add an index for better performance
CREATE INDEX IF NOT EXISTS idx_enrollments_user_course 
ON public.enrollments (user_id, course_id);

-- Verify the constraint was added
SELECT 
  conname as constraint_name,
  contype as constraint_type,
  pg_get_constraintdef(oid) as constraint_definition
FROM pg_constraint 
WHERE conrelid = 'public.enrollments'::regclass 
  AND conname = 'unique_user_course_enrollment';
