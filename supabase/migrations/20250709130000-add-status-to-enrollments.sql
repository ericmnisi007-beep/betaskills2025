-- Migration: Add status column to enrollments table
ALTER TABLE public.enrollments
ADD COLUMN status text NOT NULL DEFAULT 'started' CHECK (status IN ('started', 'proof_uploaded', 'approved', 'denied'));

-- Optional: Add a comment for clarity
COMMENT ON COLUMN public.enrollments.status IS 'Tracks the status of the enrollment: started, proof_uploaded, approved, denied'; 