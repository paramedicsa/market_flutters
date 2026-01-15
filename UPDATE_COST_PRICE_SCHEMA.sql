-- Update cost price schema to remove USD equivalent and add currency support
-- This script updates the products table to use a single cost_price with cost_currency

-- First, add the new columns
ALTER TABLE products ADD COLUMN IF NOT EXISTS cost_price NUMERIC(10,2);
ALTER TABLE products ADD COLUMN IF NOT EXISTS cost_currency TEXT DEFAULT 'ZAR';

-- Migrate existing data: if base_price_zar has value, set cost_price to it and currency to 'ZAR'
UPDATE products SET cost_price = base_price_zar, cost_currency = 'ZAR' WHERE base_price_zar IS NOT NULL AND cost_price IS NULL;

-- For products where base_price_usd is set but base_price_zar is not, set cost_price to base_price_usd and currency to 'USD'
UPDATE products SET cost_price = base_price_usd, cost_currency = 'USD' WHERE base_price_usd IS NOT NULL AND base_price_zar IS NULL AND cost_price IS NULL;

-- Drop the old columns (if they exist - these might be cost_price_zar/cost_price_usd if they were added before)
ALTER TABLE products DROP COLUMN IF EXISTS cost_price_zar;
ALTER TABLE products DROP COLUMN IF EXISTS cost_price_usd;

-- Add comments
COMMENT ON COLUMN products.cost_price IS 'Total cost per item in the specified currency (including product cost, packaging, shipping, customs)';
COMMENT ON COLUMN products.cost_currency IS 'Currency of the cost_price (ZAR or USD)';

-- Update RLS policies if needed (assuming public access for development)
-- No changes needed for RLS as columns are just renamed/migrated
