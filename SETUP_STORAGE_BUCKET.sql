-- Setup Supabase Storage for Product Images
-- Run this in Supabase SQL Editor to create the storage bucket

-- 1. Create storage bucket for products (if not exists)
INSERT INTO storage.buckets (id, name, public)
VALUES ('products', 'products', true)
ON CONFLICT (id) DO NOTHING;

-- 2. Set up RLS policies for products bucket (public access for development)

-- Drop existing policies if they exist (to avoid conflicts)
DROP POLICY IF EXISTS "Public Access for Product Images" ON storage.objects;
DROP POLICY IF EXISTS "Public Upload for Product Images" ON storage.objects;
DROP POLICY IF EXISTS "Public Update for Product Images" ON storage.objects;
DROP POLICY IF EXISTS "Public Delete for Product Images" ON storage.objects;

-- Allow public to read/view images
CREATE POLICY "Public Access for Product Images"
ON storage.objects FOR SELECT
USING (bucket_id = 'products');

-- Allow public to upload images (TEMPORARY - change in production!)
CREATE POLICY "Public Upload for Product Images"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'products');

-- Allow public to update images (TEMPORARY - change in production!)
CREATE POLICY "Public Update for Product Images"
ON storage.objects FOR UPDATE
USING (bucket_id = 'products');

-- Allow public to delete images (TEMPORARY - change in production!)
CREATE POLICY "Public Delete for Product Images"
ON storage.objects FOR DELETE
USING (bucket_id = 'products');

-- 3. Verify bucket exists
SELECT
    id,
    name,
    public,
    created_at
FROM storage.buckets
WHERE id = 'products';

-- 4. Check policies
SELECT
    policyname,
    cmd,
    qual
FROM pg_policies
WHERE schemaname = 'storage'
AND tablename = 'objects'
AND policyname LIKE '%Product Images%';

-- Success message
SELECT '✅ Products storage bucket setup complete!' as status;
SELECT 'Bucket: products (public access enabled)' as details;
SELECT '⚠️ Remember to restrict access in production!' as warning;

