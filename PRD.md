# Project Requirement Document (PRD): GEMA App

**Versi:** 2.1 (Flutter Edition - Premium UI/UX)
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

### 1. Identitas Visual (Branding Premium)

- **Warna Utama: Hijau Zamrud (Emerald Green) — Gradient**
  - Primary Gradient: `#50C878` → `#34D399` → `#2E8B57`
  - Solid Primary: `#50C878` (fallback)
  - Dark Emerald: `#1B5E3B` (untuk dark mode accents)
- **Warna Premium:**
  - Gold Accent: `#FFD700` (untuk wallet, premium features, rating bintang)
  - Warning: `#FFB800` (lebih soft dari kuning standar)
  - Danger: `#FF4757` (modern red, bukan `#E74C3C` yang jadul)
  - Success: `#2ED573` (vibrant green)
  - Info: `#5B9FFF` (modern blue, bukan `#3498DB`)
- **Neutral Palette:**
  - Background Light: `#F8FAFB` (bukan putih polos — ada hint biru sangat halus)
  - Background Dark: `#0A0A0A` (deep black, bukan `#121212`)
  - Surface Light: `#FFFFFF` dengan opacity 80% (glass effect)
  - Surface Dark: `#1A1A1A` dengan border `#2A2A2A`
  - Text Primary Light: `#1A1A2E` (deep navy-black, bukan hitam biasa)
  - Text Primary Dark: `#F0F0F0` (warm white)
  - Text Secondary: `#6B7280` (cool gray)
- **Identitas Lokal:** Watermark pola ukiran kayu Jepara dengan opasitas sangat rendah (2-3%) sebagai subtle pattern di background, bukan elemen dominan.

### 2. Design Language: Glassmorphism + Gradient

**Filosofi Design:** Tampilan mewah, modern, dan premium — seperti aplikasi iOS 17/18 atau aplikasi fintech kelas atas. Tidak terlihat "jadul" atau "murah".

#### Glassmorphism Cards
- Background semi-transparan dengan `backdrop blur` effect
- Border tipis dengan gradient subtle (`rgba(255,255,255,0.2)` → `rgba(255,255,255,0.05)`)
- Shadow lembut yang dalam, bukan shadow keras
- `borderRadius: 20` minimum untuk semua cards

#### Gradient Elements
- **Tombol Primary:** Linear gradient `#50C878` → `#34D399` dengan subtle glow
- **Tombol Secondary:** Outlined button dengan border gradient
- **Header/AppBar:** Gradient transparan → solid saat scroll
- **Service Cards:** Setiap layanan punya gradient unik:
  - GEMA-Food: `#50C878` → `#34D399` (Emerald)
  - GEMA-Send: `#5B9FFF` → `#3B82F6` (Blue)
  - GEMA-Service: `#FFB800` → `#F59E0B` (Gold)

#### Micro-Interactions
- **Button Press:** Scale down 0.97 + shadow reduction
- **Card Hover/Tap:** Subtle lift effect (elevation increase)
- **Page Transitions:** Shared axis atau fade through (bukan slide biasa)
- **List Items:** Staggered fade-in animation saat muncul
- **Pull to Refresh:** Custom indicator dengan logo GEMA yang rotate

### 3. Struktur Layout & Navigasi (Modern Premium)

- **Beranda (Homepage):**
  - **AppBar:** Transparent dengan blur effect, menampilkan greeting ("Selamat Pagi, [Nama]!") + avatar + notifikasi bell dengan badge
  - **Wallet Card:** Glassmorphism card dengan gradient emerald subtle, menampilkan saldo + quick actions (Top Up, Withdraw)
  - **Service Grid:** Bukan icon grid biasa — setiap layanan adalah **card besar** dengan:
    - Gradient background unik per layanan
    - Phosphor Icon besar (32-40px) dengan warna putih
    - Label di bawah icon
    - Subtle shadow + border radius 20px
  - **Promo Banner:** Horizontal scrollable carousel dengan glass overlay
  - **Bottom Navigation:** **Floating style** (tidak nempel tepi bawah, ada margin 12px dari bawah & samping), dengan:
    - Active icon: Filled Phosphor Icon + gradient background pill
    - Inactive icon: Light Phosphor Icon + label kecil
    - Blur background pada nav bar

