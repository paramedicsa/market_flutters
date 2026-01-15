-- =====================================================
-- COMPLETE PRODUCTS TABLE SCHEMA
-- This creates/updates the products table with ALL required columns
-- Run this in Supabase SQL Editor
-- =====================================================

-- Drop existing table if you want to start fresh (CAREFUL: This deletes all data!)
-- DROP TABLE IF EXISTS products CASCADE;

-- Create products table with ALL columns
CREATE TABLE IF NOT EXISTS products (
  -- Primary key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Basic product information
  name TEXT NOT NULL,
  category TEXT,
  description TEXT,
  styling TEXT,

  -- Pricing - ZAR (South African Rand)
  base_price_zar NUMERIC(10,2) NOT NULL DEFAULT 0,
  selling_price_zar NUMERIC(10,2) NOT NULL DEFAULT 0,
  member_price_zar NUMERIC(10,2),
  promo_price_zar NUMERIC(10,2),
  cost_price_zar NUMERIC(10,2),

  -- Pricing - USD (US Dollars)
  base_price_usd NUMERIC(10,2) NOT NULL DEFAULT 0,
  selling_price_usd NUMERIC(10,2) NOT NULL DEFAULT 0,
  member_price_usd NUMERIC(10,2),
  promo_price_usd NUMERIC(10,2),
  cost_price_usd NUMERIC(10,2),

  -- Inventory
  stock_quantity INTEGER NOT NULL DEFAULT 0,

  -- Media
  images TEXT[] DEFAULT '{}',

  -- Marketing flags
  is_featured BOOLEAN DEFAULT false,
  is_new_arrival BOOLEAN DEFAULT false,
  is_best_seller BOOLEAN DEFAULT false,
  is_vault_item BOOLEAN DEFAULT false,

  -- Gift options
  allow_gift_wrap BOOLEAN DEFAULT false,
  allow_gift_message BOOLEAN DEFAULT false,

  -- Product metadata
  status TEXT DEFAULT 'draft',
  url_slug TEXT UNIQUE,
  sku TEXT UNIQUE,

  -- Production information
  made_by TEXT,
  materials TEXT[] DEFAULT '{}',

  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Add indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_products_category ON products(category);
CREATE INDEX IF NOT EXISTS idx_products_status ON products(status);
CREATE INDEX IF NOT EXISTS idx_products_is_featured ON products(is_featured);
CREATE INDEX IF NOT EXISTS idx_products_is_new_arrival ON products(is_new_arrival);
CREATE INDEX IF NOT EXISTS idx_products_is_best_seller ON products(is_best_seller);
CREATE INDEX IF NOT EXISTS idx_products_created_at ON products(created_at DESC);

-- Add comments to document the schema
COMMENT ON TABLE products IS 'Main products table containing all product information';
COMMENT ON COLUMN products.id IS 'Unique product identifier (UUID)';
COMMENT ON COLUMN products.name IS 'Product display name';
COMMENT ON COLUMN products.category IS 'Product category/collection name';
COMMENT ON COLUMN products.description IS 'Detailed product description';
COMMENT ON COLUMN products.styling IS 'Styling tips and suggestions for wearing/using the product';
COMMENT ON COLUMN products.base_price_zar IS 'Recommended Retail Price (RRP) in South African Rand';
COMMENT ON COLUMN products.base_price_usd IS 'Recommended Retail Price (RRP) in US Dollars';
COMMENT ON COLUMN products.selling_price_zar IS 'Actual selling price in South African Rand';
COMMENT ON COLUMN products.selling_price_usd IS 'Actual selling price in US Dollars';
COMMENT ON COLUMN products.member_price_zar IS 'Membership/loyalty price in South African Rand (typically 20% off)';
COMMENT ON COLUMN products.member_price_usd IS 'Membership/loyalty price in US Dollars (typically 20% off)';
COMMENT ON COLUMN products.promo_price_zar IS 'Promotional/sale price in South African Rand';
COMMENT ON COLUMN products.promo_price_usd IS 'Promotional/sale price in US Dollars';
COMMENT ON COLUMN products.cost_price_zar IS 'Total cost per item in South African Rand (including product cost, packaging, shipping, customs)';
COMMENT ON COLUMN products.cost_price_usd IS 'Total cost per item in US Dollars (including product cost, packaging, shipping, customs)';
COMMENT ON COLUMN products.stock_quantity IS 'Current stock quantity available';
COMMENT ON COLUMN products.images IS 'Array of image URLs for product photos';
COMMENT ON COLUMN products.is_featured IS 'Featured product flag for homepage display';
COMMENT ON COLUMN products.is_new_arrival IS 'New arrival flag for new products section';
COMMENT ON COLUMN products.is_best_seller IS 'Best seller flag for popular products';
COMMENT ON COLUMN products.is_vault_item IS 'Vault item flag for limited-time exclusive products';
COMMENT ON COLUMN products.allow_gift_wrap IS 'Allow gift wrapping option for this product';
COMMENT ON COLUMN products.allow_gift_message IS 'Allow gift message option for this product';
COMMENT ON COLUMN products.status IS 'Product status: draft, active, archived, out_of_stock';
COMMENT ON COLUMN products.url_slug IS 'SEO-friendly URL slug (must be unique)';
COMMENT ON COLUMN products.sku IS 'Stock Keeping Unit - unique product identifier (must be unique)';
COMMENT ON COLUMN products.made_by IS 'Artist or manufacturer name who created the product';
COMMENT ON COLUMN products.materials IS 'Array of materials used in the product (e.g., Silver, Gold, Glass, Beads, etc.)';
COMMENT ON COLUMN products.created_at IS 'Timestamp when product was created';
COMMENT ON COLUMN products.updated_at IS 'Timestamp when product was last updated';

-- Enable Row Level Security (RLS)
ALTER TABLE products ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Allow public read access to active products" ON products;
DROP POLICY IF EXISTS "Allow authenticated users full access" ON products;

-- Create policies for public read access to active products
CREATE POLICY "Allow public read access to active products"
ON products FOR SELECT
USING (status = 'active');

-- Create policy for authenticated users (admin) to manage all products
CREATE POLICY "Allow authenticated users full access"
ON products FOR ALL
USING (auth.role() = 'authenticated');

-- Create function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger to auto-update updated_at
DROP TRIGGER IF EXISTS update_products_updated_at ON products;
CREATE TRIGGER update_products_updated_at
    BEFORE UPDATE ON products
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

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
WHERE table_name = 'products'
ORDER BY ordinal_position;

-- =====================================================
-- COMPLETE! Products table ready with all columns:
-- =====================================================
-- ✅ id (UUID)
-- ✅ name (TEXT)
-- ✅ category (TEXT)
-- ✅ description (TEXT)
-- ✅ styling (TEXT)
-- ✅ base_price_zar (NUMERIC)
-- ✅ base_price_usd (NUMERIC)
-- ✅ selling_price_zar (NUMERIC)
-- ✅ selling_price_usd (NUMERIC)
-- ✅ member_price_zar (NUMERIC)
-- ✅ member_price_usd (NUMERIC)
-- ✅ promo_price_zar (NUMERIC)
-- ✅ promo_price_usd (NUMERIC)
-- ✅ cost_price_zar (NUMERIC)
-- ✅ cost_price_usd (NUMERIC)
-- ✅ stock_quantity (INTEGER)
-- ✅ images (TEXT[])
-- ✅ is_featured (BOOLEAN)
-- ✅ is_new_arrival (BOOLEAN)
-- ✅ is_best_seller (BOOLEAN)
-- ✅ is_vault_item (BOOLEAN)
-- ✅ allow_gift_wrap (BOOLEAN)
-- ✅ allow_gift_message (BOOLEAN)
-- ✅ status (TEXT)
-- ✅ url_slug (TEXT)
-- ✅ sku (TEXT)
-- ✅ made_by (TEXT)
-- ✅ materials (TEXT[])
-- ✅ created_at (TIMESTAMPTZ)
-- ✅ updated_at (TIMESTAMPTZ)
-- =====================================================

