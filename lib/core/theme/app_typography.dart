import 'package:flutter/material.dart';

class AppTypography {
  // Font families - Material Design 3 recommendations
  static const String _primaryFontFamily = 'Inter'; // Modern, readable font for UI
  static const String _displayFontFamily = 'Poppins'; // For headings and display text
  static const String _monoFontFamily = 'JetBrains Mono'; // For code/numbers
  
  // ===== MATERIAL DESIGN 3 TYPOGRAPHY SCALE =====
  
  // Display styles - for large, impactful text
  static const TextStyle displayLarge = TextStyle(
    fontFamily: _displayFontFamily,
    fontSize: 57,
    fontWeight: FontWeight.w400,
    height: 1.12,
    letterSpacing: -0.25,
  );
  
  static const TextStyle displayMedium = TextStyle(
    fontFamily: _displayFontFamily,
    fontSize: 45,
    fontWeight: FontWeight.w400,
    height: 1.16,
    letterSpacing: 0,
  );
  
  static const TextStyle displaySmall = TextStyle(
    fontFamily: _displayFontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w400,
    height: 1.22,
    letterSpacing: 0,
  );
  
  // Headline styles - for medium-emphasis text
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: _displayFontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0,
  );
  
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: _displayFontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.29,
    letterSpacing: 0,
  );
  
  static const TextStyle headlineSmall = TextStyle(
    fontFamily: _displayFontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.33,
    letterSpacing: 0,
  );
  
  // Title styles - for medium text that needs emphasis
  static const TextStyle titleLarge = TextStyle(
    fontFamily: _primaryFontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.27,
    letterSpacing: 0,
  );
  
  static const TextStyle titleMedium = TextStyle(
    fontFamily: _primaryFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.50,
    letterSpacing: 0.15,
  );
  
  static const TextStyle titleSmall = TextStyle(
    fontFamily: _primaryFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.43,
    letterSpacing: 0.1,
  );
  
  // Label styles - for buttons and small text
  static const TextStyle labelLarge = TextStyle(
    fontFamily: _primaryFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.43,
    letterSpacing: 0.1,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontFamily: _primaryFontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.33,
    letterSpacing: 0.5,
  );
  
  static const TextStyle labelSmall = TextStyle(
    fontFamily: _primaryFontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 1.45,
    letterSpacing: 0.5,
  );
  
  // Body styles - for reading content
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _primaryFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.50,
    letterSpacing: 0.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _primaryFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
    letterSpacing: 0.25,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontFamily: _primaryFontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,
    letterSpacing: 0.4,
  );
  
  // ===== LEGACY ALIASES (for backward compatibility) =====
  static const TextStyle h1 = displaySmall;  // 36px
  static const TextStyle h2 = headlineLarge; // 32px
  static const TextStyle h3 = headlineMedium; // 28px
  static const TextStyle h4 = headlineSmall; // 24px
  static const TextStyle h5 = titleLarge;    // 22px
  static const TextStyle h6 = titleMedium;   // 16px
  
  static const TextStyle buttonLarge = labelLarge;  // 14px
  static const TextStyle buttonMedium = labelMedium; // 12px
  static const TextStyle buttonSmall = labelSmall;  // 11px
  
  // ===== RESTAURANT-SPECIFIC TYPOGRAPHY =====
  
  // Menu and pricing text
  static const TextStyle menuTitle = TextStyle(
    fontFamily: _displayFontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: 0.15,
  );
  
  static const TextStyle menuPrice = TextStyle(
    fontFamily: _monoFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: 0,
  );
  
  static const TextStyle menuDescription = TextStyle(
    fontFamily: _primaryFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0.25,
  );
  
  // Table and reservation text
  static const TextStyle tableNumber = TextStyle(
    fontFamily: _monoFontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: 0,
  );
  
  static const TextStyle reservationTime = TextStyle(
    fontFamily: _monoFontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.22,
    letterSpacing: 0,
  );
  
  // Status and notification text
  static const TextStyle statusLabel = TextStyle(
    fontFamily: _primaryFontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 1.33,
    letterSpacing: 0.8,
  );
  
  static const TextStyle notificationTitle = TextStyle(
    fontFamily: _primaryFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: 0.15,
  );
  
  // Form and input text
  static const TextStyle inputLabel = TextStyle(
    fontFamily: _primaryFontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.33,
    letterSpacing: 0.4,
  );
  
  static const TextStyle inputText = TextStyle(
    fontFamily: _primaryFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.5,
  );
  
  static const TextStyle inputHint = TextStyle(
    fontFamily: _primaryFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.5,
  );
  
  // Specialized content
  static const TextStyle logo = TextStyle(
    fontFamily: _displayFontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w800,
    height: 1.14,
    letterSpacing: -0.5,
  );
  
  static const TextStyle badgeText = TextStyle(
    fontFamily: _primaryFontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: 0.5,
  );
  
  static const TextStyle tabLabel = TextStyle(
    fontFamily: _primaryFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.43,
    letterSpacing: 0.1,
  );

  // ===== UTILITY METHODS =====
  
  /// Returns appropriate text style for the given context
  static TextStyle getContextualStyle(String context) {
    switch (context.toLowerCase()) {
      case 'menu_title':
        return menuTitle;
      case 'menu_price':
        return menuPrice;
      case 'table_number':
        return tableNumber;
      case 'status':
        return statusLabel;
      case 'notification':
        return notificationTitle;
      default:
        return bodyMedium;
    }
  }
  
  /// Creates a text style with custom color while preserving other properties
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }
  
  /// Creates a text style with custom font weight
  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }
  
  /// Creates a text style with custom font size
  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }

  // Private constructor to prevent instantiation
  AppTypography._();
}