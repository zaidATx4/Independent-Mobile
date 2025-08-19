import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/cart/presentation/widgets/cart_count_badge.dart';
import '../../../../core/theme/theme_service.dart';

/// Header widget for brand selection screen matching Figma light theme design
class BrandSelectionHeader extends ConsumerWidget {
  const BrandSelectionHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: (screenWidth * 0.0407).clamp(12.0, 20.0), // 16px responsive
        vertical: 8.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Title - Remove Expanded to prevent overflow issues
          Flexible(
            child: Text(
              'Place an Order',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 24,
                height: 32 / 24,
                color: context.getThemedColor(
                  lightColor: const Color(0xCC1A1A1A), // Dark text for light theme
                  darkColor: const Color(0xCCFEFEFF), // Light text for dark theme
                ),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Cart/Shopping button with count badge
          CartCountBadge(
            onTap: () => context.push('/cart'),
            iconColor: context.getThemedColor(
              lightColor: const Color(0xFFFEFEFF), // Light icon for dark background in light theme
              darkColor: const Color(0xFF242424), // Dark icon for light background in dark theme
            ),
            backgroundColor: context.getThemedColor(
              lightColor: const Color(0xFF1A1A1A), // --dark-sand background for light theme
              darkColor: const Color(0xFFFFFBF1), // Sand background for dark theme
            ),
            badgeColor: const Color(0xFFFF4444),
            badgeTextColor: Colors.white,
            size: 32.0,
            iconSize: 16.0,
          ),
        ],
      ),
    );
  }
}
