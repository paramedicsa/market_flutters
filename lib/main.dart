import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/admin/admin_home_screen.dart';
import 'data/supabase/supabase_config.dart';
import 'utils/env_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file
  await EnvManager.loadEnvFile();

  try {
    await SupabaseConfig.initialize();
  } catch (e) {
    debugPrint('Supabase initialization error: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-commerce Admin Panel',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const AdminHomeScreen(),
    );
  }
}
