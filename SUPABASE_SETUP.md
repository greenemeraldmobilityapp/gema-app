# Supabase Setup Guide - GEMA Frontend

## Quick Start (5 menit)

### 1. Create Supabase Project
1. Go to https://supabase.com
2. Sign up atau login
3. Click "New Project"
4. Fill in:
   - Project Name: `gema-app`
   - Database Password: (save this!)
   - Region: `Singapore` (terdekat dengan Indonesia)
5. Wait untuk project siap (~2 menit)

### 2. Copy Credentials
Di halaman project, klik "Settings" → "API":
- Copy `Project URL` → `NEXT_PUBLIC_SUPABASE_URL`
- Copy `anon` key → `NEXT_PUBLIC_SUPABASE_ANON_KEY`
- Copy `service_role` key → `SUPABASE_SERVICE_ROLE_KEY`

### 3. Create `.env.local`
```env
# Supabase
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5...
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5...
```

### 4. Create `lib/supabase.ts`
```typescript
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!
const supabaseKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!

export const supabase = createClient(supabaseUrl, supabaseKey)
```

### 5. Test Connection
Create simple test in app/page.tsx:
```typescript
import { supabase } from '@/lib/supabase'

export default async function Home() {
  const { data, error } = await supabase.auth.getSession()
  
  if (error) return <div>Error: {error.message}</div>
  return <div>Connected! {data ? 'Auth OK' : 'Not logged in'}</div>
}
```

---

## Database Schema Setup

### Via Supabase SQL Editor

Go to Supabase Dashboard → SQL Editor → Run these queries:

```sql
-- 1. Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. Create profiles table
CREATE TABLE profiles (
  id UUID REFERENCES auth.users ON DELETE CASCADE PRIMARY KEY,
  full_name TEXT,
  phone_number TEXT,
  avatar_url TEXT,
  roles TEXT[] DEFAULT '{buyer}',
  is_verified BOOLEAN DEFAULT false,
  lat DECIMAL(10, 8),
  lng DECIMAL(11, 8),
  address_details TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Profil dapat dilihat semua user" ON profiles 
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "User hanya update profil sendiri" ON profiles 
  FOR UPDATE TO authenticated USING (auth.uid() = id);

-- 3. Create wallets table
CREATE TABLE wallets (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  profile_id UUID REFERENCES profiles(id) ON DELETE CASCADE UNIQUE,
  balance DECIMAL(12, 2) DEFAULT 0.00,
  held_balance DECIMAL(12, 2) DEFAULT 0.00,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE wallets ENABLE ROW LEVEL SECURITY;

CREATE POLICY "User lihat dompet sendiri" ON wallets 
  FOR SELECT TO authenticated USING (auth.uid() = profile_id);

-- 4. Create stores table
CREATE TABLE stores (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  owner_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  store_name TEXT NOT NULL,
  description TEXT,
  category TEXT,
  lat DECIMAL(10, 8),
  lng DECIMAL(11, 8),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE stores ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Toko dilihat semua" ON stores FOR SELECT USING (true);
CREATE POLICY "Hanya owner buat toko" ON stores FOR INSERT TO authenticated 
  WITH CHECK (auth.uid() = owner_id);
CREATE POLICY "Hanya owner edit toko" ON stores FOR UPDATE TO authenticated 
  USING (auth.uid() = owner_id);

-- 5. Create products table
CREATE TABLE products (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_id UUID REFERENCES stores(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  price DECIMAL(12, 2) NOT NULL,
  image_url TEXT,
  category TEXT,
  stock INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE products ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Products dilihat semua" ON products FOR SELECT USING (true);

-- 6. Create services table
CREATE TABLE services (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  provider_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  category TEXT,
  price DECIMAL(12, 2) NOT NULL,
  is_available BOOLEAN DEFAULT true,
  image_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE services ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Services dilihat semua" ON services FOR SELECT USING (true);

-- 7. Create orders table
CREATE TABLE orders (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  buyer_id UUID REFERENCES profiles(id),
  driver_id UUID REFERENCES profiles(id),
  store_id UUID REFERENCES stores(id),
  type TEXT CHECK (type IN ('food', 'send', 'service')),
  status TEXT DEFAULT 'pending',
  payment_method TEXT,
  total_item_price DECIMAL(12, 2) DEFAULT 0.00,
  shipping_fee DECIMAL(12, 2) DEFAULT 0.00,
  app_fee DECIMAL(12, 2) DEFAULT 2000.00,
  total_amount DECIMAL(12, 2) DEFAULT 0.00,
  dest_lat DECIMAL(10, 8),
  dest_lng DECIMAL(11, 8),
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

CREATE POLICY "User lihat order sendiri" ON orders FOR SELECT TO authenticated 
  USING (
    auth.uid() = buyer_id OR 
    auth.uid() = driver_id OR 
    auth.uid() = (SELECT owner_id FROM stores WHERE id = store_id)
  );

CREATE POLICY "Buyer buat order" ON orders FOR INSERT TO authenticated 
  WITH CHECK (auth.uid() = buyer_id);

-- 8. Create order items table
CREATE TABLE order_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
  product_id UUID REFERENCES products(id),
  service_id UUID REFERENCES services(id),
  quantity INTEGER DEFAULT 1,
  price DECIMAL(12, 2) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;

-- 9. Create trigger for auto-create profile on auth signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name)
  VALUES (
    new.id,
    new.raw_user_meta_data->>'full_name'
  );
  
  INSERT INTO public.wallets (profile_id, balance)
  VALUES (new.id, 0);
  
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();
```

