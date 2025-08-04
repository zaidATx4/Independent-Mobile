import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Theme mode options for the application
enum AppThemeMode {
  light,
  dark,
  system,
}

extension AppThemeModeExtension on AppThemeMode {
  String get name {
    switch (this) {
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
      case AppThemeMode.system:
        return 'System';
    }
  }
  
  ThemeMode get themeMode {
    switch (this) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
  
  IconData get icon {
    switch (this) {
      case AppThemeMode.light:
        return Icons.light_mode;
      case AppThemeMode.dark:
        return Icons.dark_mode;
      case AppThemeMode.system:
        return Icons.settings_brightness;
    }
  }
}

/// Service class for managing theme state and persistence
class ThemeService {
  static const String _themeKey = 'app_theme_mode';
  
  ThemeService._();
  
  /// Get the saved theme mode from SharedPreferences
  static Future<AppThemeMode> getSavedThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeName = prefs.getString(_themeKey);
      
      if (themeName == null) {
        return AppThemeMode.dark; // Default to dark theme
      }
      
      return AppThemeMode.values.firstWhere(
        (mode) => mode.toString() == themeName,
        orElse: () => AppThemeMode.dark,
      );
    } catch (e) {
      debugPrint('Error loading theme mode: $e');
      return AppThemeMode.dark;
    }
  }
  
  /// Save the theme mode to SharedPreferences
  static Future<bool> saveThemeMode(AppThemeMode themeMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_themeKey, themeMode.toString());
    } catch (e) {
      debugPrint('Error saving theme mode: $e');
      return false;
    }
  }
  
  /// Clear saved theme preferences
  static Future<bool> clearThemePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_themeKey);
    } catch (e) {
      debugPrint('Error clearing theme preferences: $e');
      return false;
    }
  }
}

/// Theme state notifier for managing theme changes
class ThemeNotifier extends StateNotifier<AppThemeMode> {
  ThemeNotifier() : super(AppThemeMode.dark) {
    _loadTheme();
  }
  
  /// Load theme from storage
  Future<void> _loadTheme() async {
    final savedTheme = await ThemeService.getSavedThemeMode();
    state = savedTheme;
  }
  
  /// Change theme mode and persist it
  Future<void> setThemeMode(AppThemeMode themeMode) async {
    state = themeMode;
    await ThemeService.saveThemeMode(themeMode);
  }
  
  /// Toggle between light and dark modes (skips system)
  Future<void> toggleTheme() async {
    final newTheme = state == AppThemeMode.light 
        ? AppThemeMode.dark 
        : AppThemeMode.light;
    await setThemeMode(newTheme);
  }
  
  /// Reset to system theme
  Future<void> resetToSystem() async {
    await setThemeMode(AppThemeMode.system);
  }
}

/// Provider for theme state management
final themeProvider = StateNotifierProvider<ThemeNotifier, AppThemeMode>((ref) {
  return ThemeNotifier();
});

/// Helper extension for accessing theme from BuildContext
extension ThemeContextExtension on BuildContext {
  /// Get the current theme mode
  AppThemeMode get currentThemeMode {
    final container = ProviderScope.containerOf(this);
    return container.read(themeProvider);
  }
  
  /// Check if current theme is dark
  bool get isDarkMode {
    final brightness = Theme.of(this).brightness;
    return brightness == Brightness.dark;
  }
  
  /// Check if current theme is light
  bool get isLightMode {
    final brightness = Theme.of(this).brightness;
    return brightness == Brightness.light;
  }
  
  /// Get appropriate color based on current theme
  Color getThemedColor({
    required Color lightColor,
    required Color darkColor,
  }) {
    return isDarkMode ? darkColor : lightColor;
  }
}

/// Utility class for theme-related helper methods
class ThemeUtils {
  ThemeUtils._();
  
  /// Get system brightness
  static Brightness getSystemBrightness(BuildContext context) {
    return MediaQuery.of(context).platformBrightness;
  }
  
  /// Check if system is in dark mode
  static bool isSystemDarkMode(BuildContext context) {
    return getSystemBrightness(context) == Brightness.dark;
  }
  
  /// Get effective theme mode based on system settings
  static ThemeMode getEffectiveThemeMode(AppThemeMode appThemeMode, BuildContext context) {
    switch (appThemeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
  
  /// Get theme-appropriate status bar style
  static SystemUiOverlayStyle getStatusBarStyle(BuildContext context) {
    if (context.isDarkMode) {
      return SystemUiOverlayStyle.light;
    } else {
      return SystemUiOverlayStyle.dark;
    }
  }
  
  /// Animate theme transition
  static Widget buildThemeTransition({
    required Widget child,
    required ThemeData theme,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return AnimatedTheme(
      data: theme,
      duration: duration,
      curve: Curves.easeInOut,
      child: child,
    );
  }
}