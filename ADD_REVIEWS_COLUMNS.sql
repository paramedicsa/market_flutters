-- =====================================================
-- ADD MISSING COLUMNS TO EXISTING REVIEWS TABLE
-- Use this if your reviews table already exists
-- Run this in Supabase SQL Editor
-- =====================================================

ALTER TABLE reviews
ADD COLUMN IF NOT EXISTS id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
ADD COLUMN IF NOT EXISTS product_id UUID,
ADD COLUMN IF NOT EXISTS order_id TEXT,
ADD COLUMN IF NOT EXISTS rating INTEGER CHECK (rating >= 1 AND rating <= 5),
ADD COLUMN IF NOT EXISTS review_text TEXT CHECK (LENGTH(review_text) <= 300),
ADD COLUMN IF NOT EXISTS status TEXT DEFAULT 'pending',
ADD COLUMN IF NOT EXISTS reviewer_name TEXT,
ADD COLUMN IF NOT EXISTS reviewer_country TEXT,
ADD COLUMN IF NOT EXISTS reviewer_flag TEXT,
ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ DEFAULT NOW(),
ADD COLUMN IF NOT EXISTS approved_at TIMESTAMPTZ;

-- Update any NULL values in required fields
UPDATE reviews SET rating = 5 WHERE rating IS NULL;
UPDATE reviews SET status = 'approved' WHERE status IS NULL;

-- Add foreign key constraint if it doesn't exist
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conname = 'fk_product'
    ) THEN
        ALTER TABLE reviews ADD CONSTRAINT fk_product
        FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE;
    END IF;
END $$;

-- Add indexes for better performance
CREATE INDEX IF NOT EXISTS idx_reviews_product_id ON reviews(product_id);
CREATE INDEX IF NOT EXISTS idx_reviews_status ON reviews(status);
CREATE INDEX IF NOT EXISTS idx_reviews_rating ON reviews(rating);
CREATE INDEX IF NOT EXISTS idx_reviews_created_at ON reviews(created_at DESC);

-- Add comments
COMMENT ON COLUMN reviews.product_id IS 'Foreign key to products table';
COMMENT ON COLUMN reviews.order_id IS 'Order ID associated with review';
COMMENT ON COLUMN reviews.rating IS 'Star rating 1-5';
COMMENT ON COLUMN reviews.review_text IS 'Review text (max 300 chars)';
COMMENT ON COLUMN reviews.status IS 'pending/approved/rejected';
COMMENT ON COLUMN reviews.reviewer_name IS 'Reviewer name';
COMMENT ON COLUMN reviews.reviewer_country IS 'Reviewer country';
COMMENT ON COLUMN reviews.reviewer_flag IS 'Country flag emoji';
COMMENT ON COLUMN reviews.created_at IS 'Review submission date';
COMMENT ON COLUMN reviews.approved_at IS 'Review approval date';

-- Enable RLS
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;

-- Drop existing policies
DROP POLICY IF EXISTS "Allow public read approved reviews" ON reviews;
DROP POLICY IF EXISTS "Allow public insert reviews" ON reviews;
DROP POLICY IF EXISTS "Allow public select reviews" ON reviews;
DROP POLICY IF EXISTS "Allow public update reviews" ON reviews;
DROP POLICY IF EXISTS "Allow public delete reviews" ON reviews;

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
-- VERIFICATION
-- =====================================================
SELECT
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_name = 'reviews'
ORDER BY column_name;

-- =====================================================
-- SUCCESS! Reviews table ready!
-- =====================================================

