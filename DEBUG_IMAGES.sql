-- Check products table structure and sample data to see image format
-- Run this in Supabase SQL Editor to debug image issues

-- 1. Check the images column type and structure
SELECT
    column_name,
    data_type,
    udt_name
FROM information_schema.columns
WHERE table_name = 'products'
AND column_name = 'images';

-- 2. Check if any products have images
SELECT
    id,
    name,
    images,
    jsonb_typeof(images) as images_type,
    jsonb_array_length(images) as images_count
FROM products
LIMIT 5;

-- 3. Show sample product with images if any exist
SELECT
    name,
    images
FROM products
WHERE images IS NOT NULL
AND jsonb_array_length(images) > 0
LIMIT 3;

