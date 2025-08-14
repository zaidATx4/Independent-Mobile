import '../../domain/entities/food_item_entity.dart';
import '../../domain/repositories/food_item_repository.dart';
import '../models/food_item_model.dart';

/// Implementation of FoodItemRepository with mock data
/// This provides sample food items for development and testing
class FoodItemRepositoryImpl implements FoodItemRepository {
  /// Mock food items data with real image assets
  static final List<FoodItemModel> _mockFoodItems = [
    // Desserts
    const FoodItemModel(
      id: 'dessert_1',
      name: 'Matilda Cake',
      description: 'Rich chocolate cake with layers of vanilla cream and fresh berries',
      price: 25.0,
      currency: 'SAR',
      category: 'Desserts',
      imagePath: 'assets/images/Static/Restaurant_Foods/Matilda_Cake1.jpg',
      isAvailable: true,
      locationId: 'salt_mall_emirates',
      brandId: 'salt',
      preparationTimeMinutes: 10,
      isPopular: true,
      dietaryTags: ['Vegetarian'],
      spiceLevel: 0,
      calories: 450,
      allergens: ['Gluten', 'Dairy', 'Eggs'],
    ),
    const FoodItemModel(
      id: 'dessert_2',
      name: 'Red Velvet Cake',
      description: 'Classic red velvet cake with cream cheese frosting and vanilla cream',
      price: 28.0,
      currency: 'SAR',
      category: 'Desserts',
      imagePath: 'assets/images/Static/Restaurant_Foods/Red_Cake.jpg',
      isAvailable: true,
      locationId: 'salt_mall_emirates',
      brandId: 'salt',
      preparationTimeMinutes: 10,
      isPopular: true,
      dietaryTags: ['Vegetarian'],
      spiceLevel: 0,
      calories: 520,
      allergens: ['Gluten', 'Dairy', 'Eggs'],
    ),
    const FoodItemModel(
      id: 'dessert_3',
      name: 'Pink Berry Cake',
      description: 'Light sponge cake with fresh berry compote and whipped cream',
      price: 30.0,
      currency: 'SAR',
      category: 'Desserts',
      imagePath: 'assets/images/Static/Restaurant_Foods/Pink_Cake1.jpg',
      isAvailable: true,
      locationId: 'salt_mall_emirates',
      brandId: 'salt',
      preparationTimeMinutes: 12,
      isPopular: false,
      dietaryTags: ['Vegetarian'],
      spiceLevel: 0,
      calories: 380,
      allergens: ['Gluten', 'Dairy', 'Eggs'],
    ),
    const FoodItemModel(
      id: 'dessert_4',
      name: 'Strawberry Delight',
      description: 'Fresh strawberry cake with vanilla custard and chocolate drizzle',
      price: 32.0,
      currency: 'SAR',
      category: 'Desserts',
      imagePath: 'assets/images/Static/Restaurant_Foods/Strawberry_Cake.jpg',
      isAvailable: true,
      locationId: 'salt_mall_emirates',
      brandId: 'salt',
      preparationTimeMinutes: 15,
      isPopular: true,
      dietaryTags: ['Vegetarian'],
      spiceLevel: 0,
      calories: 420,
      allergens: ['Gluten', 'Dairy', 'Eggs'],
    ),
    const FoodItemModel(
      id: 'dessert_5',
      name: 'Biscuit Cake',
      description: 'Traditional biscuit cake with coffee flavor and mascarpone cream',
      price: 22.0,
      currency: 'SAR',
      category: 'Desserts',
      imagePath: 'assets/images/Static/Restaurant_Foods/Buiscut_Cake.jpg',
      isAvailable: true,
      locationId: 'salt_mall_emirates',
      brandId: 'salt',
      preparationTimeMinutes: 8,
      isPopular: false,
      dietaryTags: ['Vegetarian'],
      spiceLevel: 0,
      calories: 350,
      allergens: ['Gluten', 'Dairy', 'Eggs'],
    ),
    const FoodItemModel(
      id: 'dessert_6',
      name: 'Icing Cake',
      description: 'Classic vanilla cake with rich buttercream icing and decorative toppings',
      price: 26.0,
      currency: 'SAR',
      category: 'Desserts',
      imagePath: 'assets/images/Static/Restaurant_Foods/Icing_Cake.jpg',
      isAvailable: true,
      locationId: 'salt_mall_emirates',
      brandId: 'salt',
      preparationTimeMinutes: 10,
      isPopular: false,
      dietaryTags: ['Vegetarian'],
      spiceLevel: 0,
      calories: 480,
      allergens: ['Gluten', 'Dairy', 'Eggs'],
    ),
    
    // Additional Dessert items (converted from other categories)
    const FoodItemModel(
      id: 'dessert_7',
      name: 'Chocolate Brownie',
      description: 'Rich chocolate brownie with nuts and chocolate chips',
      price: 35.0,
      currency: 'SAR',
      category: 'Desserts',
      imagePath: 'assets/images/Static/Restaurant_Foods/Matilda_Cake1.jpg',
      isAvailable: true,
      locationId: 'salt_mall_emirates',
      brandId: 'salt',
      preparationTimeMinutes: 20,
      isPopular: true,
      dietaryTags: ['Vegetarian'],
      spiceLevel: 0,
      calories: 450,
      allergens: ['Gluten', 'Dairy', 'Nuts'],
    ),
    const FoodItemModel(
      id: 'dessert_8',
      name: 'Lemon Tart',
      description: 'Tangy lemon curd tart with fresh berries and mint',
      price: 32.0,
      currency: 'SAR',
      category: 'Desserts',
      imagePath: 'assets/images/Static/Restaurant_Foods/Red_Cake.jpg',
      isAvailable: true,
      locationId: 'salt_mall_emirates',
      brandId: 'salt',
      preparationTimeMinutes: 18,
      isPopular: true,
      dietaryTags: ['Vegetarian'],
      spiceLevel: 0,
      calories: 380,
      allergens: ['Gluten', 'Dairy', 'Eggs'],
    ),

    // Mock Tiramisu
    const FoodItemModel(
      id: 'dessert_9',
      name: 'Classic Tiramisu',
      description: 'Traditional Italian dessert with coffee-soaked ladyfingers and mascarpone',
      price: 18.0,
      currency: 'SAR',
      category: 'Desserts',
      imagePath: 'assets/images/Static/Restaurant_Foods/Pink_Cake1.jpg',
      isAvailable: true,
      locationId: 'salt_mall_emirates',
      brandId: 'salt',
      preparationTimeMinutes: 12,
      isPopular: false,
      dietaryTags: ['Vegetarian'],
      spiceLevel: 0,
      calories: 320,
      allergens: ['Dairy', 'Eggs'],
    ),

    // Mock Cheesecake
    const FoodItemModel(
      id: 'dessert_10',
      name: 'New York Cheesecake',
      description: 'Creamy cheesecake with berry compote and graham cracker crust',
      price: 15.0,
      currency: 'SAR',
      category: 'Desserts',
      imagePath: 'assets/images/Static/Restaurant_Foods/Strawberry_Cake.jpg',
      isAvailable: true,
      locationId: 'salt_mall_emirates',
      brandId: 'salt',
      preparationTimeMinutes: 5,
      isPopular: true,
      dietaryTags: ['Vegetarian'],
      spiceLevel: 0,
      calories: 480,
      allergens: ['Dairy', 'Eggs'],
    ),

    // Mock Crème Brûlée
    const FoodItemModel(
      id: 'dessert_11',
      name: 'Crème Brûlée',
      description: 'Classic French dessert with vanilla custard and caramelized sugar',
      price: 28.0,
      currency: 'SAR',
      category: 'Desserts',
      imagePath: 'assets/images/Static/Restaurant_Foods/Buiscut_Cake.jpg',
      isAvailable: true,
      locationId: 'salt_mall_emirates',
      brandId: 'salt',
      preparationTimeMinutes: 25,
      isPopular: false,
      dietaryTags: ['Vegetarian'],
      spiceLevel: 0,
      calories: 420,
      allergens: ['Dairy', 'Eggs'],
    ),
    
    // Beverages
    const FoodItemModel(
      id: 'beverage_1',
      name: 'Fresh Orange Juice',
      description: 'Freshly squeezed orange juice served chilled',
      price: 12.0,
      currency: 'SAR',
      category: 'Beverages',
      imagePath: 'assets/images/Static/Restaurant_Foods/Matilda_Cake1.jpg',
      isAvailable: true,
      locationId: 'salt_mall_emirates',
      brandId: 'salt',
      preparationTimeMinutes: 5,
      isPopular: true,
      dietaryTags: ['Vegan', 'Gluten-Free'],
      spiceLevel: 0,
      calories: 120,
      allergens: [],
    ),
    const FoodItemModel(
      id: 'beverage_2',
      name: 'Iced Coffee',
      description: 'Cold brew coffee with ice and milk',
      price: 15.0,
      currency: 'SAR',
      category: 'Beverages',
      imagePath: 'assets/images/Static/Restaurant_Foods/Red_Cake.jpg',
      isAvailable: true,
      locationId: 'salt_mall_emirates',
      brandId: 'salt',
      preparationTimeMinutes: 3,
      isPopular: true,
      dietaryTags: ['Vegetarian'],
      spiceLevel: 0,
      calories: 80,
      allergens: ['Dairy'],
    ),
    
    // Main Dishes
    const FoodItemModel(
      id: 'main_1',
      name: 'Grilled Chicken Breast',
      description: 'Tender grilled chicken breast with herbs and spices',
      price: 45.0,
      currency: 'SAR',
      category: 'Main Dishes',
      imagePath: 'assets/images/Static/Restaurant_Foods/Pink_Cake1.jpg',
      isAvailable: true,
      locationId: 'salt_mall_emirates',
      brandId: 'salt',
      preparationTimeMinutes: 20,
      isPopular: true,
      dietaryTags: ['High-Protein', 'Gluten-Free'],
      spiceLevel: 2,
      calories: 350,
      allergens: [],
    ),
    const FoodItemModel(
      id: 'main_2',
      name: 'Grilled Salmon',
      description: 'Fresh salmon fillet grilled with lemon and herbs',
      price: 52.0,
      currency: 'SAR',
      category: 'Main Dishes',
      imagePath: 'assets/images/Static/Restaurant_Foods/Strawberry_Cake.jpg',
      isAvailable: true,
      locationId: 'salt_mall_emirates',
      brandId: 'salt',
      preparationTimeMinutes: 18,
      isPopular: true,
      dietaryTags: ['High-Protein', 'Gluten-Free'],
      spiceLevel: 1,
      calories: 420,
      allergens: ['Fish'],
    ),
    
    // Burgers
    const FoodItemModel(
      id: 'burger_1',
      name: 'Classic Beef Burger',
      description: 'Juicy beef patty with lettuce, tomato, and special sauce',
      price: 38.0,
      currency: 'SAR',
      category: 'Burgers',
      imagePath: 'assets/images/Static/Restaurant_Foods/Buiscut_Cake.jpg',
      isAvailable: true,
      locationId: 'salt_mall_emirates',
      brandId: 'salt',
      preparationTimeMinutes: 15,
      isPopular: true,
      dietaryTags: ['High-Protein'],
      spiceLevel: 1,
      calories: 580,
      allergens: ['Gluten', 'Dairy'],
    ),
    const FoodItemModel(
      id: 'burger_2',
      name: 'Chicken Deluxe Burger',
      description: 'Crispy chicken breast with avocado and ranch dressing',
      price: 35.0,
      currency: 'SAR',
      category: 'Burgers',
      imagePath: 'assets/images/Static/Restaurant_Foods/Icing_Cake.jpg',
      isAvailable: true,
      locationId: 'salt_mall_emirates',
      brandId: 'salt',
      preparationTimeMinutes: 12,
      isPopular: true,
      dietaryTags: ['High-Protein'],
      spiceLevel: 1,
      calories: 520,
      allergens: ['Gluten', 'Dairy'],
    ),
    const FoodItemModel(
      id: 'burger_3',
      name: 'Veggie Burger',
      description: 'Plant-based patty with fresh vegetables and vegan mayo',
      price: 32.0,
      currency: 'SAR',
      category: 'Burgers',
      imagePath: 'assets/images/Static/Restaurant_Foods/Matilda_Cake1.jpg',
      isAvailable: true,
      locationId: 'salt_mall_emirates',
      brandId: 'salt',
      preparationTimeMinutes: 10,
      isPopular: false,
      dietaryTags: ['Vegan', 'Vegetarian'],
      spiceLevel: 0,
      calories: 420,
      allergens: ['Gluten'],
    ),
    
    // Fries & Sides
    const FoodItemModel(
      id: 'side_1',
      name: 'Classic French Fries',
      description: 'Golden crispy fries seasoned with salt',
      price: 18.0,
      currency: 'SAR',
      category: 'Fries & Sides',
      imagePath: 'assets/images/Static/Restaurant_Foods/Red_Cake.jpg',
      isAvailable: true,
      locationId: 'salt_mall_emirates',
      brandId: 'salt',
      preparationTimeMinutes: 8,
      isPopular: true,
      dietaryTags: ['Vegan'],
      spiceLevel: 0,
      calories: 320,
      allergens: [],
    ),
    const FoodItemModel(
      id: 'side_2',
      name: 'Sweet Potato Fries',
      description: 'Crispy sweet potato fries with paprika seasoning',
      price: 22.0,
      currency: 'SAR',
      category: 'Fries & Sides',
      imagePath: 'assets/images/Static/Restaurant_Foods/Pink_Cake1.jpg',
      isAvailable: true,
      locationId: 'salt_mall_emirates',
      brandId: 'salt',
      preparationTimeMinutes: 10,
      isPopular: true,
      dietaryTags: ['Vegan', 'Gluten-Free'],
      spiceLevel: 1,
      calories: 280,
      allergens: [],
    ),
    const FoodItemModel(
      id: 'side_3',
      name: 'Onion Rings',
      description: 'Crispy battered onion rings with ranch dip',
      price: 20.0,
      currency: 'SAR',
      category: 'Fries & Sides',
      imagePath: 'assets/images/Static/Restaurant_Foods/Strawberry_Cake.jpg',
      isAvailable: true,
      locationId: 'salt_mall_emirates',
      brandId: 'salt',
      preparationTimeMinutes: 12,
      isPopular: false,
      dietaryTags: ['Vegetarian'],
      spiceLevel: 0,
      calories: 380,
      allergens: ['Gluten', 'Dairy'],
    ),
    
    // Coffee & Drinks
    const FoodItemModel(
      id: 'drink_1',
      name: 'Cappuccino',
      description: 'Rich espresso with steamed milk and foam',
      price: 16.0,
      currency: 'SAR',
      category: 'Coffee & Drinks',
      imagePath: 'assets/images/Static/Restaurant_Foods/Buiscut_Cake.jpg',
      isAvailable: true,
      locationId: 'salt_mall_emirates',
      brandId: 'salt',
      preparationTimeMinutes: 5,
      isPopular: true,
      dietaryTags: ['Vegetarian'],
      spiceLevel: 0,
      calories: 120,
      allergens: ['Dairy'],
    ),
    const FoodItemModel(
      id: 'drink_2',
      name: 'Iced Latte',
      description: 'Cold espresso with chilled milk and ice',
      price: 18.0,
      currency: 'SAR',
      category: 'Coffee & Drinks',
      imagePath: 'assets/images/Static/Restaurant_Foods/Icing_Cake.jpg',
      isAvailable: true,
      locationId: 'salt_mall_emirates',
      brandId: 'salt',
      preparationTimeMinutes: 4,
      isPopular: true,
      dietaryTags: ['Vegetarian'],
      spiceLevel: 0,
      calories: 150,
      allergens: ['Dairy'],
    ),
    const FoodItemModel(
      id: 'drink_3',
      name: 'Fresh Lemonade',
      description: 'Freshly squeezed lemon juice with mint leaves',
      price: 14.0,
      currency: 'SAR',
      category: 'Coffee & Drinks',
      imagePath: 'assets/images/Static/Restaurant_Foods/Matilda_Cake1.jpg',
      isAvailable: true,
      locationId: 'salt_mall_emirates',
      brandId: 'salt',
      preparationTimeMinutes: 3,
      isPopular: false,
      dietaryTags: ['Vegan', 'Gluten-Free'],
      spiceLevel: 0,
      calories: 80,
      allergens: [],
    ),
    
    // Pasta
    const FoodItemModel(
      id: 'pasta_1',
      name: 'Spaghetti Carbonara',
      description: 'Classic Italian pasta with eggs, cheese, and pancetta',
      price: 42.0,
      currency: 'SAR',
      category: 'Pasta',
      imagePath: 'assets/images/Static/Restaurant_Foods/Red_Cake.jpg',
      isAvailable: true,
      locationId: 'salt_mall_emirates',
      brandId: 'salt',
      preparationTimeMinutes: 18,
      isPopular: true,
      dietaryTags: ['High-Protein'],
      spiceLevel: 0,
      calories: 650,
      allergens: ['Gluten', 'Dairy', 'Eggs'],
    ),
    const FoodItemModel(
      id: 'pasta_2',
      name: 'Penne Arrabbiata',
      description: 'Spicy tomato pasta with garlic, chili, and herbs',
      price: 38.0,
      currency: 'SAR',
      category: 'Pasta',
      imagePath: 'assets/images/Static/Restaurant_Foods/Pink_Cake1.jpg',
      isAvailable: true,
      locationId: 'salt_mall_emirates',
      brandId: 'salt',
      preparationTimeMinutes: 15,
      isPopular: true,
      dietaryTags: ['Vegan'],
      spiceLevel: 3,
      calories: 480,
      allergens: ['Gluten'],
    ),
    const FoodItemModel(
      id: 'pasta_3',
      name: 'Fettuccine Alfredo',
      description: 'Creamy white sauce pasta with parmesan cheese',
      price: 40.0,
      currency: 'SAR',
      category: 'Pasta',
      imagePath: 'assets/images/Static/Restaurant_Foods/Strawberry_Cake.jpg',
      isAvailable: true,
      locationId: 'salt_mall_emirates',
      brandId: 'salt',
      preparationTimeMinutes: 16,
      isPopular: false,
      dietaryTags: ['Vegetarian'],
      spiceLevel: 0,
      calories: 580,
      allergens: ['Gluten', 'Dairy'],
    ),
  ];