- **Halaman Transaksi/Peta:**
  - Full screen map dengan glassmorphism overlay
  - **DraggableScrollableSheet** dengan glass effect:
    - Background: `rgba(255,255,255,0.85)` + backdrop blur
    - Border radius top: 24px
    - Driver info: Avatar besar + nama + rating bintang gold + plat nomor
    - ETA dengan countdown timer
    - Action buttons: Chat (gradient blue), Telepon (gradient green), Emergency (gradient red)

### 4. Desain Mode (Dual Themes — Premium)

| Elemen UI | Light Mode | Dark Mode |
|---|---|---|
| Background | `#F8FAFB` (hint biru halus) | `#0A0A0A` (deep black) |
| Glass Card | `rgba(255,255,255,0.8)` + blur 20px | `rgba(26,26,26,0.8)` + blur 20px |
| Card Border | `rgba(255,255,255,0.5)` 1px | `rgba(255,255,255,0.08)` 1px |
| Card Shadow | `0 8px 32px rgba(0,0,0,0.08)` | `0 8px 32px rgba(0,0,0,0.3)` |
| Teks Utama | `#1A1A2E` (deep navy-black) | `#F0F0F0` (warm white) |
| Teks Secondary | `#6B7280` (cool gray) | `#9CA3AF` (medium gray) |
| Primary Gradient | `#50C878` → `#34D399` | `#34D399` → `#2E8B57` |
| Bottom Nav | Glass white + blur | Glass dark + blur |

### 5. Tipografi (Premium Font Stack)

**Jangan pakai Roboto default — terlihat jadul dan terlalu "Android".**

| Penggunaan | Font | Weight | Size Range |
|---|---|---|---|
| **Heading Besar** | Plus Jakarta Sans | Bold (700) | 24-32px |
| **Heading Medium** | Plus Jakarta Sans | SemiBold (600) | 18-22px |
| **Subheading** | Plus Jakarta Sans | Medium (500) | 14-16px |
| **Body Text** | Inter | Regular (400) | 14-16px |
| **Body Bold** | Inter | Medium (500) | 14px |
| **Harga/Angka** | DM Sans | SemiBold (600) | 16-24px |
| **Caption/Label** | Inter | Regular (400) | 12px |
| **Button Text** | Plus Jakarta Sans | SemiBold (600) | 14-16px |

**Font Loading (pubspec.yaml):**
```yaml
fonts:
  - family: PlusJakartaSans
    fonts:
      - asset: assets/fonts/PlusJakartaSans-Regular.ttf
      - asset: assets/fonts/PlusJakartaSans-Medium.ttf (weight: 500)
      - asset: assets/fonts/PlusJakartaSans-SemiBold.ttf (weight: 600)
      - asset: assets/fonts/PlusJakartaSans-Bold.ttf (weight: 700)
  - family: Inter
    fonts:
      - asset: assets/fonts/Inter-Regular.ttf
      - asset: assets/fonts/Inter-Medium.ttf (weight: 500)
  - family: DMSans
    fonts:
      - asset: assets/fonts/DMSans-Regular.ttf
      - asset: assets/fonts/DMSans-SemiBold.ttf (weight: 600)
```

### 6. Icon System (Phosphor Icons)

**Package:** `phosphor_flutter` — premium, dual-tone, sangat modern.

| Konteks | Icon Style | Size |
|---|---|---|
| **Bottom Nav** | `PhosphorIconsStyle.fill` (active) / `PhosphorIconsStyle.regular` (inactive) | 24px |
| **Service Cards** | `PhosphorIconsStyle.duotone` | 32-40px |
| **Action Buttons** | `PhosphorIconsStyle.bold` | 20px |
| **List Items** | `PhosphorIconsStyle.regular` | 20px |
| **Status Icons** | `PhosphorIconsStyle.fill` | 16-20px |

