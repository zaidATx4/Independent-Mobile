import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Location selection header widget matching Figma design
/// Contains back button and "Select Location" title
class LocationSelectionHeader extends StatelessWidget {
  const LocationSelectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Match Figma design background
      color: const Color(0xFF1A1A1A), // indpt/neutral background
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // px-4 py-2
      child: Row(
        children: [
          // Back button matching Figma design
          _buildBackButton(context),
          
          const SizedBox(width: 16.0), // gap-4 = 16px
          
          // "Select Location" title
          Expanded(
            child: _buildTitle(),
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
            color: const Color(0xFFFEFEFF), // Use #FEFEFF color for border
            width: 1.0,
          ),
        ),
        child: const Center(
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 16.0, // size-4 = 16px
            color: Color(0xFFFEFEFF), // indpt/text primary (white icon)
          ),
        ),
      ),
    );
  }

  /// Build title text matching Figma design
  Widget _buildTitle() {
    return Text(
      'Select Location',
      style: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 24.0, // text-[24px] - Indpt/Title 1
        fontWeight: FontWeight.w700, // font-bold (700)
        color: Color(0xFFFEFEFF), // Full opacity white as requested
        height: 1.33, // line-height: 32px / 24px = 1.33
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}