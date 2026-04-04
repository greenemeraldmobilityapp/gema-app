# Project Requirement Document (PRD): GEMA App

**Versi:** 2.0 (Flutter Edition - Comprehensive)
**Nama Proyek:** GEMA (Green Emerald Mobility App)
**Owner:** Emerald Tech Solution
**Target Launch:** Kabupaten Jepara, Jawa Tengah

## 1. Visi & Tujuan

Membangun Super-App lokal yang mengintegrasikan Marketplace, Logistik (Kurir), dan Jasa (Service) untuk memajukan ekosistem ekonomi digital di Kabupaten Jepara.

## 2. Model Bisnis & Monetisasi

GEMA mengambil keuntungan melalui skema bagi hasil dari setiap transaksi sukses:

- **Komisi Penjual (Merchant):** 15% dari harga produk.
- **Komisi Kurir/Driver:** 15% dari biaya ongkir.
- **Komisi Penyedia Jasa (Service):** 15% dari total nilai jasa.
- **Biaya Aplikasi (Platform Fee):** Rp2.000 flat per transaksi (dibebankan ke pelanggan).

## 3. Peran Pengguna (User Roles)

- **Pelanggan (Buyer):** Belanja produk, pesan kurir/jasa, melakukan pembayaran, dan tracking.
- **Penjual (Merchant):** Mengelola toko dan produk (setelah verifikasi admin).
- **Mitra Kurir (Driver):** Mengantar barang dan makanan.
- **Mitra Jasa (Provider):** Menyediakan jasa spesifik (Tukang ukir, servis AC, dll).
- **Admin (Emerald Tech):** Verifikasi mitra, manajemen keuangan, dan layanan pelanggan.

## 4. Fitur Utama berdasarkan Kategori

### A. GEMA-Food & Marketplace

- Pemesanan barang dari toko terverifikasi di wilayah Jepara.
- Filter produk berdasarkan kategori (Mebel, Kuliner, Fashion, dll).
- Manajemen keranjang dan checkout terintegrasi.
- Multi-item per order (satu toko dalam satu pesanan).

### B. GEMA-Send (Logistik)

- **Sameday:** Pengiriman instan di hari yang sama.
- **Next-Day/Reguler:** Pengambilan barang dilakukan kurir pada hari H pengiriman (pagi hari).
- **Hitung Ongkir:** Otomatis berdasarkan jarak (Haversine Formula untuk tahap awal).

### C. GEMA-Service (Jasa Baru)

- Penyediaan jasa tukang ukir, servis perabot, atau jasa angkut pindahan.
- Sistem pemesanan berdasarkan jadwal.

### D. Sistem Keamanan & Pembayaran (Payment Gateway)

- **Cashless:** Pembayaran via Xendit (QRIS, VA, E-Wallet).
- **COD (Cash on Delivery):**
  - Hanya bisa diambil oleh Driver yang memiliki Saldo Minimal di dompet aplikasi (Saldo > Nilai Komisi + Nilai Barang).
  - Sistem menahan saldo driver (held_balance) saat order diterima.
  - Saldo dipotong otomatis sebagai komisi perusahaan saat pesanan selesai.
  - Jika dibatalkan, held_balance dikembalikan penuh.
- **Withdrawal:** Penjual dan Driver dapat menarik pendapatan mereka ke rekening bank via Xendit.

### E. Sistem Pembatalan (Adopsi Gojek)

- **Pelanggan:** Bisa batal gratis maksimal 5 menit setelah dapat kurir.
- **Penalti:** Pembatalan sepihak setelah kurir berangkat akan dikenakan denda atau blokir akun sementara jika merugikan mitra.

### F. Chat & Komunikasi

- Chat real-time antara Pelanggan ↔ Driver.
- Chat real-time antara Pelanggan ↔ Merchant.
- Tombol darurat (hubungi admin) saat ada masalah di lapangan.

### G. Rating & Review

- Rating 1-5 bintang + komentar setelah order selesai.
- Rating untuk Driver, Merchant, dan Service Provider secara terpisah.
- Average rating ditampilkan di profil toko/driver/provider.

## 5. Alur Kerja Sistem (Workflow)

### 5.1 Status Order Lifecycle

| Status | Deskripsi |
|---|---|
| `pending` | Order baru dibuat, menunggu driver |
| `searching_driver` | Sistem mencari driver terdekat yang saldo cukup |
| `driver_found` | Driver menerima order |
| `driver_to_merchant` | Driver dalam perjalanan ke lokasi penjual |
| `picked_up` | Driver sudah ambil barang dari penjual |
| `driver_to_customer` | Driver dalam perjalanan ke lokasi pelanggan |
| `delivered` | Barang sudah sampai, pembayaran diproses |
| `cancelled` | Order dibatalkan (oleh customer, driver, atau admin) |

### 5.2 Alur Lengkap

