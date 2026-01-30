-- Allow users to create their own profile
CREATE POLICY "Users can create own profile" ON public.profiles
FOR INSERT 
WITH CHECK (auth.uid() = id);

-- Update the trigger function to properly handle new users with automatic admin approval
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER SET search_path = ''
AS $$
DECLARE
  user_role text;
  is_approved boolean;
  approval_status text;
BEGIN
  -- Get role from user metadata
  user_role := COALESCE(new.raw_user_meta_data ->> 'role', 'student');
  
  -- Determine approval status for all users (auto-approve)
  is_approved := true;
  approval_status := 'approved';
  
  -- Insert profile with proper role and approval status
  INSERT INTO public.profiles (
    id, 
    email, 
    first_name, 
    last_name, 
    role, 
    approved, 
    approval_status
  )
  VALUES (
    new.id, 
    new.email,
    new.raw_user_meta_data ->> 'first_name', 
    new.raw_user_meta_data ->> 'last_name',
    user_role,
    is_approved,
    approval_status
  );
  
  RETURN new;
END;
$$;

-- Create the trigger if it doesn't exist
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Add approved column if it doesn't exist
DO $$ 
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'approved') THEN
    ALTER TABLE profiles ADD COLUMN approved boolean NOT NULL DEFAULT false;
  END IF;
END $$;