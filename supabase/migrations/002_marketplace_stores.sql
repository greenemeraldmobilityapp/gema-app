-- GEMA App - Supabase Database Migration
-- Phase 2: Marketplace & Stores Schema

-- Addresses table (multi-address per user)
CREATE TABLE IF NOT EXISTS addresses (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  profile_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  label TEXT NOT NULL,
  address TEXT NOT NULL,
  city TEXT NOT NULL DEFAULT 'Jepara',
  province TEXT NOT NULL DEFAULT 'Jawa Tengah',
  postal_code TEXT,
  latitude DECIMAL(10, 8),
  longitude DECIMAL(11, 8),
  is_default BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Wallets table (separate from profiles for better tracking)
CREATE TABLE IF NOT EXISTS wallets (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  profile_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL UNIQUE,
  balance DECIMAL(15, 2) DEFAULT 0.00,
  held_balance DECIMAL(15, 2) DEFAULT 0.00,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Offerings table (replaces products - supports both products and services)
CREATE TABLE IF NOT EXISTS offerings (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  store_id UUID REFERENCES stores(id) ON DELETE CASCADE,
  provider_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  type TEXT NOT NULL CHECK (type IN ('product', 'service')),
  name TEXT NOT NULL,
  description TEXT,
  price DECIMAL(15, 2) NOT NULL,
  category TEXT NOT NULL,
  image_urls TEXT[],
  rating DECIMAL(3, 2) DEFAULT 0.00,
  rating_count INTEGER DEFAULT 0,
  sold_count INTEGER DEFAULT 0,
  is_available BOOLEAN DEFAULT TRUE,
  is_negotiable BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT check_store_or_provider CHECK (
    (store_id IS NOT NULL AND provider_id IS NULL) OR
    (store_id IS NULL AND provider_id IS NOT NULL)
  )
);

-- Driver locations table (real-time tracking)
CREATE TABLE IF NOT EXISTS driver_locations (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  driver_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL UNIQUE,
  latitude DECIMAL(10, 8) NOT NULL,
  longitude DECIMAL(11, 8) NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Withdrawals table
CREATE TABLE IF NOT EXISTS withdrawals (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  profile_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  amount DECIMAL(15, 2) NOT NULL,
  status TEXT NOT NULL CHECK (status IN ('pending', 'processing', 'completed', 'failed')),
  bank_name TEXT NOT NULL,
  bank_account_number TEXT NOT NULL,
  bank_account_name TEXT NOT NULL,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  processed_at TIMESTAMPTZ
);

-- Notifications table
CREATE TABLE IF NOT EXISTS notifications (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  profile_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  title TEXT NOT NULL,
  message TEXT NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('order', 'payment', 'system', 'promo')),
  is_read BOOLEAN DEFAULT FALSE,
  data JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Rename existing 'products' table to 'stores' if it exists (Phase 1 naming)
-- Note: Phase 1 created 'merchants' and 'products' tables
-- Phase 2 renames to 'stores' and adds 'offerings'
-- For backward compatibility, we keep the Phase 1 tables and create aliases

-- Update orders table to use store_id instead of merchant_id
-- (Phase 1 used merchant_id, Phase 2 uses store_id)
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'orders' AND column_name = 'merchant_id'
  ) THEN
    ALTER TABLE orders RENAME COLUMN merchant_id TO store_id;
  END IF;
END $$;

-- Add missing columns to orders table
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'orders' AND column_name = 'type'
  ) THEN
    ALTER TABLE orders ADD COLUMN type TEXT DEFAULT 'marketplace'
      CHECK (type IN ('food', 'marketplace', 'send', 'service'));
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'orders' AND column_name = 'payment_method'
  ) THEN
    ALTER TABLE orders ADD COLUMN payment_method TEXT DEFAULT 'xendit'
      CHECK (payment_method IN ('xendit', 'cod'));
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'orders' AND column_name = 'total_item_price'
  ) THEN
    ALTER TABLE orders ADD COLUMN total_item_price DECIMAL(15, 2) DEFAULT 0.00;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'orders' AND column_name = 'shipping_fee'
  ) THEN
    ALTER TABLE orders ADD COLUMN shipping_fee DECIMAL(15, 2) DEFAULT 0.00;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'orders' AND column_name = 'app_fee'
  ) THEN
    ALTER TABLE orders ADD COLUMN app_fee DECIMAL(15, 2) DEFAULT 0.00;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'orders' AND column_name = 'dest_address'
  ) THEN
    ALTER TABLE orders ADD COLUMN dest_address TEXT;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'orders' AND column_name = 'dest_lat'
  ) THEN
    ALTER TABLE orders ADD COLUMN dest_lat DECIMAL(10, 8);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'orders' AND column_name = 'dest_lng'
  ) THEN
    ALTER TABLE orders ADD COLUMN dest_lng DECIMAL(11, 8);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'orders' AND column_name = 'scheduled_at'
  ) THEN
    ALTER TABLE orders ADD COLUMN scheduled_at TIMESTAMPTZ;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'orders' AND column_name = 'cancelled_by'
  ) THEN
    ALTER TABLE orders ADD COLUMN cancelled_by UUID REFERENCES auth.users(id);
  END IF;
