import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Header widget for brand selection screen matching Figma design
class BrandSelectionHeader extends StatelessWidget {
  const BrandSelectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
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
                fontWeight: FontWeight.w700,
                fontSize: 24,
                height: 32 / 24,
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xCCFEFEFF)
                    : const Color(0xCC1A1A1A),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Cart/Shopping button
          Container(
            padding: const EdgeInsets.all(8.0), // p-[8px]
            decoration: const BoxDecoration(
              color: Color(0xFFFFFBF1), // bg-[#fffbf1] - sand color
              borderRadius: BorderRadius.all(
                Radius.circular(44.0),
              ), // rounded-[44px]
            ),
            child: _buildCartIcon(),
          ),
        ],
      ),
    );
  }

  /// Build cart icon based on Figma design
  Widget _buildCartIcon() {
    return SizedBox(
      width: 16.0,
      height: 16.0,
      child: SvgPicture.asset(
        'assets/images/icons/SVGs/Loyalty/Cart_icon.svg',
        width: 16.0,
        height: 16.0,
        colorFilter: const ColorFilter.mode(
          Color(0xFF242424), // Dark color for visibility on light background
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
