# 🚨 CLOUD SYNC QUICK FIX

## Immediate Issue: Database Tables Not Created

The cloud sync is showing "⚠️ Not synced yet" because the database tables don't exist yet. Here's the quick fix:

### Step 1: Run SQL Script in Supabase

1. **Go to Supabase Dashboard**: https://supabase.com/dashboard
2. **Select your Beta Skills project**
3. **Click "SQL Editor"** in the left sidebar
4. **Click "New Query"**
5. **Copy and paste this SQL script**:

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
CREATE INDEX IF NOT EXISTS idx_user_data_sync_user_id ON user_data_sync(user_id);
CREATE INDEX IF NOT EXISTS idx_user_data_sync_user_email ON user_data_sync(user_email);
CREATE INDEX IF NOT EXISTS idx_course_progress_user_id ON course_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_course_progress_course_id ON course_progress(course_id);
CREATE INDEX IF NOT EXISTS idx_course_progress_user_email ON course_progress(user_email);

-- Enable RLS (Row Level Security)
ALTER TABLE user_data_sync ENABLE ROW LEVEL SECURITY;
ALTER TABLE course_progress ENABLE ROW LEVEL SECURITY;

-- Create policies to allow users to only access their own data
CREATE POLICY "Users can only access their own sync data" ON user_data_sync
  FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "Users can only access their own course progress" ON course_progress
  FOR ALL USING (auth.uid() = user_id);

-- Create function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers to automatically update updated_at
CREATE TRIGGER update_user_data_sync_updated_at 
  BEFORE UPDATE ON user_data_sync 
  FOR EACH ROW 
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_course_progress_updated_at 
  BEFORE UPDATE ON course_progress 
  FOR EACH ROW 
  EXECUTE FUNCTION update_updated_at_column();

-- Success message
SELECT 'Cloud sync tables created successfully! Your data will now sync across all devices.' as message;
```

6. **Click "Run"** to execute the script
7. **You should see**: "Cloud sync tables created successfully!"

### Step 2: Test the Fix

1. **Refresh your browser**
2. **Check the cloud sync status** in the bottom-right corner
3. **It should change from "Tables not created" to "Last synced: [time]"**

### Step 3: Test Cross-Device Sync

1. **Open your app in two different browsers**
2. **Log in with the same account in both browsers**
3. **Make changes in one browser** (enroll in a course)
4. **Click the "Sync" button** in the other browser
5. **Your data should now appear in both browsers**

## Debug Tools Available

Open your browser console and run these commands:

- `checkCloudSyncStatus()` - Check current sync status
- `forceCloudSync()` - Force immediate sync
- `setupInstructions()` - Show setup instructions again

## Expected Result

✅ **Cloud sync status changes** from "⚠️ Tables not created" to "✅ Last synced: [time]"  
✅ **Data syncs across browsers** automatically  
✅ **Enrollments and progress** appear in all browsers  
✅ **No more data resets** when switching devices  

---

**🎯 This will fix the cross-device synchronization issue completely!**