1. **Pemesanan:** Pelanggan checkout → Pilih Metode Bayar (Xendit/COD) → Order status `pending`.
2. **Dispatching:** Sistem mencari kurir terdekat (radius 5km) yang memiliki saldo cukup → Status `searching_driver`.
3. **Driver Accept:** Kurir menerima order → Status `driver_found` → `held_balance` di-hold dari saldo driver.
4. **Proses:** Kurir menuju lokasi penjual (`driver_to_merchant`) → Konfirmasi pengambilan (`picked_up`) → Menuju lokasi pelanggan (`driver_to_customer`).
5. **Tracking:** Pelanggan melihat posisi kurir secara real-time di peta (flutter_map).
6. **Selesai:** Kurir konfirmasi sampai (`delivered`) → Held_balance dilepas → Saldo terbagi otomatis (Potong komisi 15%, kirim ke merchant).
7. **Review:** Pelanggan memberikan rating 1-5 bintang + komentar.

### 5.3 COD Flow (Detail)

1. Customer pilih COD saat checkout.
2. Sistem filter driver dengan `balance >= (total_item_price + shipping_fee + app_fee)`.
3. Saat driver accept: `held_balance` = total order di-hold dari balance.
4. Saat delivered:
   - `held_balance` dikembalikan ke `balance`.
   - Komisi merchant (15%) dan komisi driver (15%) dipotong dari `balance` driver.
   - Hasil bersih dikirim ke saldo merchant.
   - Customer bayar tunai ke driver.
5. Saat cancelled: `held_balance` dikembalikan penuh ke driver.

## 6. Spesifikasi Teknologi

- **Framework:** Flutter 3.x (stable) + Dart 3.x
- **State Management:** Riverpod (flutter_riverpod + riverpod_generator)
- **Routing:** go_router (typed routes, deep linking)
- **Backend & Database:** Supabase (PostgreSQL, Auth, Real-time, Storage) via `supabase_flutter` SDK
- **Local Storage:** Isar (NoSQL, offline mode, cache)
- **Peta & Lokasi:** flutter_map + OpenStreetMap (Gratis) + geolocator
- **Payment:** Xendit REST API (via Dio/http)
- **Notifications:** firebase_messaging + flutter_local_notifications
- **CI/CD iOS:** Codemagic (cloud macOS build)
- **Development Environment:** Termux + proot-distro Debian + OpenCode CLI

### Kenapa Flutter?

- **Single Codebase** — Satu kode untuk Android & iOS, hemat waktu & biaya development.
- **Native Performance** — Compiled ke ARM/x86 native code, 60-120 FPS, smooth animations.
- **Hot Reload** — Iterasi cepat saat development, cocok untuk vibe coding dengan AI assistant.
- **Rich Ecosystem** — Package resmi dari Supabase, Google Maps, payment gateway, dll.
- **Play Store & App Store Ready** — Build APK/AAB untuk Android, IPA untuk iOS (via Codemagic).

### Kenapa Riverpod?

- **Compile-safe** — Error terdeteksi saat compile, bukan runtime.
- **Code Generation** — `riverpod_generator` auto-generate providers dari anotasi `@riverpod`.
- **Auto-dispose** — Memory management otomatis, tidak ada memory leak.
- **Testable** — Mudah di-unit test, override provider untuk mocking.
- **Modern Dart** — Mendukung pattern matching, records, sealed classes (Dart 3+).

### Kenapa Isar?

- **Super Cepat** — 10x lebih cepat dari SQLite untuk read/write.
- **Type-safe** — Schema didefinisikan dengan Dart classes, auto-generate.
- **Async-first** — Semua operasi non-blocking, tidak freeze UI.
- **Offline-ready** — Cocok untuk caching data, keranjang belanja, draft order.

---

## SKEMA DATABASE (Supabase PostgreSQL)

> **Catatan:** Skema database Supabase tetap sama (PostgreSQL). Migrasi dikelola via Supabase Dashboard atau SQL migration.
> Di sisi Flutter, kita gunakan `supabase_flutter` SDK untuk query — tidak perlu ORM terpisah.
> Row Level Security (RLS) policies wajib di-setup untuk keamanan data.

### Tabel & Relasi (Lengkap)

