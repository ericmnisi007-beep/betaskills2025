-- Create tables for Card Payment Error Recovery System
-- Requirements: 6.1, 6.2, 6.3, 6.4

-- Manual Interventions Table
-- Tracks manual interventions triggered for unresolvable issues
CREATE TABLE IF NOT EXISTS manual_interventions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  error_id TEXT NOT NULL,
  intervention_type TEXT NOT NULL CHECK (intervention_type IN (
    'technical_review',
    'manual_approval', 
    'system_maintenance',
    'configuration_update',
    'escalation_to_admin',
    'emergency_response'
  )),
  priority TEXT NOT NULL CHECK (priority IN ('low', 'medium', 'high', 'urgent', 'emergency')),
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'in_progress', 'resolved', 'escalated')),
  assigned_to TEXT,
  context JSONB,
  details JSONB,
  requires_immediate_attention BOOLEAN DEFAULT FALSE,
  escalation_required BOOLEAN DEFAULT FALSE,
  estimated_resolution_time INTEGER, -- in seconds
  actual_resolution_time INTEGER, -- in seconds
  resolution_notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  resolved_at TIMESTAMP WITH TIME ZONE
);

-- Fallback Executions Table
-- Tracks fallback mechanism executions for critical failures
CREATE TABLE IF NOT EXISTS fallback_executions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  webhook_id TEXT NOT NULL,
  operation_type TEXT NOT NULL CHECK (operation_type IN (
    'webhook_processing',
    'payment_detection',
    'enrollment_approval',
    'access_granting',
    'status_synchronization'
  )),
  error_type TEXT NOT NULL,
  fallback_mechanism TEXT NOT NULL CHECK (fallback_mechanism IN (
    'manual_approval_queue',
    'admin_notification',
    'delayed_processing',
    'safe_mode_processing',
    'emergency_approval'
  )),
  success BOOLEAN NOT NULL,
  manual_approval_triggered BOOLEAN DEFAULT FALSE,
  execution_time INTEGER, -- in milliseconds
  details JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Error Recovery Attempts Table
-- Tracks recovery strategy attempts for processing errors
CREATE TABLE IF NOT EXISTS error_recovery_attempts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  webhook_id TEXT NOT NULL,
  error_id TEXT NOT NULL,
  recovery_strategy TEXT NOT NULL CHECK (recovery_strategy IN (
    'retry_with_backoff',
    'alternative_endpoint',
    'cached_data_fallback',
    'manual_approval_route',
    'graceful_degradation',
    'circuit_breaker_reset',
    'database_reconnection',
    'service_restart'
  )),
  success BOOLEAN NOT NULL,
  execution_time INTEGER, -- in milliseconds
  retry_count INTEGER DEFAULT 0,
  error_message TEXT,
  details JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- System Health Events Table
-- Tracks system health status changes and critical events
CREATE TABLE IF NOT EXISTS system_health_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  event_type TEXT NOT NULL CHECK (event_type IN (
    'health_status_change',
    'error_rate_threshold',
    'performance_degradation',
    'service_unavailable',
    'recovery_completed'
  )),
  severity TEXT NOT NULL CHECK (severity IN ('low', 'medium', 'high', 'critical')),
  previous_status TEXT,
  current_status TEXT CHECK (current_status IN ('healthy', 'degraded', 'critical', 'offline')),
  error_rate DECIMAL(5,2),
  success_rate DECIMAL(5,2),
  average_processing_time INTEGER, -- in milliseconds
  affected_services TEXT[],
  details JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Processing Error Log Table
