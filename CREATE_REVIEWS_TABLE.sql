-- =====================================================
-- CREATE COMPLETE REVIEWS TABLE WITH ALL COLUMNS
-- Run this in Supabase SQL Editor
-- =====================================================

-- Drop existing table if starting fresh (CAREFUL: deletes data)
-- DROP TABLE IF EXISTS reviews CASCADE;

-- Create reviews table with ALL required columns
CREATE TABLE IF NOT EXISTS reviews (
  -- Primary key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Foreign keys
  product_id UUID NOT NULL,
  order_id TEXT NOT NULL,

  -- Review content
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  review_text TEXT CHECK (LENGTH(review_text) <= 300),

  -- Review status
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),

  -- Reviewer information
  reviewer_name TEXT,
  reviewer_country TEXT,
  reviewer_flag TEXT,

  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  approved_at TIMESTAMPTZ,

  -- Foreign key constraint
  CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- Add indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_reviews_product_id ON reviews(product_id);
CREATE INDEX IF NOT EXISTS idx_reviews_status ON reviews(status);
CREATE INDEX IF NOT EXISTS idx_reviews_rating ON reviews(rating);
CREATE INDEX IF NOT EXISTS idx_reviews_created_at ON reviews(created_at DESC);

-- Add comments to document the schema
COMMENT ON TABLE reviews IS 'Product reviews from customers';
COMMENT ON COLUMN reviews.id IS 'Unique review identifier (UUID)';
COMMENT ON COLUMN reviews.product_id IS 'Foreign key to products table';
COMMENT ON COLUMN reviews.order_id IS 'Order ID associated with this review';
COMMENT ON COLUMN reviews.rating IS 'Star rating from 1 to 5';
COMMENT ON COLUMN reviews.review_text IS 'Review text content (max 300 characters)';
COMMENT ON COLUMN reviews.status IS 'Review status: pending, approved, or rejected';
COMMENT ON COLUMN reviews.reviewer_name IS 'Name of the person who wrote the review';
COMMENT ON COLUMN reviews.reviewer_country IS 'Country of the reviewer';
COMMENT ON COLUMN reviews.reviewer_flag IS 'Country flag emoji (e.g., 🇯🇵, 🇧🇷, 🇺🇸)';
COMMENT ON COLUMN reviews.created_at IS 'When review was submitted';
COMMENT ON COLUMN reviews.approved_at IS 'When review was approved by admin';

-- Enable Row Level Security (RLS)
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;

-- Drop existing policies
DROP POLICY IF EXISTS "Allow public read approved reviews" ON reviews;
DROP POLICY IF EXISTS "Allow public insert reviews" ON reviews;
DROP POLICY IF EXISTS "Allow public select reviews" ON reviews;
DROP POLICY IF EXISTS "Allow public update reviews" ON reviews;
DROP POLICY IF EXISTS "Allow public delete reviews" ON reviews;

-- PUBLIC ACCESS FOR DEVELOPMENT (same as products)
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
-- VERIFICATION QUERY
-- Run this to verify all columns exist:
-- =====================================================

SELECT
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'reviews'
ORDER BY ordinal_position;

-- =====================================================
-- COMPLETE! Reviews table ready with all columns:
-- =====================================================
-- ✅ id (UUID)
-- ✅ product_id (UUID)
-- ✅ order_id (TEXT)
-- ✅ rating (INTEGER)
-- ✅ review_text (TEXT)
-- ✅ status (TEXT)
-- ✅ reviewer_name (TEXT)
-- ✅ reviewer_country (TEXT)
-- ✅ reviewer_flag (TEXT)
-- ✅ created_at (TIMESTAMPTZ)
-- ✅ approved_at (TIMESTAMPTZ)
-- =====================================================