| Tabel | Primary Key | Foreign Keys | Deskripsi |
|---|---|---|---|
| `profiles` | `id` (UUID, ref ke `auth.users`) | - | Data pengguna (buyer, merchant, driver, provider, admin) |
| `addresses` | `id` (UUID) | `profile_id` -> `profiles.id` | Multi-alamat per user (rumah, kantor, dll) |
| `wallets` | `id` (UUID) | `profile_id` -> `profiles.id` | Saldo pengguna (balance & held_balance) |
| `transactions` | `id` (UUID) | `profile_id` -> `profiles.id`, `order_id` -> `orders.id` | Ledger/audit trail semua pergerakan saldo |
| `withdrawals` | `id` (UUID) | `profile_id` -> `profiles.id` | Riwayat penarikan saldo ke bank |
| `stores` | `id` (UUID) | `owner_id` -> `profiles.id` | Data toko merchant |
| `offerings` | `id` (UUID) | `store_id` -> `stores.id`, `provider_id` -> `profiles.id` | Produk atau jasa |
| `orders` | `id` (UUID) | `buyer_id`, `driver_id`, `store_id`, `cancelled_by` -> `profiles.id` | Pesanan (food, marketplace, send, service) |
| `order_items` | `id` (UUID) | `order_id` -> `orders.id`, `offering_id` -> `offerings.id` | Detail item per order |
| `driver_locations` | `id` (UUID) | `driver_id` -> `profiles.id` | Posisi real-time kurir di peta |
| `reviews` | `id` (UUID) | `order_id` -> `orders.id`, `reviewer_id`, `target_id` -> `profiles.id` | Rating & review |
| `messages` | `id` (UUID) | `order_id` -> `orders.id`, `sender_id`, `receiver_id` -> `profiles.id` | Chat antar pengguna |
| `notifications` | `id` (UUID) | `profile_id` -> `profiles.id` | Log notifikasi in-app |

### Row Level Security (RLS) Policies

```sql
-- Enable RLS on all tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE addresses ENABLE ROW LEVEL SECURITY;
ALTER TABLE wallets ENABLE ROW LEVEL SECURITY;
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE withdrawals ENABLE ROW LEVEL SECURITY;
ALTER TABLE stores ENABLE ROW LEVEL SECURITY;
ALTER TABLE offerings ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE driver_locations ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- Profiles
CREATE POLICY "Profil dapat dilihat oleh semua user terautentikasi" ON profiles FOR SELECT TO authenticated USING (true);
CREATE POLICY "User hanya bisa update profil miliknya sendiri" ON profiles FOR UPDATE TO authenticated USING (auth.uid() = id);

-- Addresses
CREATE POLICY "User bisa lihat alamat sendiri" ON addresses FOR SELECT TO authenticated USING (auth.uid() = profile_id);
CREATE POLICY "User bisa kelola alamat sendiri" ON addresses FOR ALL TO authenticated USING (auth.uid() = profile_id);

-- Wallets
CREATE POLICY "User bisa lihat dompet sendiri" ON wallets FOR SELECT TO authenticated USING (auth.uid() = profile_id);

-- Transactions
CREATE POLICY "User bisa lihat transaksi sendiri" ON transactions FOR SELECT TO authenticated USING (auth.uid() = profile_id);

-- Withdrawals
CREATE POLICY "User bisa lihat withdrawal sendiri" ON withdrawals FOR SELECT TO authenticated USING (auth.uid() = profile_id);
CREATE POLICY "User bisa buat withdrawal" ON withdrawals FOR INSERT TO authenticated WITH CHECK (auth.uid() = profile_id);

-- Stores
CREATE POLICY "Toko bisa dilihat semua orang" ON stores FOR SELECT USING (true);
CREATE POLICY "Hanya pemilik yang bisa buat toko" ON stores FOR INSERT TO authenticated WITH CHECK (auth.uid() = owner_id);
CREATE POLICY "Hanya pemilik yang bisa edit/tutup toko" ON stores FOR UPDATE TO authenticated USING (auth.uid() = owner_id);

-- Offerings
CREATE POLICY "Produk/Jasa bisa dilihat semua orang" ON offerings FOR SELECT USING (true);
CREATE POLICY "Hanya pemilik toko/jasa yang bisa mengelola produk" ON offerings FOR ALL TO authenticated USING (
    EXISTS (SELECT 1 FROM stores WHERE id = store_id AND owner_id = auth.uid()) OR (provider_id = auth.uid())
);

-- Orders
CREATE POLICY "User bisa lihat orderan miliknya" ON orders FOR SELECT TO authenticated USING (
    auth.uid() = buyer_id OR
    auth.uid() = driver_id OR
    auth.uid() = (SELECT owner_id FROM stores WHERE id = store_id)
);
CREATE POLICY "Buyer bisa buat order" ON orders FOR INSERT TO authenticated WITH CHECK (auth.uid() = buyer_id);
CREATE POLICY "Buyer/Driver/Merchant bisa update status" ON orders FOR UPDATE TO authenticated USING (
    auth.uid() = buyer_id OR auth.uid() = driver_id OR auth.uid() = (SELECT owner_id FROM stores WHERE id = store_id)
);

-- Order Items
CREATE POLICY "User bisa lihat item orderan miliknya" ON order_items FOR SELECT TO authenticated USING (
    EXISTS (SELECT 1 FROM orders WHERE id = order_id AND (buyer_id = auth.uid() OR driver_id = auth.uid()))
);

-- Driver Locations
CREATE POLICY "Lokasi driver bisa dilihat semua user terautentikasi" ON driver_locations FOR SELECT TO authenticated USING (true);
CREATE POLICY "Driver bisa update lokasi sendiri" ON driver_locations FOR ALL TO authenticated USING (auth.uid() = driver_id);

-- Reviews
CREATE POLICY "Review bisa dilihat semua orang" ON reviews FOR SELECT USING (true);
CREATE POLICY "User bisa buat review sendiri" ON reviews FOR INSERT TO authenticated WITH CHECK (auth.uid() = reviewer_id);

-- Messages
CREATE POLICY "User bisa lihat pesan yang dikirim/diterima" ON messages FOR SELECT TO authenticated USING (
    auth.uid() = sender_id OR auth.uid() = receiver_id
);
CREATE POLICY "User bisa kirim pesan" ON messages FOR INSERT TO authenticated WITH CHECK (auth.uid() = sender_id);

-- Notifications
CREATE POLICY "User bisa lihat notifikasi sendiri" ON notifications FOR SELECT TO authenticated USING (auth.uid() = profile_id);
```