**Icon Mapping untuk Layanan Utama:**
- GEMA-Food: `PhosphorIcons.forkKnife` (duotone)
- GEMA-Send: `PhosphorIcons.package` (duotone)
- GEMA-Service: `PhosphorIcons.wrench` (duotone)
- Wallet: `PhosphorIcons.wallet` (duotone)
- Chat: `PhosphorIcons.chatCircleDots` (duotone)
- Tracking: `PhosphorIcons.mapPinLine` (duotone)
- Profile: `PhosphorIcons.userCircle` (duotone)
- Notification: `PhosphorIcons.bell` (regular/fill)

### 7. Komponen UI Utama (Premium Reusable Widgets)

#### Gradient Button (Primary CTA)
```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFF50C878), Color(0xFF34D399)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Color(0xFF50C878).withOpacity(0.4),
        blurRadius: 12,
        offset: Offset(0, 4),
      ),
    ],
  ),
  child: Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        child: Text(label, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    ),
  ),
)
```

#### Glass Card
```dart
ClipRRect(
  borderRadius: BorderRadius.circular(20),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
    child: Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: child,
    ),
  ),
)
```

#### Floating Bottom Navigation
```dart
// Margin dari tepi: 12px bottom, 16px left/right
Container(
  margin: EdgeInsets.fromLTRB(16, 0, 16, 12),
  decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.9),
    borderRadius: BorderRadius.circular(24),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 20,
        offset: Offset(0, 4),
      ),
    ],
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(24),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
      child: BottomNavigationBar(...),
    ),
  ),
)
```

#### Status Badge (Gradient)
```dart
// pending → gold gradient, delivered → green gradient, cancelled → red gradient
Container(
  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  decoration: BoxDecoration(
    gradient: LinearGradient(colors: statusColors),
    borderRadius: BorderRadius.circular(20),
  ),
  child: Text(statusLabel, style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
)
```

#### Shimmer Loading (Premium)
```dart
// Gunakan package: shimmer
Shimmer.fromColors(
  baseColor: Colors.grey[300]!,
  highlightColor: Colors.grey[100]!,
  child: Container(
    height: 200,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
  ),
)
```

### 8. User Experience (UX) Principles — Premium

- **Haptic Feedback:**
  - `HapticFeedback.lightImpact()` — tombol biasa
  - `HapticFeedback.mediumImpact()` — aksi penting (checkout, confirm)
  - `HapticFeedback.heavyImpact()` — success/error state
  - `HapticFeedback.selectionClick()` — scroll snap, picker

- **Visual Feedback:**
  - Staggered animation: List items muncul satu per satu (delay 50ms)
  - Hero animations: Transisi halaman dengan shared element
  - Skeleton shimmer: Gradient animation, bukan pulsing dot
  - Pull-to-refresh: Custom GEMA logo yang rotate

- **Real-time Interaction:**
  - Supabase Realtime + `StreamBuilder` untuk update order instan
  - Live location tracking di peta dengan smooth polyline animation
  - Chat typing indicator + read receipts

- **Error Handling:**
  - Custom error screen dengan illustration (bukan teks error biasa)
  - Retry button dengan gradient style
  - Toast notification (package: `toastification`) — elegant, auto-dismiss

- **Offline Support:**
  - Isar untuk cache produk, toko, keranjang
  - Offline indicator bar (gradient red) di top app saat tidak ada koneksi
  - Auto-sync queue saat kembali online

### 9. Offline & Sync Strategy

- **Isar Database:** Cache produk, toko, dan keranjang belanja untuk akses offline.
- **Sync Queue:** Order yang dibuat saat offline masuk ke `OfflineOrder` collection, auto-sync saat online kembali.
- **Connectivity Check:** `connectivity_plus` package untuk deteksi status jaringan.
- **Push Notifications:** Firebase Cloud Messaging untuk notifikasi order status, chat baru, dan promo.

### 10. Keamanan & Compliance

