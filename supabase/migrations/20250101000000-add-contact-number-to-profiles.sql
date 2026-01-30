-- Add contact_number column to profiles table
ALTER TABLE public.profiles 
ADD COLUMN IF NOT EXISTS contact_number TEXT;

-- Update the handle_new_user function to include contact_number
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
  -- Get role from user metadata (default to student)
  user_role := 'student';
  
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
    new.raw_user_meta_data ->> 'contact_number'
  );
  
  RETURN new;
END;
$$;
