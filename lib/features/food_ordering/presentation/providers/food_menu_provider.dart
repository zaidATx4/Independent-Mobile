import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';
import '../../domain/entities/food_item_entity.dart';
import '../../domain/usecases/get_food_items_usecase.dart';
import '../../data/repositories/food_item_repository_impl.dart';

/// Strongly-typed params to ensure stable equality for family providers
@immutable
class FoodMenuParams {
  final String locationId;
  final String? brandId;

  const FoodMenuParams({required this.locationId, this.brandId});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodMenuParams &&
          runtimeType == other.runtimeType &&
          locationId == other.locationId &&
          brandId == other.brandId;

  @override
  int get hashCode => Object.hash(locationId, brandId);
}

/// Provider for FoodItemRepository
final foodItemRepositoryProvider = Provider<FoodItemRepositoryImpl>((ref) {
  return FoodItemRepositoryImpl();
});

/// Provider for GetFoodItemsUseCase
final getFoodItemsUseCaseProvider = Provider<GetFoodItemsUseCase>((ref) {
  final repository = ref.watch(foodItemRepositoryProvider);
  return GetFoodItemsUseCase(repository);
});

/// State class for food menu
class FoodMenuState {
  final List<FoodItemEntity> foodItems;
  final List<FoodItemEntity> filteredFoodItems;
  final List<String> categories;
  final bool isLoading;
  final String? error;
  final String selectedLocationId;
  final String? selectedBrandId;
  final String searchQuery;
  final String selectedCategory;
  final List<String> selectedDietaryTags;
  final double? minPrice;
  final double? maxPrice;
  final int? minSpiceLevel;
  final int? maxSpiceLevel;
  final bool showOnlyPopular;

  const FoodMenuState({
    this.foodItems = const [],
    this.filteredFoodItems = const [],
    this.categories = const [],
    this.isLoading = false,
    this.error,
    required this.selectedLocationId,
    this.selectedBrandId,
    this.searchQuery = '',
    this.selectedCategory = '',
    this.selectedDietaryTags = const [],
    this.minPrice,
    this.maxPrice,
    this.minSpiceLevel,
    this.maxSpiceLevel,
    this.showOnlyPopular = false,
  });

  FoodMenuState copyWith({
    List<FoodItemEntity>? foodItems,
    List<FoodItemEntity>? filteredFoodItems,
    List<String>? categories,
    bool? isLoading,
    String? error,
    String? selectedLocationId,
    String? selectedBrandId,
    String? searchQuery,
    String? selectedCategory,
    List<String>? selectedDietaryTags,
    double? minPrice,
    double? maxPrice,
    int? minSpiceLevel,
    int? maxSpiceLevel,
    bool? showOnlyPopular,
  }) {
    return FoodMenuState(
      foodItems: foodItems ?? this.foodItems,
      filteredFoodItems: filteredFoodItems ?? this.filteredFoodItems,
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedLocationId: selectedLocationId ?? this.selectedLocationId,
      selectedBrandId: selectedBrandId ?? this.selectedBrandId,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedDietaryTags: selectedDietaryTags ?? this.selectedDietaryTags,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minSpiceLevel: minSpiceLevel ?? this.minSpiceLevel,
      maxSpiceLevel: maxSpiceLevel ?? this.maxSpiceLevel,
      showOnlyPopular: showOnlyPopular ?? this.showOnlyPopular,
    );
  }

  /// Get unique categories from filtered food items
  List<String> get availableCategories {
    if (categories.isEmpty) return [];

    // Always include selected category first if it exists
    final List<String> result = [];
    if (selectedCategory.isNotEmpty && categories.contains(selectedCategory)) {
      result.add(selectedCategory);
    }

    // Add other categories
    for (final category in categories) {
      if (!result.contains(category)) {
        result.add(category);
      }
    }

    return result;
  }

  /// Get count of items in the selected category
  int get selectedCategoryItemCount {
    if (selectedCategory.isEmpty) return filteredFoodItems.length;
    return filteredFoodItems
        .where((item) => item.category == selectedCategory)
        .length;
  }

  /// Check if any filters are applied
  bool get hasActiveFilters {
    return searchQuery.isNotEmpty ||
        selectedCategory.isNotEmpty ||
        selectedDietaryTags.isNotEmpty ||
        minPrice != null ||
        maxPrice != null ||
        minSpiceLevel != null ||
        maxSpiceLevel != null ||
        showOnlyPopular;
  }
}

/// StateNotifier for managing food menu state
class FoodMenuNotifier extends StateNotifier<FoodMenuState> {
  final GetFoodItemsUseCase _getFoodItemsUseCase;

  FoodMenuNotifier(
    this._getFoodItemsUseCase,
    String locationId,
    String? brandId,
  ) : super(
        FoodMenuState(
          selectedLocationId: locationId,
          selectedBrandId: brandId,
          // Default to All chip selected to show all food items initially
          selectedCategory: 'All',
          categories: const ['All', 'Desserts'],
        ),
      );

  /// Initialize data loading - call this after provider creation
  Future<void> initialize() async {
    await _loadFoodData();
  }

