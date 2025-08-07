import 'package:flutter/material.dart';
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
              color: const Color(0xFF9C9C9D).withOpacity(0.5), // indpt/text tertiary with opacity
            ),
            const SizedBox(height: 16),
            Text(
              'No items found',
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500, // Medium
                fontSize: 16,
                height: 24 / 16, // Indpt/Text 1
                color: Color(0xFF9C9C9D), // indpt/text tertiary
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400, // Regular
                fontSize: 14,
                height: 21 / 14, // Indpt/btn
                color: Color(0xFF9C9C9D), // indpt/text tertiary
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