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
  bool _isInitDone = false;
  bool _authStarted = false;

  Future<void> _initializeAndAuth(Map<String, dynamic> settings) async {
    if (_authStarted) return;
    _authStarted = true;

    final bool useBiometrics = settings['useBiometrics'] ?? true;

    if (!useBiometrics) {
      if (mounted) {
        setState(() {
          _isAuthenticated = true;
          _isInitDone = true;
        });
      }
      return;
    }

    try {
      final success = await AuthService.authenticate();
      if (mounted) {
        setState(() {
          _isAuthenticated = success;
          _isInitDone = true;
        });
      }
    } catch (e) {
      print('AUTH_ERROR: $e');
      if (mounted) {
        setState(() {
          _isAuthenticated = true; // Fallback pour éviter blocage
          _isInitDone = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(appSettingsProvider);

    return settingsAsync.when(
      data: (settings) {
        // On déclenche l'auth dès que les settings sont là
        if (!_isInitDone && !_authStarted) {
          _initializeAndAuth(settings);
        }

        if (!_isInitDone) {
          return _buildLoadingScreen(settings);
        }

        final themeType = settings['theme'] as GlassTheme;

        if (!_isAuthenticated) {
          return _buildLockedScreen(themeType, settings);
        }

        return MaterialApp(
          title: 'Gestion Pro P2P',
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.system,
          theme: AppTheme.getTheme(themeType, false),
          darkTheme: AppTheme.getTheme(themeType, true),
          home: const RootScreen(),
        );
      },
      loading: () => const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator()))),
      error: (e, s) => MaterialApp(home: Scaffold(body: Center(child: Text('Erreur Critique: $e')))),
    );
  }

  Widget _buildLoadingScreen(Map<String, dynamic> settings) {
    final themeType = settings['theme'] as GlassTheme;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(themeType, false),
      home: const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildLockedScreen(GlassTheme themeType, Map<String, dynamic> settings) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(themeType, false),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline_rounded, size: 80, color: Colors.grey),
              const SizedBox(height: 20),
              const Text('Accès Verrouillé', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  _authStarted = false; // Reset pour retenter
                  _initializeAndAuth(settings);
                },
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
                child: const Text('DÉVERROUILLER'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
