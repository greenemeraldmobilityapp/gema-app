#!/bin/bash
# GEMA App - Quick Start Script

echo "🚀 GEMA App - Quick Start"
echo "========================="
echo ""

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js tidak ditemukan. Silakan install Node.js 18+ terlebih dahulu."
    exit 1
fi

echo "✅ Node.js version: $(node --version)"
echo "✅ npm version: $(npm --version)"
echo ""

# Install dependencies
echo "📦 Installing dependencies..."
npm install --legacy-peer-deps

if [ $? -ne 0 ]; then
    echo "❌ Installation failed"
    exit 1
fi

echo ""
echo "✅ Dependencies installed successfully!"
echo ""

# Setup .env.local
if [ ! -f .env.local ]; then
    echo "📝 Creating .env.local from .env.example..."
    cp .env.example .env.local
    echo "⚠️  Please update .env.local with your credentials:"
    echo "   - NEXT_PUBLIC_SUPABASE_URL"
    echo "   - NEXT_PUBLIC_SUPABASE_ANON_KEY"
    echo "   - NEXT_PUBLIC_XENDIT_API_KEY"
    echo ""
fi

# Build
echo "🔨 Building project..."
npm run build

if [ $? -ne 0 ]; then
    echo "❌ Build failed"
    exit 1
fi

echo ""
echo "✅ Build completed successfully!"
echo ""
echo "🎉 Setup complete! You can now:"
echo ""
echo "   Development:"
echo "   $ npm run dev"
echo ""
echo "   Production:"
echo "   $ npm run start"
echo ""
echo "   Linting:"
echo "   $ npm run lint"
echo ""
echo "   Type checking:"
echo "   $ npm run type-check"
echo ""
echo "default browser akan membuka http://localhost:3000"
echo ""
echo "Made with 💚 for Jepara"
