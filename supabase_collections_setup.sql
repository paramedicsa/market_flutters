-- =========================================
-- COLLECTIONS TABLE SETUP FOR MARKET FLUTTER
-- =========================================
-- This script creates/updates the collections table with all necessary fields
-- and sets up proper policies for secure access

-- Create collections table if it doesn't exist
CREATE TABLE IF NOT EXISTS public.collections (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    image_url TEXT,
    read_more_text TEXT DEFAULT 'Read more',
    explanation_text TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    is_active BOOLEAN DEFAULT true NOT NULL
);

-- Add new columns if they don't exist (for existing tables)
ALTER TABLE public.collections
ADD COLUMN IF NOT EXISTS read_more_text TEXT DEFAULT 'Read more',
ADD COLUMN IF NOT EXISTS explanation_text TEXT;

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_collections_is_active ON public.collections(is_active);
CREATE INDEX IF NOT EXISTS idx_collections_created_at ON public.collections(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_collections_name ON public.collections(name);

-- Create updated_at trigger function if it doesn't exist
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = timezone('utc'::text, now());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for updated_at if it doesn't exist
DROP TRIGGER IF EXISTS handle_collections_updated_at ON public.collections;
CREATE TRIGGER handle_collections_updated_at
    BEFORE UPDATE ON public.collections
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_updated_at();

-- =========================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- =========================================

-- Enable RLS on collections table
ALTER TABLE public.collections ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Collections are viewable by everyone" ON public.collections;
DROP POLICY IF EXISTS "Collections are insertable by authenticated users" ON public.collections;
DROP POLICY IF EXISTS "Collections are updatable by authenticated users" ON public.collections;
DROP POLICY IF EXISTS "Collections are deletable by authenticated users" ON public.collections;

-- Create policies for public read access (for frontend users)
CREATE POLICY "Collections are viewable by everyone"
ON public.collections FOR SELECT
USING (is_active = true);

-- Create policies for admin operations (authenticated users only)
CREATE POLICY "Collections are insertable by authenticated users"
ON public.collections FOR INSERT
WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Collections are updatable by authenticated users"
ON public.collections FOR UPDATE
USING (auth.role() = 'authenticated')
WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Collections are deletable by authenticated users"
ON public.collections FOR DELETE
USING (auth.role() = 'authenticated');

-- =========================================
-- STORAGE BUCKET SETUP
-- =========================================

-- Create collections storage bucket if it doesn't exist
INSERT INTO storage.buckets (id, name, public)
VALUES ('collections', 'collections', true)
ON CONFLICT (id) DO NOTHING;

-- Storage policies for collections bucket
DROP POLICY IF EXISTS "Collections images are publicly accessible" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can upload collection images" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can update collection images" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can delete collection images" ON storage.objects;

-- Allow public access to collection images
CREATE POLICY "Collections images are publicly accessible"
ON storage.objects FOR SELECT
USING (bucket_id = 'collections');

-- Allow authenticated users to upload collection images
CREATE POLICY "Authenticated users can upload collection images"
ON storage.objects FOR INSERT
WITH CHECK (
    bucket_id = 'collections'
    AND auth.role() = 'authenticated'
);

-- Allow authenticated users to update collection images
CREATE POLICY "Authenticated users can update collection images"
ON storage.objects FOR UPDATE
USING (
    bucket_id = 'collections'
    AND auth.role() = 'authenticated'
)
WITH CHECK (
    bucket_id = 'collections'
    AND auth.role() = 'authenticated'
);

-- Allow authenticated users to delete collection images
CREATE POLICY "Authenticated users can delete collection images"
ON storage.objects FOR DELETE
USING (
    bucket_id = 'collections'
    AND auth.role() = 'authenticated'
);

-- =========================================
-- SAMPLE DATA (Optional - for testing)
-- =========================================

-- Insert sample collections (uncomment to use)
/*
INSERT INTO public.collections (name, description, read_more_text, explanation_text) VALUES
('Radiant Visionary Collection', 'Bold red jewelry for confident personalities', 'Discover More', '**Radiant Visionary** People who wear red jewelry are the living exclamation points of the fashion world. They possess an infectious vitality and a self-assuredness that draws people toward them like a warm hearth.

**The Personality Breakdown:**
**Unapologetic Confidence:** A wearer of red jewelry doesn''t hide in the shadows. They are comfortable being the center of attention and possess the **"main character energy"** required to lead, inspire, and take risks.

**Warmth and Charisma:** Red is the color of the heart. Those who choose it are often perceived as deeply passionate, approachable, and generous. Their jewelry serves as a visual cue for their **high emotional intelligence** and their ability to connect deeply with others.

**A "Joie de Vivre" Spirit:** Whether it''s a pair of bold ruby studs or a chunky scarlet necklace, red jewelry signifies a person who celebrates life. They find joy in the small details and approach their day with a spirited, **"can-do"** attitude.

**Fearless Creativity:** They view fashion as a playground. By choosing such a high-contrast color, they demonstrate an **artistic eye** and a refusal to follow **"safe"** or boring trends. They are the trendsetters who know that a pop of crimson can transform a simple outfit into a masterpiece.

**Inner Strength:** Historically, red is the color of courage. The red-jewelry wearer is often the person friends turn to in a crisis—they are resilient, grounded, and possess a **fiery inner strength** that helps them navigate challenges with grace.'),
('Summer Collection', 'Beautiful summer pieces perfect for warm weather', 'Discover More', 'Featuring **handcrafted** designs with *premium materials*'),
('Winter Essentials', 'Cozy winter collection for cold days', 'Explore Collection', 'Made with **warm fabrics** and *durable stitching*'),
('Spring Blossoms', 'Fresh spring designs inspired by nature', 'View Details', 'Includes **seasonal colors** and *lightweight materials*'),
('Autumn Harvest', 'Rich autumn tones and textures', 'Learn More', 'Showcasing **natural dyes** and *traditional techniques*')
ON CONFLICT DO NOTHING;
*/

-- =========================================
-- VERIFICATION QUERIES
-- =========================================

-- Check table structure
-- SELECT column_name, data_type, is_nullable, column_default
-- FROM information_schema.columns
-- WHERE table_name = 'collections'
-- ORDER BY ordinal_position;

-- Check policies
-- SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual, with_check
-- FROM pg_policies
-- WHERE tablename = 'collections';

-- Check storage policies
-- SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual, with_check
-- FROM pg_policies
-- WHERE tablename = 'objects' AND schemaname = 'storage';

-- Check sample data
-- SELECT id, name, description, read_more_text, explanation_text, is_active, created_at
-- FROM public.collections
-- ORDER BY created_at DESC
-- LIMIT 5;
