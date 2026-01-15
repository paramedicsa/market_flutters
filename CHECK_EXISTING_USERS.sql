-- CHECK EXISTING USERS
-- See what users exist in the database
-- Run this in Supabase SQL Editor

SELECT id, email, created_at
FROM auth.users
ORDER BY created_at DESC
LIMIT 10;

-- Or if users table is separate:
SELECT id, email, created_at
FROM users
ORDER BY created_at DESC
LIMIT 10;