### Triggers & Functions (Supabase SQL)

```sql
-- Fungsi: Buat Profil & Wallet saat Signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name, avatar_url)
  VALUES (new.id, new.raw_user_meta_data->>'full_name', new.raw_user_meta_data->>'avatar_url');

  INSERT INTO public.wallets (profile_id, balance, held_balance)
  VALUES (new.id, 0, 0);

  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();

-- Fungsi: Bagi Hasil dengan Escrow (15% Komisi)
CREATE OR REPLACE FUNCTION public.process_transaction_fees()
RETURNS trigger AS $$
DECLARE
    comm_merchant DECIMAL;
    comm_driver DECIMAL;
    m_owner_id UUID;
    driver_wallet_balance DECIMAL;
BEGIN
    IF (NEW.status = 'delivered' AND OLD.status != 'delivered') THEN
        comm_merchant := NEW.total_item_price * 0.15;
        comm_driver := NEW.shipping_fee * 0.15;

        -- Cek saldo driver cukup
        SELECT balance INTO driver_wallet_balance FROM public.wallets WHERE profile_id = NEW.driver_id;

        IF driver_wallet_balance >= (comm_merchant + comm_driver) THEN
            -- Potong Komisi dari Saldo Driver
            UPDATE public.wallets
            SET balance = balance - (comm_merchant + comm_driver),
                held_balance = GREATEST(held_balance - NEW.total_amount, 0),
                updated_at = NOW()
            WHERE profile_id = NEW.driver_id;

            -- Kirim Hasil ke Merchant
            SELECT owner_id INTO m_owner_id FROM stores WHERE id = NEW.store_id;
            IF m_owner_id IS NOT NULL THEN
                UPDATE public.wallets
                SET balance = balance + (NEW.total_item_price - comm_merchant),
                    updated_at = NOW()
                WHERE profile_id = m_owner_id;
            END IF;

            -- Catat di ledger transaksi
            INSERT INTO public.transactions (profile_id, order_id, type, amount, description)
            VALUES (NEW.driver_id, NEW.id, 'debit', comm_merchant + comm_driver, 'Komisi platform');

            INSERT INTO public.transactions (profile_id, order_id, type, amount, description)
            VALUES (m_owner_id, NEW.id, 'credit', NEW.total_item_price - comm_merchant, 'Pembayaran order');
        ELSE
            -- Saldo driver tidak cukup, tetap proses tapi flag
            UPDATE public.wallets
            SET held_balance = GREATEST(held_balance - NEW.total_amount, 0),
                updated_at = NOW()
            WHERE profile_id = NEW.driver_id;
        END IF;
    END IF;

    -- Handle cancellation: release held_balance
    IF (NEW.status = 'cancelled' AND OLD.status != 'cancelled' AND NEW.driver_id IS NOT NULL) THEN
        UPDATE public.wallets
        SET held_balance = GREATEST(held_balance - (NEW.total_item_price + NEW.shipping_fee + NEW.app_fee), 0),
            updated_at = NOW()
        WHERE profile_id = NEW.driver_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_order_status_changed
  AFTER UPDATE ON public.orders
  FOR EACH ROW EXECUTE PROCEDURE public.process_transaction_fees();

-- Fungsi: Hold balance saat driver accept order (COD)
CREATE OR REPLACE FUNCTION public.hold_driver_balance()
RETURNS trigger AS $$
BEGIN
    IF (NEW.driver_id IS NOT NULL AND OLD.driver_id IS NULL) THEN
        UPDATE public.wallets
        SET held_balance = held_balance + (NEW.total_item_price + NEW.shipping_fee + NEW.app_fee),
            updated_at = NOW()
        WHERE profile_id = NEW.driver_id;

        INSERT INTO public.transactions (profile_id, order_id, type, amount, description)
        VALUES (NEW.driver_id, NEW.id, 'hold', NEW.total_item_price + NEW.shipping_fee + NEW.app_fee, 'Hold saldo order COD');
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_driver_assigned
  AFTER UPDATE ON public.orders
  FOR EACH ROW EXECUTE PROCEDURE public.hold_driver_balance();
```

