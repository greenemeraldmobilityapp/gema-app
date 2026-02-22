Project Requirement Document (PRD): GEMA App
Versi: 1.2 (Final Draft)
Nama Proyek: GEMA (Green Emerald Mobility App)
Owner: Emerald Tech Solution
Target Launch: Kabupaten Jepara, Jawa Tengah
1. Visi & Tujuan
Membangun Super-App lokal yang mengintegrasikan Marketplace, Logistik (Kurir), dan Jasa (Service) untuk memajukan ekosistem ekonomi digital di Kabupaten Jepara.
2. Model Bisnis & Monetisasi
GEMA mengambil keuntungan melalui skema bagi hasil dari setiap transaksi sukses:
 * Komisi Penjual (Merchant): 15% dari harga produk.
 * Komisi Kurir/Driver: 15% dari biaya ongkir.
 * Komisi Penyedia Jasa (Service): 15% dari total nilai jasa.
 * Biaya Aplikasi (Platform Fee): Rp2.000 flat per transaksi (dibebankan ke pelanggan).
3. Peran Pengguna (User Roles)
 * Pelanggan (Buyer): Belanja produk, pesan kurir/jasa, melakukan pembayaran, dan tracking.
 * Penjual (Merchant): Mengelola toko dan produk (setelah verifikasi admin).
 * Mitra Kurir (Driver): Mengantar barang dan makanan.
 * Mitra Jasa (Provider): Menyediakan jasa spesifik (Tukang ukir, servis AC, dll).
 * Admin (Emerald Tech): Verifikasi mitra, manajemen keuangan, dan layanan pelanggan.
4. Fitur Utama berdasarkan Kategori
A. GEMA-Food & Marketplace
 * Pemesanan barang dari toko terverifikasi di wilayah Jepara.
 * Filter produk berdasarkan kategori (Mebel, Kuliner, Fashion, dll).
 * Manajemen keranjang dan checkout terintegrasi.
B. GEMA-Send (Logistik)
 * Sameday: Pengiriman instan di hari yang sama.
 * Next-Day/Reguler: Pengambilan barang dilakukan kurir pada hari H pengiriman (pagi hari).
 * Hitung Ongkir: Otomatis berdasarkan jarak (Haversine Formula untuk tahap awal).
C. GEMA-Service (Jasa Baru)
 * Penyediaan jasa tukang ukir, servis perabot, atau jasa angkut pindahan.
 * Sistem pemesanan berdasarkan jadwal.
D. Sistem Keamanan & Pembayaran (Payment Gateway)
 * Cashless: Pembayaran via Xendit (QRIS, VA, E-Wallet).
 * COD (Cash on Delivery):
   * Hanya bisa diambil oleh Driver yang memiliki Saldo Minimal di dompet aplikasi (Saldo > Nilai Komisi + Nilai Barang).
   * Sistem memotong saldo driver secara otomatis sebagai komisi perusahaan saat pesanan selesai.
 * Withdrawal: Penjual dan Driver dapat menarik pendapatan mereka ke rekening bank via Xendit.
E. Sistem Pembatalan (Adopsi Gojek)
 * Pelanggan: Bisa batal gratis maksimal 5 menit setelah dapat kurir.
 * Penalti: Pembatalan sepihak setelah kurir berangkat akan dikenakan denda atau blokir akun sementara jika merugikan mitra.
5. Alur Kerja Sistem (Workflow)
 * Pemesanan: Pelanggan checkout -> Pilih Metode Bayar (Xendit/COD).
 * Dispatching: Sistem mengirimkan notifikasi ke kurir terdekat yang memiliki saldo cukup.
 * Proses: Kurir menuju lokasi penjual -> Konfirmasi pengambilan -> Menuju lokasi pelanggan.
 * Tracking: Pelanggan melihat posisi kurir secara real-time di peta (Leaflet.js).
 * Selesai: Kurir konfirmasi sampai -> Saldo terbagi otomatis (Potong komisi 15%).
6. Spesifikasi Teknologi
 * Frontend: Next.js (App Router), Tailwind CSS.
 * Backend & Database: Supabase (PostgreSQL, Auth, Real-time).
 * Peta & Lokasi: Leaflet.js dengan OpenStreetMap (Gratis).
 * Mobile Experience: Progressive Web App (PWA) dengan Push Notifications.
 * Hosting: Vercel & GitHub.
