
-- FIX_REVIEWS_USER_ID_NULLABLE.sql
-- Make user_id nullable for seeded reviews
-- Run this in Supabase SQL Editor BEFORE inserting reviews

-- Make user_id nullable so seeded reviews can exist without real users
ALTER TABLE reviews ALTER COLUMN user_id DROP NOT NULL;

-- =====================================================
-- VERIFICATION
-- =====================================================

SELECT column_name, is_nullable
FROM information_schema.columns
WHERE table_name = 'reviews' AND column_name = 'user_id';

-- Should show: user_id | YES (nullable)
-- =====================================================

-- Now you can run INSERT_REVIEWS_FOR_PRODUCT.sql
