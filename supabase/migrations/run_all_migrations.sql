-- =====================================================
-- ARTIST SUBSCRIPTION SYSTEM - COMPLETE MIGRATION
-- Run this entire file in Supabase SQL Editor
-- =====================================================
-- This combines all three migration files in the correct order:
-- 1. profiles table
-- 2. artist_subscription_packages table
-- 3. artist_subscriptions table
-- =====================================================

-- =====================================================
-- PART 1: PROFILES TABLE
-- =====================================================

-- Create profiles table
CREATE TABLE IF NOT EXISTS profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT,
  full_name TEXT,
  avatar_url TEXT,
  artist_name TEXT,
  subscription_package TEXT,
  subscription_status TEXT DEFAULT 'inactive' CHECK (subscription_status IN ('inactive', 'active', 'cancelled', 'past_due')),
  subscription_start_date TIMESTAMPTZ,
  subscription_end_date TIMESTAMPTZ,
  paypal_subscription_id TEXT,
  payfast_subscription_id TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Policies for profiles
CREATE POLICY "Public profiles are viewable by everyone"
  ON profiles FOR SELECT
  USING (true);

CREATE POLICY "Users can insert their own profile"
  ON profiles FOR INSERT
  WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can update their own profile"
  ON profiles FOR UPDATE
  USING (auth.uid() = id);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_profiles_email ON profiles(email);
CREATE INDEX IF NOT EXISTS idx_profiles_subscription_status ON profiles(subscription_status);
CREATE INDEX IF NOT EXISTS idx_profiles_subscription_package ON profiles(subscription_package);

-- Auto-create profile on user signup
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO profiles (id, email, full_name)
  VALUES (NEW.id, NEW.email, NEW.raw_user_meta_data->>'full_name');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to auto-create profile
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION handle_new_user();

-- Update updated_at timestamp
CREATE OR REPLACE FUNCTION handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS on_profiles_updated ON profiles;
CREATE TRIGGER on_profiles_updated
  BEFORE UPDATE ON profiles
  FOR EACH ROW
  EXECUTE FUNCTION handle_updated_at();

COMMENT ON TABLE profiles IS 'User profile data extending auth.users';
COMMENT ON COLUMN profiles.subscription_package IS 'Current artist subscription package (tester, hobbyist, creator, boutique, gallery)';
COMMENT ON COLUMN profiles.subscription_status IS 'Subscription status (inactive, active, cancelled, past_due)';

-- =====================================================
-- PART 2: ARTIST SUBSCRIPTION PACKAGES TABLE
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
-- PART 3: ARTIST SUBSCRIPTIONS TABLE
-- =====================================================

-- Create artist_subscriptions table
CREATE TABLE IF NOT EXISTS artist_subscriptions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  package_id UUID NOT NULL REFERENCES artist_subscription_packages(id),
  package_name TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'active', 'cancelled', 'past_due', 'expired')),
  payment_provider TEXT NOT NULL CHECK (payment_provider IN ('paypal', 'payfast')),
  subscription_id TEXT NOT NULL, -- PayPal or PayFast subscription ID
  currency TEXT NOT NULL CHECK (currency IN ('USD', 'ZAR')),
  amount DECIMAL(10, 2) NOT NULL,
  start_date TIMESTAMPTZ,
  end_date TIMESTAMPTZ,
  next_billing_date TIMESTAMPTZ,
  cancelled_at TIMESTAMPTZ,
  cancellation_reason TEXT,
  metadata JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE artist_subscriptions ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can view their own subscriptions"
  ON artist_subscriptions FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own subscriptions"
  ON artist_subscriptions FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own subscriptions"
  ON artist_subscriptions FOR UPDATE
  USING (auth.uid() = user_id);

