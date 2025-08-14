import 'package:flutter/material.dart';
import '../../../../../core/theme/theme_service.dart';
import '../../domain/entities/food_entities.dart';

class FoodFilterChips extends StatelessWidget {
  final List<FoodCategory> categories;
  final ValueChanged<String> onCategoryToggle;

  const FoodFilterChips({
    super.key,
    required this.categories,
    required this.onCategoryToggle,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          ...categories.map((category) => Padding(
            padding: EdgeInsets.only(
              right: category != categories.last ? 10 : 0, // Exact gap specification: 10px
            ),
            child: FilterChipWidget(
              category: category,
              onTap: () => onCategoryToggle(category.id),
            ),
          )),
        ],
      ),
    );
  }
}

class FilterChipWidget extends StatelessWidget {
  final FoodCategory category;
  final VoidCallback onTap;

  const FilterChipWidget({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = category.isSelected;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // Exact Figma specifications - width auto-sized based on content
        height: 18, // Fixed height: 18px
        padding: const EdgeInsets.symmetric(
          horizontal: 8, // padding-left: 8px, padding-right: 8px
          vertical: 0, // No vertical padding since height is fixed
        ),
        decoration: BoxDecoration(
          color: isSelected 
              ? context.getThemedColor(
                  lightColor: const Color(0xFF1A1A1A), // Light theme: dark background when selected
                  darkColor: const Color(0xFFFFFBF1), // Dark theme: sand
                )
              : Colors.transparent,
          borderRadius: BorderRadius.circular(21), // border-radius: 21px
          border: Border.all(
            color: isSelected 
                ? context.getThemedColor(
                    lightColor: const Color(0xFF1A1A1A), // Light theme: dark border when selected
                    darkColor: const Color(0xFFFFFBF1), // Dark theme: sand
                  )
                : context.getThemedColor(
                    lightColor: const Color(0xFF878787), // Light theme: medium gray when unselected
                    darkColor: const Color(0xFF9C9C9D), // Dark theme: text tertiary
                  ),
            width: 1, // border-width: 1px (exact specification)
            style: BorderStyle.solid,
          ),
        ),
        child: Center(
          child: Text(
            category.displayName,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400, // Regular
              fontSize: 12,
              height: 1.0, // Adjusted to fit within 18px height constraint
              color: isSelected 
                  ? context.getThemedColor(
                      lightColor: const Color(0xFFFEFEFF), // Light theme: white text when selected
                      darkColor: const Color(0xFF242424), // Dark theme: accent
                    )
                  : context.getThemedColor(
                      lightColor: const Color(0xFF878787), // Light theme: medium gray when unselected
                      darkColor: const Color(0xFF9C9C9D), // Dark theme: text tertiary
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