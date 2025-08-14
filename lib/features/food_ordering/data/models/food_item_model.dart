import '../../domain/entities/food_item_entity.dart';

/// Data model for food item that extends the domain entity
/// Handles JSON serialization/deserialization for API communication
class FoodItemModel extends FoodItemEntity {
  const FoodItemModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.currency,
    required super.category,
    required super.imagePath,
    required super.isAvailable,
    required super.locationId,
    required super.brandId,
    super.preparationTimeMinutes,
    super.isPopular,
    super.dietaryTags,
    super.spiceLevel,
    super.calories,
    super.allergens,
  });

  /// Create a FoodItemModel from JSON data
  factory FoodItemModel.fromJson(Map<String, dynamic> json) {
    return FoodItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'SAR',
      category: json['category'] as String,
      imagePath: json['imagePath'] as String,
      isAvailable: json['isAvailable'] as bool? ?? true,
      locationId: json['locationId'] as String,
      brandId: json['brandId'] as String,
      preparationTimeMinutes: json['preparationTimeMinutes'] as int? ?? 15,
      isPopular: json['isPopular'] as bool? ?? false,
      dietaryTags: (json['dietaryTags'] as List<dynamic>?)
              ?.map((tag) => tag.toString())
              .toList() ??
          const [],
      spiceLevel: json['spiceLevel'] as int? ?? 0,
      calories: json['calories'] as int?,
      allergens: (json['allergens'] as List<dynamic>?)
              ?.map((allergen) => allergen.toString())
              .toList() ??
          const [],
    );
  }

  /// Convert the model to JSON format
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'currency': currency,
      'category': category,
      'imagePath': imagePath,
      'isAvailable': isAvailable,
      'locationId': locationId,
      'brandId': brandId,
      'preparationTimeMinutes': preparationTimeMinutes,
      'isPopular': isPopular,
      'dietaryTags': dietaryTags,
      'spiceLevel': spiceLevel,
      'calories': calories,
      'allergens': allergens,
    };
  }

  /// Create a copy of the model with updated values
  FoodItemModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? currency,
    String? category,
    String? imagePath,
    bool? isAvailable,
    String? locationId,
    String? brandId,
    int? preparationTimeMinutes,
    bool? isPopular,
    List<String>? dietaryTags,
    int? spiceLevel,
    int? calories,
    List<String>? allergens,
  }) {
    return FoodItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      category: category ?? this.category,
      imagePath: imagePath ?? this.imagePath,
      isAvailable: isAvailable ?? this.isAvailable,
      locationId: locationId ?? this.locationId,
      brandId: brandId ?? this.brandId,
      preparationTimeMinutes: preparationTimeMinutes ?? this.preparationTimeMinutes,
      isPopular: isPopular ?? this.isPopular,
      dietaryTags: dietaryTags ?? this.dietaryTags,
      spiceLevel: spiceLevel ?? this.spiceLevel,
      calories: calories ?? this.calories,
      allergens: allergens ?? this.allergens,
    );
  }

  /// Convert from entity to model
  factory FoodItemModel.fromEntity(FoodItemEntity entity) {
    return FoodItemModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      currency: entity.currency,
      category: entity.category,
      imagePath: entity.imagePath,
      isAvailable: entity.isAvailable,
      locationId: entity.locationId,
      brandId: entity.brandId,
      preparationTimeMinutes: entity.preparationTimeMinutes,
      isPopular: entity.isPopular,
      dietaryTags: entity.dietaryTags,
      spiceLevel: entity.spiceLevel,
      calories: entity.calories,
      allergens: entity.allergens,
    );
  }

  /// Convert to domain entity
  FoodItemEntity toEntity() {
    return FoodItemEntity(
      id: id,
      name: name,
      description: description,
      price: price,
      currency: currency,
      category: category,
      imagePath: imagePath,
      isAvailable: isAvailable,
      locationId: locationId,
      brandId: brandId,
      preparationTimeMinutes: preparationTimeMinutes,
      isPopular: isPopular,
      dietaryTags: dietaryTags,
      spiceLevel: spiceLevel,
      calories: calories,
      allergens: allergens,
    );
  }
}