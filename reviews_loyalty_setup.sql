-- =====================================================
-- REVIEWS & LOYALTY SYSTEM DATABASE SCHEMA
-- Run this SQL in your Supabase SQL Editor
-- =====================================================

-- Reviews table
CREATE TABLE IF NOT EXISTS reviews (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  product_id UUID NOT NULL,
  user_id UUID REFERENCES auth.users(id),
  order_id UUID NOT NULL,
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  review_text TEXT CHECK (LENGTH(review_text) <= 300),
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
  reviewer_name TEXT,
  reviewer_country TEXT,
  reviewer_flag TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  approved_at TIMESTAMP WITH TIME ZONE,
  approved_by UUID REFERENCES auth.users(id),
  UNIQUE(order_id, product_id)
);

-- Loyalty Points table
CREATE TABLE IF NOT EXISTS loyalty_points (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id),
  points INTEGER DEFAULT 0,
  lifetime_points INTEGER DEFAULT 0,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id)
);

-- Points Transactions table
CREATE TABLE IF NOT EXISTS points_transactions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id),
  points INTEGER NOT NULL,
  transaction_type TEXT NOT NULL CHECK (transaction_type IN ('review', 'purchase', 'redeem', 'manual_adjustment')),
  reference_id UUID,
  description TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Review Notifications Queue
CREATE TABLE IF NOT EXISTS review_notifications (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  order_id UUID NOT NULL,
  user_id UUID NOT NULL REFERENCES auth.users(id),
  product_id UUID NOT NULL,
  scheduled_for TIMESTAMP WITH TIME ZONE NOT NULL,
  sent BOOLEAN DEFAULT false,
  sent_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE loyalty_points ENABLE ROW LEVEL SECURITY;
ALTER TABLE points_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE review_notifications ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- POLICIES FOR PUBLIC ACCESS (Change to authenticated if needed)
-- =====================================================

-- Reviews policies
CREATE POLICY "Public read approved reviews" ON reviews FOR SELECT USING (status = 'approved');
CREATE POLICY "Public insert reviews" ON reviews FOR INSERT WITH CHECK (true);
CREATE POLICY "Public update reviews" ON reviews FOR UPDATE USING (true);
CREATE POLICY "Public delete reviews" ON reviews FOR DELETE USING (true);

-- Loyalty points policies
CREATE POLICY "Public read loyalty_points" ON loyalty_points FOR SELECT USING (true);
CREATE POLICY "Public insert loyalty_points" ON loyalty_points FOR INSERT WITH CHECK (true);
CREATE POLICY "Public update loyalty_points" ON loyalty_points FOR UPDATE USING (true);
CREATE POLICY "Public delete loyalty_points" ON loyalty_points FOR DELETE USING (true);

-- Points transactions policies
CREATE POLICY "Public read transactions" ON points_transactions FOR SELECT USING (true);
CREATE POLICY "Public insert transactions" ON points_transactions FOR INSERT WITH CHECK (true);
CREATE POLICY "Public update transactions" ON points_transactions FOR UPDATE USING (true);
CREATE POLICY "Public delete transactions" ON points_transactions FOR DELETE USING (true);

-- Review notifications policies
CREATE POLICY "Public read notifications" ON review_notifications FOR SELECT USING (true);
CREATE POLICY "Public insert notifications" ON review_notifications FOR INSERT WITH CHECK (true);
CREATE POLICY "Public update notifications" ON review_notifications FOR UPDATE USING (true);
CREATE POLICY "Public delete notifications" ON review_notifications FOR DELETE USING (true);

-- =====================================================
-- TRIGGER: AUTO-AWARD POINTS WHEN REVIEW IS APPROVED
-- =====================================================

CREATE OR REPLACE FUNCTION award_review_points()
RETURNS TRIGGER AS $$
BEGIN
  -- Only award points when status changes from pending to approved
  IF NEW.status = 'approved' AND (OLD.status IS NULL OR OLD.status = 'pending') THEN
    -- Add 100 points to user's loyalty account (if user_id exists)
    IF NEW.user_id IS NOT NULL THEN
      INSERT INTO loyalty_points (user_id, points, lifetime_points)
      VALUES (NEW.user_id, 100, 100)
      ON CONFLICT (user_id)
      DO UPDATE SET
        points = loyalty_points.points + 100,
        lifetime_points = loyalty_points.lifetime_points + 100,
        updated_at = NOW();

      -- Record transaction
      INSERT INTO points_transactions (user_id, points, transaction_type, reference_id, description)
      VALUES (NEW.user_id, 100, 'review', NEW.id, 'Review approved for product: ' || NEW.product_id);
    END IF;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger
DROP TRIGGER IF EXISTS on_review_approved ON reviews;
CREATE TRIGGER on_review_approved
  AFTER UPDATE ON reviews
  FOR EACH ROW
  EXECUTE FUNCTION award_review_points();

-- =====================================================
-- FUNCTION: SCHEDULE REVIEW NOTIFICATIONS (5 days after delivery)
-- Note: You'll need to create this trigger on your orders table when it exists
-- =====================================================

CREATE OR REPLACE FUNCTION schedule_review_notification()
RETURNS TRIGGER AS $$
BEGIN
  -- Schedule notification for 5 days after delivery
  IF NEW.status = 'delivered' AND (OLD.status IS NULL OR OLD.status != 'delivered') THEN
    INSERT INTO review_notifications (order_id, user_id, product_id, scheduled_for)
    SELECT
      NEW.id,
      NEW.user_id,
      NEW.product_id,
      NOW() + INTERVAL '5 days'
    WHERE NOT EXISTS (
      SELECT 1 FROM review_notifications
      WHERE order_id = NEW.id AND product_id = NEW.product_id
    );
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Uncomment and run this when you have an orders table:
-- CREATE TRIGGER on_order_delivered
--   AFTER UPDATE ON orders
--   FOR EACH ROW
--   EXECUTE FUNCTION schedule_review_notification();

-- =====================================================
-- INDEXES FOR PERFORMANCE
-- =====================================================

CREATE INDEX IF NOT EXISTS idx_reviews_product_id ON reviews(product_id);
CREATE INDEX IF NOT EXISTS idx_reviews_user_id ON reviews(user_id);
CREATE INDEX IF NOT EXISTS idx_reviews_status ON reviews(status);
CREATE INDEX IF NOT EXISTS idx_reviews_created_at ON reviews(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_loyalty_points_user_id ON loyalty_points(user_id);
CREATE INDEX IF NOT EXISTS idx_points_transactions_user_id ON points_transactions(user_id);
CREATE INDEX IF NOT EXISTS idx_review_notifications_scheduled ON review_notifications(scheduled_for) WHERE NOT sent;

-- =====================================================
-- SAMPLE DATA (Optional - for testing)
-- =====================================================

-- Insert a system user for seeded reviews (optional)
-- You can use any UUID or create a specific system user

COMMENT ON TABLE reviews IS 'Customer product reviews with 300 character limit';
COMMENT ON TABLE loyalty_points IS 'User loyalty points balance';
COMMENT ON TABLE points_transactions IS 'Audit trail for all points transactions';
COMMENT ON TABLE review_notifications IS 'Queue for scheduled review request notifications';

-- =====================================================
-- COMPLETE!
-- Your reviews and loyalty system is now set up.
-- =====================================================

