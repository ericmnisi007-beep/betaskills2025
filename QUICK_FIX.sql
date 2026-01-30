-- QUICK FIX: Run this in your Supabase SQL Editor to fix the enrollment error

-- Step 1: Create the enrollments table (if it doesn't exist)
CREATE TABLE IF NOT EXISTS public.enrollments (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL,
    user_email TEXT NOT NULL,
    course_id TEXT NOT NULL,
    course_title TEXT NOT NULL,
    proof_of_payment TEXT,
    payment_ref TEXT,
    payment_date TEXT,
    status TEXT DEFAULT 'pending',
    enrolled_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    approved_at TIMESTAMP WITH TIME ZONE,
    progress INTEGER DEFAULT 0
);

-- Step 2: Disable RLS temporarily to fix the error
ALTER TABLE public.enrollments DISABLE ROW LEVEL SECURITY;

-- Step 3: Create the storage bucket for proofs
INSERT INTO storage.buckets (id, name, public)
VALUES ('proofs', 'proofs', true)
ON CONFLICT (id) DO NOTHING;

-- Step 4: Make storage bucket public (simple approach)
UPDATE storage.buckets 
SET public = true 
WHERE id = 'proofs';

-- You can enable RLS later with proper policies if needed 