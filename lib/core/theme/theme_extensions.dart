import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Custom color extension for Material Design 3 theme
/// Provides additional semantic colors specific to the restaurant app
@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    required this.success,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.info,
    required this.infoContainer,
    required this.onInfoContainer,
    required this.goldAccent,
    required this.silverAccent,
    required this.foodRating,
    required this.tableAvailable,
    required this.tableOccupied,
    required this.tableReserved,
    required this.tableCleaning,
    required this.brandGradient,
    required this.surfaceElevated,
    required this.onSurfaceElevated,
  });

  // Semantic colors
  final Color success;
  final Color successContainer;
  final Color onSuccessContainer;
  final Color warning;
  final Color warningContainer;
  final Color onWarningContainer;
  final Color info;
  final Color infoContainer;
  final Color onInfoContainer;

  // Premium/Accent colors
  final Color goldAccent;
  final Color silverAccent;
  final Color foodRating;

  // Restaurant-specific colors
  final Color tableAvailable;
  final Color tableOccupied;
  final Color tableReserved;
  final Color tableCleaning;

  // Special properties
  final LinearGradient brandGradient;
  final Color surfaceElevated;
  final Color onSurfaceElevated;

  /// Light theme custom colors
  static const CustomColors light = CustomColors(
    // Success colors
    success: AppColors.success,
    successContainer: Color(0xFFC8E6C9),
    onSuccessContainer: Color(0xFF1B5E20),
    
    // Warning colors  
    warning: AppColors.warning,
    warningContainer: Color(0xFFFFE0B2),
    onWarningContainer: Color(0xFFE65100),
    
    // Info colors
    info: AppColors.info,
    infoContainer: Color(0xFFBBDEFB),
    onInfoContainer: Color(0xFF0D47A1),
    
    // Premium colors
    goldAccent: AppColors.goldAccent,
    silverAccent: AppColors.silverAccent,
    foodRating: AppColors.foodRating,
    
    // Table status colors
    tableAvailable: AppColors.tableAvailable,
    tableOccupied: AppColors.tableOccupied,
    tableReserved: AppColors.tableReserved,
    tableCleaning: AppColors.tableCleaning,
    
    // Special properties
    brandGradient: AppColors.primaryGradient,
    surfaceElevated: Color(0xFFF8F5F2),
    onSurfaceElevated: Color(0xFF1F1A16),
  );

  /// Dark theme custom colors
  static const CustomColors dark = CustomColors(
    // Success colors
    success: AppColors.successLight,
    successContainer: Color(0xFF2E7D32),
    onSuccessContainer: Color(0xFFC8E6C9),
    
    // Warning colors
    warning: AppColors.warningLight,
    warningContainer: Color(0xFFF57C00),
    onWarningContainer: Color(0xFFFFE0B2),
    
    // Info colors
    info: AppColors.infoLight,
    infoContainer: Color(0xFF1976D2),
    onInfoContainer: Color(0xFFBBDEFB),
    
    // Premium colors
    goldAccent: Color(0xFFFFFFFF), // White for dark mode as per Figma
    silverAccent: AppColors.silverAccent,
    foodRating: AppColors.foodRating,
    
    // Table status colors
    tableAvailable: AppColors.tableAvailable,
    tableOccupied: Color(0xFFFF6B6B),
    tableReserved: AppColors.tableReserved,
    tableCleaning: AppColors.tableCleaning,
    
    // Special properties
    brandGradient: AppColors.darkPrimaryGradient,
    surfaceElevated: Color(0xFF1E1C20),
    onSurfaceElevated: Color(0xFFECE0DB),
  );

  @override
  CustomColors copyWith({
    Color? success,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? info,
    Color? infoContainer,
    Color? onInfoContainer,
    Color? goldAccent,
    Color? silverAccent,
    Color? foodRating,
    Color? tableAvailable,
    Color? tableOccupied,
    Color? tableReserved,
    Color? tableCleaning,
    LinearGradient? brandGradient,
    Color? surfaceElevated,
    Color? onSurfaceElevated,
  }) {
    return CustomColors(
      success: success ?? this.success,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      warning: warning ?? this.warning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      info: info ?? this.info,
      infoContainer: infoContainer ?? this.infoContainer,
      onInfoContainer: onInfoContainer ?? this.onInfoContainer,
      goldAccent: goldAccent ?? this.goldAccent,
      silverAccent: silverAccent ?? this.silverAccent,
      foodRating: foodRating ?? this.foodRating,
      tableAvailable: tableAvailable ?? this.tableAvailable,
      tableOccupied: tableOccupied ?? this.tableOccupied,
      tableReserved: tableReserved ?? this.tableReserved,
      tableCleaning: tableCleaning ?? this.tableCleaning,
      brandGradient: brandGradient ?? this.brandGradient,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      onSurfaceElevated: onSurfaceElevated ?? this.onSurfaceElevated,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    
    return CustomColors(
      success: Color.lerp(success, other.success, t) ?? success,
      successContainer: Color.lerp(successContainer, other.successContainer, t) ?? successContainer,
      onSuccessContainer: Color.lerp(onSuccessContainer, other.onSuccessContainer, t) ?? onSuccessContainer,
      warning: Color.lerp(warning, other.warning, t) ?? warning,
      warningContainer: Color.lerp(warningContainer, other.warningContainer, t) ?? warningContainer,
      onWarningContainer: Color.lerp(onWarningContainer, other.onWarningContainer, t) ?? onWarningContainer,
      info: Color.lerp(info, other.info, t) ?? info,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t) ?? infoContainer,
      onInfoContainer: Color.lerp(onInfoContainer, other.onInfoContainer, t) ?? onInfoContainer,
      goldAccent: Color.lerp(goldAccent, other.goldAccent, t) ?? goldAccent,
      silverAccent: Color.lerp(silverAccent, other.silverAccent, t) ?? silverAccent,
      foodRating: Color.lerp(foodRating, other.foodRating, t) ?? foodRating,
      tableAvailable: Color.lerp(tableAvailable, other.tableAvailable, t) ?? tableAvailable,
      tableOccupied: Color.lerp(tableOccupied, other.tableOccupied, t) ?? tableOccupied,
      tableReserved: Color.lerp(tableReserved, other.tableReserved, t) ?? tableReserved,
      tableCleaning: Color.lerp(tableCleaning, other.tableCleaning, t) ?? tableCleaning,
      brandGradient: LinearGradient.lerp(brandGradient, other.brandGradient, t) ?? brandGradient,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t) ?? surfaceElevated,
      onSurfaceElevated: Color.lerp(onSurfaceElevated, other.onSurfaceElevated, t) ?? onSurfaceElevated,
    );
  }
}

