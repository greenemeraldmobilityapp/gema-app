# GEMA Frontend - Roadmap Lengkap Sesuai PRD

Status: ✅ **Frontend UI Dasar Selesai** | 🔄 **Integrasi Backend Dimulai**

---

## 📊 Checklist Progres

### ✅ FASE 1: Foundation (Completed)
- [x] Setup Next.js 16 + TypeScript + Tailwind CSS
- [x] 9 halaman utama (Home, Food, Send, Service, Marketplace, Activity, Chat, Profile, Tracking)
- [x] 10+ komponen reusable (Header, Button, Card, WalletCard, ServiceGrid, TrackingMap)
- [x] Dark/Light mode system
- [x] Responsive design (mobile-first)
- [x] Utility functions (formatCurrency, haversineDistance, calculateShippingFee)
- [x] Global styles & Tailwind configuration
- [x] Error fixes (39 errors → 0 errors)

---

## 🔄 FASE 2: Backend Integration (NEXT STEPS)

### 1️⃣ Konfigurasi Supabase (Priority CRITICAL)
**Purpose**: Koneksi database, authentication, dan real-time features

**Tasks**:
```
[ ] 1. Setup Supabase project di https://supabase.com
[ ] 2. Copy credentials ke .env.local:
      NEXT_PUBLIC_SUPABASE_URL=your_url
      NEXT_PUBLIC_SUPABASE_ANON_KEY=your_key
      SUPABASE_SERVICE_ROLE_KEY=your_key
[ ] 3. Install & configure Supabase client:
      npm install @supabase/supabase-js
[ ] 4. Create Supabase client util: lib/supabase.ts
[ ] 5. Setup auth provider context (lib/AuthContext.tsx)
```

**Files to Create**:
- `lib/supabase.ts` - Supabase client initialization
- `lib/AuthContext.tsx` - Authentication state management
- `components/AuthProvider.tsx` - Auth provider wrapper
- `.env.local` - Environment variables

**Expected Output**:
```typescript
// lib/supabase.ts
import { createClient } from '@supabase/supabase-js'

export const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL,
  process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY
)
```

---

### 2️⃣ Setup Authentication (Priority HIGH)
**Purpose**: Login, signup, logout, session persistence

**Tasks**:
```
[ ] 1. Create auth page: app/auth/page.tsx
      - Login form (email + password)
      - Signup form dengan validasi
      - Password recovery
[ ] 2. Create useAuth hook:
      - Login function
      - Signup function
      - Logout function
      - User monitoring
[ ] 3. Protect routes dengan middleware
      - Redirect unauthenticated users ke /auth
      - Cek role-based access
[ ] 4. Add sign-out button di profile page
[ ] 5. Add loading skeleton saat auth check
[ ] 6. Implement session persistence (localStorage)
```

**Files to Create**:
- `app/auth/page.tsx` - Auth page dengan form
- `hooks/useAuth.ts` - Auth hook
- `middleware.ts` - Route protection middleware
- `components/AuthGuard.tsx` - Auth wrapper component

---

### 3️⃣ Setup Payment Gateway - Xendit (Priority HIGH)
**Purpose**: Integrasi pembayaran QRIS, VA, E-Wallet, COD

**Tasks**:
```
[ ] 1. Setup Xendit account di https://dashboard.xendit.co
[ ] 2. Add Xendit key ke .env.local:
      NEXT_PUBLIC_XENDIT_API_KEY=your_key
      XENDIT_SECRET_KEY=your_secret
[ ] 3. Install Xendit client:
      npm install xendit-node
[ ] 4. Create payment methods page:
      - QRIS
      - Virtual Account (BNI, BRI, Mandiri)
      - E-Wallet (OVO, Dana, LinkAja)
      - COD (Cash on Delivery)
[ ] 5. Create checkout flow:
      app/checkout/page.tsx
      - Review pesanan
      - Pilih metode pembayaran
      - Konfirmasi bayar
[ ] 6. Create invoice/receipt page
[ ] 7. Implement webhook untuk payment confirmation
[ ] 8. Add refund logic (pembatalan pesanan)
```

