import '../entities/location_entity.dart';
import '../repositories/location_repository.dart';

/// Use case for retrieving locations with business logic
class GetLocationsUseCase {
  final LocationRepository _repository;

  const GetLocationsUseCase(this._repository);

  /// Get all locations for a specific brand
  /// Applies business rules like filtering unavailable locations, sorting by distance
  Future<List<LocationEntity>> getLocationsByBrandId(String brandId) async {
    try {
      final locations = await _repository.getLocationsByBrandId(brandId);
      
      // Apply business rules
      return _applyBusinessRules(locations);
    } catch (e) {
      throw LocationException('Failed to fetch locations: ${e.toString()}');
    }
  }

  /// Search locations with business logic
  Future<List<LocationEntity>> searchLocations(String query) async {
    try {
      if (query.trim().isEmpty) {
        return [];
      }

      final locations = await _repository.searchLocations(query.trim());
      return _applyBusinessRules(locations);
    } catch (e) {
      throw LocationException('Failed to search locations: ${e.toString()}');
    }
  }

  /// Get nearby locations within radius
  Future<List<LocationEntity>> getNearbyLocations({
    required double latitude,
    required double longitude,
    double radiusKm = 10.0,
  }) async {
    try {
      final locations = await _repository.getNearbyLocations(
        latitude: latitude,
        longitude: longitude,
        radiusKm: radiusKm,
      );
      
      return _applyBusinessRules(locations);
    } catch (e) {
      throw LocationException('Failed to fetch nearby locations: ${e.toString()}');
    }
  }

  /// Filter locations by availability
  Future<List<LocationEntity>> getAvailableLocations(String brandId) async {
    try {
      final locations = await _repository.getAvailableLocations(brandId);
      return _applyBusinessRules(locations);
    } catch (e) {
      throw LocationException('Failed to fetch available locations: ${e.toString()}');
    }
  }

  /// Get locations with special offers
  Future<List<LocationEntity>> getLocationsWithOffers(String brandId) async {
    try {
      final locations = await _repository.getLocationsWithOffers(brandId);
      return _applyBusinessRules(locations);
    } catch (e) {
      throw LocationException('Failed to fetch locations with offers: ${e.toString()}');
    }
  }

  /// Apply business rules to location list
  List<LocationEntity> _applyBusinessRules(List<LocationEntity> locations) {
    // Sort by priority:
    // 1. Open locations first
    // 2. Then by distance (nearest first)
    // 3. Then by delivery availability
    locations.sort((a, b) {
      // Open locations first
      if (a.isOpen && !b.isOpen) return -1;
      if (!a.isOpen && b.isOpen) return 1;
      
      // Then by distance
      final distanceComparison = a.distanceKm.compareTo(b.distanceKm);
      if (distanceComparison != 0) return distanceComparison;
      
      // Then by delivery availability
      if (a.acceptsDelivery && !b.acceptsDelivery) return -1;
      if (!a.acceptsDelivery && b.acceptsDelivery) return 1;
      
      return 0;
    });

    return locations;
  }
}

/// Custom exception for location-related errors
class LocationException implements Exception {
  final String message;
  
  const LocationException(this.message);
  
  @override
  String toString() => 'LocationException: $message';
}