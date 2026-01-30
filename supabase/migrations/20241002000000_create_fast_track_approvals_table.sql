-- Create fast_track_approvals table for audit logging
-- This table tracks all card payment fast-track approval events

CREATE TABLE IF NOT EXISTS fast_track_approvals (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    
    -- Enrollment and payment references
    enrollment_id UUID NOT NULL,
    transaction_id TEXT,
    payment_reference TEXT,
    payment_amount DECIMAL(10,2),
    payment_currency TEXT DEFAULT 'ZAR',
    
    -- Fast-track processing results
    fast_track_success BOOLEAN NOT NULL DEFAULT false,
    enrollment_approved BOOLEAN NOT NULL DEFAULT false,
    access_granted BOOLEAN NOT NULL DEFAULT false,
    processing_time_ms INTEGER,
    
    -- Error tracking
    error_code TEXT,
    error_message TEXT,
    error_recoverable BOOLEAN,
    
    -- Audit trail (JSON)
    audit_trail JSONB,
    
    -- Approval metadata
    approved_by TEXT NOT NULL DEFAULT 'system_card_payment',
    approval_type TEXT NOT NULL DEFAULT 'card_payment_fast_track',
    
    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Indexes for performance
    CONSTRAINT fk_fast_track_enrollment 
        FOREIGN KEY (enrollment_id) 
        REFERENCES enrollments(id) 
        ON DELETE CASCADE
);

-- Create indexes for efficient querying
CREATE INDEX IF NOT EXISTS idx_fast_track_approvals_enrollment_id 
    ON fast_track_approvals(enrollment_id);

CREATE INDEX IF NOT EXISTS idx_fast_track_approvals_transaction_id 
    ON fast_track_approvals(transaction_id);

CREATE INDEX IF NOT EXISTS idx_fast_track_approvals_created_at 
    ON fast_track_approvals(created_at DESC);

CREATE INDEX IF NOT EXISTS idx_fast_track_approvals_success 
    ON fast_track_approvals(fast_track_success, enrollment_approved);

-- Add RLS (Row Level Security) policies
ALTER TABLE fast_track_approvals ENABLE ROW LEVEL SECURITY;

-- Policy: Admin users can view all fast-track approvals
CREATE POLICY "Admin users can view all fast-track approvals" ON fast_track_approvals
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM profiles 
            WHERE profiles.id = auth.uid() 
            AND profiles.role = 'admin'
        )
    );

-- Policy: System can insert fast-track approval records
CREATE POLICY "System can insert fast-track approvals" ON fast_track_approvals
    FOR INSERT WITH CHECK (true);

-- Policy: Users can view their own fast-track approvals
CREATE POLICY "Users can view their own fast-track approvals" ON fast_track_approvals
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM enrollments 
            WHERE enrollments.id = fast_track_approvals.enrollment_id 
            AND enrollments.user_id = auth.uid()
        )
    );

-- Add comments for documentation
COMMENT ON TABLE fast_track_approvals IS 'Audit log for card payment fast-track approval events';
COMMENT ON COLUMN fast_track_approvals.enrollment_id IS 'Reference to the enrollment that was processed';
COMMENT ON COLUMN fast_track_approvals.transaction_id IS 'Ikhokha transaction ID from webhook';
COMMENT ON COLUMN fast_track_approvals.payment_reference IS 'Payment reference from webhook';
COMMENT ON COLUMN fast_track_approvals.fast_track_success IS 'Whether the fast-track processing completed successfully';
COMMENT ON COLUMN fast_track_approvals.enrollment_approved IS 'Whether the enrollment was approved';
COMMENT ON COLUMN fast_track_approvals.access_granted IS 'Whether course access was granted';
COMMENT ON COLUMN fast_track_approvals.processing_time_ms IS 'Total processing time in milliseconds';
COMMENT ON COLUMN fast_track_approvals.audit_trail IS 'Detailed audit trail of processing steps';
COMMENT ON COLUMN fast_track_approvals.approved_by IS 'System identifier that approved the enrollment';
COMMENT ON COLUMN fast_track_approvals.approval_type IS 'Type of approval process used';