**Files to Create**:
- `app/checkout/page.tsx` - Checkout page
- `lib/xendit.ts` - Xendit client setup
- `components/PaymentMethods.tsx` - Payment method selector
- `app/api/payment/create-invoice.ts` - Backend endpoint
- `app/api/webhooks/xendit.ts` - Webhook handler

---

### 4️⃣ Database Setup & Initial Data (Priority HIGH)
**Purpose**: Setup database schema, seed data untuk testing

**Tasks**:
```
[ ] 1. Run SQL schema dari PRD.md di Supabase:
      - profiles, wallets, stores, offerings, orders
      - Enable RLS policies
      - Setup triggers untuk automasi
[ ] 2. Create seed script untuk dummy data:
      - 5 toko contoh (Mebel, Kuliner, Fashion)
      - 20+ produk contoh
      - Jasa contoh (ukir, AC, pindahan)
[ ] 3. Setup Supabase functions untuk:
      - Bagi hasil otomatis (15% komisi)
      - Hitung ongkir berdasarkan distance
      - Update order status
[ ] 4. Verify RLS policies berfungsi
```

**Expected Output**:
Database siap dengan:
- 5 stores dengan 20+ products
- 10 service offerings
- Test data untuk setiap kategori

---

## 📱 FASE 3: Feature Implementation

### 5️⃣ Cart & Checkout Flow (Priority HIGH)
**Dependencies**: Xendit payment setup

**Tasks**:
```
[ ] 1. Create cart state management (Zustand):
      - Add to cart
      - Remove from cart
      - Update quantity
      - Clear cart
      - Persist to localStorage
[ ] 2. Enhance marketplace/food pages:
      - Add to cart button per product
      - Show cart count badge di header
      - Side drawer untuk quick cart preview
[ ] 3. Create full checkout page:
      app/checkout/page.tsx
      - Review ordered items
      - Show breakdown harga:
        * Harga barang
        * Biaya ongkir (calculated)
        * Platform fee (Rp2.000)
        * Total
      - Select payment method
      - Confirm & create order
[ ] 4. Hitung ongkir otomatis (gunakan haversineDistance)
[ ] 5. Create order confirmation page
[ ] 6. Validate minimum order amount
```

**Files to Create**:
- `lib/store.ts` - Zustand store untuk cart
- `hooks/useCart.ts` - Cart hook
- `app/checkout/page.tsx` - Checkout page
- `components/CartSummary.tsx` - Cart preview component
- `components/PriceBreakdown.tsx` - Harga detail

---

### 6️⃣ Real-time Order Tracking (Priority MEDIUM)
**Dependencies**: TrackingMap page sudah ada, tinggal integrate

**Tasks**:
```
[ ] 1. Setup Leaflet.js dengan OpenStreetMap:
      npm install leaflet react-leaflet
[ ] 2. Enhance TrackingMap component:
      - Real-time driver location (dari Supabase)
      - Route polyline dari driver ke destination
      - ETA calculation
      - Status badges (OTW, Arrived, etc)
[ ] 3. Setup Supabase real-time subscription:
      - Subscribe ke driver location updates
      - Auto-update map saat driver bergerak
[ ] 4. Add chat integration:
      - Chat dengan driver dari tracking page
      - Call driver button (mock untuk sekarang)
[ ] 5. Order status timeline:
      - Pending -> Accepted -> Picked Up -> OTW -> Delivered
      - Animate transition saat status berubah
```

**Files to Create/Update**:
- `components/TrackingMap.tsx` - Enhanced dengan real-time
- `lib/realtime.ts` - Supabase realtime subscriptions
- `hooks/useTracking.ts` - Tracking hook

---

### 7️⃣ Chat Functionality (Priority MEDIUM)
**Dependencies**: Auth, Supabase realtime

**Tasks**:
```
[ ] 1. Create chat table di Supabase
[ ] 2. Setup real-time message subscription
[ ] 3. Enhance chat page:
      - Chat list dengan last message
      - Active chat room
      - Message input dengan send button
      - Timestamp & read receipts (optional)
      - Typing indicator
[ ] 4. Create message notification
[ ] 5. Add unread badge di chat tab
```

**Files to Create**:
- `app/chat/[id]/page.tsx` - Chat room page
- `components/ChatMessage.tsx` - Message bubble
- `hooks/useChat.ts` - Chat hook
- `lib/chat.ts` - Chat utilities

