import 'package:flutter_test/flutter_test.dart';
import '../lib/features/food_ordering/data/repositories/food_item_repository_impl.dart';

void main() {
  group('FoodItemRepository Tests', () {
    late FoodItemRepositoryImpl repository;

    setUp(() {
      repository = FoodItemRepositoryImpl();
    });

    test('should return food items for any location', () async {
      final result = await repository.getFoodItemsByLocationId('any_location');
      
      print('Total food items: ${result.length}');
      for (final item in result) {
        print('Item: ${item.name} - ${item.category} - ${item.imagePath}');
      }
      
      expect(result.isNotEmpty, true);
      expect(result.length, 17); // Total mock items
    });

    test('should return categories for any location', () async {
      final result = await repository.getCategoriesByLocationId('any_location');
      
      print('Categories: $result');
      
      expect(result.isNotEmpty, true);
      expect(result.contains('Desserts'), true);
    });

    test('should return dessert items', () async {
      final result = await repository.getFoodItemsByCategory('any_location', 'Desserts');
      
      print('Dessert items: ${result.length}');
      for (final item in result) {
        print('Dessert: ${item.name} - ${item.imagePath}');
      }
      
      expect(result.isNotEmpty, true);
      expect(result.every((item) => item.category == 'Desserts'), true);
    });
  });
}