-- ================================================
-- SUPABASE DATABASE SETUP
-- E-commerce Admin Panel - Products Table
-- ================================================

-- Create products table
CREATE TABLE IF NOT EXISTS products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    category TEXT NOT NULL,
    description TEXT,
    base_price_zar DECIMAL(10, 2) NOT NULL,
    base_price_usd DECIMAL(10, 2) NOT NULL,
    member_price_zar DECIMAL(10, 2),
    member_price_usd DECIMAL(10, 2),
    promo_price_zar DECIMAL(10, 2),
    promo_price_usd DECIMAL(10, 2),
    stock_quantity INTEGER DEFAULT 0,
    images TEXT[] DEFAULT '{}',
    is_featured BOOLEAN DEFAULT false,
    is_new_arrival BOOLEAN DEFAULT false,
    is_best_seller BOOLEAN DEFAULT false,
    is_vault_item BOOLEAN DEFAULT false,
    allow_gift_wrap BOOLEAN DEFAULT false,
    allow_gift_message BOOLEAN DEFAULT false,
    status TEXT DEFAULT 'draft',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create index for faster queries
CREATE INDEX IF NOT EXISTS idx_products_category ON products(category);
CREATE INDEX IF NOT EXISTS idx_products_status ON products(status);
CREATE INDEX IF NOT EXISTS idx_products_created_at ON products(created_at DESC);

-- Create storage bucket for product images
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
    'product-images',
    'product-images',
    true,
    5242880,
    ARRAY['image/jpeg', 'image/png', 'image/webp']
)
ON CONFLICT (id) DO NOTHING;

-- Enable Row Level Security
ALTER TABLE products ENABLE ROW LEVEL SECURITY;

-- Public read access (everyone can view products)
CREATE POLICY "Public products are viewable by everyone"
ON products FOR SELECT
USING (true);

-- Authenticated users can insert products
CREATE POLICY "Authenticated users can insert products"
ON products FOR INSERT
TO authenticated
WITH CHECK (true);

-- Authenticated users can update products
CREATE POLICY "Authenticated users can update products"
ON products FOR UPDATE
TO authenticated
USING (true);

-- Authenticated users can delete products
CREATE POLICY "Authenticated users can delete products"
ON products FOR DELETE
TO authenticated
USING (true);

-- Storage policies for product-images bucket
CREATE POLICY "Public Access for Images"
ON storage.objects FOR SELECT
USING (bucket_id = 'product-images');

CREATE POLICY "Authenticated users can upload images"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'product-images');

CREATE POLICY "Authenticated users can update images"
ON storage.objects FOR UPDATE
TO authenticated
USING (bucket_id = 'product-images');

CREATE POLICY "Authenticated users can delete images"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = 'product-images');

-- Sample data (optional)
INSERT INTO products (name, category, description, base_price_zar, base_price_usd, stock_quantity, status, is_featured)
VALUES
    ('Rose Gold Ring', 'Rings', 'Beautiful rose gold ring with diamond accent', 2500.00, 138.89, 15, 'active', true),
    ('Silver Hoop Earrings', 'Earrings', 'Classic silver hoop earrings', 850.00, 47.22, 25, 'active', false),
    ('Gold Chain Necklace', 'Chains', '18K gold plated chain necklace', 1200.00, 66.67, 10, 'active', true)
ON CONFLICT DO NOTHING;

-- ================================================
-- SETUP COMPLETE
-- ================================================

