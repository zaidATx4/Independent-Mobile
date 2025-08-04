import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_spacing.dart';
import 'theme_extensions.dart';

class DarkTheme {
  static ThemeData get theme {
    const colorScheme = ColorScheme.dark(
      // Primary colors - Restaurant brand
      primary: AppColors.primaryDark,
      onPrimary: AppColors.darkOnPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.onPrimaryContainer,
      
      // Secondary colors
      secondary: AppColors.secondaryDark,
      onSecondary: AppColors.darkOnSecondary,
      secondaryContainer: AppColors.secondaryContainer,
      onSecondaryContainer: AppColors.onSecondaryContainer,
      
      // Surface colors for dark theme
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkOnSurface,
      surfaceContainerHighest: AppColors.darkSurfaceVariant,
      onSurfaceVariant: AppColors.darkOnSurfaceVariant,
      
      // Error colors
      error: AppColors.darkError,
      onError: AppColors.darkOnError,
      errorContainer: AppColors.darkErrorContainer,
      onErrorContainer: AppColors.darkOnErrorContainer,
      
      // Outline colors
      outline: AppColors.darkOutline,
      outlineVariant: AppColors.darkOutlineVariant,
      
      // Shadow and surface tint
      shadow: AppColors.darkShadow,
      surfaceTint: AppColors.primaryDark,
      
      // Inverse colors
      inverseSurface: AppColors.lightSurface,
      onInverseSurface: AppColors.lightOnSurface,
      inversePrimary: AppColors.primary,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.darkBackground,
      
      // Extensions for custom colors
      extensions: <ThemeExtension<dynamic>>[
        CustomColors.dark,
      ],

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkOnSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.h5.copyWith(
          color: AppColors.darkOnSurface,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(
          color: AppColors.darkOnSurface,
        ),
        actionsIconTheme: IconThemeData(
          color: AppColors.darkOnSurface,
        ),
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: AppTypography.h1.copyWith(color: AppColors.darkOnBackground),
        displayMedium: AppTypography.h2.copyWith(color: AppColors.darkOnBackground),
        displaySmall: AppTypography.h3.copyWith(color: AppColors.darkOnBackground),
        headlineLarge: AppTypography.h4.copyWith(color: AppColors.darkOnBackground),
        headlineMedium: AppTypography.h5.copyWith(color: AppColors.darkOnBackground),
        headlineSmall: AppTypography.h6.copyWith(color: AppColors.darkOnBackground),
        bodyLarge: AppTypography.bodyLarge.copyWith(color: AppColors.darkOnSurface),
        bodyMedium: AppTypography.bodyMedium.copyWith(color: AppColors.darkOnSurface),
        bodySmall: AppTypography.bodySmall.copyWith(color: AppColors.darkOnSurfaceVariant),
        labelLarge: AppTypography.buttonLarge.copyWith(color: AppColors.darkOnSurface),
        labelMedium: AppTypography.buttonMedium.copyWith(color: AppColors.darkOnSurface),
        labelSmall: AppTypography.buttonSmall.copyWith(color: AppColors.darkOnSurface),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryDark,
          foregroundColor: AppColors.darkOnPrimary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          elevation: AppSpacing.elevation2,
          textStyle: AppTypography.buttonMedium.copyWith(
            color: AppColors.darkOnPrimary,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryDark,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          side: BorderSide(color: AppColors.primaryDark),
          textStyle: AppTypography.buttonMedium.copyWith(
            color: AppColors.primaryDark,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryDark,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          textStyle: AppTypography.buttonMedium.copyWith(
            color: AppColors.primaryDark,
          ),
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: AppSpacing.elevation2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        margin: const EdgeInsets.all(AppSpacing.sm),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: AppColors.darkOutline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: AppColors.primaryDark, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: AppColors.darkError, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.darkOnSurfaceVariant,
        ),
        labelStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.darkOnSurfaceVariant,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: AppColors.primaryDark,
        unselectedItemColor: AppColors.darkOnSurfaceVariant,
        elevation: AppSpacing.elevation8,
        type: BottomNavigationBarType.fixed,
      ),

      // Navigation Bar Theme (Material 3)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        indicatorColor: AppColors.primaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.labelSmall.copyWith(color: AppColors.darkOnSurface);
          }
          return AppTypography.labelSmall.copyWith(color: AppColors.darkOnSurfaceVariant);
        }),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: AppColors.darkOnPrimary,
        elevation: AppSpacing.elevation6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.darkSurface,
        elevation: AppSpacing.elevation8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        titleTextStyle: AppTypography.h6.copyWith(
          color: AppColors.darkOnSurface,
        ),
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.darkOnSurface,
        ),
      ),

      // Snack Bar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkSurfaceVariant,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.darkOnSurface,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkSurfaceVariant,
        labelStyle: AppTypography.labelMedium.copyWith(
          color: AppColors.darkOnSurface,
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
            return AppColors.darkOnPrimary;
          }
          return AppColors.darkOutline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryDark;
          }
          return AppColors.darkSurfaceVariant;
        }),
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: AppColors.darkOutlineVariant,
        thickness: 1,
        space: AppSpacing.sm,
      ),
    );
  }
}