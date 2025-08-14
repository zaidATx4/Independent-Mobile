import '../entities/food_item_entity.dart';
import '../repositories/food_item_repository.dart';

/// Use case for food item operations
/// Encapsulates business logic for food item retrieval and filtering
class GetFoodItemsUseCase {
  final FoodItemRepository _repository;

  GetFoodItemsUseCase(this._repository);

  /// Get all food items for a specific restaurant location
  Future<List<FoodItemEntity>> getFoodItemsByLocationId(String locationId) {
    return _repository.getFoodItemsByLocationId(locationId);
  }

  /// Get food items by category for a specific location
  Future<List<FoodItemEntity>> getFoodItemsByCategory(
    String locationId,
    String category,
  ) {
    return _repository.getFoodItemsByCategory(locationId, category);
  }

  /// Get all available categories for a specific location
  Future<List<String>> getCategoriesByLocationId(String locationId) {
    return _repository.getCategoriesByLocationId(locationId);
  }

  /// Get popular/featured food items for a specific location
  Future<List<FoodItemEntity>> getPopularFoodItems(String locationId) {
    return _repository.getPopularFoodItems(locationId);
  }

  /// Search food items by name or description
  Future<List<FoodItemEntity>> searchFoodItems(
    String locationId,
    String query,
  ) {
    if (query.trim().isEmpty) {
      return getFoodItemsByLocationId(locationId);
    }
    return _repository.searchFoodItems(locationId, query);
  }

  /// Get food items filtered by dietary requirements
  Future<List<FoodItemEntity>> getFoodItemsByDietaryTags(
    String locationId,
    List<String> dietaryTags,
  ) {
    if (dietaryTags.isEmpty) {
      return getFoodItemsByLocationId(locationId);
    }
    return _repository.getFoodItemsByDietaryTags(locationId, dietaryTags);
  }

  /// Get food items by spice level range
  Future<List<FoodItemEntity>> getFoodItemsBySpiceLevel(
    String locationId,
    int minSpiceLevel,
    int maxSpiceLevel,
  ) {
    return _repository.getFoodItemsBySpiceLevel(
      locationId,
      minSpiceLevel,
      maxSpiceLevel,
    );
  }

  /// Get a single food item by its ID
  Future<FoodItemEntity?> getFoodItemById(String itemId) {
    return _repository.getFoodItemById(itemId);
  }

  /// Get food items by price range
  Future<List<FoodItemEntity>> getFoodItemsByPriceRange(
    String locationId,
    double minPrice,
    double maxPrice,
  ) {
    return _repository.getFoodItemsByPriceRange(
      locationId,
      minPrice,
      maxPrice,
    );
  }

  /// Check if a food item is available at a specific location
  Future<bool> isFoodItemAvailable(String itemId, String locationId) {
    return _repository.isFoodItemAvailable(itemId, locationId);
  }

  /// Refresh the food items data for a specific location
  Future<List<FoodItemEntity>> refreshFoodItems(String locationId) {
    return _repository.refreshFoodItems(locationId);
  }

  /// Get filtered food items based on multiple criteria
  /// This is a business logic method that combines multiple filters
  Future<List<FoodItemEntity>> getFilteredFoodItems({
    required String locationId,
    String? category,
    String? searchQuery,
    List<String>? dietaryTags,
    int? minSpiceLevel,
    int? maxSpiceLevel,
    double? minPrice,
    double? maxPrice,
    bool onlyPopular = false,
  }) async {
    List<FoodItemEntity> items;

    // Start with category or all items
    if (category != null && category.isNotEmpty) {
      items = await getFoodItemsByCategory(locationId, category);
    } else {
      items = await getFoodItemsByLocationId(locationId);
    }

    // Apply search filter
    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final searchResults = await searchFoodItems(locationId, searchQuery);
      final searchIds = searchResults.map((item) => item.id).toSet();
      items = items.where((item) => searchIds.contains(item.id)).toList();
    }

    // Apply dietary tags filter
    if (dietaryTags != null && dietaryTags.isNotEmpty) {
      items = items.where((item) {
        return dietaryTags.any((tag) => item.dietaryTags.contains(tag));
      }).toList();
    }

    // Apply spice level filter
    if (minSpiceLevel != null || maxSpiceLevel != null) {
      final minLevel = minSpiceLevel ?? 0;
      final maxLevel = maxSpiceLevel ?? 5;
      items = items.where((item) {
        return item.spiceLevel >= minLevel && item.spiceLevel <= maxLevel;
      }).toList();
    }

    // Apply price range filter
    if (minPrice != null || maxPrice != null) {
      final minPriceValue = minPrice ?? 0.0;
      final maxPriceValue = maxPrice ?? double.infinity;
      items = items.where((item) {
        return item.price >= minPriceValue && item.price <= maxPriceValue;
      }).toList();
    }

    // Apply popular filter
    if (onlyPopular) {
      items = items.where((item) => item.isPopular).toList();
    }

    // Filter out unavailable items
    items = items.where((item) => item.isAvailable).toList();

    return items;
  }
}