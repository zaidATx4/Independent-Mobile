import 'package:flutter/material.dart';
import '../buttons/custom_radio_button_light.dart';

/// Light theme version of reusable settings option item with text and radio button
/// Uses light background with dark text and appropriate contrast colors
class SettingsOptionItemLight extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showTopBorder;
  final bool showBottomBorder;
  final double height;

  const SettingsOptionItemLight({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.showTopBorder = true,
    this.showBottomBorder = true,
    this.height = 48,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        border: Border(
          top: showTopBorder 
              ? const BorderSide(color: Color(0xFFD9D9D9), width: 1) // Light stroke color from Figma
              : BorderSide.none,
          bottom: showBottomBorder 
              ? const BorderSide(color: Color(0xFFD9D9D9), width: 1) // Light stroke color from Figma
              : BorderSide.none,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title - Left aligned
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF1A1A1A), // Dark text for light theme
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.normal,
                    height: 21 / 14, // Figma line-height / font-size
                  ),
                ),
                // Radio Button
                CustomRadioButtonLight(isSelected: isSelected),
              ],
            ),
          ),
        ),
      ),
    );
  }
}