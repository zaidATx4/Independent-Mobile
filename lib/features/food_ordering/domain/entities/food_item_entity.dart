/// Food item entity representing menu items from restaurants
/// Contains all necessary information for display and ordering
class FoodItemEntity {
  /// Unique identifier for the food item
  final String id;

  /// Name of the food item (e.g., "Matilda Cake")
  final String name;

  /// Detailed description of the food item
  final String description;

  /// Price in the local currency (SAR)
  final double price;

  /// Currency code (e.g., "SAR")
  final String currency;

  /// Category of the food item (e.g., "Desserts", "Burgers")
  final String category;

  /// Local asset path to the food item image
  final String imagePath;

  /// Whether the item is currently available for ordering
  final bool isAvailable;

  /// Restaurant/location ID where this item is served
  final String locationId;

  /// Brand ID that owns this item
  final String brandId;

  /// Estimated preparation time in minutes
  final int preparationTimeMinutes;

  /// Whether the item is marked as popular/featured
  final bool isPopular;

  /// Dietary tags (e.g., "Vegetarian", "Gluten-Free")
  final List<String> dietaryTags;

  /// Spice level rating (0-5, where 0 is no spice)
  final int spiceLevel;

  /// Calorie count if available
  final int? calories;

  /// Allergen information
  final List<String> allergens;

  const FoodItemEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.currency,
    required this.category,
    required this.imagePath,
    required this.isAvailable,
    required this.locationId,
    required this.brandId,
    this.preparationTimeMinutes = 15,
    this.isPopular = false,
    this.dietaryTags = const [],
    this.spiceLevel = 0,
    this.calories,
    this.allergens = const [],
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FoodItemEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'FoodItemEntity(id: $id, name: $name, price: $price $currency, category: $category)';
  }

  /// Returns formatted price string with currency symbol
  String get formattedPrice {
    return '$price $currency';
  }

  /// Returns whether the item has any dietary restrictions
  bool get hasDietaryRestrictions {
    return dietaryTags.isNotEmpty || allergens.isNotEmpty;
  }

  /// Returns whether the item is spicy (spice level > 0)
  bool get isSpicy {
    return spiceLevel > 0;
  }

  /// Returns spice level description
  String get spiceLevelDescription {
    switch (spiceLevel) {
      case 0:
        return 'No Spice';
      case 1:
        return 'Mild';
      case 2:
        return 'Medium';
      case 3:
        return 'Hot';
      case 4:
        return 'Very Hot';
      case 5:
        return 'Extremely Hot';
      default:
        return 'Unknown';
    }
  }
}