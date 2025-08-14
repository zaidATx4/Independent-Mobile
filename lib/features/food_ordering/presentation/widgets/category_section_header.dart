import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Category section header widget matching Figma design
/// Shows category name and filter button
class CategorySectionHeader extends StatelessWidget {
  final String categoryName;
  final int itemCount;
  final VoidCallback? onFilterPressed;
  final String? locationId;
  final String? brandId;
  final String? brandLogoPath;

  const CategorySectionHeader({
    super.key,
    required this.categoryName,
    this.itemCount = 0,
    this.onFilterPressed,
    this.locationId,
    this.brandId,
    this.brandLogoPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF1A1A1A), // indpt/neutral background
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // px-4 py-2
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Category name
          Expanded(
            child: Text(
              categoryName,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 20.0,
                fontWeight: FontWeight.w600, // SemiBold
                color: Color(0xCCFEFEFF), // rgba(254,254,255,0.8)
                height: 1.5, // line-height: 30px / 20px
              ),
            ),
          ),
          
          // Filter button - navigates to categories screen
          GestureDetector(
            onTap: () => _handleCategoriesNavigation(context),
            child: Container(
              width: 32.0, // p-[8px] = 16px padding + 16px icon = 32px total
              height: 32.0,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBF1), // indpt/sand
                borderRadius: BorderRadius.circular(44.0), // rounded-[44px] - fully rounded
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/icons/SVGs/3_Dots.svg',
                  width: 14.0,
                  height: 14.0,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF242424), // Dark color for contrast on sand background
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Handle navigation to categories screen
  void _handleCategoriesNavigation(BuildContext context) {
    if (onFilterPressed != null) {
      onFilterPressed!();
    }
  }
}

/// Simple section divider for visual separation
class SectionDivider extends StatelessWidget {
  final double height;
  final Color? color;

  const SectionDivider({
    super.key,
    this.height = 1.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      color: color ?? const Color(0xFF4D4E52), // indpt/stroke
    );
  }
}