-- =====================================================
-- COMPLETE DATABASE SETUP - Products & Reviews
-- This ensures EVERYTHING works: status column, policies, reviews
-- Copy and paste this entire file into Supabase SQL Editor
-- =====================================================

-- =====================================================
-- PART 1: PRODUCTS TABLE
-- =====================================================

-- Ensure products table has status column
ALTER TABLE products
ADD COLUMN IF NOT EXISTS status TEXT DEFAULT 'draft',
ADD COLUMN IF NOT EXISTS colors TEXT[] DEFAULT '{}',
ADD COLUMN IF NOT EXISTS tags TEXT[] DEFAULT '{}';

-- Update any NULL status values to 'draft'
UPDATE products SET status = 'draft' WHERE status IS NULL;

-- Add comments for new columns
COMMENT ON COLUMN products.status IS 'Product status: draft or active (published)';
COMMENT ON COLUMN products.colors IS 'Array of product colors (e.g., Crimson red, Cloudy white, Polished silver)';
COMMENT ON COLUMN products.tags IS 'Array of product tags for search and categorization (e.g., heart necklace, handmade jewelry)';

-- Enable RLS on products table
ALTER TABLE products ENABLE ROW LEVEL SECURITY;

-- Drop all existing policies on products
DROP POLICY IF EXISTS "Allow public read access to active products" ON products;
DROP POLICY IF EXISTS "Allow authenticated users full access" ON products;
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON products;
DROP POLICY IF EXISTS "Enable read access for all users" ON products;
DROP POLICY IF EXISTS "Enable update for authenticated users only" ON products;
DROP POLICY IF EXISTS "Enable delete for authenticated users only" ON products;
DROP POLICY IF EXISTS "Allow public insert for development" ON products;
DROP POLICY IF EXISTS "Allow public select for development" ON products;
DROP POLICY IF EXISTS "Allow public update for development" ON products;
DROP POLICY IF EXISTS "Allow public delete for development" ON products;

-- Create PUBLIC policies for DEVELOPMENT MODE
-- ⚠️ WARNING: These allow ANYONE to manage products (no authentication required)

CREATE POLICY "Allow public insert for development"
ON products FOR INSERT
WITH CHECK (true);

CREATE POLICY "Allow public select for development"
ON products FOR SELECT
USING (true);

CREATE POLICY "Allow public update for development"
ON products FOR UPDATE
USING (true)
WITH CHECK (true);

CREATE POLICY "Allow public delete for development"
ON products FOR DELETE
USING (true);

-- =====================================================
-- PART 2: REVIEWS TABLE
-- =====================================================

-- Ensure reviews table exists (create if not)
CREATE TABLE IF NOT EXISTS reviews (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id UUID,
  order_id TEXT,
  rating INTEGER,
  review_text TEXT,
  status TEXT DEFAULT 'pending',
  reviewer_name TEXT,
  reviewer_country TEXT,
  reviewer_flag TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  approved_at TIMESTAMPTZ
);

-- Add missing columns if table already existed
ALTER TABLE reviews
ADD COLUMN IF NOT EXISTS product_id UUID,
ADD COLUMN IF NOT EXISTS order_id TEXT,
ADD COLUMN IF NOT EXISTS rating INTEGER,
ADD COLUMN IF NOT EXISTS review_text TEXT,
ADD COLUMN IF NOT EXISTS status TEXT DEFAULT 'pending',
ADD COLUMN IF NOT EXISTS reviewer_name TEXT,
ADD COLUMN IF NOT EXISTS reviewer_country TEXT,
ADD COLUMN IF NOT EXISTS reviewer_flag TEXT,
ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ DEFAULT NOW(),
ADD COLUMN IF NOT EXISTS approved_at TIMESTAMPTZ;

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_reviews_product_id ON reviews(product_id);
CREATE INDEX IF NOT EXISTS idx_reviews_status ON reviews(status);
CREATE INDEX IF NOT EXISTS idx_reviews_rating ON reviews(rating);
CREATE INDEX IF NOT EXISTS idx_reviews_created_at ON reviews(created_at DESC);

-- Enable RLS on reviews table
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;

-- Drop all existing policies on reviews
DROP POLICY IF EXISTS "Allow public read approved reviews" ON reviews;
DROP POLICY IF EXISTS "Allow public insert reviews" ON reviews;
DROP POLICY IF EXISTS "Allow public select reviews" ON reviews;
DROP POLICY IF EXISTS "Allow public update reviews" ON reviews;
DROP POLICY IF EXISTS "Allow public delete reviews" ON reviews;
DROP POLICY IF EXISTS "Allow public insert for development" ON reviews;
DROP POLICY IF EXISTS "Allow public select for development" ON reviews;
DROP POLICY IF EXISTS "Allow public update for development" ON reviews;
DROP POLICY IF EXISTS "Allow public delete for development" ON reviews;

-- Create PUBLIC policies for DEVELOPMENT MODE
CREATE POLICY "Allow public insert for development"
ON reviews FOR INSERT
WITH CHECK (true);

CREATE POLICY "Allow public select for development"
ON reviews FOR SELECT
USING (true);

CREATE POLICY "Allow public update for development"
ON reviews FOR UPDATE
USING (true)
WITH CHECK (true);

CREATE POLICY "Allow public delete for development"
ON reviews FOR DELETE
USING (true);

-- =====================================================
-- VERIFICATION
-- =====================================================

-- Check products policies
SELECT
    'PRODUCTS POLICIES:' AS info,
    policyname,
    cmd AS operation,
    roles
FROM pg_policies
WHERE tablename = 'products'
ORDER BY cmd;

-- Check reviews policies
SELECT
    'REVIEWS POLICIES:' AS info,
    policyname,
    cmd AS operation,
    roles
FROM pg_policies
WHERE tablename = 'reviews'
ORDER BY cmd;

-- Success messages
SELECT '✅ Products table: status, colors, and tags columns added/verified' AS status
UNION ALL
SELECT '✅ Products policies: Full CRUD access (INSERT, SELECT, UPDATE, DELETE)' AS status
UNION ALL
SELECT '✅ Reviews table: All columns added/verified' AS status
UNION ALL
SELECT '✅ Reviews policies: Full CRUD access (INSERT, SELECT, UPDATE, DELETE)' AS status
UNION ALL
SELECT '⚠️  Development mode active - PUBLIC access enabled' AS status
UNION ALL
SELECT '📝 Remember to secure with authentication before going live!' AS status;

-- =====================================================
-- COMPLETE!
-- =====================================================
-- Products table: ✅ Status, Colors, Tags columns, ✅ Full CRUD policies
-- Reviews table: ✅ All columns, ✅ Full CRUD policies
--
-- You can now:
-- - Create products with colors and tags ✅
-- - Edit products ✅
-- - Delete products ✅
-- - Save reviews ✅
-- - Manage everything without authentication (development mode)
-- =====================================================

