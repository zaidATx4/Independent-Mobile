import '../entities/food_item_entity.dart';

/// Repository interface for food item operations
/// Defines the contract for food item data access
abstract class FoodItemRepository {
  /// Get all food items for a specific restaurant location
  /// [locationId] - The ID of the restaurant location
  /// Returns a list of available food items
  Future<List<FoodItemEntity>> getFoodItemsByLocationId(String locationId);

  /// Get food items by category for a specific location
  /// [locationId] - The ID of the restaurant location
  /// [category] - The category to filter by (e.g., "Desserts", "Burgers")
  /// Returns a list of food items in the specified category
  Future<List<FoodItemEntity>> getFoodItemsByCategory(
    String locationId,
    String category,
  );

  /// Get all available categories for a specific location
  /// [locationId] - The ID of the restaurant location
  /// Returns a list of available food categories
  Future<List<String>> getCategoriesByLocationId(String locationId);

  /// Get popular/featured food items for a specific location
  /// [locationId] - The ID of the restaurant location
  /// Returns a list of popular food items
  Future<List<FoodItemEntity>> getPopularFoodItems(String locationId);

  /// Search food items by name or description
  /// [locationId] - The ID of the restaurant location
  /// [query] - The search query string
  /// Returns a list of food items matching the search query
  Future<List<FoodItemEntity>> searchFoodItems(
    String locationId,
    String query,
  );

  /// Get food items filtered by dietary requirements
  /// [locationId] - The ID of the restaurant location
  /// [dietaryTags] - List of dietary tags to filter by
  /// Returns a list of food items matching the dietary requirements
  Future<List<FoodItemEntity>> getFoodItemsByDietaryTags(
    String locationId,
    List<String> dietaryTags,
  );

  /// Get food items by spice level range
  /// [locationId] - The ID of the restaurant location
  /// [minSpiceLevel] - Minimum spice level (0-5)
  /// [maxSpiceLevel] - Maximum spice level (0-5)
  /// Returns a list of food items within the spice level range
  Future<List<FoodItemEntity>> getFoodItemsBySpiceLevel(
    String locationId,
    int minSpiceLevel,
    int maxSpiceLevel,
  );

  /// Get a single food item by its ID
  /// [itemId] - The ID of the food item
  /// Returns the food item or null if not found
  Future<FoodItemEntity?> getFoodItemById(String itemId);

  /// Get food items by price range
  /// [locationId] - The ID of the restaurant location
  /// [minPrice] - Minimum price
  /// [maxPrice] - Maximum price
  /// Returns a list of food items within the price range
  Future<List<FoodItemEntity>> getFoodItemsByPriceRange(
    String locationId,
    double minPrice,
    double maxPrice,
  );

  /// Check if a food item is available at a specific location
  /// [itemId] - The ID of the food item
  /// [locationId] - The ID of the restaurant location
  /// Returns true if the item is available, false otherwise
  Future<bool> isFoodItemAvailable(String itemId, String locationId);

  /// Refresh the food items data for a specific location
  /// [locationId] - The ID of the restaurant location
  /// Returns a list of refreshed food items
  Future<List<FoodItemEntity>> refreshFoodItems(String locationId);
}