-- Detailed log of all processing errors detected
CREATE TABLE IF NOT EXISTS processing_error_log (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  webhook_id TEXT NOT NULL,
  error_id TEXT NOT NULL,
  error_type TEXT NOT NULL,
  severity TEXT NOT NULL CHECK (severity IN ('low', 'medium', 'high', 'critical')),
  message TEXT NOT NULL,
  processing_stage TEXT NOT NULL CHECK (processing_stage IN (
    'webhook_received',
    'security_validation',
    'payment_type_detection',
    'enrollment_lookup',
    'fast_track_processing',
    'status_update',
    'real_time_sync',
    'audit_logging',
    'completion'
  )),
  enrollment_id UUID,
  user_id UUID,
  course_id UUID,
  payment_reference TEXT,
  transaction_id TEXT,
  recoverable BOOLEAN DEFAULT TRUE,
  retry_count INTEGER DEFAULT 0,
  max_retries INTEGER DEFAULT 3,
  context JSONB,
  details JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Circuit Breaker States Table
-- Tracks circuit breaker states for different services
CREATE TABLE IF NOT EXISTS circuit_breaker_states (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  service_name TEXT NOT NULL UNIQUE,
  state TEXT NOT NULL CHECK (state IN ('closed', 'open', 'half-open')),
  failure_count INTEGER DEFAULT 0,
  success_count INTEGER DEFAULT 0,
  last_failure_time TIMESTAMP WITH TIME ZONE,
  last_success_time TIMESTAMP WITH TIME ZONE,
  next_attempt_time TIMESTAMP WITH TIME ZONE,
  failure_threshold INTEGER DEFAULT 5,
  recovery_timeout INTEGER DEFAULT 60, -- in seconds
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_manual_interventions_status ON manual_interventions(status);
CREATE INDEX IF NOT EXISTS idx_manual_interventions_priority ON manual_interventions(priority);
CREATE INDEX IF NOT EXISTS idx_manual_interventions_created_at ON manual_interventions(created_at);
CREATE INDEX IF NOT EXISTS idx_manual_interventions_requires_attention ON manual_interventions(requires_immediate_attention);

CREATE INDEX IF NOT EXISTS idx_fallback_executions_webhook_id ON fallback_executions(webhook_id);
CREATE INDEX IF NOT EXISTS idx_fallback_executions_operation_type ON fallback_executions(operation_type);
CREATE INDEX IF NOT EXISTS idx_fallback_executions_success ON fallback_executions(success);
CREATE INDEX IF NOT EXISTS idx_fallback_executions_created_at ON fallback_executions(created_at);

CREATE INDEX IF NOT EXISTS idx_error_recovery_attempts_webhook_id ON error_recovery_attempts(webhook_id);
CREATE INDEX IF NOT EXISTS idx_error_recovery_attempts_error_id ON error_recovery_attempts(error_id);
CREATE INDEX IF NOT EXISTS idx_error_recovery_attempts_success ON error_recovery_attempts(success);
CREATE INDEX IF NOT EXISTS idx_error_recovery_attempts_created_at ON error_recovery_attempts(created_at);

CREATE INDEX IF NOT EXISTS idx_system_health_events_event_type ON system_health_events(event_type);
CREATE INDEX IF NOT EXISTS idx_system_health_events_severity ON system_health_events(severity);
CREATE INDEX IF NOT EXISTS idx_system_health_events_current_status ON system_health_events(current_status);
CREATE INDEX IF NOT EXISTS idx_system_health_events_created_at ON system_health_events(created_at);

CREATE INDEX IF NOT EXISTS idx_processing_error_log_webhook_id ON processing_error_log(webhook_id);
CREATE INDEX IF NOT EXISTS idx_processing_error_log_error_type ON processing_error_log(error_type);
CREATE INDEX IF NOT EXISTS idx_processing_error_log_severity ON processing_error_log(severity);
CREATE INDEX IF NOT EXISTS idx_processing_error_log_enrollment_id ON processing_error_log(enrollment_id);
CREATE INDEX IF NOT EXISTS idx_processing_error_log_created_at ON processing_error_log(created_at);

CREATE INDEX IF NOT EXISTS idx_circuit_breaker_states_service_name ON circuit_breaker_states(service_name);
CREATE INDEX IF NOT EXISTS idx_circuit_breaker_states_state ON circuit_breaker_states(state);
CREATE INDEX IF NOT EXISTS idx_circuit_breaker_states_updated_at ON circuit_breaker_states(updated_at);

-- Create updated_at trigger function if it doesn't exist
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at columns
CREATE TRIGGER update_manual_interventions_updated_at 
    BEFORE UPDATE ON manual_interventions 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_processing_error_log_updated_at 
    BEFORE UPDATE ON processing_error_log 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_circuit_breaker_states_updated_at 
    BEFORE UPDATE ON circuit_breaker_states 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Insert default circuit breaker states for key services
INSERT INTO circuit_breaker_states (service_name, state, failure_threshold, recovery_timeout) VALUES
  ('payment_detection', 'closed', 5, 60),
  ('fast_track_processing', 'closed', 3, 30),
  ('database_connection', 'closed', 10, 120),
  ('webhook_validation', 'closed', 5, 60),
  ('real_time_sync', 'closed', 5, 60)
ON CONFLICT (service_name) DO NOTHING;

-- Add RLS policies for security
ALTER TABLE manual_interventions ENABLE ROW LEVEL SECURITY;
ALTER TABLE fallback_executions ENABLE ROW LEVEL SECURITY;
ALTER TABLE error_recovery_attempts ENABLE ROW LEVEL SECURITY;
ALTER TABLE system_health_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE processing_error_log ENABLE ROW LEVEL SECURITY;
ALTER TABLE circuit_breaker_states ENABLE ROW LEVEL SECURITY;

-- Create policies for admin access
CREATE POLICY "Admin can manage manual interventions" ON manual_interventions
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.role = 'admin'
    )
  );

