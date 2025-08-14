import '../entities/brand_entity.dart';
import '../entities/location_entity.dart';
import '../repositories/brand_repository.dart';

/// Use case for getting brands with various filtering options
class GetBrandsUseCase {
  final BrandRepository _repository;

  const GetBrandsUseCase(this._repository);

  /// Get all brands
  Future<List<BrandEntity>> call() async {
    return await _repository.getBrands();
  }

  /// Get brands by search query
  Future<List<BrandEntity>> searchBrands(String query) async {
    if (query.trim().isEmpty) {
      return await call(); // Return all brands if query is empty
    }
    return await _repository.searchBrands(query.trim());
  }

  /// Get nearby brands
  Future<List<BrandEntity>> getNearbyBrands({
    required double latitude,
    required double longitude,
    double radiusKm = 10.0,
  }) async {
    return await _repository.getNearbyBrands(
      latitude: latitude,
      longitude: longitude,
      radiusKm: radiusKm,
    );
  }

  /// Get featured brands
  Future<List<BrandEntity>> getFeaturedBrands() async {
    return await _repository.getFeaturedBrands();
  }

  /// Get brand with its locations
  Future<BrandWithLocations?> getBrandWithLocations(String brandId) async {
    final brand = await _repository.getBrandById(brandId);
    if (brand == null) return null;

    final locations = await _repository.getLocationsByBrandId(brandId);
    return BrandWithLocations(brand: brand, locations: locations);
  }
}

/// Data class to hold brand with its locations
class BrandWithLocations {
  final BrandEntity brand;
  final List<LocationEntity> locations;

  const BrandWithLocations({
    required this.brand,
    required this.locations,
  });
}

