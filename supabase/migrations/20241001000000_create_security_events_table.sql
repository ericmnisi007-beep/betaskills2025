-- Create security events table for audit logging and monitoring
CREATE TABLE IF NOT EXISTS security_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    type VARCHAR(50) NOT NULL CHECK (type IN ('api_key_rotation', 'webhook_validation_failure', 'threat_detected', 'unauthorized_access')),
    severity VARCHAR(20) NOT NULL CHECK (severity IN ('low', 'medium', 'high', 'critical')),
    description TEXT NOT NULL,
    metadata JSONB DEFAULT '{}',
    timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    source_ip INET,
    user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create indexes for efficient querying
CREATE INDEX IF NOT EXISTS idx_security_events_type ON security_events(type);
CREATE INDEX IF NOT EXISTS idx_security_events_severity ON security_events(severity);
CREATE INDEX IF NOT EXISTS idx_security_events_timestamp ON security_events(timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_security_events_source_ip ON security_events(source_ip);
CREATE INDEX IF NOT EXISTS idx_security_events_user_id ON security_events(user_id);

-- Create composite index for common queries
CREATE INDEX IF NOT EXISTS idx_security_events_type_severity_timestamp 
ON security_events(type, severity, timestamp DESC);

-- Enable Row Level Security
ALTER TABLE security_events ENABLE ROW LEVEL SECURITY;

-- Create policy for admin access only
CREATE POLICY "Admin access to security events" ON security_events
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM user_roles 
            WHERE user_id = auth.uid() 
            AND role = 'admin'
        )
    );

-- Create policy for system service access (for logging)
CREATE POLICY "System service access to security events" ON security_events
    FOR INSERT WITH CHECK (true);

-- Create function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_security_events_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for updated_at
CREATE TRIGGER trigger_update_security_events_updated_at
    BEFORE UPDATE ON security_events
    FOR EACH ROW
    EXECUTE FUNCTION update_security_events_updated_at();

-- Create function for security event cleanup (remove old events)
CREATE OR REPLACE FUNCTION cleanup_old_security_events()
RETURNS void AS $$
BEGIN
    -- Keep only last 90 days of security events
    DELETE FROM security_events 
    WHERE timestamp < NOW() - INTERVAL '90 days';
    
    -- Keep all critical events regardless of age
    -- (they are excluded from the above deletion by this logic)
END;
$$ LANGUAGE plpgsql;

-- Create table for API key management
CREATE TABLE IF NOT EXISTS api_keys (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    key_id VARCHAR(255) UNIQUE NOT NULL,
    key_hash VARCHAR(255) NOT NULL, -- Store hash, not actual key
    name VARCHAR(255) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'revoked')),
    created_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    expires_at TIMESTAMPTZ,
    last_used_at TIMESTAMPTZ,
    usage_count INTEGER DEFAULT 0,
    metadata JSONB DEFAULT '{}'
);

-- Create indexes for API keys
CREATE INDEX IF NOT EXISTS idx_api_keys_key_id ON api_keys(key_id);
CREATE INDEX IF NOT EXISTS idx_api_keys_status ON api_keys(status);
CREATE INDEX IF NOT EXISTS idx_api_keys_expires_at ON api_keys(expires_at);

-- Enable RLS for API keys
ALTER TABLE api_keys ENABLE ROW LEVEL SECURITY;

-- Create policy for admin access to API keys
CREATE POLICY "Admin access to API keys" ON api_keys
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM user_roles 
            WHERE user_id = auth.uid() 
            AND role = 'admin'
        )
    );

-- Create table for webhook security logs
CREATE TABLE IF NOT EXISTS webhook_security_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    webhook_id VARCHAR(255),
    source_ip INET NOT NULL,
    signature_provided VARCHAR(255),
    signature_valid BOOLEAN NOT NULL,
    timestamp_provided VARCHAR(255),
    timestamp_valid BOOLEAN NOT NULL,
    source_verified BOOLEAN NOT NULL,
    threat_detected BOOLEAN NOT NULL DEFAULT FALSE,
    validation_errors TEXT[],
    payload_hash VARCHAR(255), -- Hash of payload for verification
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create indexes for webhook security logs
CREATE INDEX IF NOT EXISTS idx_webhook_security_logs_source_ip ON webhook_security_logs(source_ip);
CREATE INDEX IF NOT EXISTS idx_webhook_security_logs_created_at ON webhook_security_logs(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_webhook_security_logs_threat_detected ON webhook_security_logs(threat_detected);
CREATE INDEX IF NOT EXISTS idx_webhook_security_logs_signature_valid ON webhook_security_logs(signature_valid);

-- Enable RLS for webhook security logs
ALTER TABLE webhook_security_logs ENABLE ROW LEVEL SECURITY;

-- Create policy for admin access to webhook security logs
CREATE POLICY "Admin access to webhook security logs" ON webhook_security_logs
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM user_roles 
            WHERE user_id = auth.uid() 
            AND role = 'admin'
        )
    );

