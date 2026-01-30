# Database Population Guide

This guide will help you populate your Supabase database with real data for the admin dashboard.

## 🚀 Quick Start

### Option 1: Using Node.js Script (Recommended)

1. **Ensure your environment variables are set** in your `.env` file:
   ```
   VITE_SUPABASE_URL=your_supabase_url
   VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
   SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
   ```

2. **Run the population script**:
   ```bash
   npm run populate-db
   ```

3. **Verify the data** by checking your admin dashboard at `http://localhost:8085/admin-dashboard`

### Option 2: Using Supabase SQL Editor

1. **Open your Supabase Dashboard**
2. **Go to the SQL Editor**
3. **Copy and paste the contents** of `scripts/populate-real-data.sql`
4. **Run the script**

## 📊 What Data Will Be Created

### Users (16 total)
- **2 Admin users** (Dr. Russon Nkuna, Sarah Johnson)
- **3 Instructor users** (Michael Chen, Lisa Thompson, David Williams)
- **8 Approved students** (John Doe, Jane Smith, Mike Wilson, etc.)
- **4 Pending students** (Robert Taylor, Sophia Anderson, etc.)
- **2 Rejected students** (Daniel White, Mia Martin)

### Enrollments (11 total)
- **5 Approved enrollments** with varying progress (30% - 90%)
- **4 Pending enrollments** awaiting approval
- **2 Rejected enrollments**

## 🎯 Expected Dashboard Results

After running the script, your admin dashboard should show:

### User Management Tab:
- **Total Users**: 16
- **Approved Users**: 13
- **Pending Users**: 4
- **Rejected Users**: 2

### Enrollment Management Tab:
- **Total Enrollments**: 11
- **Pending**: 4
- **Approved**: 5
- **Rejected**: 2

## 🔧 Troubleshooting

### If you get permission errors:
1. Make sure you're using the **Service Role Key** (not the anon key)
2. Check that your Supabase RLS policies allow admin access
3. Verify your environment variables are correct

### If no data appears:
1. Check the browser console for errors
2. Verify the database connection in your Supabase dashboard
3. Ensure the tables exist and have the correct schema

### If you want to start fresh:
1. Delete existing data from the `profiles` and `enrollments` tables
2. Run the population script again

## 📝 Customizing the Data

You can modify the data by editing:
- `scripts/populate-real-data.sql` - for SQL-based population
- `scripts/populate-database.js` - for Node.js-based population

## 🎉 Next Steps

Once the data is populated:
1. **Test the admin dashboard** functionality
2. **Try approving/rejecting** some pending enrollments
3. **Test the search and filter** features
4. **Export data** to verify the CSV export works

Your admin dashboard should now be fully functional with real data!