✅ Done! Your database is ready.

---

## Seed Data (Testing)

### Create Products
Go to Supabase → SQL Editor → Run:

```sql
-- Create test store first
INSERT INTO stores (owner_id, store_name, description, category, lat, lng) 
VALUES (
  '00000000-0000-0000-0000-000000000000'::uuid,
  'Mebel Jepara Asli',
  'Furniture berkualitas tinggi dari Jepara',
  'Mebel',
  -6.8910,
  110.2852
);

-- Insert test products
INSERT INTO products (store_id, name, description, price, category, stock) 
VALUES 
  ((SELECT id FROM stores LIMIT 1), 'Kursi Makan Jati', 'Kursi makan dari kayu jati solid', 450000, 'Furniture', 10),
  ((SELECT id FROM stores LIMIT 1), 'Meja Kantor Minimalis', 'Meja kantor desain modern', 800000, 'Furniture', 5),
  ((SELECT id FROM stores LIMIT 1), 'Lemari Pakaian Ukir', 'Lemari dengan ukiran tradisional Jepara', 2500000, 'Furniture', 3);
```

---

## Authentication Setup

### Enable Email Authentication
1. Go to Supabase Dashboard
2. Click "Authentication" menu
3. Go to "Providers"
4. Enable "Email" with default settings
5. Go to "URL Configuration"
6. Add your app URL:
   - Development: `http://localhost:3000`
   - Production: `https://yourdomain.com`

---

## File checklist

Setelah setup, buat files berikut:

```
lib/
  ├── supabase.ts          ✅ (copy dari section 4 di atas)
  └── validations.ts       (untuk form validation)
components/
  ├── AuthProvider.tsx     (auth context provider)
  └── AuthGuard.tsx        (route protection)
app/
  ├── auth/
  │   └── page.tsx         (login/signup page)
  └── api/
      └── auth/
          └── callback.ts  (auth callback handler)
hooks/
  ├── useAuth.ts           (auth hook)
  └── useForm.ts           (form hook)
```

---

## Next: Auth Implementation

Once connected:
1. Go ke fase 2 di NEXT_STEPS.md
2. Implement login/signup flow
3. Add AuthProvider wrapping
4. Protect routes

**Happy coding!** 🚀
