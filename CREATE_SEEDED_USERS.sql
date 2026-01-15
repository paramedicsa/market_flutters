-- CREATE_SEEDED_USERS.sql
-- Create seeded users for the reviews
-- Run this BEFORE inserting reviews
-- =====================================================

-- Insert seeded users into auth.users (if using Supabase Auth)
-- Note: This might not work if you don't have admin access to auth.users
-- In that case, you'll need to create users through the Supabase dashboard

-- Alternative: If you have a separate users table, use this instead:
INSERT INTO users (id, email, name, created_at) VALUES
('550e8400-e29b-41d4-a716-446655440001', 'elena.rossi@example.com', 'Elena Rossi', '2023-10-12T12:00:00.000Z'),
('550e8400-e29b-41d4-a716-446655440002', 'liam.smith@example.com', 'Liam Smith', '2023-08-28T12:00:00.000Z'),
('550e8400-e29b-41d4-a716-446655440003', 'anneliese.weber@example.com', 'Anneliese Weber', '2023-11-15T12:00:00.000Z'),
('550e8400-e29b-41d4-a716-446655440004', 'thabo.mbeki@example.com', 'Thabo Mbeki', '2023-06-05T12:00:00.000Z'),
('550e8400-e29b-41d4-a716-446655440005', 'chloe.dubois@example.com', 'Chloé Dubois', '2023-09-20T12:00:00.000Z'),
('550e8400-e29b-41d4-a716-446655440006', 'james.wilson@example.com', 'James Wilson', '2023-07-14T12:00:00.000Z'),
('550e8400-e29b-41d4-a716-446655440007', 'fernanda.santos@example.com', 'Fernanda Santos', '2023-12-02T12:00:00.000Z'),
('550e8400-e29b-41d4-a716-446655440008', 'robert.johnson@example.com', 'Robert Johnson', '2024-01-10T12:00:00.000Z');

-- =====================================================
-- IF YOU CAN'T CREATE USERS:
-- Alternative solution: Make user_id nullable
-- =====================================================

-- ALTER TABLE reviews ALTER COLUMN user_id DROP NOT NULL;

-- Then run the reviews insert script
-- =====================================================
