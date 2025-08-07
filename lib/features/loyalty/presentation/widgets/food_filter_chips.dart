import 'package:flutter/material.dart';
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
          color: isSelected ? const Color(0xFFFFFBF1) : Colors.transparent, // indpt/sand
          borderRadius: BorderRadius.circular(21), // border-radius: 21px
          border: Border.all(
            color: isSelected 
                ? const Color(0xFFFFFBF1) // indpt/sand
                : const Color(0xFF9C9C9D), // indpt/text tertiary
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
                  ? const Color(0xFF242424) // indpt/accent
                  : const Color(0xFF9C9C9D), // indpt/text tertiary
            ),
            textAlign: TextAlign.center,
            maxLines: 1, // Single line to fit within 18px height
          ),
        ),
      ),
    );
  }
}