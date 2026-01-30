-- Create course_progress table for detailed progress tracking
CREATE TABLE IF NOT EXISTS course_progress (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  user_email TEXT NOT NULL,
  course_id TEXT NOT NULL,
  progress_data JSONB NOT NULL DEFAULT '{}',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, course_id)
);

-- Create indexes for faster queries
CREATE INDEX IF NOT EXISTS idx_course_progress_user_id ON course_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_course_progress_course_id ON course_progress(course_id);
CREATE INDEX IF NOT EXISTS idx_course_progress_user_email ON course_progress(user_email);

-- Enable RLS (Row Level Security)
ALTER TABLE course_progress ENABLE ROW LEVEL SECURITY;

-- Create policy to allow users to only access their own progress
CREATE POLICY "Users can only access their own course progress" ON course_progress
  FOR ALL USING (auth.uid() = user_id);

-- Create trigger to automatically update updated_at
CREATE TRIGGER update_course_progress_updated_at 
  BEFORE UPDATE ON course_progress 
  FOR EACH ROW 
  EXECUTE FUNCTION update_updated_at_column();
