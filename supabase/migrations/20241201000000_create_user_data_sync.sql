-- Create user_data_sync table for cross-device data synchronization
CREATE TABLE IF NOT EXISTS user_data_sync (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  user_email TEXT NOT NULL,
  data JSONB NOT NULL DEFAULT '{}',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id)
);

-- Create index for faster queries
CREATE INDEX IF NOT EXISTS idx_user_data_sync_user_id ON user_data_sync(user_id);
CREATE INDEX IF NOT EXISTS idx_user_data_sync_user_email ON user_data_sync(user_email);

-- Enable RLS (Row Level Security)
ALTER TABLE user_data_sync ENABLE ROW LEVEL SECURITY;

-- Create policy to allow users to only access their own data
CREATE POLICY "Users can only access their own sync data" ON user_data_sync
  FOR ALL USING (auth.uid() = user_id);

-- Create function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger to automatically update updated_at
CREATE TRIGGER update_user_data_sync_updated_at 
  BEFORE UPDATE ON user_data_sync 
  FOR EACH ROW 
  EXECUTE FUNCTION update_updated_at_column();
