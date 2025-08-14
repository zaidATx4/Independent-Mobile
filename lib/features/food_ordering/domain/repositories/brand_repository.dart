import '../entities/brand_entity.dart';
import '../entities/location_entity.dart';

/// Repository interface for brand and location operations
abstract class BrandRepository {
  /// Get all available brands
  Future<List<BrandEntity>> getBrands();

  /// Get brand by ID
  Future<BrandEntity?> getBrandById(String brandId);

  /// Get locations for a specific brand
  Future<List<LocationEntity>> getLocationsByBrandId(String brandId);

  /// Get location by ID
  Future<LocationEntity?> getLocationById(String locationId);

  /// Search brands by name or cuisine type
  Future<List<BrandEntity>> searchBrands(String query);

  /// Get nearby brands based on user location
  Future<List<BrandEntity>> getNearbyBrands({
    required double latitude,
    required double longitude,
    double radiusKm = 10.0,
  });

  /// Get featured/recommended brands
  Future<List<BrandEntity>> getFeaturedBrands();
}