import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppThemeMode { light, dark }

class ThemeNotifier extends StateNotifier<AppThemeMode> {
  ThemeNotifier() : super(AppThemeMode.dark); // Default to dark as shown in Figma

  void setTheme(AppThemeMode theme) {
    state = theme;
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, AppThemeMode>((ref) {
  return ThemeNotifier();
});