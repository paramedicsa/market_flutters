-- CHECK_REVIEWS_TABLE_SCHEMA.sql
-- Check the actual schema of the reviews table
-- Run this in Supabase SQL Editor

SELECT
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'reviews'
ORDER BY ordinal_position;

-- This will show us what columns exist and which are required