SKEMA DATABASE:-- ==========================================
-- 1. PEMBERSIHAN & EKSTENSI
-- ==========================================
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
-- ==========================================
-- 2. TABEL UTAMA & PROFIL
-- ==========================================
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
-- Aktifkan RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
-- Policy Profiles
CREATE POLICY "Profil dapat dilihat oleh semua user terautentikasi" ON profiles FOR SELECT TO authenticated USING (true);
CREATE POLICY "User hanya bisa update profil miliknya sendiri" ON profiles FOR UPDATE TO authenticated USING (auth.uid() = id);
-- ==========================================
-- 3. TABEL WALLET (DOMPET)
-- ==========================================
CREATE TABLE wallets (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  profile_id UUID REFERENCES profiles(id) ON DELETE CASCADE UNIQUE,
  balance DECIMAL(12, 2) DEFAULT 0.00,
  held_balance DECIMAL(12, 2) DEFAULT 0.00,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
ALTER TABLE wallets ENABLE ROW LEVEL SECURITY;
-- Policy Wallets
CREATE POLICY "User bisa lihat dompet sendiri" ON wallets FOR SELECT TO authenticated USING (auth.uid() = profile_id);
-- Update wallet hanya boleh dilakukan oleh sistem (melalui function/trigger), bukan client.
-- ==========================================
-- 4. TABEL TOKO & PRODUK
-- ==========================================
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
-- Policy Stores
CREATE POLICY "Toko bisa dilihat semua orang" ON stores FOR SELECT USING (true);
CREATE POLICY "Hanya pemilik yang bisa buat toko" ON stores FOR INSERT TO authenticated WITH CHECK (auth.uid() = owner_id);
CREATE POLICY "Hanya pemilik yang bisa edit/tutup toko" ON stores FOR UPDATE TO authenticated USING (auth.uid() = owner_id);
CREATE TABLE offerings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_id UUID REFERENCES stores(id) ON DELETE CASCADE,
  provider_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  type TEXT CHECK (type IN ('product', 'service')),
  name TEXT NOT NULL,
  price DECIMAL(12, 2),
  description TEXT,
  image_url TEXT,
  is_negotiable BOOLEAN DEFAULT false
);
ALTER TABLE offerings ENABLE ROW LEVEL SECURITY;
-- Policy Offerings
CREATE POLICY "Produk/Jasa bisa dilihat semua orang" ON offerings FOR SELECT USING (true);
CREATE POLICY "Hanya pemilik toko/jasa yang bisa mengelola produk" ON offerings FOR ALL TO authenticated USING (
    EXISTS (SELECT 1 FROM stores WHERE id = store_id AND owner_id = auth.uid()) OR (provider_id = auth.uid())
);
-- ==========================================
-- 5. TABEL PESANAN & TRACKING
-- ==========================================
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
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
-- Policy Orders
CREATE POLICY "User bisa lihat orderan miliknya (sebagai buyer/driver/merchant)" ON orders FOR SELECT TO authenticated USING (
    auth.uid() = buyer_id OR 
    auth.uid() = driver_id OR 
    auth.uid() = (SELECT owner_id FROM stores WHERE id = store_id)
);
CREATE POLICY "Buyer bisa buat order" ON orders FOR INSERT TO authenticated WITH CHECK (auth.uid() = buyer_id);
CREATE POLICY "Buyer/Driver/Merchant bisa update status sesuai alur" ON orders FOR UPDATE TO authenticated USING (
    auth.uid() = buyer_id OR auth.uid() = driver_id OR auth.uid() = (SELECT owner_id FROM stores WHERE id = store_id)
);
-- ==========================================
-- 6. FUNGSI OTOMATISASI (TRIGGERS)
-- ==========================================
-- Fungsi: Buat Profil & Wallet saat Signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name, avatar_url)
  VALUES (new.id, new.raw_user_meta_data->>'full_name', new.raw_user_meta_data->>'avatar_url');
  
  INSERT INTO public.wallets (profile_id, balance)
  VALUES (new.id, 0);
  
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();
-- Fungsi: Bagi Hasil (15% Komisi)
CREATE OR REPLACE FUNCTION public.process_transaction_fees()
RETURNS trigger AS $$
DECLARE
    comm_merchant DECIMAL;
    comm_driver DECIMAL;
    m_owner_id UUID;
