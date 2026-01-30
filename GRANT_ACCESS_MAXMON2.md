# 🎓 Grant Full Access to maxmon2@gmail.com

## Quick Action Required

### Step 1: Open Supabase SQL Editor
Go to: https://supabase.com/dashboard/project/YOUR_PROJECT/sql

### Step 2: Run This SQL

```sql
-- Grant full access to all 22 courses for maxmon2@gmail.com
INSERT INTO public.enrollments (user_id, course_id, status, enrolled_at, progress, payment_status)
SELECT 
    (SELECT id FROM auth.users WHERE email = 'maxmon2@gmail.com'),
    course_id,
    'active',
    NOW(),
    0,
    'completed'
FROM (
    VALUES 
        ('cybersecurity101'),
        ('emotional-intelligence'),
        ('prophet'),
        ('entrepreneurship-final'),
        ('ai-assisted-programming'),
        ('ai-assisted-web-development'),
        ('christian-teacher'),
        ('podcast-management-101'),
        ('sound-engineering-102'),
        ('computer-repairs'),
        ('roofing'),
        ('plumbing'),
        ('tiling-101'),
        ('hair-dressing'),
        ('nail-technician'),
        ('petrol-motor-mechanic'),
        ('diesel-motor-mechanic'),
        ('landscaping'),
        ('social-media-marketing-101'),
        ('master-electrician-online'),
        ('beauty-therapy-101'),
        ('dog-grooming-101')
) AS courses(course_id)
ON CONFLICT (user_id, course_id) 
DO UPDATE SET
    status = 'active',
    payment_status = 'completed';
```

### Step 3: Verify

The user should now see **"Continue"** buttons on all course cards instead of "Enroll Now".

## ✅ Expected Result

- User: maxmon2@gmail.com
- Access: ALL 22 courses (including the new Prophet course)
- Button: "Continue" (not "Enroll Now")
- Status: Active enrollment with completed payment

## 📝 Note

The button text automatically changes from "Enroll Now" to "Continue" when:
1. User is enrolled in the course (enrollment record exists)
2. Enrollment status is 'active'
3. Payment status is 'completed'

This is handled automatically by the `CourseCard` component logic.
