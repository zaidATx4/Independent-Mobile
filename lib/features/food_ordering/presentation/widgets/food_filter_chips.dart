import 'package:flutter/material.dart';

/// Food category filter chips widget matching Figma design
/// Displays horizontal scrollable list of category filters
class FoodFilterChips extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const FoodFilterChips({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF1A1A1A), // indpt/neutral background
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // px-4 py-2
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            // Generate filter chips for each category
            for (int index = 0; index < categories.length; index++) ...[
              _buildFilterChip(
                categories[index],
                isSelected: categories[index] == selectedCategory,
              ),
              if (index < categories.length - 1) const SizedBox(width: 4.0), // gap-1
            ],
          ],
        ),
      ),
    );
  }

  /// Build individual filter chip matching Figma design
  Widget _buildFilterChip(String category, {required bool isSelected}) {
    return GestureDetector(
      onTap: () => onCategorySelected(category),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0), // px-2 py-0
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFFBF1) : Colors.transparent, // indpt/sand when selected
          borderRadius: BorderRadius.circular(21.0), // rounded-[21px]
          border: Border.all(
            color: isSelected 
                ? const Color(0xFFFFFBF1) // indpt/sand border when selected
                : const Color(0xFF9C9C9D), // indpt/text tertiary border when not selected
            width: 1.0,
          ),
        ),
        child: Center(
          child: Text(
            category,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 12.0,
              fontWeight: FontWeight.w400, // Regular
              color: isSelected 
                  ? const Color(0xFF242424) // indpt/accent text when selected
                  : const Color(0xFF9C9C9D), // indpt/text tertiary when not selected
              height: 1.5, // line-height: 18px / 12px
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

/// Extension to get display-friendly category names
extension CategoryDisplay on String {
  String get displayName {
    switch (toLowerCase()) {
      case 'fries & sides':
        return 'Fries & Sides';
      case 'coffee & drinks':
        return 'Coffee & Drinks';
      default:
        return this;
    }
  }
}