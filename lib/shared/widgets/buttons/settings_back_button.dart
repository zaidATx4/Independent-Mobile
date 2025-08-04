import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Reusable circular back button with white border used in settings screens
class SettingsBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double size;
  final double iconSize;

  const SettingsBackButton({
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
          border: Border.all(color: const Color(0xFFFEFEFF), width: 1),
          borderRadius: BorderRadius.circular(44),
        ),
        child: Center(
          child: Icon(
            Icons.chevron_left,
            color: const Color(0xFFFEFEFF),
            size: iconSize,
          ),
        ),
      ),
    );
  }
}