import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/providers/navigation_providers.dart';
import '../../loyalty/presentation/pages/scan_screen.dart';
import 'home_screen_without_bottom_nav.dart';

class MainNavigationScreen extends ConsumerWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(selectedTabProvider);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive padding and sizing
    final horizontalPadding = (screenWidth * 0.04).clamp(12.0, 20.0);
    final verticalPadding = (screenHeight * 0.015).clamp(10.0, 16.0);
    final iconSize = 24.0; // Fixed 24px as per Figma
    final fontSize = 10.0; // Fixed 10px as per Figma

    return Scaffold(
      body: _getSelectedScreen(selectedTab),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDarkMode
              ? const Color(0xFF242424) // Dark theme color
              : const Color(0xFFFEFEFF), // Light theme: #fefeff
          border: Border(
            top: BorderSide(
              color: isDarkMode
                  ? const Color(0xFF4D4E52) // Dark theme border
                  : const Color(0xFFD9D9D9), // Light theme border
              width: 1,
            ),
          ),
          boxShadow: isDarkMode
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNavItem(
                    svgPath: 'assets/images/icons/SVGs/Home_Icon_Light.svg',
                    label: 'Home',
                    index: 0,
                    isSelected: selectedTab == 0,
                    iconSize: iconSize,
                    fontSize: fontSize,
                    theme: theme,
                    isDarkMode: isDarkMode,
                    onTap: () => ref.read(selectedTabProvider.notifier).state = 0,
                  ),
                  _buildNavItem(
                    svgPath: 'assets/images/icons/SVGs/QR_Icon_light.svg',
                    label: 'Scan',
                    index: 1,
                    isSelected: selectedTab == 1,
                    iconSize: iconSize,
                    fontSize: fontSize,
                    theme: theme,
                    isDarkMode: isDarkMode,
                    onTap: () => ref.read(selectedTabProvider.notifier).state = 1,
                  ),
                  _buildNavItem(
                    svgPath: 'assets/images/icons/SVGs/Order_Icon_light.svg',
                    label: 'Order',
                    index: 2,
                    isSelected: selectedTab == 2,
                    iconSize: iconSize,
                    fontSize: fontSize,
                    theme: theme,
                    isDarkMode: isDarkMode,
                    onTap: () => ref.read(selectedTabProvider.notifier).state = 2,
                  ),
                  _buildNavItem(
                    svgPath: 'assets/images/icons/SVGs/Restaurant_Icon_light.svg',
                    label: 'Reserve',
                    index: 3,
                    isSelected: selectedTab == 3,
                    iconSize: iconSize,
                    fontSize: fontSize,
                    theme: theme,
                    isDarkMode: isDarkMode,
                    onTap: () => ref.read(selectedTabProvider.notifier).state = 3,
                  ),
                  _buildNavItem(
                    svgPath: 'assets/images/icons/SVGs/Feed_Icon_light.svg',
                    label: 'Feed',
                    index: 4,
                    isSelected: selectedTab == 4,
                    iconSize: iconSize,
                    fontSize: fontSize,
                    theme: theme,
                    isDarkMode: isDarkMode,
                    onTap: () => ref.read(selectedTabProvider.notifier).state = 4,
                  ),
                  _buildNavItem(
                    svgPath: 'assets/images/icons/SVGs/Location_Icon_light.svg',
                    label: 'Location',
                    index: 5,
                    isSelected: selectedTab == 5,
                    iconSize: iconSize,
                    fontSize: fontSize,
                    theme: theme,
                    isDarkMode: isDarkMode,
                    onTap: () => ref.read(selectedTabProvider.notifier).state = 5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getSelectedScreen(int selectedTab) {
    switch (selectedTab) {
      case 0:
        return const HomeScreenWithoutBottomNav();
      case 1:
        return const ScanScreen();
      case 2:
        return const PlaceholderScreen(title: 'Order');
      case 3:
        return const PlaceholderScreen(title: 'Reserve');
      case 4:
        return const PlaceholderScreen(title: 'Feed');
      case 5:
        return const PlaceholderScreen(title: 'Location');
      default:
        return const HomeScreenWithoutBottomNav();
    }
  }

  Widget _buildNavItem({
    required String svgPath,
    required String label,
    required int index,
    required bool isSelected,
    required double iconSize,
    required double fontSize,
    required ThemeData theme,
    required bool isDarkMode,
    required VoidCallback onTap,
  }) {
    final unselectedColor = isDarkMode
        ? const Color(0xFF9C9C9D) // Dark theme tertiary
        : const Color(0xFF878787); // Light theme

    final selectedColor = isDarkMode
        ? const Color(0xFFFFFBF1) // Dark theme sand
        : const Color(0xFF1A1A1A); // Light theme

    final selectedBackground = isDarkMode
        ? const Color(0xFF1A1A1A) // Dark background for selected
        : const Color(0xFFFFFCF5); // Light theme

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? (iconSize * 0.5) : (iconSize * 0.33),
          vertical: (iconSize * 0.33),
        ),
        decoration: isSelected
            ? BoxDecoration(
                color: selectedBackground,
                borderRadius: BorderRadius.circular(
                  isDarkMode ? (iconSize * 0.83) : 38,
                ),
              )
            : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              svgPath,
              width: iconSize,
              height: iconSize,
              colorFilter: ColorFilter.mode(
                isSelected ? selectedColor : unselectedColor,
                BlendMode.srcIn,
              ),
            ),
            if (isSelected) ...[
              SizedBox(width: iconSize * 0.25),
              Text(
                label,
                style: AppTypography.labelMedium.copyWith(
                  color: selectedColor,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Placeholder screen for unimplemented tabs
class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFFEFEFF),
      body: Center(
        child: Text(
          '$title Screen\nComing Soon',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? const Color(0xFFFEFEFF) : const Color(0xFF1A1A1A),
          ),
        ),
      ),
    );
  }
}