  @override
  Future<List<FoodItemEntity>> getFoodItemsByLocationId(String locationId) async {
    // Simulate network delay (reduced for development)
    await Future.delayed(const Duration(milliseconds: 100));
    
    // Return ALL mock food items for any location (ignore locationId filtering)
    return _mockFoodItems
        .map((model) => model.toEntity())
        .toList();
  }

  @override
  Future<List<FoodItemEntity>> getFoodItemsByCategory(
    String locationId,
    String category,
  ) async {
    await Future.delayed(const Duration(milliseconds: 50));
    
    // Return items by category for any location (ignore locationId filtering)
    return _mockFoodItems
        .where((item) => item.category == category)
        .map((model) => model.toEntity())
        .toList();
  }

  @override
  Future<List<String>> getCategoriesByLocationId(String locationId) async {
    await Future.delayed(const Duration(milliseconds: 50));
    
    // Return all categories for any location (ignore locationId filtering)
    final categories = _mockFoodItems
        .map((item) => item.category)
        .toSet()
        .toList();
    
    // Sort categories with Desserts first for demo
    categories.sort((a, b) {
      if (a == 'Desserts') return -1;
      if (b == 'Desserts') return 1;
      return a.compareTo(b);
    });
    
    return categories;
  }

  @override
  Future<List<FoodItemEntity>> getPopularFoodItems(String locationId) async {
    await Future.delayed(const Duration(milliseconds: 50));
    
    return _mockFoodItems
        .where((item) => 
            item.locationId == locationId && 
            item.isPopular)
        .map((model) => model.toEntity())
        .toList();
  }

