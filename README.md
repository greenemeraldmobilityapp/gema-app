# GEMA - Green Emerald Mobility App 🟢

Sebuah super-app lokal yang mengintegrasikan Marketplace, Logistik (Kurir), dan Jasa untuk memajukan ekosistem ekonomi digital di Kabupaten Jepara, Jawa Tengah.

## 🚀 Fitur Utama

- **GEMA Food** 🍽️ - Pesan makanan dari restoran terpercaya
- **GEMA Send** 📦 - Pengiriman same-day dan regular
- **GEMA Service** 🔧 - Pesan jasa profesional (ukir, servis AC, pindahan, dll)
- **Marketplace** 🛍️ - Belanja produk lokal Jepara
- **Real-time Tracking** 📍 - Lacak pesanan dengan peta interaktif
- **Wallet System** 💳 - Dompet digital dengan top-up dan withdrawal
- **PWA Support** 📱 - Aplikasi native-like di browser

## 🛠️ Tech Stack

### Frontend
- **Framework**: Next.js 16 (App Router)
- **Styling**: Tailwind CSS 4.2
- **Language**: TypeScript
- **Maps**: Leaflet.js dengan OpenStreetMap
- **State Management**: Zustand

### Backend & Database
- **Backend**: Supabase (PostgreSQL + Real-time)
- **Auth**: Supabase Auth
- **Payment**: Xendit (QRIS, VA, E-Wallet)

### Infrastructure
- **Hosting**: Vercel (Frontend) & GitHub
- **PWA**: Service Workers, Web App Manifest

## 📋 Struktur Folder

```
gema-app/
├── app/                          # Next.js App Router
│   ├── layout.tsx               # Root layout
│   ├── page.tsx                 # Homepage
│   ├── globals.css              # Global styles
│   ├── food/                    # GEMA Food pages
│   ├── send/                    # GEMA Send pages
│   ├── service/                 # GEMA Service pages
│   ├── marketplace/             # Marketplace pages
│   ├── tracking/                # Order tracking
│   ├── activity/                # User activity
│   ├── chat/                    # Chat page
│   ├── profile/                 # User profile
│   └── not-found.tsx            # 404 page
├── components/                  # Reusable components
│   ├── ThemeProvider.tsx        # Dark/Light mode
│   ├── Header.tsx               # Top header
│   ├── BottomNavigation.tsx     # Bottom nav bar
│   ├── ServiceGrid.tsx          # Service grid
│   ├── WalletCard.tsx           # Wallet display
│   ├── TrackingMap.tsx          # Order tracking map
│   ├── Button.tsx               # Reusable button
│   ├── Card.tsx                 # Reusable card
│   ├── Skeleton.tsx             # Loading skeletons
│   └── RootLayoutWrapper.tsx    # Layout wrapper
├── lib/                         # Utilities & helpers
├── public/                      # Static assets
│   ├── manifest.json            # PWA manifest
│   └── favicon.svg              # App icon
├── .env.example                 # Environment template
├── .env.local                   # Local env variables
├── next.config.js               # Next.js config
├── tailwind.config.js           # Tailwind config
├── postcss.config.js            # PostCSS config
├── tsconfig.json                # TypeScript config
└── package.json                 # Dependencies
```

## 🎨 Design System

### Color Palette
- **Primary**: `#50C878` (Emerald Green)
- **Dark Accent**: `#2E8B57` (Dark Emerald)
- **Warning**: `#FFCC00` (Golden Yellow)
- **Danger**: `#E74C3C` (Red)

### Light Mode
- Background: `#FFFFFF`
- Secondary: `#F8F9FA`
- Text Primary: `#2D3436`

### Dark Mode
- Background: `#121212`
- Secondary: `#1E1E1E`
- Text Primary: `#E0E0E0`

## 📱 Responsive Design

Aplikasi dirancang untuk mobile-first dengan max-width 428px (device standar):
- Bottom navigation bar yang selalu terlihat
- Floating drawer untuk informasi detail
- Touch-friendly buttons dan components

## 🚀 Getting Started

### Prerequisites
- Node.js 18+ dan npm/yarn
- Git

### Installation

```bash
# Clone repository
git clone https://github.com/greenemeraldmobilityapp/gema-app.git
cd gema-app

# Install dependencies
npm install --legacy-peer-deps

# Setup environment variables
cp .env.example .env.local
# Edit .env.local dengan credentials Anda
```

### Development

```bash
# Run development server
npm run dev

# Open browser
open http://localhost:3000
```

Server akan berjalan di `http://localhost:3000`

### Build & Deploy

```bash
# Build untuk production
npm run build

# Run production server
npm run start

# Lint code
npm run lint
```

## 📚 API Integration

### Supabase Setup
1. Buat project di supabase.com
2. Copy URL dan anon key ke `.env.local`
3. Import schema dari `SKEMA DATABASE` di PRD.md

### Xendit Setup
1. Daftar di xendit.co
2. Copy API key ke `.env.local`
3. Setup webhook untuk payment callbacks

### Leaflet Maps
Sudah terintegrasi dengan OpenStreetMap (gratis, tanpa API key)

## 🔐 Security

- RLS (Row Level Security) di semua tabel Supabase
- Environment variables untuk credentials sensitif
- CORS configuration untuk API endpoints
- Input validation di semua forms

## 📈 Performance

- Next.js SSG/SSR untuk optimasi loading
- Image optimization dengan next/image
- Code splitting otomatis
- PWA caching strategy

## 🎯 Roadmap

- [ ] v1.0 - Core features (Food, Send, Service)
- [ ] v1.1 - Advanced tracking & real-time updates
- [ ] v1.2 - Chat & customer support
- [ ] v1.3 - Analytics & merchant dashboard
- [ ] v2.0 - Driver app & admin panel

## 📝 License

ISC License - Emerald Tech Solution

## 👥 Contributors

- Emerald Tech Solution Team

## 📞 Support

Untuk bantuan atau pertanyaan, hubungi:
- Email: support@gemaapp.id
- WhatsApp: +62-XXX-XXXX-XXXX

---

**Made with 💚 for Jepara** 🏠
