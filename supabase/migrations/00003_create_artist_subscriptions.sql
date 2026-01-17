-- =====================================================
-- ARTIST SUBSCRIPTIONS TABLE
-- Tracks individual artist subscription records
-- Links profiles to their subscription packages
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
-- ARTIST SUBSCRIPTIONS TABLE COMPLETE
-- =====================================================
