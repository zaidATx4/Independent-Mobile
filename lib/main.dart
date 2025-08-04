import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_service.dart';
import 'features/splash/presentation/splash_screen.dart';
import 'features/language/presentation/language_selection_screen.dart';
import 'features/country/presentation/country_selection_screen.dart';
import 'features/auth/presentation/welcome_screen.dart';
import 'features/auth/presentation/otp_verification_screen.dart';
import 'features/auth/presentation/sign_up_screen.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/settings/presentation/settings_screen.dart';
import 'features/settings/presentation/screens/theme_screen.dart';

void main() {
  // Disable all debug painting that shows green borders
  debugPaintSizeEnabled = false;
  runApp(const ProviderScope(child: MyApp()));
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/language',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const LanguageSelectionScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0), // Slide in from right
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            )),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/country-selection',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const CountrySelectionScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0), // Slide in from right
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            )),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/welcome',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const WelcomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0), // Slide in from right
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            )),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/otp-verification',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const OtpVerificationScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0), // Slide in from right
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            )),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/sign-up',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SignUpScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0), // Slide in from right
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            )),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0), // Slide in from right
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            )),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/settings',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SettingsScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0), // Slide in from right
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            )),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/theme',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const ThemeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0), // Slide in from right
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            )),
            child: child,
          );
        },
      ),
    ),
  ],
);

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    
    return MaterialApp.router(
      title: 'Independent Mobile - Restaurant Management',
      
      // Theme configuration with Material Design 3
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode.themeMode,
      
      // Router configuration
      routerConfig: _router,
      
      // Debug settings
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      
      // Localization and accessibility
      supportedLocales: const [
        Locale('en', 'US'), // English
        Locale('es', 'ES'), // Spanish
        Locale('fr', 'FR'), // French
        // Add more locales as needed for restaurant app
      ],
      
      // App-wide builder for theme transitions
      builder: (context, child) {
        return ThemeUtils.buildThemeTransition(
          theme: Theme.of(context),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}

