-- =====================================================
-- TEMPORARY PUBLIC ACCESS FOR PRODUCTS TABLE
-- This allows ANYONE to create/edit products (FOR DEVELOPMENT ONLY!)
-- You can secure this later with authentication
-- Run this in Supabase SQL Editor
-- =====================================================

-- Drop existing policies
DROP POLICY IF EXISTS "Allow public read access to active products" ON products;
DROP POLICY IF EXISTS "Allow authenticated users full access" ON products;
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON products;
DROP POLICY IF EXISTS "Enable read access for all users" ON products;
DROP POLICY IF EXISTS "Enable update for authenticated users only" ON products;
DROP POLICY IF EXISTS "Enable delete for authenticated users only" ON products;

-- Enable RLS (required to have policies)
ALTER TABLE products ENABLE ROW LEVEL SECURITY;

-- ⚠️ DEVELOPMENT MODE: Allow PUBLIC full access to products
-- Anyone can do ANYTHING with products (for building/testing)

-- Allow anyone to INSERT products
CREATE POLICY "Allow public insert for development"
ON products FOR INSERT
WITH CHECK (true);

-- Allow anyone to SELECT all products
CREATE POLICY "Allow public select for development"
ON products FOR SELECT
USING (true);

-- Allow anyone to UPDATE products
CREATE POLICY "Allow public update for development"
ON products FOR UPDATE
USING (true)
WITH CHECK (true);

-- Allow anyone to DELETE products
CREATE POLICY "Allow public delete for development"
ON products FOR DELETE
USING (true);

-- =====================================================
-- VERIFICATION: Check policies exist
-- =====================================================
SELECT
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd
FROM pg_policies
WHERE tablename = 'products';

-- =====================================================
-- ⚠️ WARNING: DEVELOPMENT MODE ACTIVE!
-- =====================================================
-- These policies allow ANYONE (public) to:
-- - Create products
-- - Read all products
-- - Update products
-- - Delete products
--
-- ✅ Perfect for building and testing!
-- ⚠️ REMEMBER to secure this later with authentication!
-- =====================================================

