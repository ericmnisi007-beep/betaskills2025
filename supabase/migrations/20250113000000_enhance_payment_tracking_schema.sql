-- Enhanced Payment Tracking Schema Migration
-- Adds payment tracking columns to enrollments table and creates payment_errors table
-- Requirements: 6.1, 6.2, 6.3, 6.4

-- 1. Add payment tracking columns to enrollments table
ALTER TABLE public.enrollments 
ADD COLUMN IF NOT EXISTS payment_tracking_id VARCHAR(255),
ADD COLUMN IF NOT EXISTS payment_gateway VARCHAR(50),
ADD COLUMN IF NOT EXISTS payment_status VARCHAR(50) DEFAULT 'pending';

-- 2. Add comments to describe the new columns
COMMENT ON COLUMN public.enrollments.payment_tracking_id IS 'Unique identifier for tracking payment transactions across gateways';
COMMENT ON COLUMN public.enrollments.payment_gateway IS 'Payment gateway used (e.g., ikhokha, payfast, manual)';
COMMENT ON COLUMN public.enrollments.payment_status IS 'Current status of the payment (pending, completed, failed)';

-- 3. Create indexes for efficient admin dashboard queries
CREATE INDEX IF NOT EXISTS idx_enrollments_payment_method ON public.enrollments(payment_method);
CREATE INDEX IF NOT EXISTS idx_enrollments_payment_status ON public.enrollments(payment_status);
CREATE INDEX IF NOT EXISTS idx_enrollments_payment_gateway ON public.enrollments(payment_gateway);
CREATE INDEX IF NOT EXISTS idx_enrollments_payment_tracking_id ON public.enrollments(payment_tracking_id);

-- 4. Create payment_errors table for comprehensive error logging
CREATE TABLE IF NOT EXISTS public.payment_errors (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  payment_id VARCHAR(255),
  enrollment_id UUID REFERENCES public.enrollments(id) ON DELETE SET NULL,
  error_code VARCHAR(100) NOT NULL,
  error_message TEXT NOT NULL,
  user_message TEXT NOT NULL,
  error_category VARCHAR(50) NOT NULL CHECK (error_category IN ('card', 'network', 'system', 'validation', 'gateway')),
  severity VARCHAR(20) NOT NULL CHECK (severity IN ('low', 'medium', 'high', 'critical')),
  user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  course_id VARCHAR(100),
  payment_method VARCHAR(50),
  payment_gateway VARCHAR(50),
  gateway_response JSONB,
  user_agent TEXT,
  ip_address INET,
  resolved BOOLEAN DEFAULT false,
  resolved_at TIMESTAMP WITH TIME ZONE,
  resolved_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 5. Add comments to payment_errors table
COMMENT ON TABLE public.payment_errors IS 'Comprehensive logging of payment errors for analysis and debugging';
COMMENT ON COLUMN public.payment_errors.payment_id IS 'Payment transaction ID from gateway';
COMMENT ON COLUMN public.payment_errors.enrollment_id IS 'Associated enrollment ID if available';
COMMENT ON COLUMN public.payment_errors.error_code IS 'Technical error code from gateway or system';
COMMENT ON COLUMN public.payment_errors.error_message IS 'Technical error message for debugging';
COMMENT ON COLUMN public.payment_errors.user_message IS 'User-friendly error message displayed to user';
COMMENT ON COLUMN public.payment_errors.error_category IS 'Category of error for classification';
COMMENT ON COLUMN public.payment_errors.severity IS 'Severity level of the error';
COMMENT ON COLUMN public.payment_errors.gateway_response IS 'Full response from payment gateway';
COMMENT ON COLUMN public.payment_errors.resolved IS 'Whether the error has been resolved';

-- 6. Create indexes for payment_errors table
CREATE INDEX IF NOT EXISTS idx_payment_errors_payment_id ON public.payment_errors(payment_id);
CREATE INDEX IF NOT EXISTS idx_payment_errors_enrollment_id ON public.payment_errors(enrollment_id);
CREATE INDEX IF NOT EXISTS idx_payment_errors_error_code ON public.payment_errors(error_code);
CREATE INDEX IF NOT EXISTS idx_payment_errors_error_category ON public.payment_errors(error_category);
CREATE INDEX IF NOT EXISTS idx_payment_errors_severity ON public.payment_errors(severity);
CREATE INDEX IF NOT EXISTS idx_payment_errors_user_id ON public.payment_errors(user_id);
CREATE INDEX IF NOT EXISTS idx_payment_errors_course_id ON public.payment_errors(course_id);
CREATE INDEX IF NOT EXISTS idx_payment_errors_payment_gateway ON public.payment_errors(payment_gateway);
CREATE INDEX IF NOT EXISTS idx_payment_errors_resolved ON public.payment_errors(resolved);
CREATE INDEX IF NOT EXISTS idx_payment_errors_created_at ON public.payment_errors(created_at);

-- 7. Enable Row Level Security on payment_errors table
ALTER TABLE public.payment_errors ENABLE ROW LEVEL SECURITY;

-- 8. Create RLS policies for payment_errors table
-- Users can view their own payment errors
CREATE POLICY "Users can view their own payment errors" ON public.payment_errors
  FOR SELECT USING (auth.uid() = user_id);

-- Admins and instructors can view all payment errors
CREATE POLICY "Admins and instructors can view all payment errors" ON public.payment_errors
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.profiles 
      WHERE id = auth.uid() 
      AND role IN ('instructor', 'admin')
    )
  );

