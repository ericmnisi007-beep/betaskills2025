-- Create error_reports table for tracking application errors
CREATE TABLE IF NOT EXISTS error_reports (
    id TEXT PRIMARY KEY,
    message TEXT NOT NULL,
    stack TEXT,
    component_stack TEXT,
    user_agent TEXT,
    url TEXT,
    user_id UUID REFERENCES auth.users(id),
    severity TEXT CHECK (severity IN ('low', 'medium', 'high', 'critical')) DEFAULT 'medium',
    resolved BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create performance_metrics table for tracking performance data
CREATE TABLE IF NOT EXISTS performance_metrics (
    id TEXT PRIMARY KEY,
    metric_name TEXT NOT NULL,
    value NUMERIC NOT NULL,
    context JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_error_reports_created_at ON error_reports(created_at);
CREATE INDEX IF NOT EXISTS idx_error_reports_severity ON error_reports(severity);
CREATE INDEX IF NOT EXISTS idx_error_reports_resolved ON error_reports(resolved);
CREATE INDEX IF NOT EXISTS idx_error_reports_user_id ON error_reports(user_id);

CREATE INDEX IF NOT EXISTS idx_performance_metrics_created_at ON performance_metrics(created_at);
CREATE INDEX IF NOT EXISTS idx_performance_metrics_metric_name ON performance_metrics(metric_name);

-- Create updated_at trigger for error_reports
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_error_reports_updated_at 
    BEFORE UPDATE ON error_reports 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- Enable RLS (Row Level Security)
ALTER TABLE error_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE performance_metrics ENABLE ROW LEVEL SECURITY;

-- Create RLS policies for error_reports
CREATE POLICY "Admin users can view all error reports" ON error_reports
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM profiles 
            WHERE profiles.id = auth.uid() 
            AND profiles.role = 'admin'
        )
    );

CREATE POLICY "System can insert error reports" ON error_reports
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Admin users can update error reports" ON error_reports
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM profiles 
            WHERE profiles.id = auth.uid() 
            AND profiles.role = 'admin'
        )
    );

-- Create RLS policies for performance_metrics
CREATE POLICY "Admin users can view all performance metrics" ON performance_metrics
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM profiles 
            WHERE profiles.id = auth.uid() 
            AND profiles.role = 'admin'
        )
    );

CREATE POLICY "System can insert performance metrics" ON performance_metrics
    FOR INSERT WITH CHECK (true);

-- Create function to clean up old data
CREATE OR REPLACE FUNCTION cleanup_old_monitoring_data()
RETURNS void AS $$
BEGIN
    -- Delete error reports older than 30 days
    DELETE FROM error_reports 
    WHERE created_at < NOW() - INTERVAL '30 days';
    
    -- Delete performance metrics older than 7 days
    DELETE FROM performance_metrics 
    WHERE created_at < NOW() - INTERVAL '7 days';
END;
$$ LANGUAGE plpgsql;

-- Create a scheduled job to run cleanup (if pg_cron is available)
-- This would typically be set up separately in production
-- SELECT cron.schedule('cleanup-monitoring-data', '0 2 * * *', 'SELECT cleanup_old_monitoring_data();');