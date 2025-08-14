import 'package:flutter/material.dart';
import '../providers/location_selection_provider.dart';

/// Location filter chips widget matching Figma design
/// Displays horizontal scrollable filter chips for location filtering
class LocationFilterChips extends StatelessWidget {
  final LocationFilter selectedFilter;
  final Function(LocationFilter) onFilterSelected;

  const LocationFilterChips({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: _buildFilterChips(),
      ),
    );
  }

  /// Build list of filter chips
  List<Widget> _buildFilterChips() {
    final filters = [
      LocationFilter.all, // Add "All" filter first
      LocationFilter.offers,
      LocationFilter.nearby,
      LocationFilter.availableNow,
      LocationFilter.familyFriendly,
      LocationFilter.outdoorSeating,
    ];

    return filters.map((filter) => Padding(
      padding: EdgeInsets.only(
        right: filter != filters.last ? 6 : 0, // Reduced from 10px to 6px
      ),
      child: _buildFilterChip(filter),
    )).toList();
  }

  /// Build individual filter chip matching food search design
  Widget _buildFilterChip(LocationFilter filter) {
    final isSelected = selectedFilter == filter;
    
    return GestureDetector(
      onTap: () => onFilterSelected(filter),
      child: Container(
        // Exact Figma specifications from food chips - width auto-sized based on content
        height: 18, // Fixed height: 18px
        padding: const EdgeInsets.symmetric(
          horizontal: 8, // padding-left: 8px, padding-right: 8px
          vertical: 0, // No vertical padding since height is fixed
        ),
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(0xFFFFFBF1) // Dark theme: sand when selected
              : Colors.transparent,
          borderRadius: BorderRadius.circular(21), // border-radius: 21px
          border: Border.all(
            color: isSelected 
                ? const Color(0xFFFFFBF1) // Dark theme: sand when selected
                : const Color(0xFFFEFEFF), // Use #FEFEFF for unselected borders
            width: 1, // border-width: 1px (exact specification)
            style: BorderStyle.solid,
          ),
        ),
        child: Center(
          child: Text(
            filter.displayName,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400, // Regular
              fontSize: 12,
              height: 1.0, // Adjusted to fit within 18px height constraint
              color: isSelected 
                  ? const Color(0xFF242424) // Dark theme: accent when selected
                  : const Color(0xFFFEFEFF), // Use #FEFEFF for unselected text
            ),
            textAlign: TextAlign.center,
            maxLines: 1, // Single line to fit within 18px height
          ),
        ),
      ),
    );
  }
}