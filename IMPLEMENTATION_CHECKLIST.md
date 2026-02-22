# GEMA Frontend - Implementation Checklist

**Overview**: Frontend UI sudah 100% selesai. Sekarang fokus ke backend integration dan feature completion.

---

## 🎯 Immediate Actions (Do This TODAY)

### [ ] 1. Create Supabase Account & Project
- [ ] Go to https://supabase.com
- [ ] Create new project named `gema-app`
- [ ] Copy URL & API keys
- [ ] Save credentials (jangan share!)

### [ ] 2. Add Environment Variables
**Create `.env.local` file:**
```env
NEXT_PUBLIC_SUPABASE_URL=https://xxxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJ0eXAi...
```

### [ ] 3. Test Supabase Connection
```bash
# Install Supabase client
npm install @supabase/supabase-js

# Create lib/supabase.ts with connection code
# Then test: npm run dev
```

---

## 📝 PHASE 1 Implementation (This Week)

### [ ] Authentication System
**Status**: Not started | Effort: ~8 hours

✅ **What to build:**
- Login page (`app/auth/page.tsx`)
- Signup form
- Password recovery
- Session persistence
- Protected routes

📊 **Dependencies:**
- Supabase Auth
- React Hook Form
- TypeScript

🎯 **Success Criteria:**
- [x] User dapat signup dengan email
- [x] User dapat login dengan email/password
- [x] Session persists di refresh page
- [x] Unauthenticated users redirect ke `/auth`
- [x] Logout berfungsi

**Start with:**
1. Read SUPABASE_SETUP.md
2. Setup database schema via SQL editor
3. Test signup/login di Supabase dashboard
4. Create `app/auth/page.tsx` with form

---

### [ ] Cart & State Management
**Status**: Not started | Effort: ~4 hours

✅ **What to build:**
- Zustand store untuk cart
- Add to cart function
- Remove from cart
- Update quantity
- localStorage persistence
- Cart badge di header

📊 **Dependencies:**
- Zustand
- localStorage API

🎯 **Success Criteria:**
- [x] Items persist saat refresh
- [x] Cart count visible di header
- [x] Can add/remove items
- [x] Total price calculated correctly

**Start with:**
1. `npm install zustand`
2. Create `lib/store.ts`
3. Create `hooks/useCart.ts`
4. Update Header component

---

### [ ] Database Integration
**Status**: Not started | Effort: ~6 hours

✅ **What to build:**
- Fetch stores dari database
- Fetch products
- Fetch services
- Real-time subscriptions setup
- Error handling

📊 **Dependencies:**
- Supabase client
- SWR atau React Query (optional)

🎯 **Success Criteria:**
- [x] Homepage loads data dari database
- [x] Food page shows real data
- [x] Service page shows real data
- [x] Error states handled
- [x] Loading states working

**Start with:**
1. Create `lib/db.ts` dengan query functions
2. Update homepage untuk fetch data
3. Update food/service/marketplace pages
4. Add error boundaries

---

## 💳 PHASE 2 Implementation (Next Week)

### [ ] Xendit Payment Integration
**Status**: Not started | Effort: ~8 hours

✅ **What to build:**
- Payment method selection
- QRIS generation
- Virtual Account creation
- Payment confirmation webhook
- Refund logic
- Invoice generation

📊 **Dependencies:**
- Xendit API
- Axios

🎯 **Success Criteria:**
- [x] Can select payment method
- [x] QRIS/VA generated correctly
- [x] Payment confirmed automatically
- [x] Receipt generated

