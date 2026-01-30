-- Create audit_logs table for tracking admin actions
CREATE TABLE IF NOT EXISTS audit_logs (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    admin_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    action_type VARCHAR(100) NOT NULL,
    target_type VARCHAR(50) NOT NULL CHECK (target_type IN ('user', 'enrollment', 'system')),
    target_id UUID,
    action_details JSONB NOT NULL DEFAULT '{}',
    ip_address INET,
    user_agent TEXT,
    session_id VARCHAR(100),
    timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_audit_logs_admin_id ON audit_logs(admin_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_action_type ON audit_logs(action_type);
CREATE INDEX IF NOT EXISTS idx_audit_logs_target_type ON audit_logs(target_type);
CREATE INDEX IF NOT EXISTS idx_audit_logs_target_id ON audit_logs(target_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_timestamp ON audit_logs(timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_audit_logs_session_id ON audit_logs(session_id);

-- Create composite indexes for common query patterns
CREATE INDEX IF NOT EXISTS idx_audit_logs_admin_timestamp ON audit_logs(admin_id, timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_audit_logs_target_timestamp ON audit_logs(target_type, target_id, timestamp DESC);

-- Enable Row Level Security
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;

-- Create RLS policies
-- Only admins can view audit logs
CREATE POLICY "Admins can view audit logs" ON audit_logs
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM profiles 
            WHERE profiles.id = auth.uid() 
            AND profiles.role = 'admin'
        )
    );

-- Only the system can insert audit logs (through service role)
CREATE POLICY "System can insert audit logs" ON audit_logs
    FOR INSERT
    WITH CHECK (true);

-- No updates or deletes allowed (audit logs should be immutable)
CREATE POLICY "No updates allowed" ON audit_logs
    FOR UPDATE
    USING (false);

CREATE POLICY "No deletes allowed" ON audit_logs
    FOR DELETE
    USING (false);

-- Create a function to automatically clean up old audit logs
CREATE OR REPLACE FUNCTION cleanup_old_audit_logs(retention_days INTEGER DEFAULT 365)
RETURNS INTEGER AS $$
DECLARE
    deleted_count INTEGER;
BEGIN
    DELETE FROM audit_logs 
    WHERE timestamp < NOW() - (retention_days || ' days')::INTERVAL;
    
    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    
    RETURN deleted_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create a view for audit log summaries
CREATE OR REPLACE VIEW audit_log_summary AS
SELECT 
    DATE(timestamp) as log_date,
    action_type,
    target_type,
    COUNT(*) as action_count,
    COUNT(DISTINCT admin_id) as unique_admins,
    COUNT(DISTINCT target_id) as unique_targets
FROM audit_logs
WHERE timestamp >= NOW() - INTERVAL '30 days'
GROUP BY DATE(timestamp), action_type, target_type
ORDER BY log_date DESC, action_count DESC;

-- Grant necessary permissions
GRANT SELECT ON audit_log_summary TO authenticated;

-- Add comments for documentation
COMMENT ON TABLE audit_logs IS 'Audit trail for all administrative actions in the system';
COMMENT ON COLUMN audit_logs.admin_id IS 'ID of the admin user who performed the action';
COMMENT ON COLUMN audit_logs.action_type IS 'Type of action performed (e.g., USER_CREATED, ENROLLMENT_APPROVED)';
COMMENT ON COLUMN audit_logs.target_type IS 'Type of entity the action was performed on';
COMMENT ON COLUMN audit_logs.target_id IS 'ID of the specific entity the action was performed on';
COMMENT ON COLUMN audit_logs.action_details IS 'JSON object containing detailed information about the action';
COMMENT ON COLUMN audit_logs.ip_address IS 'IP address from which the action was performed';
COMMENT ON COLUMN audit_logs.user_agent IS 'User agent string of the client that performed the action';
COMMENT ON COLUMN audit_logs.session_id IS 'Session identifier for tracking related actions';
COMMENT ON COLUMN audit_logs.timestamp IS 'When the action was performed';

-- Create a trigger to prevent modifications to audit logs
CREATE OR REPLACE FUNCTION prevent_audit_log_modifications()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'UPDATE' THEN
        RAISE EXCEPTION 'Audit logs cannot be modified';
    END IF;
    
    IF TG_OP = 'DELETE' THEN
        -- Only allow deletion by the cleanup function
        IF current_setting('application_name', true) != 'audit_cleanup' THEN
            RAISE EXCEPTION 'Audit logs cannot be deleted manually';
        END IF;
    END IF;
    
    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER prevent_audit_modifications
    BEFORE UPDATE OR DELETE ON audit_logs
    FOR EACH ROW
    EXECUTE FUNCTION prevent_audit_log_modifications();