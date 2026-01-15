-- CRITICAL FIX: Products table UUID generation and constraints
-- Run this SQL in your Supabase SQL Editor NOW to fix the null ID error
-- This MUST be run before you can save products!

-- ============================================================================
-- STEP 1: Enable UUID extension (if not already enabled)
-- ============================================================================
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- STEP 2: Fix the ID column to auto-generate UUIDs
-- ============================================================================

-- Drop the NOT NULL constraint temporarily if it exists
ALTER TABLE products ALTER COLUMN id DROP NOT NULL;

-- Set default UUID generation for id column
ALTER TABLE products ALTER COLUMN id SET DEFAULT uuid_generate_v4();

-- Update any existing rows with NULL id (shouldn't be any, but just in case)
UPDATE products SET id = uuid_generate_v4() WHERE id IS NULL;

-- Re-add NOT NULL constraint now that all rows have IDs
ALTER TABLE products ALTER COLUMN id SET NOT NULL;

-- ============================================================================
-- STEP 3: Add product_type column if missing
-- ============================================================================
ALTER TABLE products ADD COLUMN IF NOT EXISTS product_type TEXT;

-- Set default for product_type
ALTER TABLE products ALTER COLUMN product_type SET DEFAULT 'other';

-- Update existing rows that might have NULL product_type
UPDATE products SET product_type = 'other' WHERE product_type IS NULL;

-- Make it NOT NULL
ALTER TABLE products ALTER COLUMN product_type SET NOT NULL;

-- ============================================================================
-- STEP 4: Fix timestamp columns
-- ============================================================================

-- Ensure created_at has proper default
ALTER TABLE products ALTER COLUMN created_at SET DEFAULT now();

-- Ensure updated_at has proper default
ALTER TABLE products ALTER COLUMN updated_at SET DEFAULT now();

-- Update any existing NULL timestamps
UPDATE products SET created_at = now() WHERE created_at IS NULL;
UPDATE products SET updated_at = now() WHERE updated_at IS NULL;

-- ============================================================================
-- STEP 5: Add helpful indexes for performance
-- ============================================================================
CREATE INDEX IF NOT EXISTS idx_products_product_type ON products(product_type);
CREATE INDEX IF NOT EXISTS idx_products_category ON products(category);
CREATE INDEX IF NOT EXISTS idx_products_status ON products(status);
CREATE INDEX IF NOT EXISTS idx_products_sku ON products(sku);
CREATE INDEX IF NOT EXISTS idx_products_url_slug ON products(url_slug);

-- ============================================================================
-- STEP 6: Verify the fix worked
-- ============================================================================
-- This will show you the column definitions to confirm defaults are set
SELECT
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'products'
AND column_name IN ('id', 'product_type', 'created_at', 'updated_at')
ORDER BY ordinal_position;

-- ============================================================================
-- SUCCESS MESSAGE
-- ============================================================================
-- If you see the query results above with:
-- - id with default: uuid_generate_v4()
-- - product_type with default: 'other'
-- - created_at with default: now()
-- - updated_at with default: now()
--
-- Then you're good to go! Try saving a product in your Flutter app now.
-- ============================================================================

