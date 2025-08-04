import 'package:flutter/material.dart';

class AppColors {
  // Brand Primary Colors - Restaurant Theme (Orange/Amber for warmth)
  static const Color primary = Color(0xFFFF8C00);          // Dark Orange
  static const Color primaryDark = Color(0xFFE67E22);      // Darker Orange
  static const Color primaryLight = Color(0xFFFFA726);     // Light Orange
  static const Color onPrimary = Color(0xFFFFFFFF);        // White on primary
  
  // Primary Containers
  static const Color primaryContainer = Color(0xFF2D1B12);        // Dark container
  static const Color onPrimaryContainer = Color(0xFFFFDCC0);      // Light on dark container
  static const Color primaryLightContainer = Color(0xFFFFE8D6);   // Light container
  static const Color onPrimaryLightContainer = Color(0xFF2D1B12); // Dark on light container
  
  // Secondary Colors - Complementary (Teal/Green for balance)
  static const Color secondary = Color(0xFF00BCD4);        // Cyan
  static const Color secondaryDark = Color(0xFF00ACC1);    // Dark Cyan
  static const Color secondaryLight = Color(0xFF4DD0E1);   // Light Cyan
  static const Color onSecondary = Color(0xFFFFFFFF);      // White on secondary
  
  // Secondary Containers
  static const Color secondaryContainer = Color(0xFF0B2E32);        // Dark container
  static const Color onSecondaryContainer = Color(0xFFB8F4FF);      // Light on dark container
  static const Color secondaryLightContainer = Color(0xFFE0F7FA);   // Light container
  static const Color onSecondaryLightContainer = Color(0xFF0B2E32); // Dark on light container

  // ===== LIGHT THEME COLORS =====
  // Light Background & Surface
  static const Color lightBackground = Color(0xFFFFFBFF);      // Pure white with warm tint
  static const Color lightOnBackground = Color(0xFF1F1A16);    // Very dark brown
  static const Color lightSurface = Color(0xFFFFFBFF);        // Same as background
  static const Color lightOnSurface = Color(0xFF1F1A16);      // Dark brown
  static const Color lightSurfaceVariant = Color(0xFFF5EFEB); // Light warm grey
  static const Color lightOnSurfaceVariant = Color(0xFF524640); // Medium brown
  
  // Light Outline colors
  static const Color lightOutline = Color(0xFF837770);        // Medium outline
  static const Color lightOutlineVariant = Color(0xFFD7C8BC); // Light outline
  
  // Light Shadow
  static const Color lightShadow = Color(0xFF000000);         // Black shadow

  // ===== DARK THEME COLORS ===== 
  // Dark Background & Surface (Restaurant ambiance - warm dark tones)
  static const Color darkBackground = Color(0xFF141218);      // Very dark purple-grey
  static const Color darkOnBackground = Color(0xFFECE0DB);    // Light warm grey
  static const Color darkSurface = Color(0xFF141218);        // Same as background
  static const Color darkOnSurface = Color(0xFFECE0DB);      // Light warm grey
  static const Color darkSurfaceVariant = Color(0xFF524640); // Medium warm grey
  static const Color darkOnSurfaceVariant = Color(0xFFD7C8BC); // Light brown
  
  // Dark Primary Colors
  static const Color darkOnPrimary = Color(0xFF4A2800);      // Very dark orange
  static const Color darkOnSecondary = Color(0xFF00343A);    // Very dark cyan
  
  // Dark Outline colors
  static const Color darkOutline = Color(0xFF9F8B82);        // Medium outline
  static const Color darkOutlineVariant = Color(0xFF524640); // Dark outline
  
  // Dark Shadow
  static const Color darkShadow = Color(0xFF000000);         // Black shadow

  // ===== ERROR COLORS =====
  static const Color error = Color(0xFFE53E3E);              // Red error
  static const Color onError = Color(0xFFFFFFFF);            // White on error
  static const Color darkError = Color(0xFFFF6B6B);          // Light red for dark theme
  static const Color darkOnError = Color(0xFF5F0A0A);        // Dark red
  static const Color darkErrorContainer = Color(0xFF93000A); // Dark error container
  static const Color darkOnErrorContainer = Color(0xFFFFDAD6); // Light on dark error container
  static const Color lightErrorContainer = Color(0xFFFFDAD6); // Light error container
  static const Color onLightErrorContainer = Color(0xFF410E0B); // Dark on light error container

  // ===== SEMANTIC COLORS (Restaurant Context) =====
  static const Color success = Color(0xFF2E7D32);            // Green - orders confirmed
  static const Color successLight = Color(0xFF4CAF50);       // Light green
  static const Color successDark = Color(0xFF1B5E20);        // Dark green
  
  static const Color warning = Color(0xFFF57C00);            // Orange - pending orders
  static const Color warningLight = Color(0xFFFF9800);       // Light orange
  static const Color warningDark = Color(0xFFE65100);        // Dark orange
  
  static const Color info = Color(0xFF1976D2);               // Blue - information
  static const Color infoLight = Color(0xFF2196F3);          // Light blue
  static const Color infoDark = Color(0xFF0D47A1);           // Dark blue

  // ===== RESTAURANT SPECIFIC COLORS =====
  static const Color goldAccent = Color(0xFFFFD700);         // Gold for premium features
  static const Color silverAccent = Color(0xFFC0C0C0);       // Silver for standard features
  static const Color foodRating = Color(0xFFFFC107);         // Amber for star ratings
  
  // Table status colors
  static const Color tableAvailable = Color(0xFF4CAF50);     // Green
  static const Color tableOccupied = Color(0xFFE53E3E);      // Red
  static const Color tableReserved = Color(0xFFFF9800);      // Orange
  static const Color tableCleaning = Color(0xFF9C27B0);      // Purple

  // ===== LEGACY SUPPORT (keeping for backward compatibility) =====
  static const Color background = lightBackground;           // Alias for light background
  static const Color surface = lightSurface;                 // Alias for light surface
  static const Color textPrimary = lightOnBackground;        // Alias for primary text
  static const Color textSecondary = Color(0xFF757575);      // Secondary text
  static const Color textHint = Color(0xFFBDBDBD);          // Hint text

  // ===== GRADIENTS =====
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient darkPrimaryGradient = LinearGradient(
    colors: [primaryDark, Color(0xFFD35400)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient goldGradient = LinearGradient(
    colors: [goldAccent, Color(0xFFFFE57F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ===== OPACITY VARIANTS =====
  static Color primaryWithOpacity(double opacity) => primary.withValues(alpha: opacity);
  static Color darkSurfaceWithOpacity(double opacity) => darkSurface.withValues(alpha: opacity);
  static Color lightSurfaceWithOpacity(double opacity) => lightSurface.withValues(alpha: opacity);

  // Private constructor to prevent instantiation
  AppColors._();
}