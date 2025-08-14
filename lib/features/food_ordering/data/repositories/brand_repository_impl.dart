import '../../domain/entities/brand_entity.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/repositories/brand_repository.dart';
import '../models/brand_model.dart';
import '../models/location_model.dart';

/// Implementation of BrandRepository with mock data for development
/// TODO: Replace with actual API integration
class BrandRepositoryImpl implements BrandRepository {
  // Mock data matching the Figma design
  static final List<BrandModel> _mockBrands = [
    const BrandModel(
      id: '1',
      name: 'Salt',
      logoUrl: 'assets/images/logos/brands/Salt.png',
      description: 'View Locations',
      locationIds: ['1a', '1b'],
      isActive: true,
      cuisineTypes: ['Modern Australian', 'Seafood'],
      rating: 4.5,
      reviewCount: 128,
      estimatedDeliveryMinutes: 25,
      deliveryFee: 3.99,
      minimumOrderAmount: 25.0,
    ),
    const BrandModel(
      id: '2',
      name: 'Switch',
      logoUrl: 'assets/images/logos/brands/Switch.png',
      description: 'View Locations',
      locationIds: ['2a', '2b'],
      isActive: true,
      cuisineTypes: ['Cafe', 'Brunch'],
      rating: 4.3,
      reviewCount: 95,
      estimatedDeliveryMinutes: 20,
      deliveryFee: 2.99,
      minimumOrderAmount: 20.0,
    ),
    const BrandModel(
      id: '3',
      name: 'Somewhere',
      logoUrl: 'assets/images/logos/brands/Somewhere.png',
      description: 'View Locations',
      locationIds: ['3a'],
      isActive: true,
      cuisineTypes: ['Modern Australian'],
      rating: 4.7,
      reviewCount: 203,
      estimatedDeliveryMinutes: 30,
      deliveryFee: 4.50,
      minimumOrderAmount: 30.0,
    ),
    const BrandModel(
      id: '4',
      name: 'Joe & Juice',
      logoUrl: 'assets/images/logos/brands/Joe_and _juice.png',
      description: 'View Locations',
      locationIds: ['4a', '4b', '4c'],
      isActive: true,
      cuisineTypes: ['Juice Bar', 'Healthy'],
      rating: 4.2,
      reviewCount: 87,
      estimatedDeliveryMinutes: 15,
      deliveryFee: 2.50,
      minimumOrderAmount: 15.0,
    ),
    const BrandModel(
      id: '5',
      name: "Parkers",
      logoUrl: 'assets/images/logos/brands/Parkers.png',
      description: 'View Locations',
      locationIds: ['5a', '5b'],
      isActive: true,
      cuisineTypes: ['Burgers', 'American'],
      rating: 4.4,
      reviewCount: 156,
      estimatedDeliveryMinutes: 28,
      deliveryFee: 3.50,
      minimumOrderAmount: 22.0,
    ),
  ];

  static final List<LocationModel> _mockLocations = [
    // Salt locations
    const LocationModel(
      id: '1a',
      brandId: '1',
      name: 'Salt - CBD',
      address: '123 Collins Street, Melbourne VIC 3000',
      latitude: -37.8136,
      longitude: 144.9631,
      phoneNumber: '+61 3 9000 1234',
      operatingHours: {
        'Monday': '11:00-22:00',
        'Tuesday': '11:00-22:00',
        'Wednesday': '11:00-22:00',
        'Thursday': '11:00-22:00',
        'Friday': '11:00-23:00',
        'Saturday': '10:00-23:00',
        'Sunday': '10:00-22:00',
      },
      isOpen: true,
      acceptsDelivery: true,
      acceptsPickup: true,
      distanceKm: 1.2,
    ),
    const LocationModel(
      id: '1b',
      brandId: '1',
      name: 'Salt - South Yarra',
      address: '456 Toorak Road, South Yarra VIC 3141',
      latitude: -37.8400,
      longitude: 144.9932,
      phoneNumber: '+61 3 9000 1235',
      operatingHours: {
        'Monday': '11:00-22:00',
        'Tuesday': '11:00-22:00',
        'Wednesday': '11:00-22:00',
        'Thursday': '11:00-22:00',
        'Friday': '11:00-23:00',
        'Saturday': '10:00-23:00',
        'Sunday': '10:00-22:00',
      },
      isOpen: true,
      acceptsDelivery: true,
      acceptsPickup: true,
      distanceKm: 3.5,
    ),
    // Add more mock locations as needed
  ];

  @override
  Future<List<BrandEntity>> getBrands() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockBrands.map((model) => model.toEntity()).toList();
  }

  @override
  Future<BrandEntity?> getBrandById(String brandId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final model = _mockBrands.where((brand) => brand.id == brandId).firstOrNull;
    return model?.toEntity();
  }

  @override
  Future<List<LocationEntity>> getLocationsByBrandId(String brandId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final locations = _mockLocations
        .where((location) => location.brandId == brandId)
        .map((model) => model.toEntity())
        .toList();
    return locations;
  }

  @override
  Future<LocationEntity?> getLocationById(String locationId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final model = _mockLocations.where((location) => location.id == locationId).firstOrNull;
    return model?.toEntity();
  }

  @override
  Future<List<BrandEntity>> searchBrands(String query) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final searchQuery = query.toLowerCase();
    final filteredBrands = _mockBrands
        .where((brand) =>
            brand.name.toLowerCase().contains(searchQuery) ||
            brand.cuisineTypes.any((cuisine) => cuisine.toLowerCase().contains(searchQuery)))
        .map((model) => model.toEntity())
        .toList();
    return filteredBrands;
  }

  @override
  Future<List<BrandEntity>> getNearbyBrands({
    required double latitude,
    required double longitude,
    double radiusKm = 10.0,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    // For mock implementation, just return all brands
    // In real implementation, calculate distance and filter
    return _mockBrands.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<BrandEntity>> getFeaturedBrands() async {
    await Future.delayed(const Duration(milliseconds: 400));
    // Return brands with rating >= 4.5
    final featuredBrands = _mockBrands
        .where((brand) => brand.rating >= 4.5)
        .map((model) => model.toEntity())
        .toList();
    return featuredBrands;
  }
}