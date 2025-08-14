import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/brand_repository_impl.dart';
import '../../domain/entities/brand_entity.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/repositories/brand_repository.dart';
import '../../domain/usecases/get_brands_usecase.dart';

/// State for brand selection screen
class BrandSelectionState {
  final List<BrandEntity> brands;
  final bool isLoading;
  final String searchQuery;
  final String? selectedBrandId;
  final List<LocationEntity> selectedBrandLocations;
  final String? error;

  const BrandSelectionState({
    this.brands = const [],
    this.isLoading = false,
    this.searchQuery = '',
    this.selectedBrandId,
    this.selectedBrandLocations = const [],
    this.error,
  });

  BrandSelectionState copyWith({
    List<BrandEntity>? brands,
    bool? isLoading,
    String? searchQuery,
    String? selectedBrandId,
    List<LocationEntity>? selectedBrandLocations,
    String? error,
  }) {
    return BrandSelectionState(
      brands: brands ?? this.brands,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedBrandId: selectedBrandId ?? this.selectedBrandId,
      selectedBrandLocations: selectedBrandLocations ?? this.selectedBrandLocations,
      error: error ?? this.error,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrandSelectionState &&
          runtimeType == other.runtimeType &&
          brands == other.brands &&
          isLoading == other.isLoading &&
          searchQuery == other.searchQuery &&
          selectedBrandId == other.selectedBrandId &&
          selectedBrandLocations == other.selectedBrandLocations &&
          error == other.error;

  @override
  int get hashCode => Object.hash(
        brands,
        isLoading,
        searchQuery,
        selectedBrandId,
        selectedBrandLocations,
        error,
      );

  @override
  String toString() {
    return 'BrandSelectionState(brands: $brands, isLoading: $isLoading, searchQuery: $searchQuery, selectedBrandId: $selectedBrandId, selectedBrandLocations: $selectedBrandLocations, error: $error)';
  }
}

/// Provider for brand repository
final brandRepositoryProvider = Provider<BrandRepository>((ref) {
  return BrandRepositoryImpl();
});

/// Provider for get brands use case
final getBrandsUseCaseProvider = Provider<GetBrandsUseCase>((ref) {
  final repository = ref.read(brandRepositoryProvider);
  return GetBrandsUseCase(repository);
});

/// Provider for brand selection state
final brandSelectionProvider = StateNotifierProvider<BrandSelectionNotifier, BrandSelectionState>((ref) {
  final useCase = ref.read(getBrandsUseCaseProvider);
  return BrandSelectionNotifier(useCase);
});

/// State notifier for brand selection
class BrandSelectionNotifier extends StateNotifier<BrandSelectionState> {
  final GetBrandsUseCase _getBrandsUseCase;

  BrandSelectionNotifier(this._getBrandsUseCase) : super(const BrandSelectionState()) {
    loadBrands();
  }

  /// Load all brands
  Future<void> loadBrands() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final brands = await _getBrandsUseCase();
      state = state.copyWith(
        brands: brands,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load brands: ${e.toString()}',
      );
    }
  }

  /// Search brands by query
  Future<void> searchBrands(String query) async {
    state = state.copyWith(searchQuery: query, isLoading: true, error: null);
    
    try {
      final brands = await _getBrandsUseCase.searchBrands(query);
      state = state.copyWith(
        brands: brands,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to search brands: ${e.toString()}',
      );
    }
  }

  /// Select a brand and load its locations
  Future<void> selectBrand(String brandId) async {
    try {
      final brandWithLocations = await _getBrandsUseCase.getBrandWithLocations(brandId);
      if (brandWithLocations != null) {
        state = state.copyWith(
          selectedBrandId: brandId,
          selectedBrandLocations: brandWithLocations.locations,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to load brand locations: ${e.toString()}',
      );
    }
  }

  /// Clear selection
  void clearSelection() {
    state = state.copyWith(
      selectedBrandId: null,
      selectedBrandLocations: [],
    );
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Refresh brands
  Future<void> refresh() async {
    await loadBrands();
  }

  /// Get nearby brands (mock implementation)
  Future<void> loadNearbyBrands({
    required double latitude,
    required double longitude,
    double radiusKm = 10.0,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final brands = await _getBrandsUseCase.getNearbyBrands(
        latitude: latitude,
        longitude: longitude,
        radiusKm: radiusKm,
      );
      state = state.copyWith(
        brands: brands,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load nearby brands: ${e.toString()}',
      );
    }
  }

  /// Load featured brands
  Future<void> loadFeaturedBrands() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final brands = await _getBrandsUseCase.getFeaturedBrands();
      state = state.copyWith(
        brands: brands,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load featured brands: ${e.toString()}',
      );
    }
  }
}