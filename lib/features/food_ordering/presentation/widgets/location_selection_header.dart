import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme_service.dart';

/// Location selection header widget matching Figma design with theme support
/// Contains back button and "Select Location" title
class LocationSelectionHeader extends StatelessWidget {
  const LocationSelectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Theme-aware background matching Figma design
      color: context.getThemedColor(
        lightColor: const Color(0xFFFFFCF5), // Light theme: cream background
        darkColor: const Color(0xFF1A1A1A), // Dark theme: neutral background
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // px-4 py-2
      child: Row(
        children: [
          // Back button matching Figma design
          _buildBackButton(context),
          
          const SizedBox(width: 16.0), // gap-4 = 16px
          
          // "Select Location" title
          Expanded(
            child: _buildTitle(context),
          ),
        ],
      ),
    );
  }

  /// Build back button matching Figma specifications
  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (context.canPop()) {
          context.pop();
        }
      },
      child: Container(
        width: 44.0, // Button size from Figma
        height: 44.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(44.0), // rounded-[44px] - circular
          border: Border.all(
            color: context.getThemedColor(
              lightColor: const Color(0xFF1A1A1A), // Light theme: dark border
              darkColor: const Color(0xFFFEFEFF), // Dark theme: light border
            ),
            width: 1.0,
          ),
        ),
        child: Center(
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 16.0, // size-4 = 16px
            color: context.getThemedColor(
              lightColor: const Color(0xFF1A1A1A), // Light theme: dark icon
              darkColor: const Color(0xFFFEFEFF), // Dark theme: light icon
            ),
          ),
        ),
      ),
    );
  }

  /// Build title text matching Figma design
  Widget _buildTitle(BuildContext context) {
    return Text(
      'Select Location',
      style: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: context.getThemedColor(
          lightColor: const Color(0xCC1A1A1A), // Light theme: dark text with opacity
          darkColor: const Color(0xCCFEFEFF), // Dark theme: light text with opacity
        ),
        height: 32 / 24,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}