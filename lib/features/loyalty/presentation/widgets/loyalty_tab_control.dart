import 'package:flutter/material.dart';
import '../../../../core/theme/theme_service.dart';

class LoyaltyTabControl extends StatelessWidget {
  final String selectedTab;
  final Function(String)? onTabSelected;

  const LoyaltyTabControl({
    super.key,
    required this.selectedTab,
    this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          // Border container using positioned to avoid layout shifts
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                  width: 1.0,
                ),
              ),
            ),
          ),
          // Content container with exact 2px padding as per Figma
          Container(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              children: [
                Expanded(
                  child: _buildTabItem(context, 'Discover', selectedTab == 'Discover'),
                ),
                Expanded(
                  child: _buildTabItem(context, 'Scan', selectedTab == 'Scan'),
                ),
                Expanded(
                  child: _buildTabItem(context, 'History', selectedTab == 'History'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(BuildContext context, String title, bool isSelected) {
    return GestureDetector(
      onTap: () => onTabSelected?.call(title),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: isSelected 
              ? context.getThemedColor(
                  lightColor: const Color(0xFF242424), // Dark background for selected in light theme
                  darkColor: const Color(0xFFFFFBF1), // Light background for selected in dark theme
                )
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14.0), // Exact 14px radius as per Figma
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500, // Medium
              fontSize: 14.0,
              height: 1.5, // 21/14 = 1.5 line height ratio
              color: isSelected
                  ? context.getThemedColor(
                      lightColor: const Color(0xFFFFFFFF), // White text on dark background in light theme
                      darkColor: const Color(0xFF242424), // Dark text on light background in dark theme
                    )
                  : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), // Unselected text
            ),
          ),
        ),
      ),
    );
  }
}