-- Database Setup for Beta Skill Platform
-- Run this in your Supabase SQL Editor

-- 1. Create profiles table
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID PRIMARY KEY,
  email TEXT NOT NULL UNIQUE,
  first_name TEXT,
  last_name TEXT,
  role TEXT DEFAULT 'student',
  approved BOOLEAN DEFAULT false,
  approval_status TEXT DEFAULT 'pending',
  avatar_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Create enrollments table
CREATE TABLE IF NOT EXISTS public.enrollments (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL,
  user_email TEXT NOT NULL,
  course_id TEXT NOT NULL,
  course_title TEXT NOT NULL,
  proof_of_payment TEXT,
  payment_ref TEXT,
  payment_date TEXT,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
  enrolled_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  approved_at TIMESTAMP WITH TIME ZONE,
  progress INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. Add indexes for better performance
CREATE INDEX IF NOT EXISTS idx_enrollments_user_id ON public.enrollments(user_id);
CREATE INDEX IF NOT EXISTS idx_enrollments_course_id ON public.enrollments(course_id);
CREATE INDEX IF NOT EXISTS idx_enrollments_status ON public.enrollments(status);
CREATE INDEX IF NOT EXISTS idx_profiles_email ON public.profiles(email);

-- 4. Enable Row Level Security
ALTER TABLE public.enrollments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- 5. Create RLS policies for enrollments
CREATE POLICY "Users can view their own enrollments" ON public.enrollments
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own enrollments" ON public.enrollments
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Instructors and admins can view all enrollments" ON public.enrollments
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.profiles 
      WHERE id = auth.uid() 
      AND role IN ('instructor', 'admin')
    )
  );

CREATE POLICY "Instructors and admins can update enrollment status" ON public.enrollments
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM public.profiles 
      WHERE id = auth.uid() 
      AND role IN ('instructor', 'admin')
    )
  );

-- 6. Create RLS policies for profiles
CREATE POLICY "Users can view their own profile" ON public.profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile" ON public.profiles
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Admins can view all profiles" ON public.profiles
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.profiles 
      WHERE id = auth.uid() 
      AND role = 'admin'
    )
  );

-- 7. Create trigger function for new users
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

-- 8. Create trigger for new users
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- 9. Insert or update john.doe@gmail.com as instructor
-- Note: You'll need to replace the UUID with the actual user ID from auth.users
-- This will be handled by the trigger when the user signs up
-- For now, we'll create a placeholder that can be updated later

INSERT INTO public.profiles (id, email, first_name, last_name, role, approved, approval_status)
VALUES (
  '00000000-0000-0000-0000-000000000000', -- Placeholder UUID, will be updated
  'john.doe@gmail.com', 
  'John', 
  'Doe', 
  'instructor', 
  true, 
  'approved'
)
ON CONFLICT (email) DO UPDATE SET 
  role = 'instructor',
  approved = true,
  approval_status = 'approved',
  first_name = 'John',
  last_name = 'Doe';

-- 10. Create storage bucket for proof of payment files
INSERT INTO storage.buckets (id, name, public)
VALUES ('proofs', 'proofs', true)
ON CONFLICT (id) DO NOTHING;

-- 11. Make storage bucket public
UPDATE storage.buckets 
SET public = true 
WHERE id = 'proofs';

-- 12. Create storage policies
CREATE POLICY "Anyone can view proof files" ON storage.objects
  FOR SELECT USING (bucket_id = 'proofs');

CREATE POLICY "Authenticated users can upload proof files" ON storage.objects
  FOR INSERT WITH CHECK (bucket_id = 'proofs' AND auth.role() = 'authenticated');

-- Success message
SELECT 'Database setup completed successfully!' as status;