  @override
  Future<List<FoodItemEntity>> searchFoodItems(
    String locationId,
    String query,
  ) async {
    await Future.delayed(const Duration(milliseconds: 50));
    
    final searchQuery = query.toLowerCase().trim();
    
    return _mockFoodItems
        .where((item) => 
            item.locationId == locationId &&
            (item.name.toLowerCase().contains(searchQuery) ||
             item.description.toLowerCase().contains(searchQuery)))
        .map((model) => model.toEntity())
        .toList();
  }

  @override
  Future<List<FoodItemEntity>> getFoodItemsByDietaryTags(
    String locationId,
    List<String> dietaryTags,
  ) async {
    await Future.delayed(const Duration(milliseconds: 50));
    
    return _mockFoodItems
        .where((item) => 
            item.locationId == locationId &&
            dietaryTags.any((tag) => item.dietaryTags.contains(tag)))
        .map((model) => model.toEntity())
        .toList();
  }

  @override
  Future<List<FoodItemEntity>> getFoodItemsBySpiceLevel(
    String locationId,
    int minSpiceLevel,
    int maxSpiceLevel,
  ) async {
    await Future.delayed(const Duration(milliseconds: 50));
    
    return _mockFoodItems
        .where((item) => 
            item.locationId == locationId &&
            item.spiceLevel >= minSpiceLevel &&
            item.spiceLevel <= maxSpiceLevel)
        .map((model) => model.toEntity())
        .toList();
  }

  @override
  Future<FoodItemEntity?> getFoodItemById(String itemId) async {
    await Future.delayed(const Duration(milliseconds: 50));
    
    final item = _mockFoodItems
        .where((item) => item.id == itemId)
        .firstOrNull;
    
    return item?.toEntity();
  }

  @override
  Future<List<FoodItemEntity>> getFoodItemsByPriceRange(
    String locationId,
    double minPrice,
    double maxPrice,
  ) async {
    await Future.delayed(const Duration(milliseconds: 50));
    
    return _mockFoodItems
        .where((item) => 
            item.locationId == locationId &&
            item.price >= minPrice &&
            item.price <= maxPrice)
        .map((model) => model.toEntity())
        .toList();
  }

  @override
  Future<bool> isFoodItemAvailable(String itemId, String locationId) async {
    await Future.delayed(const Duration(milliseconds: 50));
    
    final item = _mockFoodItems
        .where((item) => 
            item.id == itemId && 
            item.locationId == locationId)
        .firstOrNull;
    
    return item?.isAvailable ?? false;
  }

  @override
  Future<List<FoodItemEntity>> refreshFoodItems(String locationId) async {
    // Refresh is the same as getting all items for now
    return getFoodItemsByLocationId(locationId);
  }
}