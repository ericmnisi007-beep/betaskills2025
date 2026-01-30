-- Fix existing users who don't have contact numbers
-- Run this in your Supabase SQL Editor

-- 1. First, let's see what users don't have contact numbers
SELECT 
    id,
    email,
    first_name,
    last_name,
    contact_number,
    created_at
FROM public.profiles 
WHERE contact_number IS NULL OR contact_number = ''
ORDER BY created_at DESC;

-- 2. Update users with placeholder contact numbers (you can change these)
UPDATE public.profiles 
SET contact_number = 'Not provided during registration'
WHERE contact_number IS NULL OR contact_number = '';

-- 3. For specific users, you can manually set their contact numbers
-- Replace the email and phone number as needed
UPDATE public.profiles 
SET contact_number = '+27 12 345 6789'  -- Replace with actual phone number
WHERE email = 'maxmon2@gmail.com';

-- 4. Verify the updates
SELECT 
    id,
    email,
    first_name,
    last_name,
    contact_number,
    created_at
FROM public.profiles 
WHERE email = 'maxmon2@gmail.com';

-- 5. Show all users with their contact numbers
SELECT 
    id,
    email,
    first_name,
    last_name,
    contact_number,
    created_at
FROM public.profiles 
ORDER BY created_at DESC
LIMIT 10;
