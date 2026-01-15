-- Add product_type column to products table
-- This separates the actual product type (ring, earrings, etc.) from the collection grouping

ALTER TABLE products ADD COLUMN IF NOT EXISTS product_type TEXT;

-- Update existing products to have a default product type based on their category
-- This is a one-time migration for existing data
UPDATE products SET product_type = 'ring' WHERE category ILIKE '%ring%';
UPDATE products SET product_type = 'earrings' WHERE category ILIKE '%earring%';
UPDATE products SET product_type = 'necklace' WHERE category ILIKE '%necklace%';
UPDATE products SET product_type = 'bracelet' WHERE category ILIKE '%bracelet%';
UPDATE products SET product_type = 'pendant' WHERE category ILIKE '%pendant%';
UPDATE products SET product_type = 'brooch' WHERE category ILIKE '%brooch%';
UPDATE products SET product_type = 'cufflinks' WHERE category ILIKE '%cufflink%';

-- Set default product type for any remaining products
UPDATE products SET product_type = 'other' WHERE product_type IS NULL;

-- Make product_type NOT NULL after migration
ALTER TABLE products ALTER COLUMN product_type SET NOT NULL;

-- Add comment to clarify the difference between category and product_type
COMMENT ON COLUMN products.category IS 'Collection grouping (e.g., "Purple Collection", "Summer Collection")';
COMMENT ON COLUMN products.product_type IS 'Actual product type (ring, earrings, necklace, etc.)';

-- Create index for better query performance
CREATE INDEX IF NOT EXISTS idx_products_product_type ON products(product_type);
