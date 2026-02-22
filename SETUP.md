# 🚀 GEMA App - Setup & Development Guide

## Quick Start

### Prasyarat
- Node.js 18+ dan npm
- Git
- Code editor (VS Code recommended)

### Instalasi

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

### Menjalankan Aplikasi

```bash
# Development
npm run dev

# Production build
npm run build
npm run start

# Linting
npm run lint
```

Aplikasi akan tersedia di `http://localhost:3000`

---

## 📁 Struktur Folder Lengkap

```
gema-app/
├── app/                           # Next.js App Router
│   ├── layout.tsx                # Root layout dengan theme provider
│   ├── globals.css               # Global styles & Tailwind
│   ├── page.tsx                  # Homepage (Beranda)
│   │
│   ├── food/
│   │   └── page.tsx              # GEMA Food listing
│   ├── send/
│   │   └── page.tsx              # GEMA Send - pengiriman
│   ├── service/
│   │   └── page.tsx              # GEMA Service - jasa
│   ├── marketplace/
│   │   └── page.tsx              # Marketplace - belanja produk
│   │
│   ├── activity/
│   │   └── page.tsx              # Riwayat pesanan
│   ├── chat/
│   │   └── page.tsx              # Chat dengan driver/merchant
│   ├── profile/
│   │   └── page.tsx              # Profil pengguna
│   ├── tracking/
│   │   └── page.tsx              # Tracking pesanan real-time
│   │
│   └── not-found.tsx             # 404 page
│
├── components/                   # Reusable React Components
│   ├── ThemeProvider.tsx         # Dark/Light mode context
│   ├── RootLayoutWrapper.tsx     # Layout wrapper (deprecated)
│   ├── Header.tsx                # Header dengan user info
│   ├── BottomNavigation.tsx      # Bottom nav bar (Home, Activity, Chat, Profile)
│   ├── WalletCard.tsx            # Kartu dompet digital
│   ├── ServiceGrid.tsx           # Grid 4 layanan utama
│   ├── TrackingMap.tsx           # Peta tracking order
│   ├── Button.tsx                # Reusable button component
│   ├── Card.tsx                  # Reusable card component
│   └── Skeleton.tsx              # Loading skeleton components
│
├── lib/
│   └── utils.ts                  # Utility functions
│       ├── formatCurrency()      # Format IDR
│       ├── formatDate()          # Format tanggal
│       ├── haversineDistance()   # Hitung jarak GPS
│       ├── calculateShippingFee()# Hitung ongkir berdasarkan jarak
│       ├── isValidEmail()        # Validasi email
│       ├── isValidPhone()        # Validasi nomor HP
│       ├── debounce()            # Debounce function
│       └── getStatusColor()      # Warna status pesanan
│
├── public/                       # Static files
│   ├── manifest.json             # PWA manifest
│   └── favicon.svg               # App icon
│
├── .env.example                  # Template environment
├── .env.local                    # Local environment (ignored by git)
├── .gitignore                    # Git ignore rules
├── next.config.js                # Next.js configuration
├── tailwind.config.js            # Tailwind CSS configuration
├── postcss.config.js             # PostCSS configuration
├── tsconfig.json                 # TypeScript configuration
├── .eslintrc.json                # ESLint configuration
├── package.json                  # Dependencies
└── README.md                     # Project documentation
```

---

## 🎨 Design System

### Color Palette

| Name | Hex | Usage |
|------|-----|-------|
| Emerald (Main) | `#50C878` | Primary buttons, brand color |
| Emerald (Dark) | `#2E8B57` | Hover states, accents |
| Warning | `#FFCC00` | Pending status, alerts |
| Danger | `#E74C3C` | Cancel, error states |

### Typography

- **Heading**: Bold, Tailwind `font-bold`
- **Body**: Regular, Tailwind `font-normal`
- **Label**: Semibold, Tailwind `font-semibold`

### Spacing

