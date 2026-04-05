import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/colors.dart';
import 'data/remote/supabase_service.dart';
import 'data/local/isar_collections.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  SystemChrome.setSystemUIOverlayStyle(AppTheme.systemOverlayStyle);

  await SupabaseService.initialize();

  await IsarService.initialize();

  runApp(
    const ProviderScope(
      child: GemaApp(),
    ),
  );
}
