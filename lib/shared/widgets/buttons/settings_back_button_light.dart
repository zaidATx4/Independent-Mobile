import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Light theme version of reusable circular back button used in settings screens
/// Features dark background with light icon for proper contrast on light surfaces
class SettingsBackButtonLight extends StatelessWidget {
  final VoidCallback? onPressed;
  final double size;
  final double iconSize;

  const SettingsBackButtonLight({
    super.key,
    this.onPressed,
    this.size = 32,
    this.iconSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () => context.pop(),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A), // Dark background
          borderRadius: BorderRadius.circular(44),
        ),
        child: Center(
          child: Icon(
            Icons.chevron_left,
            color: const Color(0xFFFEFEFF), // Light icon for contrast
            size: iconSize,
          ),
        ),
      ),
    );
  }
}