  /// Load food items and categories for the selected location
  Future<void> _loadFoodData() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Load food items for the selected location
      final foodItems = await _getFoodItemsUseCase.getFoodItemsByLocationId(
        state.selectedLocationId,
      );

      // Get all unique categories from food items
      final allCategories = foodItems
          .map((item) => item.category)
          .toSet()
          .toList()
        ..sort();

      // Create categories list with "All" first, then other categories
      final categoriesList = ['All', ...allCategories];

      // Show all items by default when "All" is selected
      final filteredItems = state.selectedCategory == 'All' 
          ? foodItems 
          : foodItems.where((item) => item.category == state.selectedCategory).toList();

      state = state.copyWith(
        foodItems: foodItems,
        filteredFoodItems: filteredItems,
        categories: categoriesList,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Apply category filter
  Future<void> selectCategory(String category) async {
    state = state.copyWith(selectedCategory: category, isLoading: true);

    await _applyFilters();
  }

  /// Apply search filter
  Future<void> searchFoodItems(String query) async {
    state = state.copyWith(searchQuery: query, isLoading: true);

    await _applyFilters();
  }

  /// Toggle dietary tag filter
  Future<void> toggleDietaryTag(String tag) async {
    final currentTags = List<String>.from(state.selectedDietaryTags);

    if (currentTags.contains(tag)) {
      currentTags.remove(tag);
    } else {
      currentTags.add(tag);
    }

    state = state.copyWith(selectedDietaryTags: currentTags, isLoading: true);

    await _applyFilters();
  }

  /// Set price range filter
  Future<void> setPriceRange(double? minPrice, double? maxPrice) async {
    state = state.copyWith(
      minPrice: minPrice,
      maxPrice: maxPrice,
      isLoading: true,
    );

    await _applyFilters();
  }

  /// Set spice level range filter
  Future<void> setSpiceLevelRange(int? minLevel, int? maxLevel) async {
    state = state.copyWith(
      minSpiceLevel: minLevel,
      maxSpiceLevel: maxLevel,
      isLoading: true,
    );

    await _applyFilters();
  }

  /// Toggle popular items filter
  Future<void> togglePopularFilter() async {
    state = state.copyWith(
      showOnlyPopular: !state.showOnlyPopular,
      isLoading: true,
    );

    await _applyFilters();
  }

  /// Apply all current filters
  Future<void> _applyFilters() async {
    try {
      // Handle "All" category specially - show all items
      if (state.selectedCategory == 'All') {
        final filteredItems = await _getFoodItemsUseCase.getFilteredFoodItems(
          locationId: state.selectedLocationId,
          category: null, // No category filter for "All"
          searchQuery: state.searchQuery.isNotEmpty ? state.searchQuery : null,
          dietaryTags: state.selectedDietaryTags.isNotEmpty
              ? state.selectedDietaryTags
              : null,
          minSpiceLevel: state.minSpiceLevel,
          maxSpiceLevel: state.maxSpiceLevel,
          minPrice: state.minPrice,
          maxPrice: state.maxPrice,
          onlyPopular: state.showOnlyPopular,
        );

        state = state.copyWith(
          filteredFoodItems: filteredItems,
          isLoading: false,
        );
      } else {
        final filteredItems = await _getFoodItemsUseCase.getFilteredFoodItems(
          locationId: state.selectedLocationId,
          category: state.selectedCategory,
          searchQuery: state.searchQuery.isNotEmpty ? state.searchQuery : null,
          dietaryTags: state.selectedDietaryTags.isNotEmpty
              ? state.selectedDietaryTags
              : null,
          minSpiceLevel: state.minSpiceLevel,
          maxSpiceLevel: state.maxSpiceLevel,
          minPrice: state.minPrice,
          maxPrice: state.maxPrice,
          onlyPopular: state.showOnlyPopular,
        );

        state = state.copyWith(
          filteredFoodItems: filteredItems,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Clear search
  Future<void> clearSearch() async {
    state = state.copyWith(searchQuery: '', isLoading: true);

    await _applyFilters();
  }

  /// Clear all filters
  Future<void> clearAllFilters() async {
    const defaultCategory = 'All';

    state = state.copyWith(
      searchQuery: '',
      selectedCategory: defaultCategory,
      selectedDietaryTags: const [],
      minPrice: null,
      maxPrice: null,
      minSpiceLevel: null,
      maxSpiceLevel: null,
      showOnlyPopular: false,
      isLoading: true,
    );

    await _applyFilters();
  }

  /// Refresh food data
  Future<void> refresh() async {
    await _loadFoodData();
  }

  /// Get food item by ID
  Future<FoodItemEntity?> getFoodItemById(String itemId) async {
    return _getFoodItemsUseCase.getFoodItemById(itemId);
  }
}

/// Provider for food menu state management
final foodMenuProvider =
    StateNotifierProvider.family<
      FoodMenuNotifier,
      FoodMenuState,
      FoodMenuParams
    >((ref, params) {
      final useCase = ref.watch(getFoodItemsUseCaseProvider);
      return FoodMenuNotifier(useCase, params.locationId, params.brandId);
    });

/// Helper function to create provider parameters
FoodMenuParams createFoodMenuParams({
  required String locationId,
  String? brandId,
}) => FoodMenuParams(locationId: locationId, brandId: brandId);