- **Rate Limiting:** Max 10 requests/menit per user untuk endpoint order dan login (Supabase Edge Function).
- **Image Optimization:** Supabase Storage, max 5MB per gambar, format WebP/JPG/PNG, `cached_network_image` untuk caching.
- **Data Privacy:** Sesuai UU PDP Indonesia — data pribadi hanya digunakan untuk operasional app, user bisa request hapus akun.
- **Input Validation:** Form validation dengan Dart native + `formz` atau `super_form_validation`.
- **Secure Storage:** `flutter_secure_storage` untuk menyimpan tokens & sensitive data.

### 11. Design System & Flutter Stack (Premium)

| Komponen | Pilihan | Alasan |
|---|---|---|
| **UI Framework** | Material 3 (built-in) | Native Flutter, konsisten, theming mudah |
| **Icons** | **Phosphor Icons** (`phosphor_flutter`) | Premium, dual-tone, sangat modern — bukan Material Icons jadul |
| **Fonts** | Plus Jakarta Sans + Inter + DM Sans | Modern, premium feel, bukan Roboto |
| **Glass Effect** | `dart:ui` ImageFilter.blur | Native Flutter, performa tinggi |
| **Animations** | `flutter_animate` + implicit animations | Smooth, declarative, staggered support |
| **Forms** | Formz + native TextFormField | Type-safe validation, clean API |
| **Maps** | flutter_map | OpenStreetMap, gratis, tanpa API key |
| **Charts (Admin)** | fl_chart | Beautiful, customizable, ringan |
| **Toast** | `toastification` | Modern, elegant, auto-dismiss, gradient support |
| **Shimmer** | `shimmer` | Gradient loading animation |
| **Image Cache** | cached_network_image | Auto-caching, placeholder, error widget |
| **State Management** | Riverpod + riverpod_generator | Compile-safe, auto-dispose, testable |

### 12. Flutter Project Structure

```
gema_app/
├── android/                    # Android config
├── ios/                        # iOS config
├── lib/
│   ├── main.dart               # App entry point
│   ├── app.dart                # MaterialApp + go_router
│   ├── core/
│   │   ├── theme/
│   │   │   ├── app_theme.dart       # ThemeData (light/dark + glassmorphism)
│   │   │   ├── colors.dart          # Emerald gradient + premium palette
│   │   │   ├── typography.dart      # Plus Jakarta Sans + Inter + DM Sans
│   │   │   └── shadows.dart         # Premium shadow presets
│   │   ├── constants/
│   │   │   ├── api_constants.dart   # Supabase URL, Xendit keys
│   │   │   └── app_constants.dart   # App-wide constants
│   │   ├── utils/
│   │   │   ├── haversine.dart       # Hitung jarak & ongkir
│   │   │   ├── formatters.dart      # Currency, date formatting
│   │   │   └── validators.dart      # Input validation
│   │   └── widgets/
│   │       ├── glass_card.dart          # Glassmorphism card reusable
│   │       ├── gradient_button.dart     # Premium gradient CTA
│   │       ├── floating_nav_bar.dart    # Floating bottom navigation
│   │       ├── status_badge.dart        # Gradient status badge
│   │       ├── shimmer_loader.dart      # Premium skeleton loading
│   │       ├── empty_state.dart         # Illustration + CTA
│   │       ├── error_screen.dart        # Custom error with retry
│   │       └── service_card.dart        # Home service grid card
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
│       │   └── widgets/
│       │       ├── wallet_card.dart
│       │       ├── service_grid.dart
│       │       └── promo_carousel.dart
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
│   ├── fonts/                  # Plus Jakarta Sans, Inter, DM Sans
│   └── patterns/               # Ukiran Jepara subtle pattern
├── test/                       # Unit & widget tests
├── pubspec.yaml                # Dependencies
└── codemagic.yaml              # CI/CD config
```

### 13. Emerald Premium Theme (Flutter ThemeData — Glassmorphism + Gradient)

