-- Gift Vault Quest Database Setup
-- This script creates all necessary tables and indexes for the Gift Vault feature

-- ============================================================================
-- PRODUCTS TABLE UPDATES
-- Add funnel_tier column if it doesn't exist
-- ============================================================================

DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.columns 
    WHERE table_name = 'products' AND column_name = 'funnel_tier'
  ) THEN
    ALTER TABLE products ADD COLUMN funnel_tier TEXT;
    COMMENT ON COLUMN products.funnel_tier IS 'Gift Vault tier: starter, premium, or bonus';
  END IF;
END $$;

-- Add index for efficient tier filtering
CREATE INDEX IF NOT EXISTS idx_products_funnel_tier 
ON products(funnel_tier) 
WHERE funnel_tier IS NOT NULL;

-- ============================================================================
-- USER WALLET TABLE
-- Tracks user bonus credits and referral bonuses
-- ============================================================================

CREATE TABLE IF NOT EXISTS user_wallet (
  user_id UUID PRIMARY KEY,
  bonus_gift_credit DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
  referral_bonus DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
  currency TEXT NOT NULL DEFAULT 'ZAR',
  last_updated TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add comments
COMMENT ON TABLE user_wallet IS 'Stores user bonus credits from sharing and referrals';
COMMENT ON COLUMN user_wallet.bonus_gift_credit IS 'Credits earned from sharing (R20/$1 per share)';
COMMENT ON COLUMN user_wallet.referral_bonus IS 'Bonus earned when referred friend makes purchase (R100/$20)';

-- Create index for efficient lookups
CREATE INDEX IF NOT EXISTS idx_user_wallet_user_id ON user_wallet(user_id);

-- ============================================================================
-- GIFT VAULT ORDERS TABLE
-- Tracks all orders from the Gift Vault Quest
-- ============================================================================

CREATE TABLE IF NOT EXISTS gift_vault_orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  group_id TEXT NOT NULL,
  product_ids TEXT[] NOT NULL,
  total_amount DECIMAL(10, 2) NOT NULL,
  currency TEXT NOT NULL DEFAULT 'ZAR',
  tier TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  referrer_id UUID,
  CONSTRAINT valid_tier CHECK (tier IN ('starter', 'premium', 'bonus')),
  CONSTRAINT valid_status CHECK (status IN ('pending', 'processing', 'completed', 'cancelled')),
  CONSTRAINT valid_currency CHECK (currency IN ('ZAR', 'USD'))
);

-- Add comments
COMMENT ON TABLE gift_vault_orders IS 'Orders placed through Gift Vault Quest feature';
COMMENT ON COLUMN gift_vault_orders.group_id IS 'User email for admin order grouping';
COMMENT ON COLUMN gift_vault_orders.tier IS 'Funnel tier: starter, premium, or bonus';
COMMENT ON COLUMN gift_vault_orders.referrer_id IS 'UUID of user who referred this customer';

-- Create indexes for efficient querying
CREATE INDEX IF NOT EXISTS idx_gift_vault_orders_user_id ON gift_vault_orders(user_id);
CREATE INDEX IF NOT EXISTS idx_gift_vault_orders_group_id ON gift_vault_orders(group_id);
CREATE INDEX IF NOT EXISTS idx_gift_vault_orders_tier ON gift_vault_orders(tier);
CREATE INDEX IF NOT EXISTS idx_gift_vault_orders_created_at ON gift_vault_orders(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_gift_vault_orders_referrer_id ON gift_vault_orders(referrer_id) WHERE referrer_id IS NOT NULL;

-- ============================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- Adjust these based on your authentication setup
-- ============================================================================

-- Enable RLS on user_wallet
ALTER TABLE user_wallet ENABLE ROW LEVEL SECURITY;

-- Users can view and update their own wallet
CREATE POLICY user_wallet_own_data ON user_wallet
  FOR ALL
  USING (auth.uid() = user_id);

-- Admins can view all wallets
CREATE POLICY user_wallet_admin_access ON user_wallet
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid()
      AND profiles.role = 'admin'
    )
  );

-- Enable RLS on gift_vault_orders
ALTER TABLE gift_vault_orders ENABLE ROW LEVEL SECURITY;

-- Users can view their own orders
CREATE POLICY gift_vault_orders_own_data ON gift_vault_orders
  FOR SELECT
  USING (auth.uid() = user_id);

-- Users can insert their own orders
CREATE POLICY gift_vault_orders_insert ON gift_vault_orders
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Admins can view all orders
CREATE POLICY gift_vault_orders_admin_access ON gift_vault_orders
  FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid()
      AND profiles.role = 'admin'
    )
  );

-- ============================================================================
-- TRIGGERS
-- Automatically update timestamps
-- ============================================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger for gift_vault_orders
DROP TRIGGER IF EXISTS update_gift_vault_orders_updated_at ON gift_vault_orders;
CREATE TRIGGER update_gift_vault_orders_updated_at
  BEFORE UPDATE ON gift_vault_orders
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Trigger for user_wallet
DROP TRIGGER IF EXISTS update_user_wallet_updated_at ON user_wallet;
CREATE TRIGGER update_user_wallet_updated_at
  BEFORE UPDATE ON user_wallet
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- SAMPLE DATA (Optional - for testing)
-- ============================================================================

-- Insert sample products with funnel tiers
INSERT INTO products (id, name, description, price, funnel_tier, currency, is_available)
VALUES 
  (gen_random_uuid(), 'Vintage Necklace', 'Beautiful vintage gold necklace', 150.00, 'starter', 'ZAR', true),
  (gen_random_uuid(), 'Classic Brooch', 'Elegant vintage brooch', 200.00, 'starter', 'ZAR', true),
  (gen_random_uuid(), 'Premium Earrings', 'Stunning diamond earrings', 500.00, 'premium', 'ZAR', true),
  (gen_random_uuid(), 'Premium Watch', 'Luxury vintage watch', 800.00, 'premium', 'ZAR', true),
  (gen_random_uuid(), 'Bonus Ring Set', 'Exclusive ring collection', 300.00, 'bonus', 'ZAR', true)
ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- VERIFICATION QUERIES
-- Run these to verify setup
-- ============================================================================

-- Check funnel_tier column exists
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'products' AND column_name = 'funnel_tier';

-- Check user_wallet table structure
SELECT column_name, data_type, column_default
FROM information_schema.columns 
WHERE table_name = 'user_wallet'
ORDER BY ordinal_position;

-- Check gift_vault_orders table structure
SELECT column_name, data_type, column_default
FROM information_schema.columns 
WHERE table_name = 'gift_vault_orders'
ORDER BY ordinal_position;

-- Check indexes
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename IN ('user_wallet', 'gift_vault_orders', 'products')
AND indexname LIKE '%vault%' OR indexname LIKE '%funnel%'
ORDER BY tablename, indexname;

-- Check RLS policies
SELECT tablename, policyname, permissive, roles, cmd, qual
FROM pg_policies
WHERE tablename IN ('user_wallet', 'gift_vault_orders')
ORDER BY tablename, policyname;

-- ============================================================================
-- CLEANUP (Use with caution - for development only)
-- ============================================================================

-- Uncomment to drop all Gift Vault tables
-- DROP TABLE IF EXISTS gift_vault_orders CASCADE;
-- DROP TABLE IF EXISTS user_wallet CASCADE;
-- DROP FUNCTION IF EXISTS update_updated_at_column CASCADE;
