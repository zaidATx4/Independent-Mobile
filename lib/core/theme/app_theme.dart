import 'package:flutter/material.dart';
import 'light_theme.dart';
import 'dark_theme.dart';
import 'theme_extensions.dart';

/// Main theme provider class that orchestrates light and dark themes
/// with Material Design 3 support and custom extensions
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();
  
  /// Light theme configuration using Material Design 3
  static ThemeData get lightTheme => LightTheme.theme.copyWith(
    extensions: <ThemeExtension<dynamic>>[
      CustomColors.light,
      CustomSpacing.standard,
    ],
  );
  
  /// Dark theme configuration optimized for restaurant ambiance
  static ThemeData get darkTheme => DarkTheme.theme.copyWith(
    extensions: <ThemeExtension<dynamic>>[
      CustomColors.dark,
      CustomSpacing.standard,
    ],
  );
  
  /// Get theme based on brightness
  static ThemeData getTheme(Brightness brightness) {
    switch (brightness) {
      case Brightness.light:
        return lightTheme;
      case Brightness.dark:
        return darkTheme;
    }
  }
  
  /// Check if the theme supports Material Design 3
  static bool get supportsMaterial3 => true;
  
  /// Get the primary color for the current theme
  static Color getPrimaryColor(Brightness brightness) {
    return getTheme(brightness).colorScheme.primary;
  }
  
  /// Get the surface color for the current theme
  static Color getSurfaceColor(Brightness brightness) {
    return getTheme(brightness).colorScheme.surface;
  }
  
  /// Get theme-appropriate colors for common UI elements
  static Map<String, Color> getSemanticColors(Brightness brightness) {
    final theme = getTheme(brightness);
    final customColors = brightness == Brightness.light 
        ? CustomColors.light 
        : CustomColors.dark;
    
    return {
      'success': customColors.success,
      'warning': customColors.warning,
      'error': theme.colorScheme.error,
      'info': customColors.info,
      'primary': theme.colorScheme.primary,
      'secondary': theme.colorScheme.secondary,
    };
  }
}