---

### 8️⃣ Admin Dashboard Features (Priority MEDIUM, untuk phase 2)
**Tasks**:
```
[ ] 1. Create admin pages:
      /admin/dashboard - Overview
      /admin/stores - Verifikasi toko
      /admin/transactions - Riwayat transaksi
      /admin/users - User management
[ ] 2. Implement role-based access:
      - Only admin dapat akses /admin routes
      - Merchant only dapat edit toko mereka
      - Driver only dapat accept orders
```

---

## 🎯 FASE 4: Enhancement & Polish

### 9️⃣ Form Validation & Error Handling (Priority HIGH)
**Tasks**:
```
[ ] 1. Add form validation library:
      npm install zod react-hook-form
[ ] 2. Create validation schemas:
      - Auth forms (login, signup)
      - Checkout forms
      - Profile update forms
      - Service booking forms
[ ] 3. Add error toast notifications
[ ] 4. Implement error boundaries
[ ] 5. Add loading spinners di semua async operations
```

**Files to Create**:
- `lib/validations.ts` - Zod schemas
- `hooks/useForm.ts` - Form hook wrapper
- `components/Toast.tsx` - Toast notification

---

### 🔟 PWA & Push Notifications (Priority LOW)
**Tasks**:
```
[ ] 1. Configure next-pwa
[ ] 2. Add service worker untuk offline support
[ ] 3. Setup push notifications:
      - Accept notification permission
      - Show notification saat order accepted
      - Show notification saat driver nearby
```

---

### 1️⃣1️⃣ Search & Filter Features (Priority MEDIUM)
**Tasks**:
```
[ ] 1. Add search input di Food/Marketplace pages
[ ] 2. Implement filters:
      - Kategori (Mebel, Kuliner, Fashion, dll)
      - Harga (min-max range)
      - Rating
      - Jarak (0-5km, 5-10km, dll)
      - Ketersediaan (Open/Closed)
[ ] 3. Add sorting options:
      - Nearest
      - Cheapest
      - Best Rating
      - Newest
```

**Files to Create**:
- `components/SearchBar.tsx` - Search component
- `components/FilterPanel.tsx` - Filter selector
- `hooks/useSearch.ts` - Search hook

---

## 📋 Prioritas Rekomendasi

### **Week 1** (Immediate)
1. ✅ Supabase setup & config `.env.local`
2. ✅ Database schema setup & seed data
3. ✅ Auth flows (login/signup/logout)
4. ✅ Cart state management

### **Week 2**
1. Xendit payment integration
2. Checkout page & order creation
3. Basic tracking dengan hardcoded data
4. Profile connection ke Supabase profile table

### **Week 3**
1. Real-time tracking dengan Leaflet
2. Chat functionality
3. Search & filter features
4. Form validation & error handling

### **Week 4**
1. PWA setup
2. Admin dashboard
3. Testing & optimization
4. Deployment ke Vercel

---

## 🔧 Environment Variables Needed

```env
# Supabase
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5...
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5...

# Xendit
NEXT_PUBLIC_XENDIT_API_KEY=your_xendit_key
XENDIT_SECRET_KEY=your_xendit_secret

# OpenRouter (optional, untuk AI features)
OPENROUTER_API_KEY=sk-or-your-key

# App Config
NEXT_PUBLIC_APP_NAME=GEMA
NEXT_PUBLIC_APP_URL=http://localhost:3000
NODE_ENV=development
```

---

## 📚 Dependencies to Install

```bash
# Already installed
npm list --depth=0

# Need to install (in order)
npm install @supabase/supabase-js
npm install @supabase/auth-helpers-nextjs
npm install zustand
npm install zod react-hook-form
npm install @hookform/resolvers
npm install react-hot-toast
npm install leaflet react-leaflet
npm install next-pwa
npm install xendit-node
```

---

## 🎬 Next Action

**Immediately after reading this:**

1. Create Supabase project: https://supabase.com
2. Copy credentials
3. Add to `.env.local` file
4. Create `lib/supabase.ts` file
5. Test connection dengan simple page query

**Then proceed dengan Phase 2 tasks secara bertahap.**

---

**Updated**: 22 Feb 2026
**Status**: Frontend UI Complete - Ready for Backend Integration ✅
