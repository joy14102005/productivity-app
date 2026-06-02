import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/app_theme.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/auth/auth_wrapper.dart';
import 'screens/main_scaffold.dart';
import 'services/notification_helper.dart';

// Initialize services (Hive, SharedPreferences). Firebase is attempted but app can run without it.
Future<void> _initResources() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  // open a box for local tasks
  await Hive.openBox('focusflow');
  // shared preferences
  await SharedPreferences.getInstance();
  // init notifications
  try {
    await NotificationHelper.init();
  } catch (_) {}
  try {
    await Firebase.initializeApp();
  } catch (e) {
    // Firebase optional - continue without crash
    // ignore: avoid_print
    print('Firebase init failed or not configured: $e');
  }
}

void main() async {
  await _initResources();
  runApp(const ProviderScope(child: FocusFlowApp()));
}

class FocusFlowApp extends ConsumerWidget {
  const FocusFlowApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'FocusFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (ctx) => const SplashScreen(),
        '/auth': (ctx) => const AuthWrapper(),
        '/home': (ctx) => const MainScaffold(),
      },
    );
  }
}
