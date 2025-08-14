import '../../domain/entities/food_entities.dart';

class FoodItemModel extends FoodItem {
  const FoodItemModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.currency,
    required super.imagePath,
    required super.category,
    super.isAvailable,
    super.rating,
    super.reviewCount,
    super.tags,
  });

  factory FoodItemModel.fromJson(Map<String, dynamic> json) {
    return FoodItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'SAR',
      imagePath: json['imagePath'] as String,
      category: json['category'] as String,
      isAvailable: json['isAvailable'] as bool? ?? true,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'currency': currency,
      'imagePath': imagePath,
      'category': category,
      'isAvailable': isAvailable,
      'rating': rating,
      'reviewCount': reviewCount,
      'tags': tags,
    };
  }

  factory FoodItemModel.fromEntity(FoodItem entity) {
    return FoodItemModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      currency: entity.currency,
      imagePath: entity.imagePath,
      category: entity.category,
      isAvailable: entity.isAvailable,
      rating: entity.rating,
      reviewCount: entity.reviewCount,
      tags: entity.tags,
    );
  }

  FoodItem toEntity() {
    return FoodItem(
      id: id,
      name: name,
      description: description,
      price: price,
      currency: currency,
      imagePath: imagePath,
      category: category,
      isAvailable: isAvailable,
      rating: rating,
      reviewCount: reviewCount,
      tags: tags,
    );
  }
}

class FoodCategoryModel extends FoodCategory {
  const FoodCategoryModel({
    required super.id,
    required super.name,
    required super.displayName,
    super.isSelected,
  });

  factory FoodCategoryModel.fromJson(Map<String, dynamic> json) {
    return FoodCategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      displayName: json['displayName'] as String,
      isSelected: json['isSelected'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'displayName': displayName,
      'isSelected': isSelected,
    };
  }

  factory FoodCategoryModel.fromEntity(FoodCategory entity) {
    return FoodCategoryModel(
      id: entity.id,
      name: entity.name,
      displayName: entity.displayName,
      isSelected: entity.isSelected,
    );
  }

  FoodCategory toEntity() {
    return FoodCategory(
      id: id,
      name: name,
      displayName: displayName,
      isSelected: isSelected,
    );
  }
}

// Static data for testing and initial implementation
class FoodDataSource {
  static List<FoodItemModel> get mockFoodItems => [
    const FoodItemModel(
      id: '1',
      name: 'Cheeseburger',
      description: 'Juicy beef patty, melted cheese, lettuce, tomato, pickles, and special sauce in a toasted bun.',
      price: 3.1,
      currency: 'SAR',
      imagePath: 'assets/images/Static/burger.png',
      category: 'burgers',
      rating: 4.5,
      reviewCount: 120,
      tags: ['beef', 'cheese', 'popular'],
    ),
    const FoodItemModel(
      id: '2',
      name: 'Chicken taco',
      description: 'Juicy beef patty, melted cheese, lettuce, tomato, pickles, and special sauce in a toasted bun.',
      price: 3.1,
      currency: 'SAR',
      imagePath: 'assets/images/Static/Chicken_taco.png',
      category: 'fries-sides',
      rating: 4.2,
      reviewCount: 85,
      tags: ['chicken', 'spicy', 'mexican'],
    ),
    const FoodItemModel(
      id: '3',
      name: 'Greek Salad',
      description: 'Juicy beef patty, melted cheese, lettuce, tomato, pickles, and special sauce in a toasted bun.',
      price: 3.1,
      currency: 'SAR',
      imagePath: 'assets/images/Static/greek_salad.png',
      category: 'fries-sides',
      rating: 4.0,
      reviewCount: 95,
      tags: ['healthy', 'vegetarian', 'fresh'],
    ),
    const FoodItemModel(
      id: '4',
      name: 'Strawberry ice cream',
      description: 'Juicy beef patty, melted cheese, lettuce, tomato, pickles, and special sauce in a toasted bun.',
      price: 3.1,
      currency: 'SAR',
      imagePath: 'assets/images/Static/ice_cream.jpg',
      category: 'desserts',
      rating: 4.8,
      reviewCount: 200,
      tags: ['sweet', 'cold', 'popular'],
    ),
    const FoodItemModel(
      id: '5',
      name: 'Parker\'s burger',
      description: 'Juicy beef patty, melted cheese, lettuce, tomato, pickles, and special sauce in a toasted bun.',
      price: 3.1,
      currency: 'SAR',
      imagePath: 'assets/images/Static/Parkers_burger.jpg',
      category: 'burgers',
      rating: 4.6,
      reviewCount: 150,
      tags: ['beef', 'premium', 'signature'],
    ),
    const FoodItemModel(
      id: '6',
      name: 'Matilda cake',
      description: 'Juicy beef patty, melted cheese, lettuce, tomato, pickles, and special sauce in a toasted bun.',
      price: 3.1,
      currency: 'SAR',
      imagePath: 'assets/images/Static/Matilda_cake.jpg',
      category: 'desserts',
      rating: 4.7,
      reviewCount: 175,
      tags: ['sweet', 'chocolate', 'premium'],
    ),
    const FoodItemModel(
      id: '7',
      name: 'Classic mojito',
      description: 'Juicy beef patty, melted cheese, lettuce, tomato, pickles, and special sauce in a toasted bun.',
      price: 3.1,
      currency: 'SAR',
      imagePath: 'assets/images/Static/mojito.jpg',
      category: 'coffee-drinks',
      rating: 4.3,
      reviewCount: 110,
      tags: ['refreshing', 'mint', 'cocktail'],
    ),
  ];

  static List<FoodCategoryModel> get mockCategories => [
    const FoodCategoryModel(
      id: 'desserts',
      name: 'desserts',
      displayName: 'Desserts',
      isSelected: true, // Default to first category selected
    ),
    const FoodCategoryModel(
      id: 'burgers',
      name: 'burgers',
      displayName: 'Burgers',
    ),
    const FoodCategoryModel(
      id: 'fries-sides',
      name: 'fries-sides',
      displayName: 'Fries & Sides',
    ),
    const FoodCategoryModel(
      id: 'coffee-drinks',
      name: 'coffee-drinks',
      displayName: 'Coffee & Drinks',
    ),
    const FoodCategoryModel(
      id: 'pasta',
      name: 'pasta',
      displayName: 'Pasta',
    ),
  ];
}