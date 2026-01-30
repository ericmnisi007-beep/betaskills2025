-- Migration: Add 'status' and 'proofOfPaymentUrl' columns to enrollments table
ALTER TABLE public.enrollments
ADD COLUMN status text NOT NULL DEFAULT 'default' CHECK (status IN ('default', 'started', 'proof_uploaded', 'approved')),
ADD COLUMN "proofOfPaymentUrl" text; 