### View

```sql
CREATE VIEW order_summary AS
SELECT
    o.id,
    o.status,
    o.type,
    o.payment_method,
    b.full_name as buyer_name,
    s.store_name,
    d.full_name as driver_name,
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

CREATE VIEW user_wallet_summary AS
SELECT
    p.id as profile_id,
    p.full_name,
    p.roles,
    w.balance,
    w.held_balance,
    (w.balance + w.held_balance) as total_assets
FROM profiles p
JOIN wallets w ON p.id = w.profile_id;
```

---

## Isar Collections (Local Storage / Offline Mode)

> **Catatan:** Isar digunakan untuk caching data lokal & offline mode di sisi Flutter.
> Schema didefinisikan dalam Dart classes dengan anotasi `@collection`.
> Auto-generate via `dart run build_runner build`.

```dart
// lib/data/local/isar_collections.dart
import 'package:isar/isar.dart';

part 'isar_collections.g.dart';

// ==========================================
// CART ITEMS (Keranjang Belanja Offline)
// ==========================================

@collection
class CartItem {
  Id id = Isar.autoIncrement;
  late String offeringId;
  late String storeId;
  late String name;
  late double price;
  int quantity = 1;
  late String? imageUrl;
  @Enumerated(EnumType.name)
  late OfferingType type; // product atau service
}

// ==========================================
// CACHED OFFERINGS (Produk/Jasa Cache)
// ==========================================

@collection
class CachedOffering {
  Id id = Isar.autoIncrement;
  late String offeringId; // UUID dari Supabase
  late String storeId;
  late String? providerId;
  @Enumerated(EnumType.name)
  late OfferingType type;
  late String name;
  late double price;
  String? description;
  String? imageUrl;
  bool isNegotiable = false;
  bool isActive = true;
  late DateTime cachedAt;
}

// ==========================================
// CACHED STORES (Toko Cache)
// ==========================================

@collection
class CachedStore {
  Id id = Isar.autoIncrement;
  late String storeId; // UUID dari Supabase
  late String ownerId;
  late String storeName;
  String? description;
  String? category;
  double? lat;
  double? lng;
  double averageRating = 0.0;
  bool isActive = true;
  late DateTime cachedAt;
}

// ==========================================
// OFFLINE ORDERS (Draft Order)
// ==========================================

@collection
class OfflineOrder {
  Id id = Isar.autoIncrement;
  String? supabaseOrderId; // null jika belum disinkron
  late String buyerId;
  String? driverId;
  late String storeId;
  @Enumerated(EnumType.name)
  late OrderType type;
  @Enumerated(EnumType.name)
  late OrderStatus status;
  @Enumerated(EnumType.name)
  late PaymentMethod paymentMethod;
  late double totalItemPrice;
  late double shippingFee;
  late double appFee;
  late double totalAmount;
  double? destLat;
  double? destLng;
  String? destAddress;
  DateTime? scheduledAt;
  late DateTime createdAt;
  bool isSynced = false; // apakah sudah dikirim ke Supabase
}

// ==========================================
// ENUMS
// ==========================================

enum OfferingType { product, service }

enum OrderType { food, marketplace, send, service }

enum OrderStatus {
  pending,
  searching_driver,
  driver_found,
  driver_to_merchant,
  picked_up,
  driver_to_customer,
  delivered,
  cancelled
}

enum PaymentMethod { xendit, cod }
```

### Isar Workflow

```bash
# 1. Edit collections di isar_collections.dart
# 2. Generate Isar schema
dart run build_runner build

# 3. Use in Flutter
final isar = await Isar.open([CartItemSchema, CachedOfferingSchema, ...]);

// Query
final cart = await isar.cartItems.where().findAll();

// Insert
await isar.writeTxn(() async {
  await isar.cartItems.put(CartItem()..offeringId = 'xxx'..name = 'Produk');
});

// Delete
await isar.writeTxn(() async {
  await isar.cartItems.delete(id);
});
```

---

## Flutter Data Layer Architecture

```
lib/
├── data/
│   ├── local/              # Isar collections & DAO
│   │   ├── isar_collections.dart
│   │   ├── isar_collections.g.dart
│   │   └── local_database.dart    # Isar initialization
│   ├── remote/             # Supabase services
│   │   ├── supabase_client.dart   # Supabase instance
│   │   ├── auth_service.dart
│   │   ├── order_service.dart
│   │   ├── wallet_service.dart
│   │   └── ...
│   ├── models/             # Dart data classes
│   │   ├── profile.dart
│   │   ├── order.dart
│   │   └── ...
│   └── repositories/       # Repository pattern (cache + remote)
│       ├── auth_repository.dart
│       ├── order_repository.dart
│       └── ...
├── providers/              # Riverpod providers
│   ├── auth_provider.dart
│   ├── order_provider.dart
│   └── ...
├── features/               # Feature-first structure
│   ├── auth/
│   ├── home/
│   ├── marketplace/
│   ├── send/
│   ├── service/
│   ├── orders/
│   ├── tracking/
│   ├── chat/
│   ├── wallet/
│   └── profile/
├── core/                   # Shared utilities
│   ├── theme/
│   ├── constants/
│   ├── utils/
│   └── widgets/
└── main.dart
```

