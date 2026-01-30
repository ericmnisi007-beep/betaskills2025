# Cloud Sync Setup Instructions

## To enable cross-device data synchronization:

### Step 1: Run the SQL Script
1. Go to your Supabase Dashboard: https://supabase.com/dashboard
2. Select your Beta Skills project
3. Click "SQL Editor" in the left sidebar
4. Click "New Query"
5. Copy and paste the entire contents of `setup-cloud-sync.sql`
6. Click "Run" to execute the script
7. You should see: "Cloud sync tables created successfully!"

### Step 2: Test the Setup
1. Refresh your browser
2. Log in with your account
3. The cloud sync status should change from "⚠️ Run SQL script in Supabase" to "Last synced: [time]"
4. Your data will now automatically sync across all devices

### What Gets Synced:
- ✅ All enrollments
- ✅ Course progress and quiz scores
- ✅ User preferences and settings
- ✅ Navigation history
- ✅ Session data

### How It Works:
- Data syncs automatically every 2 minutes
- Syncs when you switch browser tabs
- Syncs when you close the browser
- Syncs when you come back online
- Only syncs data from different devices (not the same device)

### Troubleshooting:
- If you see "⚠️ Run SQL script in Supabase", run the SQL script
- If you see "Sync failed", check your internet connection
- Data will sync automatically once the tables are created

That's it! Your data will now be consistent across all devices. 🚀
