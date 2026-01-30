-- Create enrollments table if it doesn't exist
CREATE TABLE IF NOT EXISTS public.enrollments (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL,
    user_email TEXT NOT NULL,
    course_id TEXT NOT NULL,
    course_title TEXT NOT NULL,
    proof_of_payment TEXT,
    payment_ref TEXT,
    payment_date TEXT,
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
    enrolled_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    approved_at TIMESTAMP WITH TIME ZONE,
    rejected_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security (RLS)
ALTER TABLE public.enrollments ENABLE ROW LEVEL SECURITY;

-- Create policies for enrollments table
-- Allow users to insert their own enrollments
CREATE POLICY "Users can insert their own enrollments" ON public.enrollments
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Allow users to view their own enrollments
CREATE POLICY "Users can view their own enrollments" ON public.enrollments
    FOR SELECT USING (auth.uid() = user_id);

-- Allow instructors to view all enrollments (for dashboard)
CREATE POLICY "Instructors can view all enrollments" ON public.enrollments
    FOR SELECT USING (true);

-- Allow instructors to update enrollment status
CREATE POLICY "Instructors can update enrollment status" ON public.enrollments
    FOR UPDATE USING (true);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_enrollments_user_id ON public.enrollments(user_id);
CREATE INDEX IF NOT EXISTS idx_enrollments_status ON public.enrollments(status);
CREATE INDEX IF NOT EXISTS idx_enrollments_course_id ON public.enrollments(course_id);
CREATE INDEX IF NOT EXISTS idx_enrollments_enrolled_at ON public.enrollments(enrolled_at);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger to automatically update updated_at
CREATE TRIGGER update_enrollments_updated_at 
    BEFORE UPDATE ON public.enrollments 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- Grant necessary permissions
GRANT ALL ON public.enrollments TO authenticated;
GRANT ALL ON public.enrollments TO service_role; 