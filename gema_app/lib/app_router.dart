import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/wallet/screens/wallet_screen.dart';
import '../features/marketplace/screens/food_marketplace_screen.dart';
import '../features/marketplace/screens/product_detail_screen.dart';
import '../features/marketplace/screens/store_detail_screen.dart';
import '../features/marketplace/screens/checkout_screen.dart';
import '../features/service/screens/service_screen.dart';
import '../data/remote/supabase_service.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  redirect: (context, state) {
    final isAuthenticated = SupabaseService.isAuthenticated;
    final isLoggingIn = state.matchedLocation == '/login' ||
        state.matchedLocation == '/register';

    if (!isAuthenticated && !isLoggingIn) {
      return '/login';
    }

    if (isAuthenticated && isLoggingIn) {
      return '/home';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/wallet',
      name: 'wallet',
      builder: (context, state) => const WalletScreen(),
    ),
    GoRoute(
      path: '/food-marketplace',
      name: 'foodMarketplace',
      builder: (context, state) => const FoodMarketplaceScreen(),
    ),
    GoRoute(
      path: '/product/:id',
      name: 'productDetail',
      builder: (context, state) {
        final productId = state.pathParameters['id']!;
        return ProductDetailScreen(productId: productId);
      },
    ),
    GoRoute(
      path: '/store/:id',
      name: 'storeDetail',
      builder: (context, state) {
        final storeId = state.pathParameters['id']!;
        return StoreDetailScreen(storeId: storeId);
      },
    ),
    GoRoute(
      path: '/checkout',
      name: 'checkout',
      builder: (context, state) => const CheckoutScreen(),
    ),
    GoRoute(
      path: '/service',
      name: 'service',
      builder: (context, state) => const ServiceScreen(),
    ),
  ],
);