### Supabase Client Setup

```dart
// lib/data/remote/supabase_client.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  late final SupabaseClient client;

  Future<void> initialize() async {
    await Supabase.initialize(
      url: 'YOUR_SUPABASE_URL',
      anonKey: 'YOUR_SUPABASE_ANON_KEY',
    );
    client = Supabase.instance.client;
  }
}

// Query example
final orders = await SupabaseService()
    .client
    .from('orders')
    .select('*, order_items(*)')
    .eq('buyer_id', userId)
    .order('created_at', ascending: false);
```

### Riverpod Provider Example

```dart
// lib/providers/order_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'order_provider.g.dart';

@riverpod
Future<List<Order>> userOrders(Ref ref, String userId) async {
  final orders = await SupabaseService()
      .client
      .from('orders')
      .select()
      .eq('buyer_id', userId)
      .order('created_at', ascending: false);

  return orders.map((o) => Order.fromJson(o)).toList();
}

@riverpod
Stream<Order?> orderStream(Ref ref, String orderId) {
  return SupabaseService()
      .client
      .from('orders')
      .stream(primaryKey: ['id'])
      .eq('id', orderId)
      .map((data) => data.isNotEmpty ? Order.fromJson(data.first) : null);
}
```

---

## Dokumen Panduan UI/UX: GEMA App

### 1. Identitas Visual (Branding)

- **Warna Utama: Hijau Zamrud (Emerald Green)**
  - Hex Code: `#50C878` (Main Emerald)
  - Hex Code: `#2E8B57` (Dark Emerald untuk aksen)
- **Warna Pendukung:**
  - Warning: `#FFCC00` (Kuning Emas - untuk status pending/warning)
  - Danger: `#E74C3C` (Merah - untuk pembatalan/error)
  - Success: `#27AE60` (Hijau - untuk delivered/sukses)
  - Info: `#3498DB` (Biru - untuk in-progress)
- **Identitas Lokal:** Watermark pola ukiran kayu Jepara dengan opasitas rendah (3-5%) pada latar belakang aplikasi.

### 2. Struktur Layout & Navigasi (Gojek-Style)

- **Beranda (Homepage):**
  - Header: Profil singkat & Saldo Wallet (Emerald Wallet).
  - Main Body: Grid Ikon 3x2 atau 4x2 untuk layanan utama:
    - GEMA-Food: Ikon piring/sendok.
    - GEMA-Send: Ikon paket/motor.
    - GEMA-Service: Ikon kunci inggris/palu ukir.
  - Footer: Bottom Navigation Bar (Home, Aktivitas, Chat, Profil).
- **Halaman Transaksi/Peta:**
  - Top 50% Screen: Peta interaktif (flutter_map) menunjukkan rute kurir.
  - Bottom 50% Screen: DraggableScrollableSheet berisi detail: Nama kurir, plat nomor, estimasi waktu, dan tombol chat/telepon.

### 3. Desain Mode (Dual Themes)

| Elemen UI | Light Mode | Dark Mode |
|---|---|---|
| Background Utama | #FFFFFF (Putih Bersih) | #121212 (Deep Black) |
| Card / Surface | #F8F9FA (Abu Muda) | #1E1E1E (Dark Grey) |
| Teks Utama | #2D3436 (Hitam Keabuan) | #E0E0E0 (Putih Tulang) |
| Aksen Ukiran | Abu-abu sangat muda | Emerald gelap (opasitas 5%) |

### 4. Komponen UI Utama (Reusable Widgets)

- **Buttons:** `ElevatedButton` / `FilledButton` dengan `borderRadius: BorderRadius.circular(10)`.
- **Cards:** `Card` dengan `elevation: 2` (light mode), `shape: RoundedRectangleBorder(borderSide: BorderSide())` (dark mode).
- **Inputs:** `TextField` dengan `focusedBorderColor: EmeraldGreen`.
- **Status Badges:** `Chip` dengan warna dinamis berdasarkan status order.
- **Loading:** `Shimmer` package untuk skeleton loading.
- **Dialogs:** `showModalBottomSheet` untuk action sheets, `AlertDialog` untuk konfirmasi.

### 5. User Experience (UX) Principles

