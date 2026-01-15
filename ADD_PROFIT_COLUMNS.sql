-- Add profit columns to products table
-- Run this in Supabase SQL Editor

-- Add profit columns if they don't exist
ALTER TABLE products ADD COLUMN IF NOT EXISTS profit_zar NUMERIC(10, 2);
ALTER TABLE products ADD COLUMN IF NOT EXISTS profit_usd NUMERIC(10, 2);
ALTER TABLE products ADD COLUMN IF NOT EXISTS member_profit_zar NUMERIC(10, 2);
ALTER TABLE products ADD COLUMN IF NOT EXISTS member_profit_usd NUMERIC(10, 2);

-- Add comments to explain what these columns store
COMMENT ON COLUMN products.profit_zar IS 'Profit when sold at selling price in ZAR (Selling Price - Cost Price)';
COMMENT ON COLUMN products.profit_usd IS 'Profit when sold at USD price, converted to ZAR ((USD Price × R18) - Cost Price)';
COMMENT ON COLUMN products.member_profit_zar IS 'Profit when sold at member price in ZAR (Member Price - Cost Price)';
COMMENT ON COLUMN products.member_profit_usd IS 'Profit when sold at USD member price, converted to ZAR ((USD Member Price × R18) - Cost Price)';

-- Verify columns were added
SELECT
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_schema = 'public'
AND table_name = 'products'
AND column_name IN ('profit_zar', 'profit_usd', 'member_profit_zar', 'member_profit_usd')
ORDER BY column_name;

-- Success message
SELECT '✅ Profit columns added successfully!' as status;
SELECT 'Products table now has profit tracking' as details;

