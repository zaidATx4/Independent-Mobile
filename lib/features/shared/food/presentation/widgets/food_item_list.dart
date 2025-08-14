import 'package:flutter/material.dart';
import '../../../../../core/theme/theme_service.dart';
import '../../domain/entities/food_entities.dart';
import 'food_item_card.dart';

class FoodItemList extends StatelessWidget {
  final List<FoodItem> items;
  final ScrollController scrollController;

  const FoodItemList({
    super.key,
    required this.items,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: context.getThemedColor(
                lightColor: const Color(0xFF878787).withValues(alpha: 0.5), // Light theme: medium gray with opacity
                darkColor: const Color(0xFF9C9C9D).withValues(alpha: 0.5), // Dark theme: text tertiary with opacity
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No items found',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500, // Medium
                fontSize: 16,
                height: 24 / 16, // Indpt/Text 1
                color: context.getThemedColor(
                  lightColor: const Color(0xFF878787), // Light theme: medium gray
                  darkColor: const Color(0xFF9C9C9D), // Dark theme: text tertiary
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400, // Regular
                fontSize: 14,
                height: 21 / 14, // Indpt/btn
                color: context.getThemedColor(
                  lightColor: const Color(0xFF878787), // Light theme: medium gray
                  darkColor: const Color(0xFF9C9C9D), // Dark theme: text tertiary
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Padding(
          padding: EdgeInsets.only(
            top: index == 0 ? 8 : 0,
            bottom: index == items.length - 1 ? 100 : 0, // Extra bottom padding for last item
          ),
          child: FoodItemCard(
            item: item,
          ),
        );
      },
    );
  }
}