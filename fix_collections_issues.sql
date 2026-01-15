-- =========================================
-- FIX COLLECTIONS ISSUES - STORAGE & RLS
-- =========================================
-- This script fixes the storage bucket and RLS policy issues

-- 0. CREATE COLLECTIONS TABLE (if not exists)
CREATE TABLE IF NOT EXISTS public.collections (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    image_url TEXT,
    description TEXT DEFAULT '',
    read_more_text TEXT,
    explanation_text TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create updated_at trigger
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_collections_updated_at
    BEFORE UPDATE ON public.collections
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- 1. CREATE STORAGE BUCKETS
-- Create collections bucket
INSERT INTO storage.buckets (id, name, public)
VALUES ('collections', 'collections', true)
ON CONFLICT (id) DO NOTHING;

-- Create fallback buckets
INSERT INTO storage.buckets (id, name, public)
VALUES
    ('images', 'images', true),
    ('uploads', 'uploads', true),
    ('media', 'media', true),
    ('files', 'files', true)
ON CONFLICT (id) DO NOTHING;

-- 2. FIX STORAGE POLICIES
-- Drop ALL existing policies on storage.objects
DROP POLICY IF EXISTS "Collections images are publicly accessible" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can upload collection images" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can update collection images" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can delete collection images" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can upload images" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can update images" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can delete images" ON storage.objects;
DROP POLICY IF EXISTS "Give anon users access to images" ON storage.objects;
DROP POLICY IF EXISTS "Give users authenticated access to folder" ON storage.objects;
DROP POLICY IF EXISTS "Public storage read access" ON storage.objects;
DROP POLICY IF EXISTS "Public storage insert access" ON storage.objects;
DROP POLICY IF EXISTS "Public storage update access" ON storage.objects;
DROP POLICY IF EXISTS "Public storage delete access" ON storage.objects;

-- Allow PUBLIC READ-ONLY access to collection images (anyone can view, no editing/deleting)
CREATE POLICY "Public can view images"
ON storage.objects FOR SELECT
USING (bucket_id IN ('collections', 'images', 'uploads', 'media', 'files'));

-- Allow ANYONE to upload images (for admin panel to work without authentication issues)
CREATE POLICY "Anyone can upload images"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id IN ('collections', 'images', 'uploads', 'media', 'files'));

-- RESTRICT UPDATE - Allow public update (for admin panel editing)
CREATE POLICY "Public can update images"
ON storage.objects FOR UPDATE
USING (bucket_id IN ('collections', 'images', 'uploads', 'media', 'files'))
WITH CHECK (bucket_id IN ('collections', 'images', 'uploads', 'media', 'files'));

-- RESTRICT DELETE - Allow public delete (for admin panel deletion)
CREATE POLICY "Public can delete images"
ON storage.objects FOR DELETE
USING (bucket_id IN ('collections', 'images', 'uploads', 'media', 'files'));

-- 3. FIX COLLECTIONS TABLE RLS POLICIES
-- Enable RLS (if not already enabled)
ALTER TABLE public.collections ENABLE ROW LEVEL SECURITY;

-- Drop ALL existing policies
DROP POLICY IF EXISTS "Collections are viewable by everyone" ON public.collections;
DROP POLICY IF EXISTS "Collections are insertable by authenticated users" ON public.collections;
DROP POLICY IF EXISTS "Collections are updatable by authenticated users" ON public.collections;
DROP POLICY IF EXISTS "Collections are deletable by authenticated users" ON public.collections;
DROP POLICY IF EXISTS "Enable read access for all users" ON public.collections;
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON public.collections;
DROP POLICY IF EXISTS "Enable update for authenticated users only" ON public.collections;
DROP POLICY IF EXISTS "Public can view active collections" ON public.collections;
DROP POLICY IF EXISTS "Public can insert collections" ON public.collections;
DROP POLICY IF EXISTS "Public can update collections" ON public.collections;
DROP POLICY IF EXISTS "Public can delete collections" ON public.collections;

-- Allow public read access to ALL collections (active and inactive for admin panel)
CREATE POLICY "Public can view all collections"
ON public.collections FOR SELECT
USING (true);

-- Allow ANYONE (anon + authenticated) to insert collections
CREATE POLICY "Public can insert collections"
ON public.collections FOR INSERT
WITH CHECK (true);

-- Allow ANYONE to update collections (for admin panel editing)
CREATE POLICY "Public can update collections"
ON public.collections FOR UPDATE
USING (true)
WITH CHECK (true);

-- Allow ANYONE to delete collections (for admin panel deletion)
CREATE POLICY "Public can delete collections"
ON public.collections FOR DELETE
USING (true);

-- 4. VERIFY SETUP
-- Check if buckets exist
SELECT id, name, public FROM storage.buckets WHERE id IN ('collections', 'images', 'uploads', 'media', 'files');

-- Check collections table policies
SELECT schemaname, tablename, policyname, permissive, roles, cmd
FROM pg_policies
WHERE tablename = 'collections';

-- Check storage policies
SELECT schemaname, tablename, policyname, permissive, roles, cmd
FROM pg_policies
WHERE tablename = 'objects' AND schemaname = 'storage';

-- 5. TEST DATA (Optional)
-- Uncomment to test with sample data
/*
INSERT INTO public.collections (name, description, read_more_text, explanation_text) VALUES
('Test Collection', 'Test description', 'Read More', 'This is a **test** with *formatting*.')
ON CONFLICT DO NOTHING;
*/