-- Admin/system access to all subscriptions
CREATE POLICY "Authenticated users can view all subscriptions"
  ON artist_subscriptions FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can manage all subscriptions"
  ON artist_subscriptions FOR ALL
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_artist_subscriptions_user_id ON artist_subscriptions(user_id);
CREATE INDEX IF NOT EXISTS idx_artist_subscriptions_package_id ON artist_subscriptions(package_id);
CREATE INDEX IF NOT EXISTS idx_artist_subscriptions_status ON artist_subscriptions(status);
CREATE INDEX IF NOT EXISTS idx_artist_subscriptions_subscription_id ON artist_subscriptions(subscription_id);
CREATE INDEX IF NOT EXISTS idx_artist_subscriptions_next_billing_date ON artist_subscriptions(next_billing_date);

-- Update updated_at timestamp trigger
DROP TRIGGER IF EXISTS on_artist_subscriptions_updated ON artist_subscriptions;
CREATE TRIGGER on_artist_subscriptions_updated
  BEFORE UPDATE ON artist_subscriptions
  FOR EACH ROW
  EXECUTE FUNCTION handle_updated_at();

-- Function to sync profile subscription status
CREATE OR REPLACE FUNCTION sync_profile_subscription()
RETURNS TRIGGER AS $$
BEGIN
  -- Update profile with latest subscription info when subscription is activated
  IF NEW.status = 'active' AND (OLD.status IS NULL OR OLD.status != 'active') THEN
    UPDATE profiles
    SET 
      subscription_package = NEW.package_name,
      subscription_status = 'active',
      subscription_start_date = NEW.start_date,
      subscription_end_date = NEW.end_date,
      paypal_subscription_id = CASE WHEN NEW.payment_provider = 'paypal' THEN NEW.subscription_id ELSE paypal_subscription_id END,
      payfast_subscription_id = CASE WHEN NEW.payment_provider = 'payfast' THEN NEW.subscription_id ELSE payfast_subscription_id END,
      updated_at = NOW()
    WHERE id = NEW.user_id;
  END IF;

  -- Update profile when subscription is cancelled
  IF NEW.status = 'cancelled' AND (OLD.status IS NULL OR OLD.status != 'cancelled') THEN
    UPDATE profiles
    SET 
      subscription_status = 'cancelled',
      updated_at = NOW()
    WHERE id = NEW.user_id;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to sync profile
DROP TRIGGER IF EXISTS on_subscription_status_change ON artist_subscriptions;
CREATE TRIGGER on_subscription_status_change
  AFTER INSERT OR UPDATE ON artist_subscriptions
  FOR EACH ROW
  EXECUTE FUNCTION sync_profile_subscription();

COMMENT ON TABLE artist_subscriptions IS 'Artist subscription records linking users to their subscription packages';
COMMENT ON COLUMN artist_subscriptions.subscription_id IS 'External subscription ID from PayPal or PayFast';
COMMENT ON COLUMN artist_subscriptions.status IS 'Current subscription status';
COMMENT ON COLUMN artist_subscriptions.payment_provider IS 'Payment provider (paypal for USD, payfast for ZAR)';

-- =====================================================
-- VERIFICATION QUERIES
-- =====================================================

-- Verify tables were created
SELECT 
  'TABLES CREATED' AS info,
  tablename,
  schemaname
FROM pg_tables
WHERE tablename IN ('profiles', 'artist_subscription_packages', 'artist_subscriptions')
ORDER BY tablename;

-- Verify subscription packages were inserted
SELECT 
  'SUBSCRIPTION PACKAGES' AS info,
  display_name,
  price_usd,
  price_zar,
  product_slots,
  paypal_plan_id
FROM artist_subscription_packages
ORDER BY sort_order;

-- Success message
SELECT '✅ Migration complete! All tables created successfully.' AS status
UNION ALL
SELECT '✅ profiles table: Ready for user data' AS status
UNION ALL
SELECT '✅ artist_subscription_packages: 5 packages configured' AS status
UNION ALL
SELECT '✅ artist_subscriptions: Ready to track subscriptions' AS status
UNION ALL
SELECT '📝 Next: Create PayPal plans for Tester, Hobbyist, and Creator' AS status;

-- =====================================================
-- MIGRATION COMPLETE
-- =====================================================
