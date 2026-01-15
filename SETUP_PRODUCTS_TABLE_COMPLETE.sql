-- Complete Products Table Setup
-- Run this SQL in Supabase SQL Editor to ensure all columns exist

-- ============================================================================
-- 1. Enable required extensions
-- ============================================================================
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- 2. Ensure all required columns exist with proper types
-- ============================================================================

-- Basic info columns
ALTER TABLE products ADD COLUMN IF NOT EXISTS id UUID PRIMARY KEY DEFAULT uuid_generate_v4();
ALTER TABLE products ADD COLUMN IF NOT EXISTS name TEXT NOT NULL;
ALTER TABLE products ADD COLUMN IF NOT EXISTS category TEXT NOT NULL;
ALTER TABLE products ADD COLUMN IF NOT EXISTS product_type TEXT NOT NULL DEFAULT 'other';
ALTER TABLE products ADD COLUMN IF NOT EXISTS description TEXT NOT NULL DEFAULT '';
ALTER TABLE products ADD COLUMN IF NOT EXISTS styling TEXT;

-- Pricing columns (ZAR)
ALTER TABLE products ADD COLUMN IF NOT EXISTS base_price_zar NUMERIC(10, 2) NOT NULL DEFAULT 0;
ALTER TABLE products ADD COLUMN IF NOT EXISTS selling_price_zar NUMERIC(10, 2) NOT NULL DEFAULT 0;
ALTER TABLE products ADD COLUMN IF NOT EXISTS member_price_zar NUMERIC(10, 2);
ALTER TABLE products ADD COLUMN IF NOT EXISTS promo_price_zar NUMERIC(10, 2);
ALTER TABLE products ADD COLUMN IF NOT EXISTS cost_price_zar NUMERIC(10, 2);

-- Pricing columns (USD)
ALTER TABLE products ADD COLUMN IF NOT EXISTS base_price_usd NUMERIC(10, 2) NOT NULL DEFAULT 0;
ALTER TABLE products ADD COLUMN IF NOT EXISTS selling_price_usd NUMERIC(10, 2) NOT NULL DEFAULT 0;
ALTER TABLE products ADD COLUMN IF NOT EXISTS member_price_usd NUMERIC(10, 2);
ALTER TABLE products ADD COLUMN IF NOT EXISTS promo_price_usd NUMERIC(10, 2);
ALTER TABLE products ADD COLUMN IF NOT EXISTS cost_price_usd NUMERIC(10, 2);

-- Inventory
ALTER TABLE products ADD COLUMN IF NOT EXISTS stock_quantity INTEGER NOT NULL DEFAULT 0;

-- Media (using text array since that's what the code expects)
ALTER TABLE products ADD COLUMN IF NOT EXISTS images TEXT[] DEFAULT ARRAY[]::TEXT[];

-- Marketing flags
ALTER TABLE products ADD COLUMN IF NOT EXISTS is_featured BOOLEAN NOT NULL DEFAULT false;
ALTER TABLE products ADD COLUMN IF NOT EXISTS is_new_arrival BOOLEAN NOT NULL DEFAULT false;
ALTER TABLE products ADD COLUMN IF NOT EXISTS is_best_seller BOOLEAN NOT NULL DEFAULT false;
ALTER TABLE products ADD COLUMN IF NOT EXISTS is_vault_item BOOLEAN NOT NULL DEFAULT false;

-- Gift options
ALTER TABLE products ADD COLUMN IF NOT EXISTS allow_gift_wrap BOOLEAN NOT NULL DEFAULT false;
ALTER TABLE products ADD COLUMN IF NOT EXISTS allow_gift_message BOOLEAN NOT NULL DEFAULT false;

-- Product metadata
ALTER TABLE products ADD COLUMN IF NOT EXISTS status TEXT NOT NULL DEFAULT 'draft';
ALTER TABLE products ADD COLUMN IF NOT EXISTS url_slug TEXT NOT NULL;
ALTER TABLE products ADD COLUMN IF NOT EXISTS sku TEXT NOT NULL;
ALTER TABLE products ADD COLUMN IF NOT EXISTS made_by TEXT NOT NULL DEFAULT '';

-- Arrays for materials, colors, tags (using text arrays)
ALTER TABLE products ADD COLUMN IF NOT EXISTS materials TEXT[] DEFAULT ARRAY[]::TEXT[];
ALTER TABLE products ADD COLUMN IF NOT EXISTS colors TEXT[] DEFAULT ARRAY[]::TEXT[];
ALTER TABLE products ADD COLUMN IF NOT EXISTS tags TEXT[] DEFAULT ARRAY[]::TEXT[];

-- Timestamps
ALTER TABLE products ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ DEFAULT now();
ALTER TABLE products ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ DEFAULT now();

-- ============================================================================
-- 3. Add unique constraints if they don't exist
-- ============================================================================
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conname = 'products_url_slug_key'
    ) THEN
        ALTER TABLE products ADD CONSTRAINT products_url_slug_key UNIQUE (url_slug);
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conname = 'products_sku_key'
    ) THEN
        ALTER TABLE products ADD CONSTRAINT products_sku_key UNIQUE (sku);
    END IF;
END $$;

-- ============================================================================
-- 4. Create helpful indexes
-- ============================================================================
CREATE INDEX IF NOT EXISTS idx_products_category ON products(category);
CREATE INDEX IF NOT EXISTS idx_products_product_type ON products(product_type);
CREATE INDEX IF NOT EXISTS idx_products_status ON products(status);
CREATE INDEX IF NOT EXISTS idx_products_is_featured ON products(is_featured);
CREATE INDEX IF NOT EXISTS idx_products_is_new_arrival ON products(is_new_arrival);
CREATE INDEX IF NOT EXISTS idx_products_is_best_seller ON products(is_best_seller);
CREATE INDEX IF NOT EXISTS idx_products_created_at ON products(created_at DESC);

-- ============================================================================
-- 5. Set up RLS policies for public access (temporary for development)
-- ============================================================================

-- Enable RLS
ALTER TABLE products ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Enable read access for all users" ON products;
DROP POLICY IF EXISTS "Enable insert for all users" ON products;
DROP POLICY IF EXISTS "Enable update for all users" ON products;
DROP POLICY IF EXISTS "Enable delete for all users" ON products;

-- Create public access policies (CHANGE THIS IN PRODUCTION!)
CREATE POLICY "Enable read access for all users" ON products FOR SELECT USING (true);
CREATE POLICY "Enable insert for all users" ON products FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable update for all users" ON products FOR UPDATE USING (true);
CREATE POLICY "Enable delete for all users" ON products FOR DELETE USING (true);

-- ============================================================================
-- 6. Verify the setup
-- ============================================================================

-- Show all columns
SELECT
    column_name,
    data_type,
    udt_name,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_schema = 'public'
AND table_name = 'products'
ORDER BY ordinal_position;

-- Show counts
SELECT
    COUNT(*) as total_products,
    COUNT(CASE WHEN images IS NOT NULL AND array_length(images, 1) > 0 THEN 1 END) as products_with_images,
    COUNT(CASE WHEN status = 'active' THEN 1 END) as active_products,
    COUNT(CASE WHEN status = 'draft' THEN 1 END) as draft_products
FROM products;

-- Success message
SELECT
    '✅ Products table setup complete!' as status,
    'All required columns exist with proper types' as details;

