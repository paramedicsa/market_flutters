-- Add missing columns for new product features
ALTER TABLE products
ADD COLUMN IF NOT EXISTS chain_options JSONB,
ADD COLUMN IF NOT EXISTS earring_materials JSONB,
ADD COLUMN IF NOT EXISTS ring_sizes JSONB,
ADD COLUMN IF NOT EXISTS leather_option BOOLEAN,
ADD COLUMN IF NOT EXISTS enable_material_customization BOOLEAN,
ADD COLUMN IF NOT EXISTS enable_metal_chain BOOLEAN,
ADD COLUMN IF NOT EXISTS is_promotion_active BOOLEAN,
ADD COLUMN IF NOT EXISTS promotion_start TIMESTAMP,
ADD COLUMN IF NOT EXISTS promotion_end TIMESTAMP,
ADD COLUMN IF NOT EXISTS items_sold INTEGER;
-- You can run this SQL in Supabase SQL editor or psql
