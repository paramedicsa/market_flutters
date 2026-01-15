-- INSERT REVIEWS_FOR_PRODUCT.sql
-- Insert the provided reviews for the Red Swirl Glass Heart Necklace product
-- Product ID: 0f82b11a-3615-4c5e-8439-32b8568ba6e6
-- Run this in Supabase SQL Editor

-- Insert all 8 reviews for the product
INSERT INTO reviews (product_id, user_id, order_id, rating, review_text, status, reviewer_name, reviewer_country, reviewer_flag, created_at, approved_at) VALUES
-- Elena Rossi, Italy
('0f82b11a-3615-4c5e-8439-32b8568ba6e6', NULL, '550e8400-e29b-41d4-a716-446655440011', 5, 'Che bella! The swirls in the red glass are unique. It''s the perfect size for everyday wear.', 'approved', 'Elena Rossi', 'Italy', '🇮🇹', '2023-10-12T12:00:00.000Z', '2026-01-13T07:03:35.000Z'),

-- Liam Smith, Australia
('0f82b11a-3615-4c5e-8439-32b8568ba6e6', NULL, '550e8400-e29b-41d4-a716-446655440012', 5, 'G''day, bought this for my partner and she loves it. The quality of the chain is surprisingly good.', 'approved', 'Liam Smith', 'Australia', '🇦🇺', '2023-08-28T12:00:00.000Z', '2026-01-13T07:03:35.000Z'),

-- Anneliese Weber, Germany
('0f82b11a-3615-4c5e-8439-32b8568ba6e6', NULL, '550e8400-e29b-41d4-a716-446655440013', 4, 'Sehr schön. The red is so deep and vibrant. It looks exactly like the photo.', 'approved', 'Anneliese Weber', 'Germany', '🇩🇪', '2023-11-15T12:00:00.000Z', '2026-01-13T07:03:35.000Z'),

-- Thabo Mbeki, South Africa
('0f82b11a-3615-4c5e-8439-32b8568ba6e6', NULL, '550e8400-e29b-41d4-a716-446655440014', 5, 'This piece is lekker! Great craftsmanship on the glass heart. My wife was very happy.', 'approved', 'Thabo Mbeki', 'South Africa', '🇿🇦', '2023-06-05T12:00:00.000Z', '2026-01-13T07:03:35.000Z'),

-- Chloé Dubois, France
('0f82b11a-3615-4c5e-8439-32b8568ba6e6', NULL, '550e8400-e29b-41d4-a716-446655440015', 4, 'Magnifique pendant. The swirl pattern is very artistic. It''s a bit heavier than I expected but very lovely.', 'approved', 'Chloé Dubois', 'France', '🇫🇷', '2023-09-20T12:00:00.000Z', '2026-01-13T07:03:35.000Z'),

-- James Wilson, UK
('0f82b11a-3615-4c5e-8439-32b8568ba6e6', NULL, '550e8400-e29b-41d4-a716-446655440016', 5, 'Brilliant little gift. The packaging was secure and it arrived quickly. The red really pops.', 'approved', 'James Wilson', 'UK', '🇬🇧', '2023-07-14T12:00:00.000Z', '2026-01-13T07:03:35.000Z'),

-- Fernanda Santos, Brazil
('0f82b11a-3615-4c5e-8439-32b8568ba6e6', NULL, '550e8400-e29b-41d4-a716-446655440017', 5, 'O coração é maravilhoso. I love the way the light hits the glass. Very satisfied.', 'approved', 'Fernanda Santos', 'Brazil', '🇧🇷', '2023-12-02T12:00:00.000Z', '2026-01-13T07:03:35.000Z'),

-- Robert Johnson, USA
('0f82b11a-3615-4c5e-8439-32b8568ba6e6', NULL, '550e8400-e29b-41d4-a716-446655440018', 5, 'Fantastic quality for the price. The heart has a nice thickness to it and the color is rich.', 'approved', 'Robert Johnson', 'USA', '🇺🇸', '2024-01-10T12:00:00.000Z', '2026-01-13T07:03:35.000Z');

-- =====================================================
-- VERIFICATION QUERY
-- Run this after inserting to verify:
-- =====================================================

SELECT
    r.id,
    r.reviewer_name,
    r.reviewer_country,
    r.rating,
    r.review_text,
    r.created_at,
    p.name as product_name
FROM reviews r
JOIN products p ON r.product_id = p.id
WHERE r.product_id = '0f82b11a-3615-4c5e-8439-32b8568ba6e6'
ORDER BY r.created_at DESC;

-- Expected result: 8 rows with all the reviews above
-- =====================================================
