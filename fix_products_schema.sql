-- =====================================================
-- ADD ALL MISSING COLUMNS TO PRODUCTS TABLE
-- Run this in Supabase SQL Editor
-- =====================================================

-- Add all missing columns in one statement
ALTER TABLE products
ADD COLUMN IF NOT EXISTS cost_price_zar NUMERIC(10,2) DEFAULT 0,
ADD COLUMN IF NOT EXISTS cost_price_usd NUMERIC(10,2) DEFAULT 0,
ADD COLUMN IF NOT EXISTS made_by TEXT,
ADD COLUMN IF NOT EXISTS materials TEXT[],
ADD COLUMN IF NOT EXISTS styling TEXT,
ADD COLUMN IF NOT EXISTS selling_price_usd NUMERIC(10,2),
ADD COLUMN IF NOT EXISTS base_price_usd NUMERIC(10,2),
ADD COLUMN IF NOT EXISTS member_price_usd NUMERIC(10,2),
ADD COLUMN IF NOT EXISTS promo_price_usd NUMERIC(10,2);

-- Add comments to explain the columns
COMMENT ON COLUMN products.cost_price_zar IS 'Total cost per item in South African Rand (including product cost, packaging, shipping, customs)';
COMMENT ON COLUMN products.cost_price_usd IS 'Total cost per item in US Dollars (including product cost, packaging, shipping, customs)';
COMMENT ON COLUMN products.made_by IS 'Artist or manufacturer name who created the product';
COMMENT ON COLUMN products.materials IS 'Array of materials used in the product (e.g., Silver, Gold, Glass, etc.)';
COMMENT ON COLUMN products.styling IS 'Styling tips and suggestions for wearing/using the product';
COMMENT ON COLUMN products.selling_price_usd IS 'Selling price in US Dollars';
COMMENT ON COLUMN products.base_price_usd IS 'Base/RRP price in US Dollars';
COMMENT ON COLUMN products.member_price_usd IS 'Membership price in US Dollars';
COMMENT ON COLUMN products.promo_price_usd IS 'Promotional price in US Dollars';

-- =====================================================
-- COMPLETE! Missing columns added to products table:
-- - cost_price_zar
-- - cost_price_usd
-- - made_by
-- - materials
-- - styling
-- - selling_price_usd
-- - base_price_usd
-- - member_price_usd
-- - promo_price_usd
-- =====================================================

-- To verify the columns were added, run:
SELECT column_name, data_type, column_default
FROM information_schema.columns
WHERE table_name = 'products'
AND column_name IN (
  'cost_price_zar',
  'cost_price_usd',
  'made_by',
  'materials',
  'styling',
  'selling_price_usd',
  'base_price_usd',
  'member_price_usd',
  'promo_price_usd'
)
ORDER BY column_name;

