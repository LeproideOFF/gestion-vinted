import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/settings_provider.dart';
import 'core/utils/auth_service.dart';
import 'root_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final success = await AuthService.authenticate();
    setState(() => _isAuthenticated = success);
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(appSettingsProvider);
    final themeType = settings['theme'] as GlassTheme;

    if (!_isAuthenticated) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_outline_rounded, size: 80, color: Colors.grey),
                const SizedBox(height: 20),
                const Text('Accès Verrouillé', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                ElevatedButton(onPressed: _checkAuth, child: const Text('Déverrouiller')),
              ],
            ),
          ),
        ),
      );
    }

    return MaterialApp(
      title: 'Gestion Pro P2P',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: AppTheme.getTheme(themeType, false),
      darkTheme: AppTheme.getTheme(themeType, true),
      home: const RootScreen(),
    );
  }
}
