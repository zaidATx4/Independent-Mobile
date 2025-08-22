import 'package:flutter/material.dart';
import '../buttons/settings_back_button_light.dart';

/// Light theme version of reusable header component for settings screens
/// Matches Figma design with light background and dark text
class SettingsHeaderLight extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final EdgeInsets padding;

  const SettingsHeaderLight({
    super.key,
    required this.title,
    this.onBackPressed,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      child: Row(
        children: [
          // Back Button
          SettingsBackButtonLight(onPressed: onBackPressed),
          const SizedBox(width: 16),
          // Title
          Text(
            title,
            style: const TextStyle(
              color: Color(0xCC1A1A1A), // Dark text with opacity for light theme
              fontSize: 24,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              height: 32 / 24, // Figma line-height / font-size
            ),
          ),
        ],
      ),
    );
  }
}