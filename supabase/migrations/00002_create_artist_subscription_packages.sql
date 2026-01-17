-- =====================================================
-- ARTIST SUBSCRIPTION PACKAGES TABLE
-- Defines the available subscription packages for artists
-- =====================================================

-- Create artist_subscription_packages table
CREATE TABLE IF NOT EXISTS artist_subscription_packages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  package_name TEXT NOT NULL UNIQUE,
  display_name TEXT NOT NULL,
  description TEXT NOT NULL,
  price_zar DECIMAL(10, 2) NOT NULL,
  price_usd DECIMAL(10, 2) NOT NULL,
  product_slots INTEGER NOT NULL,
  features JSONB NOT NULL DEFAULT '[]'::jsonb,
  is_locked BOOLEAN DEFAULT false,
  lock_reason TEXT,
  border_color TEXT,
  paypal_plan_id TEXT,
  payfast_plan_id TEXT,
  sort_order INTEGER NOT NULL,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE artist_subscription_packages ENABLE ROW LEVEL SECURITY;

-- Policies - public read access for all packages
CREATE POLICY "Public read access to subscription packages"
  ON artist_subscription_packages FOR SELECT
  USING (true);

-- Only admins can modify packages (requires authenticated user)
CREATE POLICY "Authenticated users can manage subscription packages"
  ON artist_subscription_packages FOR ALL
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_artist_subscription_packages_package_name ON artist_subscription_packages(package_name);
CREATE INDEX IF NOT EXISTS idx_artist_subscription_packages_sort_order ON artist_subscription_packages(sort_order);
CREATE INDEX IF NOT EXISTS idx_artist_subscription_packages_is_active ON artist_subscription_packages(is_active);

-- Update updated_at timestamp trigger
DROP TRIGGER IF EXISTS on_artist_subscription_packages_updated ON artist_subscription_packages;
CREATE TRIGGER on_artist_subscription_packages_updated
  BEFORE UPDATE ON artist_subscription_packages
  FOR EACH ROW
  EXECUTE FUNCTION handle_updated_at();

-- Insert the subscription packages with PayPal plan IDs
INSERT INTO artist_subscription_packages (
  package_name, 
  display_name, 
  description, 
  price_zar, 
  price_usd,
  product_slots, 
  features, 
  is_locked, 
  lock_reason, 
  border_color,
  paypal_plan_id,
  sort_order
) VALUES
-- Tester Package
(
  'tester', 
  'Tester', 
  'Perfect for trying out the platform with minimal commitment', 
  15.00, 
  2.00,
  5, 
  '["5 product slots", "Basic analytics", "Email support", "Mobile app access"]'::jsonb,
  false,
  NULL,
  'blue',
  NULL, -- PayPal plan ID to be added later
  1
),
-- Hobbyist Package
(
  'hobbyist', 
  'Hobbyist', 
  'Great for part-time artists looking to grow their business', 
  30.00, 
  4.00,
  15, 
  '["15 product slots", "Advanced analytics", "Priority email support", "Mobile app access", "Social media tools"]'::jsonb,
  false,
  NULL,
  'purple',
  NULL, -- PayPal plan ID to be added later
  2
),
-- Creator Package
(
  'creator', 
  'Creator', 
  'Ideal for professional artists with an established catalog', 
  75.00, 
  10.00,
  30, 
  '["30 product slots", "Full analytics suite", "24/7 priority support", "Mobile app access", "Social media tools", "Marketing assistance", "Featured artist badge"]'::jsonb,
  false,
  NULL,
  'orange',
  NULL, -- PayPal plan ID to be added later
  3
),
-- Boutique Package
(
  'boutique', 
  'Boutique', 
  'Premium package for established artists with high sales volume', 
  189.00, 
  25.00,
  50, 
  '["50 product slots", "Full analytics suite", "24/7 VIP support", "Mobile app access", "Social media tools", "Marketing assistance", "Featured artist badge", "Promotional campaigns", "Custom storefront"]'::jsonb,
  true,
  'At least 150+ products sold',
  'pink',
  'P-9SN47701RA820541PNFVN27I', -- PayPal plan ID for Boutique
  4
),
-- Gallery Package
(
  'gallery', 
  'Gallery', 
  'Elite package for top-tier artists and galleries', 
  399.00, 
  32.00,
  150, 
  '["150 product slots", "Full analytics suite", "Dedicated account manager", "Mobile app access", "Social media tools", "Marketing assistance", "Featured artist badge", "Promotional campaigns", "Custom storefront", "Priority placement", "Exclusive events"]'::jsonb,
  true,
  'Invitation Only',
  'green',
  'P-966999960M894463YNFVNYNQ', -- PayPal plan ID for Gallery
  5
)
ON CONFLICT (package_name) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  price_zar = EXCLUDED.price_zar,
  price_usd = EXCLUDED.price_usd,
  product_slots = EXCLUDED.product_slots,
  features = EXCLUDED.features,
  is_locked = EXCLUDED.is_locked,
  lock_reason = EXCLUDED.lock_reason,
  border_color = EXCLUDED.border_color,
  paypal_plan_id = EXCLUDED.paypal_plan_id,
  sort_order = EXCLUDED.sort_order,
  updated_at = NOW();

COMMENT ON TABLE artist_subscription_packages IS 'Available subscription packages for artists with pricing and features';
COMMENT ON COLUMN artist_subscription_packages.package_name IS 'Unique identifier for the package (lowercase, used in code)';
COMMENT ON COLUMN artist_subscription_packages.display_name IS 'Human-readable package name';
COMMENT ON COLUMN artist_subscription_packages.price_zar IS 'Price in South African Rand (ZAR)';
COMMENT ON COLUMN artist_subscription_packages.price_usd IS 'Price in US Dollars (USD)';
COMMENT ON COLUMN artist_subscription_packages.product_slots IS 'Number of products the artist can list';
COMMENT ON COLUMN artist_subscription_packages.features IS 'JSON array of package features';
COMMENT ON COLUMN artist_subscription_packages.is_locked IS 'Whether package requires special criteria to unlock';
COMMENT ON COLUMN artist_subscription_packages.lock_reason IS 'Message explaining unlock requirements';
COMMENT ON COLUMN artist_subscription_packages.paypal_plan_id IS 'PayPal subscription plan ID for USD payments';
COMMENT ON COLUMN artist_subscription_packages.payfast_plan_id IS 'PayFast subscription plan ID for ZAR payments';

-- =====================================================
-- ARTIST SUBSCRIPTION PACKAGES TABLE COMPLETE
-- =====================================================
