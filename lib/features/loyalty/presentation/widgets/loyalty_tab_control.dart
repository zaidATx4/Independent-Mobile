import 'package:flutter/material.dart';

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
                  color: const Color(0xFF9C9C9D), // indpt/text tertiary
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
                  child: _buildTabItem('Discover', selectedTab == 'Discover'),
                ),
                Expanded(
                  child: _buildTabItem('Scan', selectedTab == 'Scan'),
                ),
                Expanded(
                  child: _buildTabItem('History', selectedTab == 'History'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, bool isSelected) {
    return GestureDetector(
      onTap: () => onTabSelected?.call(title),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFFBF1) : Colors.transparent, // indpt/sand
          borderRadius: BorderRadius.circular(14.0), // Exact 14px radius as per Figma
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500, // Medium
              fontSize: 14.0,
              height: 1.5, // 21/14 = 1.5 line height ratio
              color: Color(0xFF242424), // indpt/accent for active, will be overridden below
            ).copyWith(
              color: isSelected
                  ? const Color(0xFF242424) // indpt/accent
                  : const Color(0xFF9C9C9D), // indpt/text tertiary
            ),
          ),
        ),
      ),
    );
  }
}