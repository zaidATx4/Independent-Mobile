import '../entities/food_entities.dart';
import '../../data/repositories/food_repository.dart';

class SearchFoodItemsUseCase {
  final FoodRepository _repository;

  SearchFoodItemsUseCase(this._repository);

  Future<List<FoodItem>> call(SearchFilters filters) async {
    return await _repository.searchFoodItems(filters);
  }
}

class GetFoodCategoriesUseCase {
  final FoodRepository _repository;

  GetFoodCategoriesUseCase(this._repository);

  Future<List<FoodCategory>> call() async {
    return await _repository.getFoodCategories();
  }
}

class GetFoodItemByIdUseCase {
  final FoodRepository _repository;

  GetFoodItemByIdUseCase(this._repository);

  Future<FoodItem?> call(String id) async {
    return await _repository.getFoodItemById(id);
  }
}