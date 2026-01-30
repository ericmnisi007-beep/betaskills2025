-- Fix admin auto-approval trigger function
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
  
  -- Determine approval status based on role
  is_approved := user_role = 'admin';
  approval_status := CASE 
    WHEN user_role = 'admin' THEN 'approved'
    ELSE 'pending'
  END;
  
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