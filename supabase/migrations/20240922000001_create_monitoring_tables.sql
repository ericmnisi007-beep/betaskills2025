-- Create application_logs table
CREATE TABLE IF NOT EXISTS application_logs (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    level TEXT NOT NULL CHECK (level IN ('info', 'warn', 'error', 'debug')),
    category TEXT NOT NULL CHECK (category IN ('payment', 'enrollment', 'admin', 'system', 'performance')),
    message TEXT NOT NULL,
    metadata JSONB,
    user_id UUID REFERENCES auth.users(id),
    session_id TEXT,
    user_agent TEXT,
    url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create performance_metrics table
CREATE TABLE IF NOT EXISTS performance_metrics (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    metric_name TEXT NOT NULL,
    value NUMERIC NOT NULL,
    unit TEXT NOT NULL,
    category TEXT NOT NULL CHECK (category IN ('api_response_time', 'page_load_time', 'payment_processing_time', 'database_query_time')),
    metadata JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create error_reports table
CREATE TABLE IF NOT EXISTS error_reports (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    error_type TEXT NOT NULL,
    error_message TEXT NOT NULL,
    stack_trace TEXT,
    user_id UUID REFERENCES auth.users(id),
    session_id TEXT,
    url TEXT,
    user_agent TEXT,
    severity TEXT NOT NULL CHECK (severity IN ('low', 'medium', 'high', 'critical')),
    category TEXT NOT NULL CHECK (category IN ('payment', 'enrollment', 'admin', 'system')),
    metadata JSONB,
    resolved BOOLEAN DEFAULT FALSE,
    resolved_at TIMESTAMPTZ,
    resolved_by UUID REFERENCES auth.users(id),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_application_logs_timestamp ON application_logs(timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_application_logs_level ON application_logs(level);
CREATE INDEX IF NOT EXISTS idx_application_logs_category ON application_logs(category);
CREATE INDEX IF NOT EXISTS idx_application_logs_user_id ON application_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_application_logs_session_id ON application_logs(session_id);

CREATE INDEX IF NOT EXISTS idx_performance_metrics_timestamp ON performance_metrics(timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_performance_metrics_category ON performance_metrics(category);
CREATE INDEX IF NOT EXISTS idx_performance_metrics_metric_name ON performance_metrics(metric_name);

CREATE INDEX IF NOT EXISTS idx_error_reports_timestamp ON error_reports(timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_error_reports_severity ON error_reports(severity);
CREATE INDEX IF NOT EXISTS idx_error_reports_category ON error_reports(category);
CREATE INDEX IF NOT EXISTS idx_error_reports_resolved ON error_reports(resolved);
CREATE INDEX IF NOT EXISTS idx_error_reports_user_id ON error_reports(user_id);

-- Create RLS policies
ALTER TABLE application_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE performance_metrics ENABLE ROW LEVEL SECURITY;
ALTER TABLE error_reports ENABLE ROW LEVEL SECURITY;

-- Allow authenticated users to insert their own logs
CREATE POLICY "Users can insert their own logs" ON application_logs
    FOR INSERT WITH CHECK (auth.uid() = user_id OR user_id IS NULL);

-- Allow authenticated users to insert performance metrics
CREATE POLICY "Users can insert performance metrics" ON performance_metrics
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- Allow authenticated users to insert error reports
CREATE POLICY "Users can insert error reports" ON error_reports
    FOR INSERT WITH CHECK (auth.uid() = user_id OR user_id IS NULL);

-- Allow admins to view all logs
CREATE POLICY "Admins can view all logs" ON application_logs
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM user_profiles 
            WHERE user_profiles.id = auth.uid() 
            AND user_profiles.role = 'admin'
        )
    );

CREATE POLICY "Admins can view all performance metrics" ON performance_metrics
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM user_profiles 
            WHERE user_profiles.id = auth.uid() 
            AND user_profiles.role = 'admin'
        )
    );

CREATE POLICY "Admins can view all error reports" ON error_reports
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM user_profiles 
            WHERE user_profiles.id = auth.uid() 
            AND user_profiles.role = 'admin'
        )
    );

-- Allow admins to update error reports (mark as resolved)
CREATE POLICY "Admins can update error reports" ON error_reports
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM user_profiles 
            WHERE user_profiles.id = auth.uid() 
            AND user_profiles.role = 'admin'
        )
    );

-- Create functions for log cleanup (optional - for maintenance)
CREATE OR REPLACE FUNCTION cleanup_old_logs()
RETURNS void AS $$
BEGIN
    -- Delete logs older than 90 days
    DELETE FROM application_logs WHERE created_at < NOW() - INTERVAL '90 days';
    
    -- Delete performance metrics older than 30 days
    DELETE FROM performance_metrics WHERE created_at < NOW() - INTERVAL '30 days';
    
    -- Delete resolved error reports older than 180 days
    DELETE FROM error_reports WHERE resolved = TRUE AND resolved_at < NOW() - INTERVAL '180 days';
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create a view for error summary
CREATE OR REPLACE VIEW error_summary AS
SELECT 
    category,
    severity,
    error_type,
    COUNT(*) as error_count,
    COUNT(*) FILTER (WHERE resolved = FALSE) as unresolved_count,
    MAX(timestamp) as last_occurrence,
    MIN(timestamp) as first_occurrence
FROM error_reports
WHERE timestamp > NOW() - INTERVAL '7 days'
GROUP BY category, severity, error_type
ORDER BY error_count DESC;

-- Create a view for performance summary
CREATE OR REPLACE VIEW performance_summary AS
SELECT 
    category,
    metric_name,
    COUNT(*) as measurement_count,
    AVG(value) as avg_value,
    MIN(value) as min_value,
    MAX(value) as max_value,
    PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY value) as p95_value,
    unit
FROM performance_metrics
WHERE timestamp > NOW() - INTERVAL '24 hours'
GROUP BY category, metric_name, unit
ORDER BY avg_value DESC;