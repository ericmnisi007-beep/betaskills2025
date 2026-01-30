-- Payment Transactions Table
-- 
-- This table stores comprehensive payment transaction data for audit, compliance, and reconciliation.
-- Implements requirements 5.4 and 5.5 from the production payment validation fix.

-- Create payment_transactions table
CREATE TABLE IF NOT EXISTS payment_transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Transaction identification
  transaction_id TEXT UNIQUE NOT NULL,
  gateway_transaction_id TEXT,
  bank_transaction_id TEXT,
  reference_number TEXT NOT NULL,
  
  -- User and course information
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  user_email TEXT NOT NULL,
  course_id TEXT NOT NULL,
  course_title TEXT NOT NULL,
  
  -- Payment details
  amount NUMERIC(10,2) NOT NULL CHECK (amount > 0),
  currency TEXT NOT NULL DEFAULT 'ZAR',
  payment_method TEXT NOT NULL DEFAULT 'card',
  gateway_provider TEXT NOT NULL DEFAULT 'ikhokha',
  
  -- Transaction status and lifecycle
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN (
    'pending', 'processing', 'approved', 'declined', 'failed', 'cancelled', 'refunded'
  )),
  
  -- Card information (masked for security)
  card_last_four TEXT,
  card_type TEXT,
  card_brand TEXT,
  
  -- Timestamps
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  processed_at TIMESTAMPTZ,
  verified_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  
  -- Failure and error information
  failure_reason TEXT,
  failure_code TEXT,
  gateway_error_code TEXT,
  gateway_error_message TEXT,
  
  -- Security and fraud prevention
  ip_address INET,
  user_agent TEXT,
  session_id TEXT,
  device_fingerprint TEXT,
  risk_score INTEGER DEFAULT 0 CHECK (risk_score >= 0 AND risk_score <= 100),
  fraud_flags JSONB DEFAULT '[]'::jsonb,
  
  -- Validation and verification
  validation_checks JSONB DEFAULT '{}'::jsonb,
  gateway_response JSONB DEFAULT '{}'::jsonb,
  webhook_data JSONB DEFAULT '{}'::jsonb,
  
  -- Audit and compliance
  attempt_number INTEGER NOT NULL DEFAULT 1 CHECK (attempt_number > 0),
  retry_count INTEGER NOT NULL DEFAULT 0 CHECK (retry_count >= 0),
  is_test_transaction BOOLEAN NOT NULL DEFAULT FALSE,
  compliance_flags JSONB DEFAULT '[]'::jsonb,
  
  -- Metadata for additional information
  metadata JSONB DEFAULT '{}'::jsonb,
  
  -- Soft delete support
  deleted_at TIMESTAMPTZ,
  deleted_by UUID REFERENCES auth.users(id)
);

-- Create indexes for efficient querying
CREATE INDEX IF NOT EXISTS idx_payment_transactions_transaction_id 
  ON payment_transactions(transaction_id);

CREATE INDEX IF NOT EXISTS idx_payment_transactions_user_id 
  ON payment_transactions(user_id);

CREATE INDEX IF NOT EXISTS idx_payment_transactions_course_id 
  ON payment_transactions(course_id);

CREATE INDEX IF NOT EXISTS idx_payment_transactions_status 
  ON payment_transactions(status);

CREATE INDEX IF NOT EXISTS idx_payment_transactions_created_at 
  ON payment_transactions(created_at DESC);

CREATE INDEX IF NOT EXISTS idx_payment_transactions_gateway_transaction_id 
  ON payment_transactions(gateway_transaction_id) 
  WHERE gateway_transaction_id IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_payment_transactions_bank_transaction_id 
  ON payment_transactions(bank_transaction_id) 
  WHERE bank_transaction_id IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_payment_transactions_user_email 
  ON payment_transactions(user_email);

CREATE INDEX IF NOT EXISTS idx_payment_transactions_reference_number 
  ON payment_transactions(reference_number);

-- Composite indexes for common queries
CREATE INDEX IF NOT EXISTS idx_payment_transactions_user_status 
  ON payment_transactions(user_id, status);

CREATE INDEX IF NOT EXISTS idx_payment_transactions_course_status 
  ON payment_transactions(course_id, status);

CREATE INDEX IF NOT EXISTS idx_payment_transactions_date_status 
  ON payment_transactions(created_at DESC, status);

-- Index for audit queries
CREATE INDEX IF NOT EXISTS idx_payment_transactions_audit 
  ON payment_transactions(created_at DESC, user_id, status) 
  WHERE deleted_at IS NULL;

-- Index for fraud detection queries
CREATE INDEX IF NOT EXISTS idx_payment_transactions_fraud 
  ON payment_transactions(ip_address, created_at DESC, risk_score) 
  WHERE status IN ('declined', 'failed') AND deleted_at IS NULL;

-- Function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_payment_transactions_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to automatically update updated_at
CREATE TRIGGER trigger_update_payment_transactions_updated_at
  BEFORE UPDATE ON payment_transactions
  FOR EACH ROW
  EXECUTE FUNCTION update_payment_transactions_updated_at();

-- Row Level Security (RLS) policies
ALTER TABLE payment_transactions ENABLE ROW LEVEL SECURITY;

-- Policy: Users can only see their own transactions
CREATE POLICY "Users can view own payment transactions" ON payment_transactions
  FOR SELECT USING (auth.uid() = user_id);

-- Policy: Only authenticated users can insert transactions
CREATE POLICY "Authenticated users can insert payment transactions" ON payment_transactions
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Policy: Users can update their own pending transactions
CREATE POLICY "Users can update own pending transactions" ON payment_transactions
  FOR UPDATE USING (
    auth.uid() = user_id AND 
    status IN ('pending', 'processing')
  );

