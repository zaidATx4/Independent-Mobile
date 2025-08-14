import '../entities/location_entity.dart';

/// Repository interface for location-related operations
abstract class LocationRepository {
  /// Get all locations for a specific brand
  Future<List<LocationEntity>> getLocationsByBrandId(String brandId);

  /// Get all locations within a radius of the user's location
  Future<List<LocationEntity>> getNearbyLocations({
    required double latitude,
    required double longitude,
    double radiusKm = 10.0,
  });

  /// Search locations by name or address
  Future<List<LocationEntity>> searchLocations(String query);

  /// Get a specific location by ID
  Future<LocationEntity?> getLocationById(String locationId);

  /// Check if a location is currently open
  Future<bool> isLocationOpen(String locationId);

  /// Get delivery/pickup availability for a location
  Future<bool> isDeliveryAvailable(String locationId);
  Future<bool> isPickupAvailable(String locationId);

  /// Get locations with current offers/promotions
  Future<List<LocationEntity>> getLocationsWithOffers(String brandId);

  /// Get currently available locations (open for delivery/pickup)
  Future<List<LocationEntity>> getAvailableLocations(String brandId);
}