-- =====================================================
-- FIX REVIEWS TABLE - Add All Missing Columns
-- Copy and paste this entire file into Supabase SQL Editor
-- =====================================================

-- First, ensure products table has status column
ALTER TABLE products
ADD COLUMN IF NOT EXISTS status TEXT DEFAULT 'draft';

-- Update any NULL status values to 'draft'
UPDATE products SET status = 'draft' WHERE status IS NULL;

-- Add reviews table columns
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

CREATE INDEX IF NOT EXISTS idx_reviews_product_id ON reviews(product_id);
CREATE INDEX IF NOT EXISTS idx_reviews_status ON reviews(status);
CREATE INDEX IF NOT EXISTS idx_reviews_rating ON reviews(rating);
CREATE INDEX IF NOT EXISTS idx_reviews_created_at ON reviews(created_at DESC);

ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Allow public insert for development" ON reviews;
DROP POLICY IF EXISTS "Allow public select for development" ON reviews;
DROP POLICY IF EXISTS "Allow public update for development" ON reviews;
DROP POLICY IF EXISTS "Allow public delete for development" ON reviews;

CREATE POLICY "Allow public insert for development" ON reviews FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public select for development" ON reviews FOR SELECT USING (true);
CREATE POLICY "Allow public update for development" ON reviews FOR UPDATE USING (true) WITH CHECK (true);
CREATE POLICY "Allow public delete for development" ON reviews FOR DELETE USING (true);

-- Success message
SELECT 'Products status column added/verified!' AS message
UNION ALL
SELECT 'Reviews table fixed with all columns!' AS message;

