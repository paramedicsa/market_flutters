-- =====================================================
-- FIX ROW LEVEL SECURITY POLICIES FOR PRODUCTS TABLE
-- This allows authenticated users to insert/update products
-- Run this in Supabase SQL Editor
-- =====================================================

-- Drop existing policies to start fresh
DROP POLICY IF EXISTS "Allow public read access to active products" ON products;
DROP POLICY IF EXISTS "Allow authenticated users full access" ON products;
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON products;
DROP POLICY IF EXISTS "Enable read access for all users" ON products;
DROP POLICY IF EXISTS "Enable update for authenticated users only" ON products;
DROP POLICY IF EXISTS "Enable delete for authenticated users only" ON products;

-- Enable RLS (if not already enabled)
ALTER TABLE products ENABLE ROW LEVEL SECURITY;

-- Policy 1: Allow public to READ active products (for customers browsing)
CREATE POLICY "Allow public read access to active products"
ON products FOR SELECT
USING (status = 'active');

-- Policy 2: Allow authenticated users to INSERT products (for admin)
CREATE POLICY "Enable insert for authenticated users only"
ON products FOR INSERT
TO authenticated
WITH CHECK (true);

-- Policy 3: Allow authenticated users to UPDATE products (for admin)
CREATE POLICY "Enable update for authenticated users only"
ON products FOR UPDATE
TO authenticated
USING (true)
WITH CHECK (true);

-- Policy 4: Allow authenticated users to DELETE products (for admin)
CREATE POLICY "Enable delete for authenticated users only"
ON products FOR DELETE
TO authenticated
USING (true);

-- Policy 5: Allow authenticated users to SELECT ALL products (for admin panel)
CREATE POLICY "Enable read all for authenticated users"
ON products FOR SELECT
TO authenticated
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
    cmd,
    qual,
    with_check
FROM pg_policies
WHERE tablename = 'products';

-- =====================================================
-- SUCCESS! RLS policies configured!
-- =====================================================
-- Public users: Can read active products
-- Authenticated users: Full CRUD access (admin)
-- =====================================================

