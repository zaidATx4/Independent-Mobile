import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/usecases/get_locations_usecase.dart';
import '../../data/repositories/location_repository_impl.dart';

/// Provider for LocationRepository
final locationRepositoryProvider = Provider<LocationRepositoryImpl>((ref) {
  return LocationRepositoryImpl();
});

/// Provider for GetLocationsUseCase
final getLocationsUseCaseProvider = Provider<GetLocationsUseCase>((ref) {
  final repository = ref.watch(locationRepositoryProvider);
  return GetLocationsUseCase(repository);
});

/// State class for location selection
class LocationSelectionState {
  final List<LocationEntity> locations;
  final List<LocationEntity> filteredLocations;
  final bool isLoading;
  final String? error;
  final String selectedBrandId;
  final String searchQuery;
  final LocationFilter selectedFilter;
  final LocationEntity? selectedLocation;

  const LocationSelectionState({
    this.locations = const [],
    this.filteredLocations = const [],
    this.isLoading = false,
    this.error,
    required this.selectedBrandId,
    this.searchQuery = '',
    this.selectedFilter = LocationFilter.all,
    this.selectedLocation,
  });

  LocationSelectionState copyWith({
    List<LocationEntity>? locations,
    List<LocationEntity>? filteredLocations,
    bool? isLoading,
    String? error,
    String? selectedBrandId,
    String? searchQuery,
    LocationFilter? selectedFilter,
    LocationEntity? selectedLocation,
  }) {
    return LocationSelectionState(
      locations: locations ?? this.locations,
      filteredLocations: filteredLocations ?? this.filteredLocations,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedBrandId: selectedBrandId ?? this.selectedBrandId,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      selectedLocation: selectedLocation ?? this.selectedLocation,
    );
  }
}

/// Enum for location filters
enum LocationFilter {
  all,
  offers,
  nearby,
  availableNow,
  familyFriendly,
  outdoorSeating,
}

/// Extension to get display name for filters
extension LocationFilterExtension on LocationFilter {
  String get displayName {
    switch (this) {
      case LocationFilter.all:
        return 'All';
      case LocationFilter.offers:
        return 'Offers';
      case LocationFilter.nearby:
        return 'Nearby';
      case LocationFilter.availableNow:
        return 'Available Now';
      case LocationFilter.familyFriendly:
        return 'Family Friendly';
      case LocationFilter.outdoorSeating:
        return 'Outdoor Seating';
    }
  }
}

/// StateNotifier for managing location selection state
class LocationSelectionNotifier extends StateNotifier<LocationSelectionState> {
  final GetLocationsUseCase _getLocationsUseCase;

  LocationSelectionNotifier(
    this._getLocationsUseCase,
    String brandId,
  ) : super(LocationSelectionState(selectedBrandId: brandId)) {
    _loadLocations();
  }

  /// Load locations for the selected brand
  Future<void> _loadLocations() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final locations = await _getLocationsUseCase.getLocationsByBrandId(
        state.selectedBrandId,
      );

      state = state.copyWith(
        locations: locations,
        filteredLocations: locations,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Apply filter to locations
  Future<void> applyFilter(LocationFilter filter) async {
    state = state.copyWith(selectedFilter: filter, isLoading: true);

    try {
      List<LocationEntity> filteredLocations;

      switch (filter) {
        case LocationFilter.all:
          filteredLocations = await _getLocationsUseCase.getLocationsByBrandId(
            state.selectedBrandId,
          );
          break;
        case LocationFilter.offers:
          filteredLocations = await _getLocationsUseCase.getLocationsWithOffers(
            state.selectedBrandId,
          );
          break;
        case LocationFilter.nearby:
          // For demo, use mock coordinates (Dubai center)
          filteredLocations = await _getLocationsUseCase.getNearbyLocations(
            latitude: 25.2048,
            longitude: 55.2708,
            radiusKm: 5.0,
          );
          break;
        case LocationFilter.availableNow:
          filteredLocations = await _getLocationsUseCase.getAvailableLocations(
            state.selectedBrandId,
          );
          break;
        case LocationFilter.familyFriendly:
        case LocationFilter.outdoorSeating:
          // For demo purposes, return open locations
          // In production, these would have specific filtering logic
          filteredLocations = await _getLocationsUseCase.getAvailableLocations(
            state.selectedBrandId,
          );
          break;
      }

      // Apply search query if exists
      if (state.searchQuery.isNotEmpty) {
        filteredLocations = _filterBySearchQuery(
          filteredLocations,
          state.searchQuery,
        );
      }

      state = state.copyWith(
        filteredLocations: filteredLocations,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Search locations by query
  Future<void> searchLocations(String query) async {
    state = state.copyWith(searchQuery: query, isLoading: true);

    try {
      List<LocationEntity> filteredLocations;

      if (query.trim().isEmpty) {
        // If search is empty, show locations based on current filter
        await applyFilter(state.selectedFilter);
        return;
      }

      // Get all locations and apply search filter
      final allLocations = state.locations.isNotEmpty
          ? state.locations
          : await _getLocationsUseCase.getLocationsByBrandId(
              state.selectedBrandId,
            );

      filteredLocations = _filterBySearchQuery(allLocations, query);

      state = state.copyWith(
        locations: allLocations,
        filteredLocations: filteredLocations,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Filter locations by search query
  List<LocationEntity> _filterBySearchQuery(
    List<LocationEntity> locations,
    String query,
  ) {
    final searchQuery = query.toLowerCase().trim();
    return locations.where((location) {
      return location.name.toLowerCase().contains(searchQuery) ||
          location.address.toLowerCase().contains(searchQuery);
    }).toList();
  }

  /// Select a location
  void selectLocation(LocationEntity location) {
    state = state.copyWith(selectedLocation: location);
  }

  /// Clear selected location
  void clearSelectedLocation() {
    state = state.copyWith(selectedLocation: null);
  }

  /// Refresh locations
  Future<void> refresh() async {
    await _loadLocations();
  }

  /// Clear search and reset filters
  void clearSearch() {
    state = state.copyWith(
      searchQuery: '',
      selectedFilter: LocationFilter.all,
    );
    applyFilter(LocationFilter.all);
  }
}

/// Provider for location selection state management
final locationSelectionProvider = StateNotifierProvider.family<
    LocationSelectionNotifier, LocationSelectionState, String>(
  (ref, brandId) {
    final useCase = ref.watch(getLocationsUseCaseProvider);
    return LocationSelectionNotifier(useCase, brandId);
  },
);

/// Provider for current selected location across the app
final selectedLocationProvider = StateProvider<LocationEntity?>((ref) => null);