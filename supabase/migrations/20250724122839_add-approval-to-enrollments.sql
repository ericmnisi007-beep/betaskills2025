-- Migration: Add approval fields to enrollments table
ALTER TABLE public.enrollments
ADD COLUMN approved boolean NOT NULL DEFAULT false,
ADD COLUMN approval_status text NOT NULL DEFAULT 'pending' CHECK (approval_status IN ('pending', 'approved', 'rejected'));

-- Optional: Add a comment for clarity
COMMENT ON COLUMN public.enrollments.approved IS 'Indicates if the enrollment is approved by admin';
COMMENT ON COLUMN public.enrollments.approval_status IS 'Tracks the approval status: pending, approved, rejected';
