-- Fix Admin Dashboard Access
-- This script ensures admins can view all enrollments and users

-- Step 1: Drop existing conflicting policies
DROP POLICY IF EXISTS "Users can view their own enrollments" ON public.enrollments;
DROP POLICY IF EXISTS "Users can create their own enrollments" ON public.enrollments;
DROP POLICY IF EXISTS "Instructors and admins can view all enrollments" ON public.enrollments;
DROP POLICY IF EXISTS "Instructors and admins can update enrollment status" ON public.enrollments;
DROP POLICY IF EXISTS "Admins can view all enrollments" ON public.enrollments;
DROP POLICY IF EXISTS "Admins can update enrollment status" ON public.enrollments;
DROP POLICY IF EXISTS "Allow all operations for now" ON public.enrollments;
DROP POLICY IF EXISTS "Enable all operations for authenticated users" ON public.enrollments;
DROP POLICY IF EXISTS "Allow authenticated users to view enrollments" ON public.enrollments;
DROP POLICY IF EXISTS "Allow authenticated users to update enrollments" ON public.enrollments;

-- Step 2: Create simple, working policies for enrollments
-- Allow users to view their own enrollments
CREATE POLICY "users_view_own_enrollments" ON public.enrollments
    FOR SELECT
    USING (auth.uid() = user_id);

-- Allow users to create their own enrollments
CREATE POLICY "users_create_own_enrollments" ON public.enrollments
    FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- Allow admins to view ALL enrollments (check by email)
CREATE POLICY "admins_view_all_enrollments" ON public.enrollments
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM auth.users
            WHERE auth.users.id = auth.uid()
            AND auth.users.email IN (
                'ericmnisi007@gmail.com',
                'john.doe@gmail.com',
                'maxmon@gmail.com',
                'maxmon2@gmail.com'
            )
        )
    );

-- Allow admins to update enrollments
CREATE POLICY "admins_update_enrollments" ON public.enrollments
    FOR UPDATE
    USING (
        EXISTS (
            SELECT 1 FROM auth.users
            WHERE auth.users.id = auth.uid()
            AND auth.users.email IN (
                'ericmnisi007@gmail.com',
                'john.doe@gmail.com',
                'maxmon@gmail.com',
                'maxmon2@gmail.com'
            )
        )
    );

-- Step 3: Fix profiles table policies
DROP POLICY IF EXISTS "Public profiles are viewable by everyone" ON public.profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON public.profiles;
DROP POLICY IF EXISTS "Admins can view all profiles" ON public.profiles;

-- Allow users to view their own profile
CREATE POLICY "users_view_own_profile" ON public.profiles
    FOR SELECT
    USING (auth.uid() = id);

-- Allow users to update their own profile
CREATE POLICY "users_update_own_profile" ON public.profiles
    FOR UPDATE
    USING (auth.uid() = id);

-- Allow admins to view ALL profiles
CREATE POLICY "admins_view_all_profiles" ON public.profiles
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM auth.users
            WHERE auth.users.id = auth.uid()
            AND auth.users.email IN (
                'ericmnisi007@gmail.com',
                'john.doe@gmail.com',
                'maxmon@gmail.com',
                'maxmon2@gmail.com'
            )
        )
    );

-- Step 4: Verify RLS is enabled
ALTER TABLE public.enrollments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Step 5: Grant necessary permissions
GRANT SELECT, INSERT, UPDATE ON public.enrollments TO authenticated;
GRANT SELECT, UPDATE ON public.profiles TO authenticated;

-- Done!
SELECT 'Admin dashboard access policies created successfully!' as status;
