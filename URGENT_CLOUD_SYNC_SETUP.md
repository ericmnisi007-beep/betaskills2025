# 🚨 URGENT: CLOUD SYNC SETUP REQUIRED

## Your data is NOT syncing because the database tables are missing!

### IMMEDIATE ACTION REQUIRED:

**Step 1: Go to Supabase Dashboard**
1. Open: https://supabase.com/dashboard
2. Click on your "Beta Skills" project

**Step 2: Run the SQL Script**
1. Click "SQL Editor" in the left sidebar
2. Click "New Query" 
3. Copy and paste this ENTIRE script:

```sql
-- Cloud Sync Setup Script for Beta Skills
-- Run this in your Supabase SQL Editor to enable cross-device synchronization

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

-- Create indexes for faster queries
CREATE INDEX IF NOT EXISTS idx_user_data_sync_user_id ON user_data_sync(user_id);
CREATE INDEX IF NOT EXISTS idx_user_data_sync_user_email ON user_data_sync(user_email);

-- Enable RLS (Row Level Security)
ALTER TABLE user_data_sync ENABLE ROW LEVEL SECURITY;

-- Create policies to allow users to only access their own data
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

-- Success message
SELECT 'Cloud sync tables created successfully! Your data will now sync across all devices.' as message;
```

4. Click "Run" button
5. You should see: "Cloud sync tables created successfully!"

**Step 3: Test the Sync**
1. Refresh your browser
2. Log in with your account
3. Look at the bottom-right corner - it should change from "⚠️ Run SQL script in Supabase" to "Last synced: [time]"
4. Your data will now sync across all devices automatically

### What Gets Synced:
- ✅ All enrollments (including pending ones)
- ✅ Course progress and quiz scores
- ✅ User preferences and settings
- ✅ Navigation history
- ✅ Session data

### How It Works:
- Syncs every 30 seconds automatically
- Syncs when you make changes
- Syncs when you switch browser tabs
- Syncs when you close the browser
- Only syncs between different devices

### If You Still See Issues:
1. Make sure you ran the SQL script completely
2. Check your internet connection
3. Refresh the page after running the script
4. The sync status should change immediately

**This is the ONLY thing you need to do to fix the cross-device sync issue!**