END $$;

-- Update order_items to add image_url and name columns
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'order_items' AND column_name = 'offering_id'
  ) THEN
    ALTER TABLE order_items ADD COLUMN offering_id UUID;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'order_items' AND column_name = 'name'
  ) THEN
    ALTER TABLE order_items ADD COLUMN name TEXT;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'order_items' AND column_name = 'image_url'
  ) THEN
    ALTER TABLE order_items ADD COLUMN image_url TEXT;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'order_items' AND column_name = 'subtotal'
  ) THEN
    ALTER TABLE order_items ADD COLUMN subtotal DECIMAL(15, 2);
  END IF;
END $$;

-- Indexes for Phase 2
CREATE INDEX IF NOT EXISTS idx_addresses_profile ON addresses(profile_id);
CREATE INDEX IF NOT EXISTS idx_wallets_profile ON wallets(profile_id);
CREATE INDEX IF NOT EXISTS idx_offerings_store ON offerings(store_id);
CREATE INDEX IF NOT EXISTS idx_offerings_provider ON offerings(provider_id);
CREATE INDEX IF NOT EXISTS idx_offerings_type ON offerings(type);
CREATE INDEX IF NOT EXISTS idx_offerings_category ON offerings(category);
CREATE INDEX IF NOT EXISTS idx_offerings_available ON offerings(is_available);
CREATE INDEX IF NOT EXISTS idx_driver_locations_driver ON driver_locations(driver_id);
CREATE INDEX IF NOT EXISTS idx_withdrawals_profile ON withdrawals(profile_id);
CREATE INDEX IF NOT EXISTS idx_notifications_profile ON notifications(profile_id);
CREATE INDEX IF NOT EXISTS idx_notifications_read ON notifications(profile_id, is_read);

-- Row Level Security for new tables

-- Addresses
ALTER TABLE addresses ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own addresses"
  ON addresses FOR SELECT
  USING (auth.uid() = profile_id);

CREATE POLICY "Users can manage own addresses"
  ON addresses FOR ALL
  USING (auth.uid() = profile_id);

-- Wallets
ALTER TABLE wallets ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own wallet"
  ON wallets FOR SELECT
  USING (auth.uid() = profile_id);

-- Offerings
ALTER TABLE offerings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view offerings"
  ON offerings FOR SELECT
  USING (TRUE);

CREATE POLICY "Store owners can manage offerings"
  ON offerings FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM stores
      WHERE stores.id = offerings.store_id
      AND stores.owner_id = auth.uid()
    )
    OR provider_id = auth.uid()
  );

-- Driver locations
ALTER TABLE driver_locations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view driver locations"
  ON driver_locations FOR SELECT
  USING (TRUE);

CREATE POLICY "Drivers can update own location"
  ON driver_locations FOR ALL
  USING (auth.uid() = driver_id);

-- Withdrawals
ALTER TABLE withdrawals ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own withdrawals"
  ON withdrawals FOR SELECT
  USING (auth.uid() = profile_id);

CREATE POLICY "Users can create withdrawals"
  ON withdrawals FOR INSERT
  WITH CHECK (auth.uid() = profile_id);

-- Notifications
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own notifications"
  ON notifications FOR SELECT
  USING (auth.uid() = profile_id);

-- Trigger for updated_at on new tables
CREATE TRIGGER update_addresses_updated_at
  BEFORE UPDATE ON addresses
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_wallets_updated_at
  BEFORE UPDATE ON wallets
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_offerings_updated_at
  BEFORE UPDATE ON offerings
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();

-- Update handle_new_user to also create wallet
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email, full_name)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', '')
  );

  INSERT INTO public.wallets (profile_id, balance, held_balance)
  VALUES (NEW.id, 0, 0);

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Views

-- User wallet summary
CREATE OR REPLACE VIEW user_wallet_summary AS
SELECT
  p.id AS profile_id,
  p.full_name,
  p.email,
  p.is_merchant,
  w.balance,
  w.held_balance,
  (w.balance + w.held_balance) AS total_assets
FROM profiles p
JOIN wallets w ON p.id = w.profile_id;

-- Order summary (updated for Phase 2)
CREATE OR REPLACE VIEW order_summary AS
SELECT
  o.id,
  o.status,
  o.type,
  o.payment_method,
  b.full_name AS buyer_name,
  s.name AS store_name,
  d.full_name AS driver_name,
  o.total_item_price,
  o.shipping_fee,
  o.app_fee,
  o.total_amount,
  o.created_at,
  o.updated_at
FROM orders o
JOIN profiles b ON o.buyer_id = b.id
LEFT JOIN stores s ON o.store_id = s.id
LEFT JOIN profiles d ON o.driver_id = d.id;