**Setup:**
1. Create Xendit account (https://dashboard.xendit.co)
2. Add API keys to .env.local
3. Create `lib/xendit.ts`
4. Create checkout flow

---

### [ ] Checkout Flow
**Status**: Not started | Effort: ~6 hours

✅ **What to build:**
- Review cart items
- Address form
- Delivery option selection
- Price breakdown
- Payment method selection
- Order confirmation

📊 **Dependencies:**
- React Hook Form
- Zod validation
- Supabase (orders table)

🎯 **Success Criteria:**
- [x] Can review items before paying
- [x] Ongkir calculated correctly
- [x] Total shown correctly
- [x] Order created in database

**Files to create:**
- `app/checkout/page.tsx`
- `components/PriceBreakdown.tsx`
- `components/PaymentMethods.tsx`

---

### [ ] Real-time Tracking
**Status**: Partial (UI done) | Effort: ~6 hours

✅ **What to build:**
- Leaflet map setup
- Real-time driver location
- Route polyline
- Status updates
- ETA calculation

📊 **Dependencies:**
- leaflet, react-leaflet
- Supabase realtime

🎯 **Success Criteria:**
- [x] Map displays correctly
- [x] Driver location updates real-time
- [x] Status changes animate
- [x] ETA calculated

**Start with:**
1. `npm install leaflet react-leaflet`
2. Update `components/TrackingMap.tsx`
3. Add realtime subscription

---

## 🎨 PHASE 3 Implementation (Week 3)

### [ ] Chat Functionality
**Status**: UI only | Effort: ~5 hours

✅ **What to build:**
- Chat list page
- Chat room page
- Real-time messages
- Typing indicator
- Unread badges

**Files:**
- `app/chat/page.tsx` - list
- `app/chat/[id]/page.tsx` - room
- `components/ChatMessage.tsx`

---

### [ ] Search & Filtering
**Status**: Not started | Effort: ~4 hours

✅ **What to build:**
- Search input
- Category filters
- Price range filter
- Distance filter
- Sorting options

**Files:**
- `components/SearchBar.tsx`
- `components/FilterPanel.tsx`

---

### [ ] Form Validation
**Status**: Not started | Effort: ~3 hours

✅ **What to build:**
- Zod schemas untuk semua forms
- Error messages
- React Hook Form integration
- Toast notifications

**Files:**
- `lib/validations.ts`
- `components/Toast.tsx`

---

## 🚀 PHASE 4 (Week 4 - Polish & Deploy)

### [ ] Admin Dashboard
- Create admin pages
- User management
- Store verification
- Transaction reports

### [ ] PWA Setup
- Service worker
- Push notifications
- Offline support

### [ ] Testing
- Unit tests
- Integration tests
- E2E tests

### [ ] Optimization
- Image optimization
- Code splitting
- Performance monitoring

### [ ] Deployment
- Setup Vercel
- Setup GitHub Actions
- Environment variables
- Custom domain

---

## 📊 Progress Tracking

**Create simple progress file:**

```
PROGRESS.md

Week 1:
- [ ] Day 1: Supabase setup + Auth
- [ ] Day 2: Cart system
- [ ] Day 3-4: Database integration
- [ ] Day 5: Testing & debugging

Week 2:
- [ ] Day 1-2: Xendit payment
- [ ] Day 3-4: Checkout flow
- [ ] Day 5: Tracking integration

Week 3:
- [ ] Chat + Search + Validation
- [ ] Testing
- [ ] Bug fixes

Week 4:
- [ ] Admin dashboard
- [ ] PWA setup
- [ ] Deployment
- [ ] Launch! 🎉
```

---

## 🛠️ Tech Stack Summary

| Layer | Technology | Status |
|-------|-----------|--------|
| **Frontend** | Next.js 16, React 19, TypeScript | ✅ Complete |
| **Styling** | Tailwind CSS 4.2 | ✅ Complete |
| **State Mgmt** | Zustand | 🔄 To integrate |
| **Database** | Supabase (PostgreSQL) | 🔄 To setup |
| **Auth** | Supabase Auth | 🔄 To implement |
| **Payment** | Xendit API | 🔄 To implement |
| **Maps** | Leaflet.js | 🔄 To integrate |
| **Chat** | Supabase Realtime | 🔄 To implement |
| **Hosting** | Vercel | 🔄 To deploy |

---

## 🎓 Learning Resources

**Supabase:**
- https://supabase.com/docs
- https://supabase.com/docs/guides/auth

**Xendit:**
- https://developers.xendit.co/
- https://developers.xendit.co/v1/products/payment-links/

**Leaflet:**
- https://leafletjs.com/
- https://react-leaflet.js.org/

**Next.js:**
- https://nextjs.org/docs
- https://nextjs.org/docs/app

---

## ⚡ Commands Reference

```bash
# Development
npm run dev          # Start dev server

# Building
npm run build        # Build for production
npm run type-check   # Check TypeScript
npm run lint         # Run ESLint

# Database
npm install @supabase/supabase-js
npm install zustand
npm install zod react-hook-form
npm install leaflet react-leaflet
npm install xendit-node

# Testing
npm install --save-dev vitest @testing-library/react

# Deployment
npm run build && npm start
```

---

## 📞 Support Resources

**Got stuck?**
1. Check error message carefully
2. Search Supabase/Next.js docs
3. Check NEXT_STEPS.md
4. Check SUPABASE_SETUP.md

**Common issues:**
- Row Level Security (RLS) blocking queries → Check RLS policies
- Auth not working → Check redirect URLs in Supabase
- Payment failing → Check Xendit API keys
- Maps not loading → Check Leaflet CSS import

---

**Last Updated**: 22 Feb 2026
**Status**: Ready for Phase 1 🚀

Good luck! Let's build GEMA! 💚
