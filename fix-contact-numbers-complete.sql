-- COMPLETE FIX FOR CONTACT NUMBERS
-- Run this in your Supabase SQL Editor

-- 1. First, ensure the contact_number column exists
ALTER TABLE public.profiles 
ADD COLUMN IF NOT EXISTS contact_number TEXT;

-- 2. Drop and recreate the trigger function to ensure it works properly
DROP FUNCTION IF EXISTS public.handle_new_user() CASCADE;

-- 3. Create the trigger function with proper contact_number handling
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER SET search_path = ''
AS $$
DECLARE
  user_role text;
  is_approved boolean;
  approval_status text;
  contact_num text;
BEGIN
  -- Get role from user metadata (default to student)
  user_role := COALESCE(new.raw_user_meta_data ->> 'role', 'student');
  
  -- Determine approval status for all users (auto-approve)
  is_approved := true;
  approval_status := 'approved';
  
  -- Get contact number from metadata
  contact_num := new.raw_user_meta_data ->> 'contact_number';
  
  -- Log the data being inserted for debugging
  RAISE NOTICE 'Creating profile for user: % with contact_number: %', new.email, contact_num;
  
  -- Insert profile with proper role and approval status
  INSERT INTO public.profiles (
    id, 
    email, 
    first_name, 
    last_name, 
    role, 
    approved, 
    approval_status,
    contact_number
  )
  VALUES (
    new.id, 
    new.email,
    new.raw_user_meta_data ->> 'first_name', 
    new.raw_user_meta_data ->> 'last_name',
    user_role,
    is_approved,
    approval_status,
    contact_num
  );
  
  RETURN new;
END;
$$;

-- 4. Create the trigger
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- 5. Update existing profiles that have NULL contact_number
UPDATE public.profiles 
SET contact_number = 'Not provided during registration'
WHERE contact_number IS NULL;

-- 6. Grant necessary permissions
GRANT USAGE ON SCHEMA public TO anon, authenticated;
GRANT ALL ON public.profiles TO anon, authenticated;

-- 7. Test the trigger by checking if it exists
SELECT 
  trigger_name, 
  event_manipulation, 
  action_statement 
FROM information_schema.triggers 
WHERE trigger_name = 'on_auth_user_created';

-- 8. Show current profiles to verify
SELECT id, email, first_name, last_name, contact_number, created_at 
FROM public.profiles 
ORDER BY created_at DESC 
LIMIT 10;