BEGIN
    IF (NEW.status = 'delivered' AND OLD.status != 'delivered') THEN
        comm_merchant := NEW.total_item_price * 0.15;
        comm_driver := NEW.shipping_fee * 0.15;
        -- Potong Komisi dari Saldo Driver
        UPDATE public.wallets 
        SET balance = balance - (comm_merchant + comm_driver)
        WHERE profile_id = NEW.driver_id;
        -- Kirim Hasil ke Merchant
        SELECT owner_id INTO m_owner_id FROM stores WHERE id = NEW.store_id;
        UPDATE public.wallets 
        SET balance = balance + (NEW.total_item_price - comm_merchant)
        WHERE profile_id = m_owner_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER on_order_delivered
  AFTER UPDATE ON public.orders
  FOR EACH ROW EXECUTE PROCEDURE public.process_transaction_fees();
-- ==========================================
-- 7. VIEW & LOGS
-- ==========================================
CREATE VIEW order_summary AS
SELECT o.id, o.status, b.full_name as buyer, s.store_name, d.full_name as driver, o.total_amount
FROM orders o
JOIN profiles b ON o.buyer_id = b.id
LEFT JOIN stores s ON o.store_id = s.id
LEFT JOIN profiles d ON o.driver_id = d.id;
Dokumen Panduan UI/UX: GEMA App
1. Identitas Visual (Branding)
 * Warna Utama: Hijau Zamrud (Emerald Green)
   * Hex Code: #50C878 (Main Emerald)
   * Hex Code: #2E8B57 (Dark Emerald untuk aksen)
 * Warna Pendukung: * Warning: #FFCC00 (Kuning Emas - untuk status pending/warning)
   * Danger: #E74C3C (Merah - untuk pembatalan/error)
 * Identitas Lokal: Watermark pola ukiran kayu Jepara dengan opasitas rendah (3-5%) pada latar belakang aplikasi.
2. Struktur Layout & Navigasi (Gojek-Style)
 * Beranda (Homepage):
   * Header: Profil singkat & Saldo Wallet (Emerald Wallet).
   * Main Body: Grid Ikon 3x2 atau 4x2 untuk layanan utama:
     * GEMA-Food: Ikon piring/sendok.
     * GEMA-Send: Ikon paket/motor.
     * GEMA-Service: Ikon kunci inggris/palu ukir.
   * Footer: Bottom Navigation Bar (Home, Aktivitas, Chat, Profil).
 * Halaman Transaksi/Peta:
   * Top 50% Screen: Peta interaktif (Leaflet.js) menunjukkan rute kurir.
   * Bottom 50% Screen: Floating Drawer berisi detail: Nama kurir, plat nomor, estimasi waktu, dan tombol chat/telepon.
3. Desain Mode (Dual Themes)
| Elemen UI | Light Mode | Dark Mode |
|---|---|---|
| Background Utama | #FFFFFF (Putih Bersih) | #121212 (Deep Black) |
| Card / Surface | #F8F9FA (Abu Muda) | #1E1E1E (Dark Grey) |
| Teks Utama | #2D3436 (Hitam Keabuan) | #E0E0E0 (Putih Tulang) |
| Aksen Ukiran | Abu-abu sangat muda | Emerald gelap (opasitas 5%) |
4. Komponen UI Utama (Reusable Components)
 * Buttons: Sudut membulat (Rounded-lg) 8px - 12px.
 * Cards: Bayangan lembut (soft shadow) pada light mode, dan border tipis pada dark mode.
 * Inputs: Fokus state menggunakan warna Emerald #50C878.
5. User Experience (UX) Principles
 * Haptic Feedback: Getaran singkat saat menekan tombol "Pesan Sekarang" (fitur PWA).
 * Visual Feedback: Skeleton screen (animasi loading abu-abu) saat data sedang diambil dari Supabase agar user tidak merasa aplikasi freeze.
 * Real-time Interaction: Status order berubah warna secara instan (Pending: Kuning, OTW: Hijau, Selesai: Biru).
Master Checklist Data Teknis
Sebelum kita pindah ke GitHub Codespaces, pastikan kamu sudah menyimpan ini:
 * Supabase URL & Key (Untuk database).
 * Xendit API Key (Untuk pembayaran).
 * OpenRouter API Key (Untuk asisten coding).
 * Logo GEMA (Format SVG untuk resolusi terbaik).