/// Extension for easy access to custom colors from BuildContext
extension CustomColorsExtension on BuildContext {
  CustomColors get customColors => Theme.of(this).extension<CustomColors>()!;
}

/// Spacing extension for consistent spacing values
@immutable
class CustomSpacing extends ThemeExtension<CustomSpacing> {
  const CustomSpacing({
    required this.micro,
    required this.tiny,
    required this.small,
    required this.medium,
    required this.large,
    required this.extraLarge,
    required this.huge,
    required this.massive,
  });

  final double micro;    // 2px
  final double tiny;     // 4px
  final double small;    // 8px
  final double medium;   // 16px
  final double large;    // 24px
  final double extraLarge; // 32px
  final double huge;     // 48px
  final double massive;  // 64px

  static const CustomSpacing standard = CustomSpacing(
    micro: 2.0,
    tiny: 4.0,
    small: 8.0,
    medium: 16.0,
    large: 24.0,
    extraLarge: 32.0,
    huge: 48.0,
    massive: 64.0,
  );

  @override
  CustomSpacing copyWith({
    double? micro,
    double? tiny,
    double? small,
    double? medium,
    double? large,
    double? extraLarge,
    double? huge,
    double? massive,
  }) {
    return CustomSpacing(
      micro: micro ?? this.micro,
      tiny: tiny ?? this.tiny,
      small: small ?? this.small,
      medium: medium ?? this.medium,
      large: large ?? this.large,
      extraLarge: extraLarge ?? this.extraLarge,
      huge: huge ?? this.huge,
      massive: massive ?? this.massive,
    );
  }

  @override
  CustomSpacing lerp(ThemeExtension<CustomSpacing>? other, double t) {
    if (other is! CustomSpacing) {
      return this;
    }

    return CustomSpacing(
      micro: lerpDouble(micro, other.micro, t),
      tiny: lerpDouble(tiny, other.tiny, t),
      small: lerpDouble(small, other.small, t),
      medium: lerpDouble(medium, other.medium, t),
      large: lerpDouble(large, other.large, t),
      extraLarge: lerpDouble(extraLarge, other.extraLarge, t),
      huge: lerpDouble(huge, other.huge, t),
      massive: lerpDouble(massive, other.massive, t),
    );
  }

  double lerpDouble(double a, double b, double t) {
    return a + (b - a) * t;
  }
}

/// Extension for easy access to custom spacing from BuildContext
extension CustomSpacingExtension on BuildContext {
  CustomSpacing get spacing => Theme.of(this).extension<CustomSpacing>()!;
}