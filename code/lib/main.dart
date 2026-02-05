import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'models/auth/auth_state.dart';
import 'providers/auth/auth_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'services/bootstrap/app_bootstrap.dart';

Future<void> main() async {
  final bootstrap = AppBootstrap();
  await bootstrap.initialize();
  runApp(const ProviderScope(child: CurationApp()));
}

class CurationApp extends ConsumerStatefulWidget {
  const CurationApp({super.key});

  @override
  ConsumerState<CurationApp> createState() => _CurationAppState();
}

class _CurationAppState extends ConsumerState<CurationApp> {
  @override
  void initState() {
    super.initState();
    // Check auth status after first frame renders to avoid frame skipping
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authProvider.notifier).checkAuthStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return MaterialApp(
      title: 'Curation',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: _buildHome(authState),
    );
  }

  Widget _buildHome(AuthState authState) {
    // Show splash/loading while checking auth status
    if (authState.status == AuthStatus.initial ||
        (authState.status == AuthStatus.loading && authState.user == null)) {
      return const _SplashScreen();
    }

    // Show login screen if not authenticated
    if (!authState.isAuthenticated) {
      return LoginScreen(
        onLoginSuccess: (user) {
          // Navigation is handled by state change
        },
      );
    }

    // Show main content if authenticated
    return const HomeScreen();
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Curation',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
