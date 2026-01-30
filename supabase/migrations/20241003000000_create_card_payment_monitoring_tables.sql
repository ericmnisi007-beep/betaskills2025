-- Card Payment Monitoring Tables
-- Creates tables for tracking metrics, performance, alerts, and business metrics

-- Card Payment Metrics Table
CREATE TABLE IF NOT EXISTS card_payment_metrics (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  total_card_payments INTEGER NOT NULL DEFAULT 0,
  successful_approvals INTEGER NOT NULL DEFAULT 0,
  failed_approvals INTEGER NOT NULL DEFAULT 0,
  average_processing_time NUMERIC NOT NULL DEFAULT 0,
  immediate_access_granted INTEGER NOT NULL DEFAULT 0,
  ui_update_success_rate NUMERIC NOT NULL DEFAULT 0,
  error_rate NUMERIC NOT NULL DEFAULT 0,
  timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create index for timestamp queries
CREATE INDEX IF NOT EXISTS idx_card_payment_metrics_timestamp 
  ON card_payment_metrics(timestamp DESC);

-- Card Payment Performance Table
CREATE TABLE IF NOT EXISTS card_payment_performance (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  webhook_processing_time NUMERIC NOT NULL DEFAULT 0,
  payment_detection_time NUMERIC NOT NULL DEFAULT 0,
  approval_processing_time NUMERIC NOT NULL DEFAULT 0,
  ui_update_time NUMERIC NOT NULL DEFAULT 0,
  persistence_time NUMERIC NOT NULL DEFAULT 0,
  total_end_to_end_time NUMERIC NOT NULL DEFAULT 0,
  timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create index for timestamp queries
CREATE INDEX IF NOT EXISTS idx_card_payment_performance_timestamp 
  ON card_payment_performance(timestamp DESC);

-- Card Payment Alerts Table
CREATE TABLE IF NOT EXISTS card_payment_alerts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  type TEXT NOT NULL,
  severity TEXT NOT NULL,
  title TEXT NOT NULL,
  message TEXT NOT NULL,
  context JSONB NOT NULL DEFAULT '{}'::jsonb,
  timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  resolved BOOLEAN NOT NULL DEFAULT FALSE,
  resolved_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create indexes for alert queries
CREATE INDEX IF NOT EXISTS idx_card_payment_alerts_timestamp 
  ON card_payment_alerts(timestamp DESC);

CREATE INDEX IF NOT EXISTS idx_card_payment_alerts_resolved 
  ON card_payment_alerts(resolved);

CREATE INDEX IF NOT EXISTS idx_card_payment_alerts_severity 
  ON card_payment_alerts(severity);

CREATE INDEX IF NOT EXISTS idx_card_payment_alerts_type 
  ON card_payment_alerts(type);

-- Card Payment Business Metrics Table
CREATE TABLE IF NOT EXISTS card_payment_business_metrics (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  card_payment_conversion_rate NUMERIC NOT NULL DEFAULT 0,
  average_time_to_access NUMERIC NOT NULL DEFAULT 0,
  user_satisfaction_score NUMERIC NOT NULL DEFAULT 0,
  manual_intervention_rate NUMERIC NOT NULL DEFAULT 0,
  timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create index for timestamp queries
CREATE INDEX IF NOT EXISTS idx_card_payment_business_metrics_timestamp 
  ON card_payment_business_metrics(timestamp DESC);

-- Add comments for documentation
COMMENT ON TABLE card_payment_metrics IS 'Tracks card payment system metrics including success rates and processing times';
COMMENT ON TABLE card_payment_performance IS 'Tracks detailed performance metrics for each stage of card payment processing';
COMMENT ON TABLE card_payment_alerts IS 'Stores system alerts for card payment processing issues';
COMMENT ON TABLE card_payment_business_metrics IS 'Tracks business-level metrics for card payment system';

-- Enable Row Level Security
ALTER TABLE card_payment_metrics ENABLE ROW LEVEL SECURITY;
ALTER TABLE card_payment_performance ENABLE ROW LEVEL SECURITY;
ALTER TABLE card_payment_alerts ENABLE ROW LEVEL SECURITY;
ALTER TABLE card_payment_business_metrics ENABLE ROW LEVEL SECURITY;

-- Create policies for admin access
CREATE POLICY "Admin users can view card payment metrics"
  ON card_payment_metrics FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid()
      AND profiles.role = 'admin'
    )
  );

CREATE POLICY "Admin users can insert card payment metrics"
  ON card_payment_metrics FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid()
      AND profiles.role = 'admin'
    )
  );

CREATE POLICY "Admin users can view card payment performance"
  ON card_payment_performance FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid()
      AND profiles.role = 'admin'
    )
  );

CREATE POLICY "Admin users can insert card payment performance"
  ON card_payment_performance FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid()
      AND profiles.role = 'admin'
    )
  );

CREATE POLICY "Admin users can view card payment alerts"
  ON card_payment_alerts FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid()
      AND profiles.role = 'admin'
    )
  );

CREATE POLICY "Admin users can insert card payment alerts"
  ON card_payment_alerts FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid()
      AND profiles.role = 'admin'
    )
  );

CREATE POLICY "Admin users can update card payment alerts"
  ON card_payment_alerts FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid()
      AND profiles.role = 'admin'
    )
  );

CREATE POLICY "Admin users can view card payment business metrics"
  ON card_payment_business_metrics FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid()
      AND profiles.role = 'admin'
    )
  );

CREATE POLICY "Admin users can insert card payment business metrics"
  ON card_payment_business_metrics FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid()
      AND profiles.role = 'admin'
    )
  );

-- Create function to clean up old metrics (data retention)
CREATE OR REPLACE FUNCTION cleanup_old_card_payment_metrics()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Delete metrics older than retention period (90 days default)
  DELETE FROM card_payment_metrics
  WHERE timestamp < NOW() - INTERVAL '90 days';

  DELETE FROM card_payment_performance
  WHERE timestamp < NOW() - INTERVAL '90 days';

  -- Delete resolved alerts older than retention period (365 days default)
  DELETE FROM card_payment_alerts
  WHERE resolved = TRUE
  AND resolved_at < NOW() - INTERVAL '365 days';

  DELETE FROM card_payment_business_metrics
  WHERE timestamp < NOW() - INTERVAL '90 days';
END;
$$;

-- Create scheduled job to run cleanup (requires pg_cron extension)
-- This should be run manually or via a cron job
-- SELECT cron.schedule('cleanup-card-payment-metrics', '0 2 * * *', 'SELECT cleanup_old_card_payment_metrics()');

COMMENT ON FUNCTION cleanup_old_card_payment_metrics IS 'Cleans up old card payment monitoring data based on retention policies';