CREATE POLICY "Admin can view fallback executions" ON fallback_executions
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.role = 'admin'
    )
  );

CREATE POLICY "Admin can view error recovery attempts" ON error_recovery_attempts
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.role = 'admin'
    )
  );

CREATE POLICY "Admin can view system health events" ON system_health_events
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.role = 'admin'
    )
  );

CREATE POLICY "Admin can view processing error log" ON processing_error_log
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.role = 'admin'
    )
  );

CREATE POLICY "Admin can manage circuit breaker states" ON circuit_breaker_states
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.role = 'admin'
    )
  );

-- Create a view for error recovery dashboard
CREATE OR REPLACE VIEW error_recovery_dashboard AS
SELECT 
  pel.webhook_id,
  pel.error_type,
  pel.severity,
  pel.message,
  pel.processing_stage,
  pel.enrollment_id,
  pel.retry_count,
  pel.max_retries,
  pel.created_at as error_occurred_at,
  era.recovery_strategy,
  era.success as recovery_success,
  era.execution_time as recovery_time,
  fe.fallback_mechanism,
  fe.manual_approval_triggered,
  mi.intervention_type,
  mi.priority as intervention_priority,
  mi.status as intervention_status
FROM processing_error_log pel
LEFT JOIN error_recovery_attempts era ON pel.error_id = era.error_id
LEFT JOIN fallback_executions fe ON pel.webhook_id = fe.webhook_id
LEFT JOIN manual_interventions mi ON pel.error_id = mi.error_id
ORDER BY pel.created_at DESC;

-- Create a view for system health monitoring
CREATE OR REPLACE VIEW system_health_monitoring AS
SELECT 
  service_name,
  state,
  failure_count,
  success_count,
  last_failure_time,
  last_success_time,
  CASE 
    WHEN state = 'open' AND next_attempt_time > NOW() THEN 'cooling_down'
    WHEN state = 'open' AND next_attempt_time <= NOW() THEN 'ready_for_retry'
    ELSE state
  END as effective_state,
  failure_threshold,
  recovery_timeout,
  updated_at
FROM circuit_breaker_states
ORDER BY 
  CASE state 
    WHEN 'open' THEN 1 
    WHEN 'half-open' THEN 2 
    ELSE 3 
  END,
  failure_count DESC;

COMMENT ON TABLE manual_interventions IS 'Tracks manual interventions triggered for unresolvable card payment processing issues';
COMMENT ON TABLE fallback_executions IS 'Logs fallback mechanism executions when card payment processing fails';
COMMENT ON TABLE error_recovery_attempts IS 'Records recovery strategy attempts for card payment processing errors';
COMMENT ON TABLE system_health_events IS 'Monitors system health status changes and critical events';
COMMENT ON TABLE processing_error_log IS 'Detailed log of all card payment processing errors detected';
COMMENT ON TABLE circuit_breaker_states IS 'Tracks circuit breaker states for different payment processing services';
COMMENT ON VIEW error_recovery_dashboard IS 'Comprehensive view of error recovery activities for monitoring';
COMMENT ON VIEW system_health_monitoring IS 'Real-time view of system health and circuit breaker states';