-- Create notifications table
CREATE TABLE IF NOT EXISTS notifications (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  type VARCHAR(50) NOT NULL,
  title VARCHAR(255) NOT NULL,
  message TEXT NOT NULL,
  data JSONB,
  read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  expires_at TIMESTAMP WITH TIME ZONE,
  priority VARCHAR(20) DEFAULT 'medium',
  category VARCHAR(50) DEFAULT 'system',
  metadata JSONB,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create notification preferences table
CREATE TABLE IF NOT EXISTS notification_preferences (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  email BOOLEAN DEFAULT TRUE,
  push BOOLEAN DEFAULT TRUE,
  in_app BOOLEAN DEFAULT TRUE,
  categories JSONB DEFAULT '{
    "enrollment": true,
    "payment": true,
    "course": true,
    "system": true,
    "admin": false
  }'::jsonb,
  types JSONB DEFAULT '{
    "enrollment_approved": true,
    "enrollment_rejected": true,
    "enrollment_pending": true,
    "new_eft_enrollment": false,
    "payment_received": true,
    "course_access_granted": true,
    "course_access_revoked": true,
    "system_maintenance": true,
    "general_announcement": true
  }'::jsonb,
  quiet_hours JSONB DEFAULT '{
    "enabled": false,
    "start": "22:00",
    "end": "08:00",
    "timezone": "UTC"
  }'::jsonb,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id)
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_type ON notifications(type);
CREATE INDEX IF NOT EXISTS idx_notifications_category ON notifications(category);
CREATE INDEX IF NOT EXISTS idx_notifications_read ON notifications(read);
CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON notifications(created_at);
CREATE INDEX IF NOT EXISTS idx_notifications_expires_at ON notifications(expires_at);

-- Create composite index for user notifications queries
CREATE INDEX IF NOT EXISTS idx_notifications_user_read_created ON notifications(user_id, read, created_at DESC);

-- Enable Row Level Security (RLS)
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE notification_preferences ENABLE ROW LEVEL SECURITY;

-- Create RLS policies for notifications
CREATE POLICY "Users can view their own notifications" ON notifications
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can update their own notifications" ON notifications
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own notifications" ON notifications
  FOR DELETE USING (auth.uid() = user_id);

CREATE POLICY "System can insert notifications" ON notifications
  FOR INSERT WITH CHECK (true);

-- Create RLS policies for notification preferences
CREATE POLICY "Users can view their own notification preferences" ON notification_preferences
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can update their own notification preferences" ON notification_preferences
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own notification preferences" ON notification_preferences
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Create function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers for updated_at
CREATE TRIGGER update_notifications_updated_at
  BEFORE UPDATE ON notifications
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_notification_preferences_updated_at
  BEFORE UPDATE ON notification_preferences
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Create function to clean up expired notifications
CREATE OR REPLACE FUNCTION cleanup_expired_notifications()
RETURNS void AS $$
BEGIN
  DELETE FROM notifications 
  WHERE expires_at IS NOT NULL 
  AND expires_at < NOW();
END;
$$ LANGUAGE plpgsql;

-- Enable real-time for notifications
ALTER PUBLICATION supabase_realtime ADD TABLE notifications;

-- Create function to get notification stats
CREATE OR REPLACE FUNCTION get_notification_stats(user_uuid UUID)
RETURNS JSON AS $$
DECLARE
  stats JSON;
BEGIN
  SELECT json_build_object(
    'total', COUNT(*),
    'unread', COUNT(*) FILTER (WHERE read = false),
    'by_category', json_object_agg(category, category_count),
    'by_type', json_object_agg(type, type_count),
    'recent_activity', json_build_object(
      'last_notification', MAX(created_at),
      'notifications_today', COUNT(*) FILTER (WHERE created_at >= CURRENT_DATE),
      'notifications_this_week', COUNT(*) FILTER (WHERE created_at >= CURRENT_DATE - INTERVAL '7 days')
    )
  )
  INTO stats
  FROM (
    SELECT 
      category,
      type,
      COUNT(*) as category_count,
      COUNT(*) as type_count
    FROM notifications 
    WHERE user_id = user_uuid
    GROUP BY category, type
  ) t;
  
  RETURN stats;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant necessary permissions
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT ALL ON notifications TO authenticated;
GRANT ALL ON notification_preferences TO authenticated;
GRANT EXECUTE ON FUNCTION get_notification_stats(UUID) TO authenticated;

-- Insert default notification preferences for existing users
INSERT INTO notification_preferences (user_id, email, push, in_app, categories, types, quiet_hours)
SELECT 
  id as user_id,
  true as email,
  true as push,
  true as in_app,
  '{
    "enrollment": true,
    "payment": true,
    "course": true,
    "system": true,
    "admin": false
  }'::jsonb as categories,
  '{
    "enrollment_approved": true,
    "enrollment_rejected": true,
    "enrollment_pending": true,
    "new_eft_enrollment": false,
    "payment_received": true,
    "course_access_granted": true,
    "course_access_revoked": true,
    "system_maintenance": true,
    "general_announcement": true
  }'::jsonb as types,
  '{
    "enabled": false,
    "start": "22:00",
    "end": "08:00",
    "timezone": "UTC"
  }'::jsonb as quiet_hours
FROM auth.users
WHERE id NOT IN (SELECT user_id FROM notification_preferences);