Menggunakan Tailwind's default spacing (4px base unit)
- Small: `p-2` (8px)
- Medium: `p-4` (16px)
- Large: `p-6` (24px)

### Border Radius

- Small: `rounded-lg` (8px)
- Medium: `rounded-xl` (12px)
- Large: `rounded-2xl` (16px)

---

## 🧩 Component Guide

### Button Component

```tsx
import Button from '@/components/Button';

<Button variant="primary" size="md" fullWidth onClick={handleClick}>
  Click Me
</Button>
```

**Props:**
- `variant`: 'primary' | 'secondary' | 'danger' | 'warning'
- `size`: 'sm' | 'md' | 'lg'
- `fullWidth`: boolean
- `disabled`: boolean
- `loading`: boolean

### Card Component

```tsx
import Card from '@/components/Card';

<Card variant="elevated" onClick={handleClick}>
  Content here
</Card>
```

**Props:**
- `variant`: 'default' | 'elevated' | 'outlined'
- `onClick`: handler

### WalletCard Component

```tsx
import WalletCard from '@/components/WalletCard';

<WalletCard balance={250000} isLoading={false} />
```

### ServiceGrid Component

```tsx
import ServiceGrid from '@/components/ServiceGrid';

<ServiceGrid />
```

---

## 🌓 Dark Mode Implementation

Theme tersimpan di localStorage dan mengikuti preferensi sistem:

```tsx
import { useTheme } from '@/components/ThemeProvider';

export default function MyComponent() {
  const { theme, toggleTheme } = useTheme();
  
  return (
    <div>
      Current theme: {theme}
      <button onClick={toggleTheme}>Toggle Theme</button>
    </div>
  );
}
```

**CSS Dark Mode:**
```css
/* Automatically applied when .dark class on html element */
.dark {
  @apply bg-[#121212] text-[#e0e0e0];
}
```

---

## 📱 Responsive Design

Breakpoints menggunakan Tailwind defaults:
- Mobile-first approach
- Max-width: 428px (standard mobile device)
- Bottom navigation always visible
- Floating drawers untuk detail

---

## 📡 API Integration

### Supabase Setup

1. Sign up di [supabase.com](https://supabase.com)
2. Create new project
3. Copy URL dan anon key
4. Update `.env.local`:

```env
NEXT_PUBLIC_SUPABASE_URL=your_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_key
```

### Xendit Payment Setup

1. Sign up di [xendit.co](https://xendit.co)
2. Get API key
3. Update `.env.local`:

```env
NEXT_PUBLIC_XENDIT_API_KEY=your_key
```

---

## 🔐 Security Best Practices

1. **Environment Variables**: Jangan commit `.env.local`
2. **RLS (Row Level Security)**: Enable di semua table Supabase
3. **Input Validation**: Gunakan `lib/utils.ts` functions
4. **HTTPS**: Always use HTTPS in production

---

## 🚀 Deployment

### Deploy ke Vercel (Recommended)

1. Push ke GitHub
2. Connect repo ke Vercel
3. Add environment variables
4. Deploy

```bash
# Vercel CLI
npm i -g vercel
vercel
```

### Deploy ke Server Sendiri

```bash
npm run build
npm run start
```

---

## 🐛 Debugging

### Enable Debug Mode

```tsx
// In browser console
localStorage.debug = 'gema:*'
```

### Check Build Size

```bash
npm run build
# Check .next folder
du -sh .next
```

---

## 📚 Useful Resources

- [Next.js Docs](https://nextjs.org/docs)
- [Tailwind CSS](https://tailwindcss.com/docs)
- [Supabase Docs](https://supabase.com/docs)
- [Leaflet.js](https://leafletjs.com/)

---

## 🤝 Contributing

1. Create feature branch
2. Make changes
3. Submit pull request
4. Follow code style

---

## 📞 Support

- Issues: GitHub Issues
- Email: support@gemaapp.id
- Docs: Check README.md

**Made with 💚 for Jepara**
