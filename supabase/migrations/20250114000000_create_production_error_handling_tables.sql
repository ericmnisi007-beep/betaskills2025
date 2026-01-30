-- Production Error Handling Tables
-- Creates tables for comprehensive error tracking, recovery attempts, and notifications

-- Production errors table
CREATE TABLE IF NOT EXISTS production_errors (
    id TEXT PRIMARY KEY,
    type TEXT NOT NULL,
    severity TEXT NOT NULL CHECK (severity IN ('low', 'medium', 'high', 'critical')),
    category TEXT NOT NULL,
    message TEXT NOT NULL,
    stack TEXT,
    context JSONB DEFAULT '{}',
    timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    source TEXT NOT NULL,
    user_id UUID REFERENCES auth.users(id),
    session_id TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Error recovery attempts table
CREATE TABLE IF NOT EXISTS error_recovery_attempts (
    attempt_id TEXT PRIMARY KEY,
    error_id TEXT NOT NULL REFERENCES production_errors(id),
    strategy_id TEXT NOT NULL,
    status TEXT NOT NULL CHECK (status IN ('pending', 'in_progress', 'completed', 'failed', 'manual_required')),
    started_at TIMESTAMPTZ NOT NULL,
    completed_at TIMESTAMPTZ,
    steps_completed TEXT[] DEFAULT '{}',
    steps_failed TEXT[] DEFAULT '{}',
    recovery_result TEXT NOT NULL CHECK (recovery_result IN ('success', 'partial_success', 'failure', 'manual_intervention_required')),
    manual_intervention_required BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Error notifications table
CREATE TABLE IF NOT EXISTS error_notifications (
    notification_id TEXT PRIMARY KEY,
    error_id TEXT NOT NULL REFERENCES production_errors(id),
    recipient_type TEXT NOT NULL CHECK (recipient_type IN ('email', 'slack', 'webhook', 'sms')),
    recipient TEXT NOT NULL,
    message TEXT NOT NULL,
    sent_at TIMESTAMPTZ NOT NULL,
    delivery_status TEXT NOT NULL CHECK (delivery_status IN ('pending', 'sent', 'delivered', 'failed')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Error patterns table
CREATE TABLE IF NOT EXISTS error_patterns (
    pattern_id TEXT PRIMARY KEY,
    description TEXT NOT NULL,
    frequency INTEGER DEFAULT 1,
    impact_score INTEGER DEFAULT 0,
    suggested_fixes TEXT[] DEFAULT '{}',
    first_seen TIMESTAMPTZ DEFAULT NOW(),
    last_seen TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Recovery strategies table
CREATE TABLE IF NOT EXISTS recovery_strategies (
    strategy_id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT NOT NULL,
    applicable_error_types TEXT[] DEFAULT '{}',
    recovery_steps JSONB DEFAULT '[]',
    success_rate DECIMAL(5,4) DEFAULT 0.0000,
    average_recovery_time INTEGER DEFAULT 0,
    requires_manual_intervention BOOLEAN DEFAULT FALSE,
    enabled BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Error metrics table for analytics
CREATE TABLE IF NOT EXISTS error_metrics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    metric_date DATE NOT NULL,
    total_errors INTEGER DEFAULT 0,
    errors_by_severity JSONB DEFAULT '{}',
    errors_by_category JSONB DEFAULT '{}',
    recovery_success_rate DECIMAL(5,4) DEFAULT 0.0000,
    manual_interventions INTEGER DEFAULT 0,
    average_resolution_time INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(metric_date)
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_production_errors_timestamp ON production_errors(timestamp);
CREATE INDEX IF NOT EXISTS idx_production_errors_type ON production_errors(type);
CREATE INDEX IF NOT EXISTS idx_production_errors_severity ON production_errors(severity);
CREATE INDEX IF NOT EXISTS idx_production_errors_category ON production_errors(category);
CREATE INDEX IF NOT EXISTS idx_production_errors_user_id ON production_errors(user_id);

CREATE INDEX IF NOT EXISTS idx_recovery_attempts_error_id ON error_recovery_attempts(error_id);
CREATE INDEX IF NOT EXISTS idx_recovery_attempts_status ON error_recovery_attempts(status);
CREATE INDEX IF NOT EXISTS idx_recovery_attempts_started_at ON error_recovery_attempts(started_at);

CREATE INDEX IF NOT EXISTS idx_error_notifications_error_id ON error_notifications(error_id);
CREATE INDEX IF NOT EXISTS idx_error_notifications_delivery_status ON error_notifications(delivery_status);
CREATE INDEX IF NOT EXISTS idx_error_notifications_sent_at ON error_notifications(sent_at);

CREATE INDEX IF NOT EXISTS idx_error_patterns_frequency ON error_patterns(frequency DESC);
CREATE INDEX IF NOT EXISTS idx_error_patterns_impact_score ON error_patterns(impact_score DESC);

CREATE INDEX IF NOT EXISTS idx_error_metrics_date ON error_metrics(metric_date);

-- RLS Policies
ALTER TABLE production_errors ENABLE ROW LEVEL SECURITY;
ALTER TABLE error_recovery_attempts ENABLE ROW LEVEL SECURITY;
ALTER TABLE error_notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE error_patterns ENABLE ROW LEVEL SECURITY;
ALTER TABLE recovery_strategies ENABLE ROW LEVEL SECURITY;
ALTER TABLE error_metrics ENABLE ROW LEVEL SECURITY;

-- Allow service role to manage all error data
CREATE POLICY "Service role can manage production errors" ON production_errors
    FOR ALL USING (auth.role() = 'service_role');

CREATE POLICY "Service role can manage recovery attempts" ON error_recovery_attempts
    FOR ALL USING (auth.role() = 'service_role');

CREATE POLICY "Service role can manage error notifications" ON error_notifications
    FOR ALL USING (auth.role() = 'service_role');

CREATE POLICY "Service role can manage error patterns" ON error_patterns
    FOR ALL USING (auth.role() = 'service_role');

CREATE POLICY "Service role can manage recovery strategies" ON recovery_strategies
    FOR ALL USING (auth.role() = 'service_role');

CREATE POLICY "Service role can manage error metrics" ON error_metrics
    FOR ALL USING (auth.role() = 'service_role');

-- Allow authenticated users to read their own errors
CREATE POLICY "Users can read their own errors" ON production_errors
    FOR SELECT USING (auth.uid() = user_id);

-- Allow admins to read all error data
CREATE POLICY "Admins can read all error data" ON production_errors
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM user_profiles 
            WHERE user_id = auth.uid() 
            AND role = 'admin'
        )
    );

CREATE POLICY "Admins can read all recovery attempts" ON error_recovery_attempts
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM user_profiles 
            WHERE user_id = auth.uid() 
            AND role = 'admin'
        )
    );

CREATE POLICY "Admins can read all error notifications" ON error_notifications
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM user_profiles 
            WHERE user_id = auth.uid() 
            AND role = 'admin'
        )
    );

