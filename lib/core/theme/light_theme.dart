import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_spacing.dart';
import 'theme_extensions.dart';

class LightTheme {
  static ThemeData get theme {
    const colorScheme = ColorScheme.light(
      // Primary colors - Restaurant brand
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryLightContainer,
      onPrimaryContainer: AppColors.onPrimaryLightContainer,
      
      // Secondary colors
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      secondaryContainer: AppColors.secondaryLightContainer,
      onSecondaryContainer: AppColors.onSecondaryLightContainer,
      
      // Surface colors for light theme
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightOnSurface,
      surfaceContainerHighest: AppColors.lightSurfaceVariant,
      onSurfaceVariant: AppColors.lightOnSurfaceVariant,
      
      // Background colors mapped to surface (background deprecated in M3)
      
      // Error colors
      error: AppColors.error,
      onError: AppColors.onError,
      errorContainer: AppColors.lightErrorContainer,
      onErrorContainer: AppColors.onLightErrorContainer,
      
      // Outline colors
      outline: AppColors.lightOutline,
      outlineVariant: AppColors.lightOutlineVariant,
      
      // Shadow and surface tint
      shadow: AppColors.lightShadow,
      surfaceTint: AppColors.primary,
      
      // Inverse colors
      inverseSurface: AppColors.darkSurface,
      onInverseSurface: AppColors.darkOnSurface,
      inversePrimary: AppColors.primaryDark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.lightBackground,
      
      // Extensions for custom colors
      extensions: <ThemeExtension<dynamic>>[
        CustomColors.light,
      ],

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightSurface,
        foregroundColor: AppColors.lightOnSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.h5.copyWith(
          color: AppColors.lightOnSurface,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: IconThemeData(
          color: AppColors.lightOnSurface,
        ),
        actionsIconTheme: IconThemeData(
          color: AppColors.lightOnSurface,
        ),
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: AppTypography.h1.copyWith(color: AppColors.lightOnBackground),
        displayMedium: AppTypography.h2.copyWith(color: AppColors.lightOnBackground),
        displaySmall: AppTypography.h3.copyWith(color: AppColors.lightOnBackground),
        headlineLarge: AppTypography.h4.copyWith(color: AppColors.lightOnBackground),
        headlineMedium: AppTypography.h5.copyWith(color: AppColors.lightOnBackground),
        headlineSmall: AppTypography.h6.copyWith(color: AppColors.lightOnBackground),
        bodyLarge: AppTypography.bodyLarge.copyWith(color: AppColors.lightOnSurface),
        bodyMedium: AppTypography.bodyMedium.copyWith(color: AppColors.lightOnSurface),
        bodySmall: AppTypography.bodySmall.copyWith(color: AppColors.lightOnSurfaceVariant),
        labelLarge: AppTypography.buttonLarge.copyWith(color: AppColors.lightOnSurface),
        labelMedium: AppTypography.buttonMedium.copyWith(color: AppColors.lightOnSurface),
        labelSmall: AppTypography.buttonSmall.copyWith(color: AppColors.lightOnSurface),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          elevation: AppSpacing.elevation2,
          textStyle: AppTypography.buttonMedium.copyWith(
            color: AppColors.onPrimary,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          side: BorderSide(color: AppColors.primary),
          textStyle: AppTypography.buttonMedium.copyWith(
            color: AppColors.primary,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          textStyle: AppTypography.buttonMedium.copyWith(
            color: AppColors.primary,
          ),
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: AppSpacing.elevation2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        margin: const EdgeInsets.all(AppSpacing.sm),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: AppColors.lightOutline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.lightOnSurfaceVariant,
        ),
        labelStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.lightOnSurfaceVariant,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.lightOnSurfaceVariant,
        elevation: AppSpacing.elevation8,
        type: BottomNavigationBarType.fixed,
      ),

      // Navigation Bar Theme (Material 3)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        indicatorColor: AppColors.primaryLightContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.labelSmall.copyWith(color: AppColors.lightOnSurface);
          }
          return AppTypography.labelSmall.copyWith(color: AppColors.lightOnSurfaceVariant);
        }),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: AppSpacing.elevation6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.lightSurface,
        elevation: AppSpacing.elevation8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        titleTextStyle: AppTypography.h6.copyWith(
          color: AppColors.lightOnSurface,
        ),
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.lightOnSurface,
        ),
      ),

      // Snack Bar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.lightSurfaceVariant,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.lightOnSurface,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.lightSurfaceVariant,
        labelStyle: AppTypography.labelMedium.copyWith(
          color: AppColors.lightOnSurface,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.onPrimary;
          }
          return AppColors.lightOutline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.lightSurfaceVariant;
        }),
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: AppColors.lightOutlineVariant,
        thickness: 1,
        space: AppSpacing.sm,
      ),
    );
  }
}