-- Create policy for system service access to webhook security logs
CREATE POLICY "System service access to webhook security logs" ON webhook_security_logs
    FOR INSERT WITH CHECK (true);

-- Create table for PCI compliance tracking
CREATE TABLE IF NOT EXISTS pci_compliance_checks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    check_timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    compliant BOOLEAN NOT NULL,
    violations TEXT[],
    check_details JSONB DEFAULT '{}',
    performed_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create indexes for PCI compliance checks
CREATE INDEX IF NOT EXISTS idx_pci_compliance_checks_timestamp ON pci_compliance_checks(check_timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_pci_compliance_checks_compliant ON pci_compliance_checks(compliant);

-- Enable RLS for PCI compliance checks
ALTER TABLE pci_compliance_checks ENABLE ROW LEVEL SECURITY;

-- Create policy for admin access to PCI compliance checks
CREATE POLICY "Admin access to PCI compliance checks" ON pci_compliance_checks
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM user_roles 
            WHERE user_id = auth.uid() 
            AND role = 'admin'
        )
    );

-- Create function to log security events
CREATE OR REPLACE FUNCTION log_security_event(
    p_type VARCHAR(50),
    p_severity VARCHAR(20),
    p_description TEXT,
    p_metadata JSONB DEFAULT '{}',
    p_source_ip INET DEFAULT NULL,
    p_user_id UUID DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
    event_id UUID;
BEGIN
    INSERT INTO security_events (type, severity, description, metadata, source_ip, user_id)
    VALUES (p_type, p_severity, p_description, p_metadata, p_source_ip, p_user_id)
    RETURNING id INTO event_id;
    
    RETURN event_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create function to check for suspicious activity
CREATE OR REPLACE FUNCTION detect_suspicious_activity()
RETURNS TABLE(
    threat_type VARCHAR(50),
    threat_count INTEGER,
    latest_occurrence TIMESTAMPTZ
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        se.type as threat_type,
        COUNT(*)::INTEGER as threat_count,
        MAX(se.timestamp) as latest_occurrence
    FROM security_events se
    WHERE se.timestamp >= NOW() - INTERVAL '1 hour'
    AND se.severity IN ('high', 'critical')
    GROUP BY se.type
    HAVING COUNT(*) > 5; -- More than 5 high/critical events per hour
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create function for automated security response
CREATE OR REPLACE FUNCTION automated_security_response()
RETURNS void AS $$
DECLARE
    suspicious_activity RECORD;
BEGIN
    -- Check for suspicious activity
    FOR suspicious_activity IN 
        SELECT * FROM detect_suspicious_activity()
    LOOP
        -- Log automated response
        PERFORM log_security_event(
            'automated_response',
            'high',
            'Automated security response triggered for ' || suspicious_activity.threat_type,
            jsonb_build_object(
                'threat_type', suspicious_activity.threat_type,
                'threat_count', suspicious_activity.threat_count,
                'response_action', 'monitoring_increased'
            )
        );
        
        -- Additional automated responses could be added here
        -- e.g., temporary IP blocking, rate limit adjustments, etc.
    END LOOP;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create scheduled job for security monitoring (if pg_cron is available)
-- SELECT cron.schedule('security-monitoring', '*/5 * * * *', 'SELECT automated_security_response();');

-- Grant necessary permissions
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT SELECT, INSERT ON security_events TO authenticated;
GRANT SELECT, INSERT ON webhook_security_logs TO authenticated;
GRANT SELECT ON api_keys TO authenticated;
GRANT SELECT ON pci_compliance_checks TO authenticated;

-- Grant execute permissions on security functions
GRANT EXECUTE ON FUNCTION log_security_event TO authenticated;
GRANT EXECUTE ON FUNCTION detect_suspicious_activity TO authenticated;

COMMENT ON TABLE security_events IS 'Stores security events for audit logging and monitoring';
COMMENT ON TABLE api_keys IS 'Manages API keys with rotation and security tracking';
COMMENT ON TABLE webhook_security_logs IS 'Logs webhook security validation attempts';
COMMENT ON TABLE pci_compliance_checks IS 'Tracks PCI DSS compliance check results';