-- Policy: Admin users can view all transactions (requires admin role)
CREATE POLICY "Admin users can view all payment transactions" ON payment_transactions
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM auth.users 
      WHERE auth.users.id = auth.uid() 
      AND auth.users.raw_user_meta_data->>'role' = 'admin'
    )
  );

-- Create a view for transaction summaries (without sensitive data)
CREATE OR REPLACE VIEW payment_transaction_summaries AS
SELECT 
  id,
  transaction_id,
  user_id,
  user_email,
  course_id,
  course_title,
  amount,
  currency,
  payment_method,
  gateway_provider,
  status,
  card_last_four,
  card_type,
  created_at,
  updated_at,
  processed_at,
  verified_at,
  completed_at,
  failure_reason,
  attempt_number,
  retry_count,
  is_test_transaction
FROM payment_transactions
WHERE deleted_at IS NULL;

-- Grant appropriate permissions
GRANT SELECT ON payment_transaction_summaries TO authenticated;
GRANT ALL ON payment_transactions TO authenticated;

-- Create function for transaction cleanup (data retention)
CREATE OR REPLACE FUNCTION cleanup_old_payment_transactions(retention_days INTEGER DEFAULT 2555) -- ~7 years default
RETURNS INTEGER AS $$
DECLARE
  deleted_count INTEGER;
BEGIN
  -- Soft delete old transactions (keep for compliance)
  UPDATE payment_transactions 
  SET deleted_at = NOW(), 
      deleted_by = auth.uid()
  WHERE created_at < NOW() - INTERVAL '1 day' * retention_days
    AND deleted_at IS NULL
    AND status IN ('declined', 'failed', 'cancelled');
  
  GET DIAGNOSTICS deleted_count = ROW_COUNT;
  
  RETURN deleted_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create function for transaction statistics
CREATE OR REPLACE FUNCTION get_payment_transaction_stats(
  start_date TIMESTAMPTZ DEFAULT NOW() - INTERVAL '30 days',
  end_date TIMESTAMPTZ DEFAULT NOW()
)
RETURNS TABLE (
  total_transactions BIGINT,
  successful_transactions BIGINT,
  failed_transactions BIGINT,
  total_amount NUMERIC,
  success_rate NUMERIC,
  average_amount NUMERIC
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    COUNT(*)::BIGINT as total_transactions,
    COUNT(*) FILTER (WHERE status = 'approved')::BIGINT as successful_transactions,
    COUNT(*) FILTER (WHERE status IN ('declined', 'failed'))::BIGINT as failed_transactions,
    COALESCE(SUM(amount) FILTER (WHERE status = 'approved'), 0) as total_amount,
    CASE 
      WHEN COUNT(*) > 0 THEN 
        ROUND((COUNT(*) FILTER (WHERE status = 'approved')::NUMERIC / COUNT(*)::NUMERIC) * 100, 2)
      ELSE 0 
    END as success_rate,
    COALESCE(AVG(amount) FILTER (WHERE status = 'approved'), 0) as average_amount
  FROM payment_transactions
  WHERE created_at BETWEEN start_date AND end_date
    AND deleted_at IS NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Add comments for documentation
COMMENT ON TABLE payment_transactions IS 'Comprehensive payment transaction logging for audit, compliance, and reconciliation';
COMMENT ON COLUMN payment_transactions.transaction_id IS 'Unique transaction identifier generated by the application';
COMMENT ON COLUMN payment_transactions.gateway_transaction_id IS 'Transaction ID from the payment gateway (Ikhokha)';
COMMENT ON COLUMN payment_transactions.bank_transaction_id IS 'Transaction ID from the bank/card issuer';
COMMENT ON COLUMN payment_transactions.risk_score IS 'Fraud risk score from 0 (low risk) to 100 (high risk)';
COMMENT ON COLUMN payment_transactions.validation_checks IS 'JSON object containing card validation results';
COMMENT ON COLUMN payment_transactions.gateway_response IS 'Full response from payment gateway for debugging';
COMMENT ON COLUMN payment_transactions.webhook_data IS 'Webhook payload data for transaction updates';
COMMENT ON COLUMN payment_transactions.fraud_flags IS 'Array of fraud detection flags';
COMMENT ON COLUMN payment_transactions.compliance_flags IS 'Array of compliance-related flags';
COMMENT ON COLUMN payment_transactions.metadata IS 'Additional transaction metadata';

-- Create notification function for real-time updates
CREATE OR REPLACE FUNCTION notify_payment_transaction_change()
RETURNS TRIGGER AS $$
BEGIN
  -- Notify about transaction status changes
  IF TG_OP = 'UPDATE' AND OLD.status != NEW.status THEN
    PERFORM pg_notify(
      'payment_transaction_status_change',
      json_build_object(
        'transaction_id', NEW.transaction_id,
        'user_id', NEW.user_id,
        'old_status', OLD.status,
        'new_status', NEW.status,
        'updated_at', NEW.updated_at
      )::text
    );
  END IF;
  
  -- Notify about new transactions
  IF TG_OP = 'INSERT' THEN
    PERFORM pg_notify(
      'payment_transaction_created',
      json_build_object(
        'transaction_id', NEW.transaction_id,
        'user_id', NEW.user_id,
        'amount', NEW.amount,
        'status', NEW.status,
        'created_at', NEW.created_at
      )::text
    );
  END IF;
  
  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

-- Create triggers for notifications
CREATE TRIGGER trigger_payment_transaction_change_notification
  AFTER INSERT OR UPDATE ON payment_transactions
  FOR EACH ROW
  EXECUTE FUNCTION notify_payment_transaction_change();