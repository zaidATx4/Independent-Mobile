import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/food_entities.dart';
import '../../domain/usecases/food_search_usecases.dart';
import '../../data/repositories/food_repository.dart';

// Repository provider
final foodRepositoryProvider = Provider<FoodRepository>((ref) {
  return FoodRepositoryImpl();
});

// Use case providers
final searchFoodItemsUseCaseProvider = Provider<SearchFoodItemsUseCase>((ref) {
  return SearchFoodItemsUseCase(ref.watch(foodRepositoryProvider));
});

final getFoodCategoriesUseCaseProvider = Provider<GetFoodCategoriesUseCase>((ref) {
  return GetFoodCategoriesUseCase(ref.watch(foodRepositoryProvider));
});

final getFoodItemByIdUseCaseProvider = Provider<GetFoodItemByIdUseCase>((ref) {
  return GetFoodItemByIdUseCase(ref.watch(foodRepositoryProvider));
});

// Search filters state
final searchFiltersProvider = StateProvider<SearchFilters>((ref) {
  return const SearchFilters();
});

// Food categories state
final foodCategoriesProvider = StateNotifierProvider<FoodCategoriesNotifier, AsyncValue<List<FoodCategory>>>((ref) {
  return FoodCategoriesNotifier(ref.watch(getFoodCategoriesUseCaseProvider));
});

class FoodCategoriesNotifier extends StateNotifier<AsyncValue<List<FoodCategory>>> {
  final GetFoodCategoriesUseCase _getFoodCategoriesUseCase;

  FoodCategoriesNotifier(this._getFoodCategoriesUseCase) : super(const AsyncValue.loading()) {
    loadCategories();
  }

  Future<void> loadCategories() async {
    try {
      final categories = await _getFoodCategoriesUseCase();
      state = AsyncValue.data(categories);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void toggleCategory(String categoryId) {
    state.whenData((categories) {
      final updatedCategories = categories.map((category) {
        if (category.id == categoryId) {
          return category.copyWith(isSelected: !category.isSelected);
        }
        return category;
      }).toList();
      state = AsyncValue.data(updatedCategories);
    });
  }

  void selectSingleCategory(String categoryId) {
    state.whenData((categories) {
      final updatedCategories = categories.map((category) {
        return category.copyWith(isSelected: category.id == categoryId);
      }).toList();
      state = AsyncValue.data(updatedCategories);
    });
  }

  void clearSelection() {
    state.whenData((categories) {
      final updatedCategories = categories.map((category) {
        return category.copyWith(isSelected: false);
      }).toList();
      state = AsyncValue.data(updatedCategories);
    });
  }
}

// Food search results state
final foodSearchResultsProvider = StateNotifierProvider<FoodSearchNotifier, AsyncValue<List<FoodItem>>>((ref) {
  return FoodSearchNotifier(
    ref.watch(searchFoodItemsUseCaseProvider),
    ref,
  );
});

class FoodSearchNotifier extends StateNotifier<AsyncValue<List<FoodItem>>> {
  final SearchFoodItemsUseCase _searchFoodItemsUseCase;
  final Ref _ref;

  FoodSearchNotifier(this._searchFoodItemsUseCase, this._ref) : super(const AsyncValue.loading()) {
    // Initial search with empty filters to show all items
    searchItems();
  }

  Future<void> searchItems() async {
    try {
      state = const AsyncValue.loading();
      
      // Get current filters
      final filters = _ref.read(searchFiltersProvider);
      
      // Get selected categories
      final categoriesAsync = _ref.read(foodCategoriesProvider);
      List<String> selectedCategories = [];
      
      categoriesAsync.whenData((categories) {
        selectedCategories = categories
            .where((cat) => cat.isSelected)
            .map((cat) => cat.id)
            .toList();
      });

      // Update filters with selected categories
      final updatedFilters = filters.copyWith(
        selectedCategories: selectedCategories,
      );

      final items = await _searchFoodItemsUseCase(updatedFilters);
      state = AsyncValue.data(items);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateSearchQuery(String query) async {
    final currentFilters = _ref.read(searchFiltersProvider);
    _ref.read(searchFiltersProvider.notifier).state = currentFilters.copyWith(
      searchQuery: query,
    );
    await searchItems();
  }

  Future<void> clearSearch() async {
    _ref.read(searchFiltersProvider.notifier).state = const SearchFilters();
    _ref.read(foodCategoriesProvider.notifier).clearSelection();
    await searchItems();
  }
}

// Provider to listen to category changes and refresh search
final searchRefreshProvider = Provider<void>((ref) {
  // Watch categories for changes
  ref.watch(foodCategoriesProvider);
  
  // Trigger search refresh when categories change
  ref.read(foodSearchResultsProvider.notifier).searchItems();
});

// Search query provider for the text field
final searchQueryProvider = StateProvider<String>((ref) => '');