-- System can insert payment errors (for error logging)
CREATE POLICY "System can insert payment errors" ON public.payment_errors
  FOR INSERT WITH CHECK (true);

-- Admins can update payment errors (for resolution)
CREATE POLICY "Admins can update payment errors" ON public.payment_errors
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM public.profiles 
      WHERE id = auth.uid() 
      AND role = 'admin'
    )
  );

-- 9. Create function to update payment_errors updated_at timestamp
CREATE OR REPLACE FUNCTION public.update_payment_errors_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 10. Create trigger for payment_errors updated_at
CREATE TRIGGER payment_errors_updated_at_trigger
  BEFORE UPDATE ON public.payment_errors
  FOR EACH ROW
  EXECUTE FUNCTION public.update_payment_errors_updated_at();

-- 11. Create function to update enrollments updated_at timestamp when payment fields change
CREATE OR REPLACE FUNCTION public.update_enrollments_payment_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  -- Only update timestamp if payment-related fields changed
  IF (OLD.payment_tracking_id IS DISTINCT FROM NEW.payment_tracking_id OR
      OLD.payment_gateway IS DISTINCT FROM NEW.payment_gateway OR
      OLD.payment_status IS DISTINCT FROM NEW.payment_status OR
      OLD.payment_method IS DISTINCT FROM NEW.payment_method) THEN
    NEW.updated_at = NOW();
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 12. Create trigger for enrollments payment updates
CREATE TRIGGER enrollments_payment_updated_at_trigger
  BEFORE UPDATE ON public.enrollments
  FOR EACH ROW
  EXECUTE FUNCTION public.update_enrollments_payment_updated_at();

-- 13. Add constraint to ensure payment_status values are valid
ALTER TABLE public.enrollments 
ADD CONSTRAINT check_payment_status 
CHECK (payment_status IN ('pending', 'completed', 'failed', 'cancelled', 'refunded'));

-- 14. Create view for admin dashboard payment tracking
CREATE OR REPLACE VIEW public.admin_payment_tracking AS
SELECT 
  e.id as enrollment_id,
  e.user_email,
  e.course_id,
  e.course_title,
  e.payment_method,
  e.payment_gateway,
  e.payment_status,
  e.payment_tracking_id,
  e.status as enrollment_status,
  e.enrolled_at,
  e.approved_at,
  e.progress,
  p.first_name,
  p.last_name,
  p.role,
  COUNT(pe.id) as error_count,
  MAX(pe.created_at) as last_error_at
FROM public.enrollments e
LEFT JOIN public.profiles p ON e.user_id = p.id
LEFT JOIN public.payment_errors pe ON e.id = pe.enrollment_id AND pe.resolved = false
GROUP BY 
  e.id, e.user_email, e.course_id, e.course_title, e.payment_method, 
  e.payment_gateway, e.payment_status, e.payment_tracking_id, 
  e.status, e.enrolled_at, e.approved_at, e.progress,
  p.first_name, p.last_name, p.role
ORDER BY e.created_at DESC;

-- 15. Grant permissions on the view
GRANT SELECT ON public.admin_payment_tracking TO authenticated;

-- 16. Create RLS policy for the view
CREATE POLICY "Admins and instructors can view payment tracking" ON public.admin_payment_tracking
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.profiles 
      WHERE id = auth.uid() 
      AND role IN ('instructor', 'admin')
    )
  );

-- Success message
SELECT 'Enhanced payment tracking schema migration completed successfully!' as status;