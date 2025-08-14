import '../../domain/entities/food_entities.dart';
import '../models/food_models.dart';

abstract class FoodRepository {
  Future<List<FoodItem>> searchFoodItems(SearchFilters filters);
  Future<List<FoodCategory>> getFoodCategories();
  Future<FoodItem?> getFoodItemById(String id);
}

class FoodRepositoryImpl implements FoodRepository {
  // Simulate network delay for realistic behavior
  static const Duration _networkDelay = Duration(milliseconds: 500);

  @override
  Future<List<FoodItem>> searchFoodItems(SearchFilters filters) async {
    await Future.delayed(_networkDelay);
    
    List<FoodItem> items = FoodDataSource.mockFoodItems
        .map((model) => model.toEntity())
        .toList();

    // Apply search query filter
    if (filters.searchQuery.isNotEmpty) {
      final query = filters.searchQuery.toLowerCase();
      items = items.where((item) {
        return item.name.toLowerCase().contains(query) ||
            item.description.toLowerCase().contains(query) ||
            item.tags.any((tag) => tag.toLowerCase().contains(query));
      }).toList();
    }

    // Apply category filters
    if (filters.selectedCategories.isNotEmpty) {
      items = items.where((item) {
        return filters.selectedCategories.contains(item.category);
      }).toList();
    }

    // Apply price filters
    if (filters.minPrice != null) {
      items = items.where((item) => item.price >= filters.minPrice!).toList();
    }
    if (filters.maxPrice != null) {
      items = items.where((item) => item.price <= filters.maxPrice!).toList();
    }

    // Apply rating filter
    if (filters.minRating != null) {
      items = items.where((item) => item.rating >= filters.minRating!).toList();
    }

    // Apply availability filter
    if (filters.availableOnly == true) {
      items = items.where((item) => item.isAvailable).toList();
    }

    return items;
  }

  @override
  Future<List<FoodCategory>> getFoodCategories() async {
    await Future.delayed(_networkDelay);
    return FoodDataSource.mockCategories
        .map((model) => model.toEntity())
        .toList();
  }

  @override
  Future<FoodItem?> getFoodItemById(String id) async {
    await Future.delayed(_networkDelay);
    final model = FoodDataSource.mockFoodItems
        .where((item) => item.id == id)
        .firstOrNull;
    return model?.toEntity();
  }
}