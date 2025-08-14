import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/theme/theme_service.dart';

class FoodSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hintText;

  const FoodSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hintText = 'Search box',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: context.getThemedColor(
            lightColor: const Color(0xFF1A1A1A).withValues(alpha: 0.64), // Light theme: dark with opacity
            darkColor: const Color(0xFFFEFEFF).withValues(alpha: 0.64), // Dark theme: rgba(254,254,255,0.64)
          ),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(34),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400, // Regular
                fontSize: 16,
                height: 24 / 16, // lineHeight / fontSize = Indpt/Text 1
                color: context.getThemedColor(
                  lightColor: const Color(0xFF1A1A1A), // Light theme: dark text
                  darkColor: const Color(0xFFFEFEFF), // Dark theme: text primary
                ),
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400, // Regular
                  fontSize: 16,
                  height: 24 / 16, // lineHeight / fontSize
                  color: context.getThemedColor(
                    lightColor: const Color(0xFF878787), // Light theme: medium gray
                    darkColor: const Color(0xFF9C9C9D), // Dark theme: text tertiary
                  ),
                ),
                // Ensure completely transparent TextField with no decoration
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                fillColor: Colors.transparent,
                filled: false,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          // Search icon positioned on the right side as per Figma
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: SizedBox(
              width: 24,
              height: 24,
              child: SvgPicture.asset(
                'assets/images/icons/SVGs/Loyalty/Search_icon.svg',
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  context.getThemedColor(
                    lightColor: const Color(0xFF1A1A1A).withValues(alpha: 0.8), // Light theme: dark with opacity
                    darkColor: const Color(0xFFFEFEFF).withValues(alpha: 0.8), // Dark theme: rgba(254,254,255,0.8)
                  ),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}