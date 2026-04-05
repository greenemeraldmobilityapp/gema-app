class AppConstants {
  AppConstants._();

  static const String appName = 'GEMA';
  static const String appVersion = '1.0.0';

  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'YOUR_SUPABASE_URL',
  );
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'YOUR_SUPABASE_ANON_KEY',
  );

  static const String xenditApiKey = String.fromEnvironment(
    'XENDIT_API_KEY',
    defaultValue: 'YOUR_XENDIT_API_KEY',
  );
  static const String xenditCallbackToken = String.fromEnvironment(
    'XENDIT_CALLBACK_TOKEN',
    defaultValue: 'YOUR_XENDIT_CALLBACK_TOKEN',
  );

  static const double jeparaLat = -6.5891;
  static const double jeparaLng = 110.6737;

  static const double defaultZoomLevel = 13.0;

  static const int splashDurationMs = 2000;

  static const int paginationLimit = 20;

  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration cacheExpiry = Duration(hours: 1);

  static const String storageBucketProducts = 'products';
  static const String storageBucketProfiles = 'profiles';
  static const String storageBucketDocuments = 'documents';

  static const String routeSplash = '/splash';
  static const String routeLogin = '/login';
  static const String routeRegister = '/register';
  static const String routeHome = '/home';
  static const String routeProfile = '/profile';
  static const String routeWallet = '/wallet';
  static const String routeFoodMarketplace = '/food-marketplace';
  static const String routeProductDetail = '/product/:id';
  static const String routeStoreDetail = '/store/:id';
  static const String routeCheckout = '/checkout';
  static const String routeActivity = '/activity';
  static const String routeTrack = '/track';
  static const String routeSend = '/send';
  static const String routeChat = '/chat';
  static const String routeService = '/service';
  static const String routeMerchantRegistration = '/merchant-registration';
}
