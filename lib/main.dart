import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_service.dart';
import 'core/router/app_router.dart';

void main() {
  // Disable all debug painting that shows green borders
  debugPaintSizeEnabled = false;
  debugPaintLayerBordersEnabled = false;
  debugRepaintRainbowEnabled = false;
  debugPaintPointersEnabled = false;
  debugDisableClipLayers = false;
  debugDisablePhysicalShapeLayers = false;
  runApp(const ProviderScope(child: MyApp()));
}


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
      routerConfig: appRouter,
      
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

