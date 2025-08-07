import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
          color: const Color(0xFFFEFEFF).withValues(alpha: 0.64), // rgba(254,254,255,0.64)
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
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400, // Regular
                fontSize: 16,
                height: 24 / 16, // lineHeight / fontSize = Indpt/Text 1
                color: Color(0xFFFEFEFF), // indpt/text primary
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400, // Regular
                  fontSize: 16,
                  height: 24 / 16, // lineHeight / fontSize
                  color: Color(0xFF9C9C9D), // indpt/text tertiary
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
                  const Color(0xFFFEFEFF).withValues(alpha: 0.8), // rgba(254,254,255,0.8)
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