- **Haptic Feedback:** `HapticFeedback.lightImpact()` saat menekan tombol penting.
- **Visual Feedback:** Shimmer loading saat data fetch dari Supabase.
- **Real-time Interaction:** `StreamBuilder` + Supabase Realtime untuk update status order instan.
- **Error Handling:** `SnackBar` untuk error, retry button untuk failed requests.
- **Offline Support:** Keranjang & cached data di Isar, browse produk tanpa internet.

### 6. Offline & Sync Strategy

- **Isar Database:** Cache produk, toko, dan keranjang belanja untuk akses offline.
- **Sync Queue:** Order yang dibuat saat offline masuk ke `OfflineOrder` collection, auto-sync saat online kembali.
- **Connectivity Check:** `connectivity_plus` package untuk deteksi status jaringan.
- **Push Notifications:** Firebase Cloud Messaging untuk notifikasi order status, chat baru, dan promo.

### 7. Keamanan & Compliance

- **Rate Limiting:** Max 10 requests/menit per user untuk endpoint order dan login (Supabase Edge Function).
- **Image Optimization:** Supabase Storage, max 5MB per gambar, format WebP/JPG/PNG, `cached_network_image` untuk caching.
- **Data Privacy:** Sesuai UU PDP Indonesia — data pribadi hanya digunakan untuk operasional app, user bisa request hapus akun.
- **Input Validation:** Form validation dengan Dart native + `formz` atau `super_form_validation`.
- **Secure Storage:** `flutter_secure_storage` untuk menyimpan tokens & sensitive data.

### 8. Design System & Flutter Stack

| Komponen | Pilihan | Alasan |
|---|---|---|
| **UI Framework** | Material 3 (built-in) | Native Flutter, konsisten, theming mudah |
| **Icons** | Material Icons + Lucide Icons | Clean, 2000+ icons, konsisten |
| **Animations** | flutter_animate + implicit animations | Smooth transitions, declarative |
| **Forms** | Formz + native TextFormField | Type-safe validation, clean API |
| **Maps** | flutter_map | OpenStreetMap, gratis, tanpa API key |
| **Charts (Admin)** | fl_chart | Beautiful, customizable, ringan |
| **Toast/Snackbar** | fluttertoast + SnackBar | Elegant, lightweight |
| **Image Cache** | cached_network_image | Auto-caching, placeholder, error widget |
| **State Management** | Riverpod + riverpod_generator | Compile-safe, auto-dispose, testable |

### 9. Flutter Project Structure

```
gema_app/
├── android/                    # Android config
├── ios/                        # iOS config
├── lib/
│   ├── main.dart               # App entry point
│   ├── app.dart                # MaterialApp + go_router
│   ├── core/
│   │   ├── theme/
│   │   │   ├── app_theme.dart       # ThemeData (light/dark)
│   │   │   └── colors.dart          # Emerald color constants
│   │   ├── constants/
│   │   │   ├── api_constants.dart   # Supabase URL, Xendit keys
│   │   │   └── app_constants.dart   # App-wide constants
│   │   ├── utils/
│   │   │   ├── haversine.dart       # Hitung jarak & ongkir
│   │   │   ├── formatters.dart      # Currency, date formatting
│   │   │   └── validators.dart      # Input validation
│   │   └── widgets/
│   │       ├── empty_state.dart
│   │       ├── error_widget.dart
│   │       ├── loading_shimmer.dart
│   │       └── status_badge.dart
│   ├── data/
│   │   ├── local/
│   │   │   ├── isar_collections.dart
│   │   │   └── local_database.dart
│   │   ├── remote/
│   │   │   ├── supabase_client.dart
│   │   │   ├── auth_service.dart
│   │   │   ├── order_service.dart
│   │   │   ├── wallet_service.dart
│   │   │   └── chat_service.dart
│   │   ├── models/
│   │   │   ├── profile.dart
│   │   │   ├── order.dart
│   │   │   ├── wallet.dart
│   │   │   └── ...
│   │   └── repositories/
│   │       ├── auth_repository.dart
│   │       ├── order_repository.dart
│   │       └── ...
│   ├── providers/
│   │   ├── auth_provider.dart
│   │   ├── order_provider.dart
│   │   ├── wallet_provider.dart
│   │   └── ...
│   └── features/
│       ├── auth/
│       │   ├── screens/
│       │   │   ├── login_screen.dart
│       │   │   └── register_screen.dart
│       │   └── widgets/
│       ├── home/
│       │   ├── screens/home_screen.dart
│       │   └── widgets/service_grid.dart
│       ├── marketplace/
│       │   ├── screens/
│       │   └── widgets/
│       ├── send/
│       ├── service/
│       ├── orders/
│       ├── tracking/
│       │   ├── screens/tracking_screen.dart
│       │   └── widgets/live_map.dart
│       ├── chat/
│       ├── wallet/
│       └── profile/
├── assets/
│   ├── images/                 # Logo, icons, illustrations
│   └── fonts/                  # Custom fonts
├── test/                       # Unit & widget tests
├── pubspec.yaml                # Dependencies
└── codemagic.yaml              # CI/CD config
```

