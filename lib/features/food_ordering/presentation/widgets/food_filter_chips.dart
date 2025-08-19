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
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Container(
      width: double.infinity,
      color: isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFFEFEFF),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // px-4 py-2
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            // Generate filter chips for each category
            for (int index = 0; index < categories.length; index++) ...[
              _buildFilterChip(
                context,
                categories[index],
                isSelected: categories[index] == selectedCategory,
                isDarkMode: isDarkMode,
              ),
              if (index < categories.length - 1) const SizedBox(width: 4.0), // gap-1
            ],
          ],
        ),
      ),
    );
  }

  /// Build individual filter chip matching Figma design
  Widget _buildFilterChip(BuildContext context, String category, {required bool isSelected, required bool isDarkMode}) {
    return GestureDetector(
      onTap: () => onCategorySelected(category),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0), // px-2 py-0
        decoration: BoxDecoration(
          color: isSelected 
              ? (isDarkMode ? const Color(0xFFFEFEFF) : const Color(0xFF1A1A1A))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(21.0), // rounded-[21px]
          border: Border.all(
            color: isSelected 
                ? (isDarkMode ? const Color(0xFFFEFEFF) : const Color(0xFF1A1A1A))
                : const Color(0xFF878787), // Same gray for both themes when not selected
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
                  ? (isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFFEFEFF))
                  : const Color(0xFF878787), // Same gray for both themes when not selected
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