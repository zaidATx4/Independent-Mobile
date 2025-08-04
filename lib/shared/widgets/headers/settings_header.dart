import 'package:flutter/material.dart';
import '../buttons/settings_back_button.dart';

/// Reusable header component for settings screens with back button and title
class SettingsHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final EdgeInsets padding;

  const SettingsHeader({
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
          SettingsBackButton(onPressed: onBackPressed),
          const SizedBox(width: 16),
          // Title
          Text(
            title,
            style: const TextStyle(
              color: Color(0xCCFEFEFF), // rgba(254,254,255,0.8)
              fontSize: 24,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              height: 32 / 24,
            ),
          ),
        ],
      ),
    );
  }
}