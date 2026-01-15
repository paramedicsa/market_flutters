-- FIX REVIEWS TABLE ORDER_ID ISSUE
-- The order_id field should be nullable for seeded reviews
-- Run this in Supabase SQL Editor
-- =====================================================

-- Drop existing table and recreate with proper schema
DROP TABLE IF EXISTS reviews CASCADE;

CREATE TABLE reviews (
  -- Primary key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Foreign keys
  product_id UUID NOT NULL,
  order_id UUID NULL,  -- Changed to nullable for seeded reviews

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

-- Enable Row Level Security (RLS)
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;

-- Drop existing policies
DROP POLICY IF EXISTS "Allow public insert for development" ON reviews;
DROP POLICY IF EXISTS "Allow public select for development" ON reviews;
DROP POLICY IF EXISTS "Allow public update for development" ON reviews;
DROP POLICY IF EXISTS "Allow public delete for development" ON reviews;

-- PUBLIC ACCESS FOR DEVELOPMENT
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
-- Run this to verify the table structure:
-- =====================================================

SELECT
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'reviews'
ORDER BY ordinal_position;

-- Expected output should show:
-- order_id | uuid | YES | NULL
-- =====================================================