CREATE POLICY "Admins can read error patterns" ON error_patterns
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM user_profiles 
            WHERE user_id = auth.uid() 
            AND role = 'admin'
        )
    );

CREATE POLICY "Admins can read recovery strategies" ON recovery_strategies
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM user_profiles 
            WHERE user_id = auth.uid() 
            AND role = 'admin'
        )
    );

CREATE POLICY "Admins can read error metrics" ON error_metrics
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM user_profiles 
            WHERE user_id = auth.uid() 
            AND role = 'admin'
        )
    );

-- Functions for error analytics
CREATE OR REPLACE FUNCTION calculate_daily_error_metrics()
RETURNS VOID AS $$
DECLARE
    target_date DATE := CURRENT_DATE - INTERVAL '1 day';
    total_errors_count INTEGER;
    severity_counts JSONB;
    category_counts JSONB;
    success_rate DECIMAL(5,4);
    manual_count INTEGER;
    avg_resolution INTEGER;
BEGIN
    -- Calculate total errors for the day
    SELECT COUNT(*) INTO total_errors_count
    FROM production_errors
    WHERE DATE(timestamp) = target_date;

    -- Calculate errors by severity
    SELECT COALESCE(jsonb_object_agg(severity, error_count), '{}') INTO severity_counts
    FROM (
        SELECT severity, COUNT(*) as error_count
        FROM production_errors
        WHERE DATE(timestamp) = target_date
        GROUP BY severity
    ) severity_data;

    -- Calculate errors by category
    SELECT COALESCE(jsonb_object_agg(category, error_count), '{}') INTO category_counts
    FROM (
        SELECT category, COUNT(*) as error_count
        FROM production_errors
        WHERE DATE(timestamp) = target_date
        GROUP BY category
    ) category_data;

    -- Calculate recovery success rate
    SELECT COALESCE(
        (COUNT(*) FILTER (WHERE recovery_result = 'success')::DECIMAL / NULLIF(COUNT(*), 0)) * 100,
        0
    ) INTO success_rate
    FROM error_recovery_attempts era
    JOIN production_errors pe ON era.error_id = pe.id
    WHERE DATE(pe.timestamp) = target_date;

    -- Count manual interventions
    SELECT COUNT(*) INTO manual_count
    FROM error_recovery_attempts era
    JOIN production_errors pe ON era.error_id = pe.id
    WHERE DATE(pe.timestamp) = target_date
    AND era.manual_intervention_required = TRUE;

    -- Calculate average resolution time (in seconds)
    SELECT COALESCE(
        AVG(EXTRACT(EPOCH FROM (era.completed_at - era.started_at)))::INTEGER,
        0
    ) INTO avg_resolution
    FROM error_recovery_attempts era
    JOIN production_errors pe ON era.error_id = pe.id
    WHERE DATE(pe.timestamp) = target_date
    AND era.completed_at IS NOT NULL;

    -- Insert or update metrics
    INSERT INTO error_metrics (
        metric_date,
        total_errors,
        errors_by_severity,
        errors_by_category,
        recovery_success_rate,
        manual_interventions,
        average_resolution_time
    ) VALUES (
        target_date,
        total_errors_count,
        severity_counts,
        category_counts,
        success_rate,
        manual_count,
        avg_resolution
    )
    ON CONFLICT (metric_date) DO UPDATE SET
        total_errors = EXCLUDED.total_errors,
        errors_by_severity = EXCLUDED.errors_by_severity,
        errors_by_category = EXCLUDED.errors_by_category,
        recovery_success_rate = EXCLUDED.recovery_success_rate,
        manual_interventions = EXCLUDED.manual_interventions,
        average_resolution_time = EXCLUDED.average_resolution_time,
        updated_at = NOW();
