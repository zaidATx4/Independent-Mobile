import 'package:flutter/material.dart';
import '../providers/location_selection_provider.dart';
import '../../../../core/theme/theme_service.dart';

/// Location filter chips widget matching Figma design with theme support
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
        children: _buildFilterChips(context),
      ),
    );
  }

  /// Build list of filter chips
  List<Widget> _buildFilterChips(BuildContext context) {
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
      child: _buildFilterChip(context, filter),
    )).toList();
  }

  /// Build individual filter chip matching food search design
  Widget _buildFilterChip(BuildContext context, LocationFilter filter) {
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
              ? context.getThemedColor(
                  lightColor: const Color(0xFF1A1A1A), // Light theme: dark background when selected
                  darkColor: const Color(0xFFFFFBF1), // Dark theme: sand background when selected
                )
              : Colors.transparent,
          borderRadius: BorderRadius.circular(21), // border-radius: 21px
          border: Border.all(
            color: isSelected 
                ? context.getThemedColor(
                    lightColor: const Color(0xFF1A1A1A), // Light theme: dark border when selected
                    darkColor: const Color(0xFFFFFBF1), // Dark theme: sand border when selected
                  )
                : context.getThemedColor(
                    lightColor: const Color(0xFF878787), // Light theme: gray border when unselected
                    darkColor: const Color(0xFFFEFEFF), // Dark theme: light border when unselected
                  ),
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
                  ? context.getThemedColor(
                      lightColor: const Color(0xFFFEFEFF), // Light theme: light text when selected
                      darkColor: const Color(0xFF242424), // Dark theme: dark text when selected
                    )
                  : context.getThemedColor(
                      lightColor: const Color(0xFF878787), // Light theme: gray text when unselected
                      darkColor: const Color(0xFFFEFEFF), // Dark theme: light text when unselected
                    ),
            ),
            textAlign: TextAlign.center,
            maxLines: 1, // Single line to fit within 18px height
          ),
        ),
      ),
    );
  }
}