import 'package:flutter/material.dart';
import '../buttons/custom_radio_button.dart';

/// Reusable settings option item with text and radio button
class SettingsOptionItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showTopBorder;
  final bool showBottomBorder;
  final double height;

  const SettingsOptionItem({
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
              ? const BorderSide(color: Color(0xFF4D4E52), width: 1) 
              : BorderSide.none,
          bottom: showBottomBorder 
              ? const BorderSide(color: Color(0xFF4D4E52), width: 1) 
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
                    color: Color(0xFFFEFEFF),
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.normal,
                    height: 21 / 14,
                  ),
                ),
                // Radio Button
                CustomRadioButton(isSelected: isSelected),
              ],
            ),
          ),
        ),
      ),
    );
  }
}