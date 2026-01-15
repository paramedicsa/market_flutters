-- =====================================================
-- ADD STYLING COLUMN TO PRODUCTS TABLE
-- =====================================================

-- Add styling column to products table
ALTER TABLE products
ADD COLUMN IF NOT EXISTS styling TEXT;

-- Add comment to explain the column
COMMENT ON COLUMN products.styling IS 'Styling tips and suggestions for wearing/using the product';

-- =====================================================
-- COMPLETE! Styling column added to products table.
-- =====================================================

