# Environment Setup Guide

## 🚨 Application Not Loading - Fix Required

The application is not loading because it's missing required Supabase environment variables.

## 🔧 Quick Fix

1. **Create a `.env` file** in the root directory of your project
2. **Add the following environment variables:**

```env
# Supabase Configuration
VITE_SUPABASE_URL=your_supabase_project_url_here
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key_here

# Optional: Service role key for database setup scripts
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key_here
```

## 📋 How to Get Your Supabase Credentials

1. **Go to your Supabase project dashboard**
2. **Navigate to Settings → API**
3. **Copy the following values:**
   - **Project URL** → Use as `VITE_SUPABASE_URL`
   - **anon public** key → Use as `VITE_SUPABASE_ANON_KEY`
   - **service_role** key → Use as `SUPABASE_SERVICE_ROLE_KEY` (optional)

## ✅ After Setup

1. **Restart your development server:**
   ```bash
   npm run dev
   ```

2. **The application should now load properly at:** `http://localhost:8081/`

## 🚨 Current Error

The application is currently throwing this error:
```
Supabase URL and Anon Key must be provided in environment variables.
```

This happens because the Supabase client cannot initialize without these credentials.

## 🔍 Verification

After adding the environment variables, you should see:
- ✅ Application loads without errors
- ✅ No console errors about missing Supabase credentials
- ✅ Authentication system works properly
- ✅ Database operations function correctly 