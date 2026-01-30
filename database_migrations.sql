-- Create user_progress table for permanent course progress storage
CREATE TABLE IF NOT EXISTS user_progress (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  course_id TEXT NOT NULL,
  current_module INTEGER DEFAULT 1,
  current_lesson INTEGER DEFAULT 1,
  completed_lessons TEXT[] DEFAULT '{}',
  quiz_scores JSONB DEFAULT '{}',
  last_visited TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  progress_percentage INTEGER DEFAULT 0,
  total_time_spent INTEGER DEFAULT 0, -- in minutes
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, course_id)
);

-- Create user_state table for global user preferences and state
CREATE TABLE IF NOT EXISTS user_state (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE UNIQUE,
  current_course TEXT,
  preferences JSONB DEFAULT '{
    "theme": "system",
    "auto_save": true,
    "notifications": true,
    "language": "en"
  }',
  last_activity TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_user_progress_user_id ON user_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_user_progress_course_id ON user_progress(course_id);
CREATE INDEX IF NOT EXISTS idx_user_progress_last_visited ON user_progress(last_visited);
CREATE INDEX IF NOT EXISTS idx_user_state_user_id ON user_state(user_id);

-- Enable Row Level Security (RLS)
ALTER TABLE user_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_state ENABLE ROW LEVEL SECURITY;

-- Create RLS policies for user_progress
CREATE POLICY "Users can view their own progress" ON user_progress
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own progress" ON user_progress
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own progress" ON user_progress
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own progress" ON user_progress
  FOR DELETE USING (auth.uid() = user_id);

-- Create RLS policies for user_state
CREATE POLICY "Users can view their own state" ON user_state
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own state" ON user_state
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own state" ON user_state
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own state" ON user_state
  FOR DELETE USING (auth.uid() = user_id);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers to automatically update updated_at
CREATE TRIGGER update_user_progress_updated_at 
  BEFORE UPDATE ON user_progress 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_state_updated_at 
  BEFORE UPDATE ON user_state 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Create view for user progress summary
CREATE OR REPLACE VIEW user_progress_summary AS
SELECT 
  up.user_id,
  up.course_id,
  up.current_module,
  up.current_lesson,
  up.progress_percentage,
  up.last_visited,
  up.total_time_spent,
  array_length(up.completed_lessons, 1) as completed_lessons_count,
  jsonb_object_keys(up.quiz_scores) as quiz_lessons,
  us.current_course,
  us.preferences
FROM user_progress up
LEFT JOIN user_state us ON up.user_id = us.user_id;

-- Grant necessary permissions
GRANT ALL ON user_progress TO authenticated;
GRANT ALL ON user_state TO authenticated;
GRANT SELECT ON user_progress_summary TO authenticated; 