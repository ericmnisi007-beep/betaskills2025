-- Create storage bucket for proof of payment files
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
    'proofs',
    'proofs', 
    true, 
    5242880, -- 5MB limit
    ARRAY['image/jpeg', 'image/png', 'image/jpg', 'application/pdf']
) ON CONFLICT (id) DO NOTHING;

-- Create policy for proof uploads
CREATE POLICY "Users can upload their own proofs" ON storage.objects
    FOR INSERT WITH CHECK (
        bucket_id = 'proofs' AND 
        auth.uid()::text = (storage.foldername(name))[1]
    );

-- Create policy for viewing proofs
CREATE POLICY "Users can view their own proofs" ON storage.objects
    FOR SELECT USING (
        bucket_id = 'proofs' AND 
        auth.uid()::text = (storage.foldername(name))[1]
    );

-- Create policy for instructors and admins to view all proofs
CREATE POLICY "Instructors and admins can view all proofs" ON storage.objects
    FOR SELECT USING (
        bucket_id = 'proofs' AND 
        EXISTS (
            SELECT 1 FROM public.profiles 
            WHERE id = auth.uid() 
            AND role IN ('instructor', 'admin')
        )
    ); 