import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme_service.dart';

class ThemeScreen extends ConsumerWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeProvider);
    final selectedTheme = currentTheme.name;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFFFFCF5),
      body: SafeArea(
        child: Column(
          children: [
            // Add top spacing to bring everything down
            const SizedBox(height: 20),
            // Header with back button and title - Exactly like Figma
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  // Back button using SVG asset
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: SvgPicture.asset(
                      'assets/images/icons/SVGs/Settings/Back_Button.svg',
                      width: 32,
                      height: 32,
                      colorFilter: ColorFilter.mode(
                        isDarkMode ? const Color(0xFFFEFEFF) : const Color(0xFF1A1A1A),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Title with exact Figma typography
                  Expanded(
                    child: Text(
                      'Theme',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                        color: isDarkMode ? const Color(0xCCFEFEFF) : const Color(0xCC1A1A1A),
                        height: 32 / 24, // lineHeight 32px
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Reduced gap between header and content
            const SizedBox(height: 16),
            
            // Theme options container - Exactly like Figma
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // "Select theme" label
                  Text(
                    'Select theme',
                    style: TextStyle(
                      color: isDarkMode ? const Color(0xCCFEFEFF) : const Color(0xCC1A1A1A),
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.normal,
                      height: 21 / 14, // lineHeight 21px
                    ),
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Theme options with 3 equal border lines
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: isDarkMode ? const Color(0xFF4D4E52) : const Color(0xFFD9D9D9), width: 1),
                        bottom: BorderSide(color: isDarkMode ? const Color(0xFF4D4E52) : const Color(0xFFD9D9D9), width: 1),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Light Theme Option
                        _buildThemeOption(
                          title: 'Light',
                          isSelected: selectedTheme == 'Light',
                          onTap: () {
                            ref.read(themeProvider.notifier).setThemeMode(AppThemeMode.light);
                          },
                          isDarkMode: isDarkMode,
                          showMiddleBorder: true,
                        ),
                        // Dark Theme Option
                        _buildThemeOption(
                          title: 'Dark',
                          isSelected: selectedTheme == 'Dark',
                          onTap: () {
                            ref.read(themeProvider.notifier).setThemeMode(AppThemeMode.dark);
                          },
                          isDarkMode: isDarkMode,
                          showMiddleBorder: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDarkMode,
    required bool showMiddleBorder,
  }) {
    final textColor = isDarkMode ? const Color(0xFFFEFEFF) : const Color(0xFF1A1A1A);
    final borderColor = isDarkMode ? const Color(0xFF4D4E52) : const Color(0xFFD9D9D9);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          // Middle border between Light and Dark options
          border: showMiddleBorder 
              ? Border(bottom: BorderSide(color: borderColor, width: 1))
              : null,
        ),
        child: Row(
          children: [
            // Title text
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.normal,
                  color: textColor,
                  height: 21 / 14, // lineHeight 21px
                ),
              ),
            ),
            // Radio button with exact SVG from assets
            SvgPicture.asset(
              isSelected
                  ? 'assets/images/icons/SVGs/Settings/Radio_button _selected.svg'
                  : 'assets/images/icons/SVGs/Settings/Radio_button _Unselected.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                isSelected
                    ? (isDarkMode ? const Color(0xFFFFFBF1) : const Color(0xFF1A1A1A))
                    : const Color(0xFF9C9C9D),
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}