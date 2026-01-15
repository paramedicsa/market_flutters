-- Comprehensive check of products table structure
-- Run this in Supabase SQL Editor to verify all columns exist

-- 1. Show ALL columns in products table with their types and defaults
SELECT
    column_name,
    data_type,
    udt_name,
    is_nullable,
    column_default,
    character_maximum_length
FROM information_schema.columns
WHERE table_schema = 'public'
AND table_name = 'products'
ORDER BY ordinal_position;

-- 2. Check for specific columns that should exist
SELECT
    CASE
        WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'products' AND column_name = 'id')
        THEN '✅ id exists'
        ELSE '❌ id missing'
    END as id_status,
    CASE
        WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'products' AND column_name = 'name')
        THEN '✅ name exists'
        ELSE '❌ name missing'
    END as name_status,
    CASE
        WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'products' AND column_name = 'category')
        THEN '✅ category exists'
        ELSE '❌ category missing'
    END as category_status,
    CASE
        WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'products' AND column_name = 'product_type')
        THEN '✅ product_type exists'
        ELSE '❌ product_type missing'
    END as product_type_status,
    CASE
        WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'products' AND column_name = 'description')
        THEN '✅ description exists'
        ELSE '❌ description missing'
    END as description_status,
    CASE
        WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'products' AND column_name = 'styling')
        THEN '✅ styling exists'
        ELSE '❌ styling missing'
    END as styling_status,
    CASE
        WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'products' AND column_name = 'base_price_zar')
        THEN '✅ base_price_zar exists'
        ELSE '❌ base_price_zar missing'
    END as base_price_zar_status,
    CASE
        WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'products' AND column_name = 'base_price_usd')
        THEN '✅ base_price_usd exists'
        ELSE '❌ base_price_usd missing'
    END as base_price_usd_status,
    CASE
        WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'products' AND column_name = 'selling_price_zar')
        THEN '✅ selling_price_zar exists'
        ELSE '❌ selling_price_zar missing'
    END as selling_price_zar_status,
    CASE
        WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'products' AND column_name = 'selling_price_usd')
        THEN '✅ selling_price_usd exists'
        ELSE '❌ selling_price_usd missing'
    END as selling_price_usd_status;

-- 3. Show a sample product with all its fields
SELECT *
FROM products
LIMIT 1;

-- 4. Count total products
SELECT
    COUNT(*) as total_products,
    COUNT(CASE WHEN images IS NOT NULL AND array_length(images, 1) > 0 THEN 1 END) as products_with_images,
    COUNT(CASE WHEN status = 'active' THEN 1 END) as active_products,
    COUNT(CASE WHEN status = 'draft' THEN 1 END) as draft_products
FROM products;

-- 5. List all columns that are missing from expected schema
WITH expected_columns AS (
    SELECT unnest(ARRAY[
        'id', 'name', 'category', 'product_type', 'description', 'styling',
        'base_price_zar', 'base_price_usd', 'selling_price_zar', 'selling_price_usd',
        'member_price_zar', 'member_price_usd', 'promo_price_zar', 'promo_price_usd',
        'cost_price_zar', 'cost_price_usd', 'stock_quantity', 'images',
        'is_featured', 'is_new_arrival', 'is_best_seller', 'is_vault_item',
        'allow_gift_wrap', 'allow_gift_message', 'status', 'url_slug', 'sku',
        'made_by', 'materials', 'colors', 'tags', 'created_at', 'updated_at'
    ]) AS column_name
),
actual_columns AS (
    SELECT column_name
    FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'products'
)
SELECT
    ec.column_name as missing_column
FROM expected_columns ec
LEFT JOIN actual_columns ac ON ec.column_name = ac.column_name
WHERE ac.column_name IS NULL;