```dart
// lib/core/theme/app_theme.dart
import 'dart:ui';
import 'package:flutter/material.dart';

class AppTheme {
  // ==========================================
  // COLOR PALETTE (Premium)
  // ==========================================
  static const emeraldPrimary = Color(0xFF50C878);
  static const emeraldLight = Color(0xFF34D399);
  static const emeraldDark = Color(0xFF1B5E3B);
  static const goldAccent = Color(0xFFFFD700);
  static const warning = Color(0xFFFFB800);
  static const danger = Color(0xFFFF4757);
  static const success = Color(0xFF2ED573);
  static const info = Color(0xFF5B9FFF);

  // Neutral
  static const bgLight = Color(0xFFF8FAFB);
  static const bgDark = Color(0xFF0A0A0A);
  static const surfaceLight = Color(0xFFFFFFFF);
  static const surfaceDark = Color(0xFF1A1A1A);
  static const textPrimaryLight = Color(0xFF1A1A2E);
  static const textPrimaryDark = Color(0xFFF0F0F0);
  static const textSecondary = Color(0xFF6B7280);
  static const textSecondaryDark = Color(0xFF9CA3AF);

  // Gradients
  static const emeraldGradient = LinearGradient(
    colors: [emeraldPrimary, emeraldLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const goldGradient = LinearGradient(
    colors: [Color(0xFFFFB800), Color(0xFFF59E0B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ==========================================
  // SHADOWS (Premium)
  // ==========================================
  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get glowShadow => [
        BoxShadow(
          color: emeraldPrimary.withOpacity(0.4),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  // ==========================================
  // TYPOGRAPHY
  // ==========================================
  static const headingFont = 'PlusJakartaSans';
  static const bodyFont = 'Inter';
  static const numberFont = 'DMSans';

  // ==========================================
  // LIGHT THEME
  // ==========================================
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        fontFamily: bodyFont,
        scaffoldBackgroundColor: bgLight,
        colorScheme: ColorScheme.light(
          primary: emeraldPrimary,
          secondary: emeraldLight,
          surface: surfaceLight,
          error: danger,
          onPrimary: Colors.white,
          onSurface: textPrimaryLight,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontFamily: headingFont,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: textPrimaryLight,
          ),
          iconTheme: IconThemeData(color: textPrimaryLight),
        ),
        cardTheme: CardTheme(
          elevation: 0,
          color: surfaceLight.withOpacity(0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.white.withOpacity(0.5), width: 1.5),
          ),
          shadowColor: Colors.black.withOpacity(0.08),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: emeraldPrimary,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontFamily: headingFont,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surfaceLight,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: emeraldPrimary, width: 2),
            borderRadius: BorderRadius.circular(16),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
            borderRadius: BorderRadius.circular(16),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: danger, width: 1.5),
            borderRadius: BorderRadius.circular(16),
          ),
          hintStyle: TextStyle(color: textSecondary, fontSize: 14),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: emeraldPrimary,
          unselectedItemColor: textSecondary,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: headingFont, fontSize: 32, fontWeight: FontWeight.w700, color: textPrimaryLight),
          displayMedium: TextStyle(fontFamily: headingFont, fontSize: 28, fontWeight: FontWeight.w700, color: textPrimaryLight),
          headlineMedium: TextStyle(fontFamily: headingFont, fontSize: 22, fontWeight: FontWeight.w600, color: textPrimaryLight),
          titleLarge: TextStyle(fontFamily: headingFont, fontSize: 18, fontWeight: FontWeight.w600, color: textPrimaryLight),
          titleMedium: TextStyle(fontFamily: headingFont, fontSize: 16, fontWeight: FontWeight.w600, color: textPrimaryLight),
          bodyLarge: TextStyle(fontFamily: bodyFont, fontSize: 16, fontWeight: FontWeight.w400, color: textPrimaryLight),
          bodyMedium: TextStyle(fontFamily: bodyFont, fontSize: 14, fontWeight: FontWeight.w400, color: textPrimaryLight),
          labelLarge: TextStyle(fontFamily: headingFont, fontSize: 14, fontWeight: FontWeight.w600),
          labelSmall: TextStyle(fontFamily: bodyFont, fontSize: 12, fontWeight: FontWeight.w400, color: textSecondary),
        ),
      );

  // ==========================================
  // DARK THEME
  // ==========================================
  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: bodyFont,
        scaffoldBackgroundColor: bgDark,
        colorScheme: ColorScheme.dark(
          primary: emeraldLight,
          secondary: emeraldDark,
          surface: surfaceDark,
          error: danger,
          onPrimary: Colors.white,
          onSurface: textPrimaryDark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontFamily: headingFont,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: textPrimaryDark,
          ),
          iconTheme: IconThemeData(color: textPrimaryDark),
        ),
        cardTheme: CardTheme(
          elevation: 0,
          color: surfaceDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFF2A2A2A), width: 1),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: emeraldLight,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontFamily: headingFont,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1A1A1A),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: emeraldLight, width: 2),
            borderRadius: BorderRadius.circular(16),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF2A2A2A), width: 1.5),
            borderRadius: BorderRadius.circular(16),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: danger, width: 1.5),
            borderRadius: BorderRadius.circular(16),
          ),
          hintStyle: const TextStyle(color: textSecondaryDark, fontSize: 14),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: emeraldLight,
          unselectedItemColor: textSecondaryDark,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: headingFont, fontSize: 32, fontWeight: FontWeight.w700, color: textPrimaryDark),
          displayMedium: TextStyle(fontFamily: headingFont, fontSize: 28, fontWeight: FontWeight.w700, color: textPrimaryDark),
          headlineMedium: TextStyle(fontFamily: headingFont, fontSize: 22, fontWeight: FontWeight.w600, color: textPrimaryDark),
          titleLarge: TextStyle(fontFamily: headingFont, fontSize: 18, fontWeight: FontWeight.w600, color: textPrimaryDark),
          titleMedium: TextStyle(fontFamily: headingFont, fontSize: 16, fontWeight: FontWeight.w600, color: textPrimaryDark),
          bodyLarge: TextStyle(fontFamily: bodyFont, fontSize: 16, fontWeight: FontWeight.w400, color: textPrimaryDark),
          bodyMedium: TextStyle(fontFamily: bodyFont, fontSize: 14, fontWeight: FontWeight.w400, color: textPrimaryDark),
          labelLarge: TextStyle(fontFamily: headingFont, fontSize: 14, fontWeight: FontWeight.w600),
          labelSmall: TextStyle(fontFamily: bodyFont, fontSize: 12, fontWeight: FontWeight.w400, color: textSecondaryDark),
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
- [ ] Premium theme implementation (glassmorphism, gradient, Phosphor Icons, custom fonts)

### Phase 2: Marketplace & Stores (Minggu 3-4)
- [ ] CRUD Toko & Produk/Jasa
- [ ] Katalog produk dengan filter & search
- [ ] Shopping cart (Isar offline) & checkout
- [ ] Image upload ke Supabase Storage
- [ ] Premium UI components (glass cards, gradient buttons, shimmer loading)

### Phase 3: Orders & Payment (Minggu 5-6)
- [ ] Order creation & status management
- [ ] Xendit payment integration (QRIS, VA, E-Wallet)
- [ ] COD flow dengan held_balance
- [ ] Transaction ledger & withdrawal
- [ ] Real-time order status (Supabase Realtime)
- [ ] Premium order tracking UI (gradient status badges, animations)

### Phase 4: Driver & Logistics (Minggu 7-8)
- [ ] Driver dispatching system
- [ ] Real-time tracking dengan flutter_map
- [ ] Haversine formula untuk ongkir
- [ ] Order status lifecycle lengkap
- [ ] Background location updates (geolocator)
- [ ] Premium map overlay (glassmorphism bottom sheet)

### Phase 5: Social & Polish (Minggu 9-10)
- [ ] Chat system (buyer ↔ driver, buyer ↔ merchant)
- [ ] Rating & review system
- [ ] Push notifications (Firebase)
- [ ] Offline mode & sync queue (Isar)
- [ ] Micro-interactions & animations polish

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