### 10. Emerald Theme (Flutter ThemeData)

```dart
// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static const emeraldPrimary = Color(0xFF50C878);
  static const emeraldDark = Color(0xFF2E8B57);
  static const warning = Color(0xFFFFCC00);
  static const danger = Color(0xFFE74C3C);
  static const success = Color(0xFF27AE60);
  static const info = Color(0xFF3498DB);

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.light(
          primary: emeraldPrimary,
          secondary: emeraldDark,
          surface: const Color(0xFFF8F9FA),
          error: danger,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: emeraldPrimary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: emeraldPrimary, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: emeraldPrimary,
          secondary: emeraldDark,
          surface: const Color(0xFF1E1E1E),
          error: danger,
        ),
        cardTheme: CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFF333333)),
          ),
        ),
      );
}
```

---

## Master Checklist Data Teknis

Sebelum memulai development, pastikan kamu sudah menyimpan ini:

- [ ] Supabase URL & Key (Untuk database, auth, storage, realtime).
- [ ] Xendit API Key (Untuk pembayaran & withdrawal).
- [ ] OpenRouter API Key (Untuk asisten coding).
- [ ] Logo GEMA (Format SVG/PNG untuk Flutter assets).
- [ ] Firebase Project + google-services.json & GoogleService-Info.plist (Untuk push notifications).
- [ ] Codemagic Account (Untuk build iOS di cloud).
- [ ] Apple Developer Account ($99/tahun, untuk submit ke App Store).
- [ ] Google Play Developer Account ($25 sekali bayar, untuk submit ke Play Store).

---

## Roadmap Development (Phased Approach)

### Phase 1: Foundation (Minggu 1-2)
- [ ] Setup Flutter project + dependencies (Riverpod, Supabase, Isar, go_router)
- [ ] Setup Supabase database schema & RLS policies
- [ ] Auth (login/register dengan Supabase Auth)
- [ ] Profile management & address management
- [ ] Wallet system (balance, held_balance)
- [ ] Isar local database setup

### Phase 2: Marketplace & Stores (Minggu 3-4)
- [ ] CRUD Toko & Produk/Jasa
- [ ] Katalog produk dengan filter & search
- [ ] Shopping cart (Isar offline) & checkout
- [ ] Image upload ke Supabase Storage
- [ ] Emerald theme implementation (light/dark)

### Phase 3: Orders & Payment (Minggu 5-6)
- [ ] Order creation & status management
- [ ] Xendit payment integration (QRIS, VA, E-Wallet)
- [ ] COD flow dengan held_balance
- [ ] Transaction ledger & withdrawal
- [ ] Real-time order status (Supabase Realtime)

### Phase 4: Driver & Logistics (Minggu 7-8)
- [ ] Driver dispatching system
- [ ] Real-time tracking dengan flutter_map
- [ ] Haversine formula untuk ongkir
- [ ] Order status lifecycle lengkap
- [ ] Background location updates (geolocator)

### Phase 5: Social & Polish (Minggu 9-10)
- [ ] Chat system (buyer ↔ driver, buyer ↔ merchant)
- [ ] Rating & review system
- [ ] Push notifications (Firebase)
- [ ] Offline mode & sync queue (Isar)

### Phase 6: Testing & Launch (Minggu 11-12)
- [ ] Unit & widget testing
- [ ] Security audit (RLS policies, secure storage)
- [ ] Performance optimization (image caching, lazy loading)
- [ ] Build APK/AAB (Android) + IPA (iOS via Codemagic)
- [ ] Submit ke Google Play Store & Apple App Store

---

## CI/CD Pipeline (Codemagic)

```yaml
# codemagic.yaml
workflows:
  ios-release:
    name: iOS Release
    instance_type: mac_mini_m1
    max_build_duration: 60
    environment:
      ios_signing:
        distribution_type: app_store
        bundle_identifier: com.emeraldtech.gema
    scripts:
      - name: Install dependencies
        script: |
          flutter pub get
      - name: Build iOS
        script: |
          flutter build ipa --release --export-options-plist=/Users/builder/export_options.plist
    artifacts:
      - build/ios/ipa/*.ipa
    publishing:
      app_store_connect:
        auth: integration
        submit_to_testflight: true
        submit_to_app_store: true

  android-release:
    name: Android Release
    instance_type: linux
    max_build_duration: 60
    environment:
      android_signing:
        - keystore_reference
    scripts:
      - name: Install dependencies
        script: |
          flutter pub get
      - name: Build Android
        script: |
          flutter build appbundle --release
    artifacts:
      - build/**/outputs/**/*.aab
    publishing:
      google_play:
        credentials: $GCLOUD_SERVICE_ACCOUNT_CREDENTIALS
        track: internal
```
