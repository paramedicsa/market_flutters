-- =====================================================
-- ADD MISSING COLUMNS TO PRODUCTS TABLE
-- =====================================================

-- Add cost price columns (ZAR and USD)
ALTER TABLE products
ADD COLUMN IF NOT EXISTS cost_price_zar NUMERIC(10,2) DEFAULT 0,
ADD COLUMN IF NOT EXISTS cost_price_usd NUMERIC(10,2) DEFAULT 0,
ADD COLUMN IF NOT EXISTS made_by TEXT,
ADD COLUMN IF NOT EXISTS materials TEXT[];

-- Add comments to explain the columns
COMMENT ON COLUMN products.cost_price_zar IS 'Total cost per item in South African Rand (including product cost, packaging, shipping, customs)';
COMMENT ON COLUMN products.cost_price_usd IS 'Total cost per item in US Dollars (including product cost, packaging, shipping, customs)';
COMMENT ON COLUMN products.made_by IS 'Artist or manufacturer name who created the product';
COMMENT ON COLUMN products.materials IS 'Array of materials used in the product (e.g., Silver, Gold, Glass, etc.)';

-- =====================================================
-- COMPLETE! Missing columns added to products table:
-- - cost_price_zar
-- - cost_price_usd
-- - made_by
-- - materials
-- =====================================================

-- To verify the columns were added, run:
-- SELECT column_name, data_type, column_default
-- FROM information_schema.columns
-- WHERE table_name = 'products'
-- AND column_name IN ('cost_price_zar', 'cost_price_usd', 'made_by', 'materials');

