-- Add the payment_method column to the enrollments table
ALTER TABLE public.enrollments
ADD COLUMN payment_method TEXT;

-- Add a comment to describe the column
COMMENT ON COLUMN public.enrollments.payment_method IS 'The payment method used for the enrollment (e.g., eft, card).';
