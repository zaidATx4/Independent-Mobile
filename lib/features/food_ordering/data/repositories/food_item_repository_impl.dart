import '../../domain/entities/food_item_entity.dart';
import '../../domain/repositories/food_item_repository.dart';
import '../models/food_item_model.dart';

/// Implementation of FoodItemRepository with mock data
/// This provides sample food items for development and testing
class FoodItemRepositoryImpl implements FoodItemRepository {
  /// Mock food items data distributed across multiple locations
  static final List<FoodItemModel> _mockFoodItems = [
    // =================== DUBAI MALL LOCATION ===================
    // Popular items and desserts
    const FoodItemModel(
      id: 'dubai_mall_dessert_1',
      name: 'Matilda Cake',
      description: 'Rich chocolate cake with layers of vanilla cream and fresh berries',
      price: 25.0,
      currency: 'SAR',
      category: 'Desserts',
      imagePath: 'assets/images/Static/Restaurant_Foods/Matilda_Cake1.jpg',
      isAvailable: true,
      locationId: 'salt_dubai_mall',
      brandId: '1',
      preparationTimeMinutes: 10,
      isPopular: true,
      dietaryTags: ['Vegetarian'],
      spiceLevel: 0,
      calories: 450,
      allergens: ['Gluten', 'Dairy', 'Eggs'],
    ),
    const FoodItemModel(
      id: 'dubai_mall_dessert_2',
      name: 'Red Velvet Cake',
      description: 'Classic red velvet cake with cream cheese frosting and vanilla cream',
      price: 28.0,
      currency: 'SAR',
      category: 'Desserts',
      imagePath: 'assets/images/Static/Restaurant_Foods/Red_Cake.jpg',
      isAvailable: true,
      locationId: 'salt_dubai_mall',
      brandId: '1',
      preparationTimeMinutes: 10,
      isPopular: true,
      dietaryTags: ['Vegetarian'],
      spiceLevel: 0,
      calories: 520,
      allergens: ['Gluten', 'Dairy', 'Eggs'],
    ),
    const FoodItemModel(
      id: 'dubai_mall_main_1',
      name: 'Truffle Burger',
      description: 'Premium beef burger with truffle mayo and aged cheese',
      price: 55.0,
      currency: 'SAR',
      category: 'Burgers',
      imagePath: 'assets/images/Static/Restaurant_Foods/Buiscut_Cake.jpg',
      isAvailable: true,
      locationId: 'salt_dubai_mall',
      brandId: '1',
      preparationTimeMinutes: 18,
      isPopular: true,
      dietaryTags: ['High-Protein'],
      spiceLevel: 1,
      calories: 680,
      allergens: ['Gluten', 'Dairy'],
    ),
    const FoodItemModel(
      id: 'dubai_mall_drink_1',
      name: 'Signature Cappuccino',
      description: 'Premium cappuccino with imported beans and foam art',
      price: 20.0,
      currency: 'SAR',
      category: 'Coffee & Drinks',
      imagePath: 'assets/images/Static/Restaurant_Foods/Buiscut_Cake.jpg',
      isAvailable: true,
      locationId: 'salt_dubai_mall',
      brandId: '1',
      preparationTimeMinutes: 7,
      isPopular: true,
      dietaryTags: ['Vegetarian'],
      spiceLevel: 0,
      calories: 150,
      allergens: ['Dairy'],
    ),
    const FoodItemModel(
      id: 'dubai_mall_pasta_1',
      name: 'Lobster Ravioli',
      description: 'Fresh lobster ravioli in creamy saffron sauce',
      price: 85.0,
      currency: 'SAR',
      category: 'Pasta',
      imagePath: 'assets/images/Static/Restaurant_Foods/Red_Cake.jpg',
      isAvailable: true,
      locationId: 'salt_dubai_mall',
      brandId: '1',
      preparationTimeMinutes: 25,
      isPopular: true,
      dietaryTags: ['High-Protein'],
      spiceLevel: 1,
      calories: 750,
      allergens: ['Gluten', 'Dairy', 'Seafood'],
    ),
    const FoodItemModel(
      id: 'dubai_mall_side_1',
      name: 'Truffle Fries',
      description: 'Hand-cut fries with truffle oil and parmesan',
      price: 35.0,
      currency: 'SAR',
      category: 'Fries & Sides',
      imagePath: 'assets/images/Static/Restaurant_Foods/Pink_Cake1.jpg',
      isAvailable: true,
      locationId: 'salt_dubai_mall',
      brandId: '1',
      preparationTimeMinutes: 12,
      isPopular: true,
      dietaryTags: ['Vegetarian'],
      spiceLevel: 0,
      calories: 420,
      allergens: ['Dairy'],
    ),

    // =================== EMIRATES MALL LOCATION ===================
    const FoodItemModel(
      id: 'emirates_mall_dessert_1',
      name: 'Pink Berry Cake',
      description: 'Light sponge cake with fresh berry compote and whipped cream',
      price: 30.0,
      currency: 'SAR',
      category: 'Desserts',
      imagePath: 'assets/images/Static/Restaurant_Foods/Pink_Cake1.jpg',
      isAvailable: true,
      locationId: 'salt_emirates_mall',
      brandId: '1',
      preparationTimeMinutes: 12,
      isPopular: false,
      dietaryTags: ['Vegetarian'],
      spiceLevel: 0,
      calories: 380,
      allergens: ['Gluten', 'Dairy', 'Eggs'],
    ),
    const FoodItemModel(
      id: 'emirates_mall_main_1',
      name: 'Grilled Salmon',
      description: 'Fresh Atlantic salmon with herbs and lemon butter',
      price: 52.0,
      currency: 'SAR',
      category: 'Main Dishes',
      imagePath: 'assets/images/Static/Restaurant_Foods/Strawberry_Cake.jpg',
      isAvailable: true,
      locationId: 'salt_emirates_mall',
      brandId: '1',
      preparationTimeMinutes: 18,
      isPopular: true,
      dietaryTags: ['High-Protein', 'Gluten-Free'],
      spiceLevel: 1,
      calories: 420,
      allergens: ['Fish'],
    ),
    const FoodItemModel(
      id: 'emirates_mall_burger_1',
      name: 'Classic Beef Burger',
      description: 'Juicy beef patty with lettuce, tomato, and special sauce',
      price: 38.0,
      currency: 'SAR',
      category: 'Burgers',
      imagePath: 'assets/images/Static/Restaurant_Foods/Buiscut_Cake.jpg',
      isAvailable: true,
      locationId: 'salt_emirates_mall',
      brandId: '1',
      preparationTimeMinutes: 15,
      isPopular: true,
      dietaryTags: ['High-Protein'],
      spiceLevel: 1,
      calories: 580,
      allergens: ['Gluten', 'Dairy'],
    ),
    const FoodItemModel(
      id: 'emirates_mall_beverage_1',
      name: 'Fresh Orange Juice',
      description: 'Freshly squeezed orange juice served chilled',
      price: 12.0,
      currency: 'SAR',
      category: 'Beverages',
      imagePath: 'assets/images/Static/Restaurant_Foods/Matilda_Cake1.jpg',
      isAvailable: true,
      locationId: 'salt_emirates_mall',
      brandId: '1',
      preparationTimeMinutes: 5,
      isPopular: true,
      dietaryTags: ['Vegan', 'Gluten-Free'],
      spiceLevel: 0,
      calories: 120,
      allergens: [],
    ),
    const FoodItemModel(
      id: 'emirates_mall_pasta_1',
      name: 'Spaghetti Carbonara',
      description: 'Classic Italian pasta with eggs, cheese, and pancetta',
      price: 42.0,
      currency: 'SAR',
      category: 'Pasta',
      imagePath: 'assets/images/Static/Restaurant_Foods/Red_Cake.jpg',
      isAvailable: true,
      locationId: 'salt_emirates_mall',
      brandId: '1',
      preparationTimeMinutes: 18,
      isPopular: true,
      dietaryTags: ['High-Protein'],
      spiceLevel: 0,
      calories: 650,
      allergens: ['Gluten', 'Dairy', 'Eggs'],
    ),
    const FoodItemModel(
      id: 'emirates_mall_side_1',
      name: 'Sweet Potato Fries',
      description: 'Crispy sweet potato fries with paprika seasoning',
      price: 22.0,
      currency: 'SAR',
      category: 'Fries & Sides',
      imagePath: 'assets/images/Static/Restaurant_Foods/Pink_Cake1.jpg',
      isAvailable: true,
      locationId: 'salt_emirates_mall',
      brandId: '1',
      preparationTimeMinutes: 10,
      isPopular: true,
      dietaryTags: ['Vegan', 'Gluten-Free'],
      spiceLevel: 1,
      calories: 280,
      allergens: [],
    ),

    // =================== CITY WALK LOCATION ===================
    const FoodItemModel(
      id: 'city_walk_dessert_1',
      name: 'Chocolate Brownie',
      description: 'Rich chocolate brownie with nuts and chocolate chips',
      price: 35.0,
      currency: 'SAR',
      category: 'Desserts',
      imagePath: 'assets/images/Static/Restaurant_Foods/Matilda_Cake1.jpg',
      isAvailable: true,
      locationId: 'salt_city_walk',
      brandId: '1',
      preparationTimeMinutes: 20,
      isPopular: true,
      dietaryTags: ['Vegetarian'],
      spiceLevel: 0,
      calories: 450,
      allergens: ['Gluten', 'Dairy', 'Nuts'],
    ),
    const FoodItemModel(
      id: 'city_walk_main_1',
      name: 'Grilled Chicken Breast',
      description: 'Tender grilled chicken breast with herbs and spices',
      price: 45.0,
      currency: 'SAR',
      category: 'Main Dishes',
      imagePath: 'assets/images/Static/Restaurant_Foods/Pink_Cake1.jpg',
      isAvailable: true,
      locationId: 'salt_city_walk',
      brandId: '1',
      preparationTimeMinutes: 20,
      isPopular: true,
      dietaryTags: ['High-Protein', 'Gluten-Free'],
      spiceLevel: 2,
      calories: 350,
      allergens: [],
    ),
    const FoodItemModel(
      id: 'city_walk_burger_1',
      name: 'Chicken Deluxe Burger',
      description: 'Crispy chicken breast with avocado and ranch dressing',
      price: 35.0,
      currency: 'SAR',
      category: 'Burgers',
      imagePath: 'assets/images/Static/Restaurant_Foods/Icing_Cake.jpg',
      isAvailable: true,
      locationId: 'salt_city_walk',
      brandId: '1',
      preparationTimeMinutes: 12,
      isPopular: true,
      dietaryTags: ['High-Protein'],
      spiceLevel: 1,
      calories: 520,
      allergens: ['Gluten', 'Dairy'],
    ),
    const FoodItemModel(
      id: 'city_walk_drink_1',
      name: 'Iced Latte',
      description: 'Cold espresso with chilled milk and ice',
      price: 18.0,
      currency: 'SAR',
      category: 'Coffee & Drinks',
      imagePath: 'assets/images/Static/Restaurant_Foods/Icing_Cake.jpg',
      isAvailable: true,
      locationId: 'salt_city_walk',
      brandId: '1',
      preparationTimeMinutes: 4,
      isPopular: true,
      dietaryTags: ['Vegetarian'],
      spiceLevel: 0,
      calories: 150,
      allergens: ['Dairy'],
    ),
    const FoodItemModel(
      id: 'city_walk_pasta_1',
      name: 'Penne Arrabbiata',
      description: 'Spicy tomato pasta with garlic, chili, and herbs',
      price: 38.0,
      currency: 'SAR',
      category: 'Pasta',
      imagePath: 'assets/images/Static/Restaurant_Foods/Pink_Cake1.jpg',
      isAvailable: true,
      locationId: 'salt_city_walk',
      brandId: '1',
      preparationTimeMinutes: 15,
      isPopular: true,
      dietaryTags: ['Vegan'],
      spiceLevel: 3,
      calories: 480,
      allergens: ['Gluten'],
    ),

    // =================== BUR JUMAN LOCATION ===================
    const FoodItemModel(
      id: 'bur_juman_dessert_1',
      name: 'Classic Tiramisu',
      description: 'Traditional Italian dessert with coffee-soaked ladyfingers and mascarpone',
      price: 18.0,
      currency: 'SAR',
      category: 'Desserts',
      imagePath: 'assets/images/Static/Restaurant_Foods/Pink_Cake1.jpg',
      isAvailable: true,
      locationId: 'salt_bur_juman',
      brandId: '1',
      preparationTimeMinutes: 12,
      isPopular: false,
      dietaryTags: ['Vegetarian'],
      spiceLevel: 0,
      calories: 320,
      allergens: ['Dairy', 'Eggs'],
    ),
    const FoodItemModel(
      id: 'bur_juman_burger_1',
      name: 'Veggie Burger',
      description: 'Plant-based patty with fresh vegetables and vegan mayo',
      price: 32.0,
      currency: 'SAR',
      category: 'Burgers',
      imagePath: 'assets/images/Static/Restaurant_Foods/Matilda_Cake1.jpg',
      isAvailable: true,
      locationId: 'salt_bur_juman',
      brandId: '1',
      preparationTimeMinutes: 10,
      isPopular: false,
      dietaryTags: ['Vegan', 'Vegetarian'],
      spiceLevel: 0,
      calories: 420,
      allergens: ['Gluten'],
    ),
    const FoodItemModel(
      id: 'bur_juman_side_1',
      name: 'Classic French Fries',
      description: 'Golden crispy fries seasoned with salt',
      price: 18.0,
      currency: 'SAR',
      category: 'Fries & Sides',
      imagePath: 'assets/images/Static/Restaurant_Foods/Red_Cake.jpg',
      isAvailable: true,
      locationId: 'salt_bur_juman',
      brandId: '1',
      preparationTimeMinutes: 8,
      isPopular: true,
      dietaryTags: ['Vegan'],
      spiceLevel: 0,
      calories: 320,
      allergens: [],
    ),
    const FoodItemModel(
      id: 'bur_juman_drink_1',
      name: 'Fresh Lemonade',
      description: 'Freshly squeezed lemon juice with mint leaves',
      price: 14.0,
      currency: 'SAR',
      category: 'Coffee & Drinks',
      imagePath: 'assets/images/Static/Restaurant_Foods/Matilda_Cake1.jpg',
      isAvailable: true,
      locationId: 'salt_bur_juman',
      brandId: '1',
      preparationTimeMinutes: 3,
      isPopular: false,
      dietaryTags: ['Vegan', 'Gluten-Free'],
      spiceLevel: 0,
      calories: 80,
      allergens: [],
    ),
    const FoodItemModel(
      id: 'bur_juman_pasta_1',
      name: 'Fettuccine Alfredo',
      description: 'Creamy white sauce pasta with parmesan cheese',
      price: 40.0,
      currency: 'SAR',
      category: 'Pasta',
      imagePath: 'assets/images/Static/Restaurant_Foods/Strawberry_Cake.jpg',
      isAvailable: true,
      locationId: 'salt_bur_juman',
      brandId: '1',
      preparationTimeMinutes: 16,
      isPopular: false,
      dietaryTags: ['Vegetarian'],
      spiceLevel: 0,
      calories: 580,
      allergens: ['Gluten', 'Dairy'],
    ),

    // =================== DEIRA CITY CENTRE LOCATION ===================
    const FoodItemModel(
      id: 'deira_dessert_1',
      name: 'New York Cheesecake',
      description: 'Creamy cheesecake with berry compote and graham cracker crust',
      price: 15.0,
      currency: 'SAR',
      category: 'Desserts',
      imagePath: 'assets/images/Static/Restaurant_Foods/Strawberry_Cake.jpg',
      isAvailable: true,
      locationId: 'salt_deira_nearby',
      brandId: '1',
      preparationTimeMinutes: 5,
      isPopular: true,
      dietaryTags: ['Vegetarian'],
      spiceLevel: 0,
      calories: 480,
      allergens: ['Dairy', 'Eggs'],
    ),
    const FoodItemModel(
      id: 'deira_beverage_1',
      name: 'Iced Coffee',
      description: 'Cold brew coffee with ice and milk',
      price: 15.0,
      currency: 'SAR',
      category: 'Beverages',
      imagePath: 'assets/images/Static/Restaurant_Foods/Red_Cake.jpg',
      isAvailable: true,
      locationId: 'salt_deira_nearby',
      brandId: '1',
      preparationTimeMinutes: 3,
      isPopular: true,
      dietaryTags: ['Vegetarian'],
      spiceLevel: 0,
      calories: 80,
      allergens: ['Dairy'],
    ),
    const FoodItemModel(
      id: 'deira_side_1',
      name: 'Onion Rings',
      description: 'Crispy battered onion rings with ranch dip',
      price: 20.0,
      currency: 'SAR',
      category: 'Fries & Sides',
      imagePath: 'assets/images/Static/Restaurant_Foods/Strawberry_Cake.jpg',
      isAvailable: true,
      locationId: 'salt_deira_nearby',
      brandId: '1',
      preparationTimeMinutes: 12,
      isPopular: false,
      dietaryTags: ['Vegetarian'],
      spiceLevel: 0,
      calories: 380,
      allergens: ['Gluten', 'Dairy'],
    ),

    // =================== SWITCH BRAND LOCATIONS ===================
    // Switch Dubai Mall
    const FoodItemModel(
      id: 'switch_dubai_pizza_1',
      name: 'Margherita Pizza',
      description: 'Classic pizza with fresh tomatoes, mozzarella, and basil',
      price: 45.0,
      currency: 'SAR',
      category: 'Pizza',
      imagePath: 'assets/images/Static/Restaurant_Foods/Red_Cake.jpg',
      isAvailable: true,
      locationId: 'switch_dubai_mall',
      brandId: '2',
      preparationTimeMinutes: 15,
      isPopular: true,
      dietaryTags: ['Vegetarian'],
      spiceLevel: 0,
      calories: 650,
      allergens: ['Gluten', 'Dairy'],
    ),
    const FoodItemModel(
      id: 'switch_dubai_salad_1',
      name: 'Caesar Salad',
      description: 'Fresh romaine lettuce with caesar dressing and croutons',
      price: 25.0,
      currency: 'SAR',
      category: 'Salads',
      imagePath: 'assets/images/Static/Restaurant_Foods/Pink_Cake1.jpg',
      isAvailable: true,
      locationId: 'switch_dubai_mall',
      brandId: '2',
      preparationTimeMinutes: 8,
      isPopular: true,
      dietaryTags: ['Vegetarian'],
      spiceLevel: 0,
      calories: 280,
      allergens: ['Gluten', 'Dairy'],
    ),

    // Switch Marina
    const FoodItemModel(
      id: 'switch_marina_wrap_1',
      name: 'Chicken Wrap',
      description: 'Grilled chicken with vegetables in a soft tortilla',
      price: 28.0,
      currency: 'SAR',
      category: 'Wraps',
      imagePath: 'assets/images/Static/Restaurant_Foods/Buiscut_Cake.jpg',
      isAvailable: true,
      locationId: 'switch_marina',
      brandId: '2',
      preparationTimeMinutes: 10,
      isPopular: true,
      dietaryTags: ['High-Protein'],
      spiceLevel: 1,
      calories: 450,
      allergens: ['Gluten'],
    ),
    const FoodItemModel(
      id: 'switch_marina_smoothie_1',
      name: 'Mango Smoothie',
      description: 'Fresh mango smoothie with yogurt and honey',
      price: 18.0,
      currency: 'SAR',
      category: 'Smoothies',
      imagePath: 'assets/images/Static/Restaurant_Foods/Matilda_Cake1.jpg',
      isAvailable: true,
      locationId: 'switch_marina',
      brandId: '2',
      preparationTimeMinutes: 5,
      isPopular: true,
      dietaryTags: ['Vegetarian', 'Gluten-Free'],
      spiceLevel: 0,
      calories: 220,
      allergens: ['Dairy'],
    ),
  ];

  @override
  Future<List<FoodItemEntity>> getFoodItemsByLocationId(String locationId) async {
    // Simulate network delay (reduced for development)
    await Future.delayed(const Duration(milliseconds: 100));
    
    // Filter food items by specific location
    return _mockFoodItems
        .where((item) => item.locationId == locationId)
        .map((model) => model.toEntity())
        .toList();
  }

  @override
  Future<List<FoodItemEntity>> getFoodItemsByCategory(
    String locationId,
    String category,
  ) async {
    await Future.delayed(const Duration(milliseconds: 50));
    
    // Filter by both location and category
    return _mockFoodItems
        .where((item) => item.locationId == locationId && item.category == category)
        .map((model) => model.toEntity())
        .toList();
  }

  @override
  Future<List<String>> getCategoriesByLocationId(String locationId) async {
    await Future.delayed(const Duration(milliseconds: 50));
    
    // Return categories only for the specified location
    final categories = _mockFoodItems
        .where((item) => item.locationId == locationId)
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