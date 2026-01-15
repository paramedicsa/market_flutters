-- ALTERNATIVE: If user_id is UUID type, use this instead
-- Generate proper UUIDs for seeded users

INSERT INTO reviews (product_id, user_id, rating, review_text, status, reviewer_name, reviewer_country, reviewer_flag, created_at, approved_at) VALUES
-- Elena Rossi, Italy
('0f82b11a-3615-4c5e-8439-32b8568ba6e6', '550e8400-e29b-41d4-a716-446655440001', 5, 'Che bella! The swirls in the red glass are unique. It''s the perfect size for everyday wear.', 'approved', 'Elena Rossi', 'Italy', '🇮🇹', '2023-10-12T12:00:00.000Z', '2026-01-13T07:03:35.000Z'),

-- Liam Smith, Australia
('0f82b11a-3615-4c5e-8439-32b8568ba6e6', '550e8400-e29b-41d4-a716-446655440002', 5, 'G''day, bought this for my partner and she loves it. The quality of the chain is surprisingly good.', 'approved', 'Liam Smith', 'Australia', '🇦🇺', '2023-08-28T12:00:00.000Z', '2026-01-13T07:03:35.000Z'),

-- Anneliese Weber, Germany
('0f82b11a-3615-4c5e-8439-32b8568ba6e6', '550e8400-e29b-41d4-a716-446655440003', 4, 'Sehr schön. The red is so deep and vibrant. It looks exactly like the photo.', 'approved', 'Anneliese Weber', 'Germany', '🇩🇪', '2023-11-15T12:00:00.000Z', '2026-01-13T07:03:35.000Z'),

-- Thabo Mbeki, South Africa
('0f82b11a-3615-4c5e-8439-32b8568ba6e6', '550e8400-e29b-41d4-a716-446655440004', 5, 'This piece is lekker! Great craftsmanship on the glass heart. My wife was very happy.', 'approved', 'Thabo Mbeki', 'South Africa', '🇿🇦', '2023-06-05T12:00:00.000Z', '2026-01-13T07:03:35.000Z'),

-- Chloé Dubois, France
('0f82b11a-3615-4c5e-8439-32b8568ba6e6', '550e8400-e29b-41d4-a716-446655440005', 4, 'Magnifique pendant. The swirl pattern is very artistic. It''s a bit heavier than I expected but very lovely.', 'approved', 'Chloé Dubois', 'France', '🇫🇷', '2023-09-20T12:00:00.000Z', '2026-01-13T07:03:35.000Z'),

-- James Wilson, UK
('0f82b11a-3615-4c5e-8439-32b8568ba6e6', '550e8400-e29b-41d4-a716-446655440006', 5, 'Brilliant little gift. The packaging was secure and it arrived quickly. The red really pops.', 'approved', 'James Wilson', 'UK', '🇬🇧', '2023-07-14T12:00:00.000Z', '2026-01-13T07:03:35.000Z'),

-- Fernanda Santos, Brazil
('0f82b11a-3615-4c5e-8439-32b8568ba6e6', '550e8400-e29b-41d4-a716-446655440007', 5, 'O coração é maravilhoso. I love the way the light hits the glass. Very satisfied.', 'approved', 'Fernanda Santos', 'Brazil', '🇧🇷', '2023-12-02T12:00:00.000Z', '2026-01-13T07:03:35.000Z'),

-- Robert Johnson, USA
('0f82b11a-3615-4c5e-8439-32b8568ba6e6', '550e8400-e29b-41d4-a716-446655440008', 5, 'Fantastic quality for the price. The heart has a nice thickness to it and the color is rich.', 'approved', 'Robert Johnson', 'USA', '🇺🇸', '2024-01-10T12:00:00.000Z', '2026-01-13T07:03:35.000Z');