END;
$$ LANGUAGE plpgsql;

-- Function to clean up old error data
CREATE OR REPLACE FUNCTION cleanup_old_error_data()
RETURNS VOID AS $$
BEGIN
    -- Delete error data older than 1 year
    DELETE FROM production_errors 
    WHERE timestamp < NOW() - INTERVAL '1 year';

    -- Delete recovery attempts older than 1 year
    DELETE FROM error_recovery_attempts 
    WHERE started_at < NOW() - INTERVAL '1 year';

    -- Delete notifications older than 6 months
    DELETE FROM error_notifications 
    WHERE sent_at < NOW() - INTERVAL '6 months';

    -- Update error patterns last_seen dates
    UPDATE error_patterns 
    SET last_seen = NOW() 
    WHERE pattern_id IN (
        SELECT DISTINCT CONCAT(type, '_', category)
        FROM production_errors 
        WHERE timestamp > NOW() - INTERVAL '30 days'
    );

    -- Delete unused error patterns (not seen in 6 months)
    DELETE FROM error_patterns 
    WHERE last_seen < NOW() - INTERVAL '6 months';
END;
$$ LANGUAGE plpgsql;

-- Insert default recovery strategies
INSERT INTO recovery_strategies (
    strategy_id,
    name,
    description,
    applicable_error_types,
    recovery_steps,
    success_rate,
    average_recovery_time,
    requires_manual_intervention
) VALUES 
(
    'payment_retry',
    'Payment Retry Strategy',
    'Retry payment processing with exponential backoff',
    ARRAY['payment_processing_error'],
    '[
        {
            "step_id": "validate_payment_data",
            "name": "Validate Payment Data",
            "description": "Validate payment data integrity",
            "action": "validate_configuration",
            "parameters": {"validation_type": "payment_data"},
            "timeout": 5000,
            "retry_count": 1,
            "success_criteria": "Payment data is valid"
        },
        {
            "step_id": "retry_payment",
            "name": "Retry Payment Processing",
            "description": "Retry the payment operation",
            "action": "retry_operation",
            "parameters": {"operation_type": "payment", "max_retries": 3},
            "timeout": 30000,
            "retry_count": 2,
            "success_criteria": "Payment processed successfully"
        }
    ]'::jsonb,
    0.8500,
    15000,
    FALSE
),
(
    'webhook_retry',
    'Webhook Retry Strategy',
    'Retry webhook processing with validation',
    ARRAY['webhook_processing_error'],
    '[
        {
            "step_id": "validate_webhook",
            "name": "Validate Webhook Data",
            "description": "Validate webhook signature and data",
            "action": "validate_configuration",
            "parameters": {"validation_type": "webhook"},
            "timeout": 5000,
            "retry_count": 1,
            "success_criteria": "Webhook data is valid"
        },
        {
            "step_id": "retry_webhook_processing",
            "name": "Retry Webhook Processing",
            "description": "Retry processing the webhook",
            "action": "retry_operation",
            "parameters": {"operation_type": "webhook", "max_retries": 2},
            "timeout": 15000,
            "retry_count": 1,
            "success_criteria": "Webhook processed successfully"
        }
    ]'::jsonb,
    0.9000,
    8000,
    FALSE
),
(
    'enrollment_recovery',
    'Enrollment Recovery Strategy',
    'Recover failed enrollment creation',
    ARRAY['enrollment_creation_error'],
    '[
        {
            "step_id": "validate_enrollment_data",
            "name": "Validate Enrollment Data",
            "description": "Validate enrollment data and dependencies",
            "action": "validate_configuration",
            "parameters": {"validation_type": "enrollment"},
            "timeout": 5000,
            "retry_count": 1,
            "success_criteria": "Enrollment data is valid"
        },
        {
            "step_id": "sync_enrollment_data",
            "name": "Sync Enrollment Data",
            "description": "Synchronize enrollment data across systems",
            "action": "sync_data",
            "parameters": {"sync_type": "enrollment"},
            "timeout": 10000,
            "retry_count": 2,
            "success_criteria": "Enrollment data synchronized"
        },
        {
            "step_id": "retry_enrollment_creation",
            "name": "Retry Enrollment Creation",
            "description": "Retry creating the enrollment",
            "action": "retry_operation",
            "parameters": {"operation_type": "enrollment", "max_retries": 2},
            "timeout": 20000,
            "retry_count": 1,
            "success_criteria": "Enrollment created successfully"
        }
    ]'::jsonb,
    0.7500,
    25000,
    FALSE
),
(
    'configuration_validation',
    'Configuration Validation Strategy',
    'Validate and fix configuration errors',
    ARRAY['configuration_error'],
    '[
        {
            "step_id": "validate_environment",
            "name": "Validate Environment Configuration",
            "description": "Validate environment variables and settings",
            "action": "validate_configuration",
            "parameters": {"validation_type": "environment"},
            "timeout": 5000,
            "retry_count": 0,
            "success_criteria": "Environment configuration is valid"
        },
        {
            "step_id": "refresh_configuration",
            "name": "Refresh Configuration",
            "description": "Refresh configuration from source",
            "action": "refresh_credentials",
            "parameters": {"refresh_type": "configuration"},
            "timeout": 10000,
            "retry_count": 1,
            "success_criteria": "Configuration refreshed successfully"
        }
    ]'::jsonb,
    0.9500,
    12000,
    FALSE
),
(
    'manual_escalation',
    'Manual Escalation Strategy',
    'Escalate critical errors to manual intervention',
    ARRAY['security_error', 'database_error'],
    '[
        {
            "step_id": "notify_stakeholders",
            "name": "Notify Stakeholders",
            "description": "Send immediate notifications to stakeholders",
            "action": "notify_stakeholders",
            "parameters": {"urgency": "critical"},
            "timeout": 5000,
            "retry_count": 2,
            "success_criteria": "Stakeholders notified"
        },
        {
            "step_id": "escalate_to_manual",
            "name": "Escalate to Manual Intervention",
            "description": "Create manual intervention ticket",
            "action": "escalate_to_manual",
            "parameters": {"priority": "critical"},
            "timeout": 2000,
            "retry_count": 0,
            "success_criteria": "Manual intervention initiated"
        }
    ]'::jsonb,
    1.0000,
    5000,
    TRUE
)
ON CONFLICT (strategy_id) DO NOTHING;

-- Create triggers for updated_at timestamps
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_production_errors_updated_at
    BEFORE UPDATE ON production_errors
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_error_recovery_attempts_updated_at
    BEFORE UPDATE ON error_recovery_attempts
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_error_notifications_updated_at
    BEFORE UPDATE ON error_notifications
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_error_patterns_updated_at
    BEFORE UPDATE ON error_patterns
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_recovery_strategies_updated_at
    BEFORE UPDATE ON recovery_strategies
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_error_metrics_updated_at
    BEFORE UPDATE ON error_metrics
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();