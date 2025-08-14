import '../../domain/entities/location_entity.dart';
import '../../domain/repositories/location_repository.dart';
import '../models/location_model.dart';

/// Implementation of LocationRepository for demo/development purposes
/// In production, this would connect to actual API endpoints
class LocationRepositoryImpl implements LocationRepository {
  
  /// Mock data for development - in production this would come from API
  static final List<LocationModel> _mockLocations = [
    const LocationModel(
      id: 'salt_dubai_mall',
      brandId: '1',
      name: 'Dubai Mall',
      address: 'Ground Floor, The Dubai Mall, Downtown Dubai, UAE',
      latitude: 25.1972,
      longitude: 55.2796,
      phoneNumber: '+971 4 339 8888',
      operatingHours: {
        'Monday': '10:00-00:00',
        'Tuesday': '10:00-00:00',
        'Wednesday': '10:00-00:00',
        'Thursday': '10:00-00:00',
        'Friday': '10:00-02:00',
        'Saturday': '10:00-02:00',
        'Sunday': '10:00-00:00',
      },
      isOpen: true,
      acceptsDelivery: true,
      acceptsPickup: true,
      distanceKm: 2.5,
      estimatedDeliveryMinutes: 25,
    ),
    const LocationModel(
      id: 'salt_emirates_mall',
      brandId: '1',
      name: 'Mall of the Emirates',
      address: 'North Beach, Jumeirah 1, Dubai, UAE',
      latitude: 25.1182,
      longitude: 55.2002,
      phoneNumber: '+971 4 341 2222',
      operatingHours: {
        'Monday': '10:00-22:00',
        'Tuesday': '10:00-22:00',
        'Wednesday': '10:00-22:00',
        'Thursday': '10:00-22:00',
        'Friday': '10:00-00:00',
        'Saturday': '10:00-00:00',
        'Sunday': '10:00-22:00',
      },
      isOpen: true,
      acceptsDelivery: true,
      acceptsPickup: true,
      distanceKm: 5.2,
      estimatedDeliveryMinutes: 30,
    ),
    const LocationModel(
      id: 'salt_bur_juman',
      brandId: '1',
      name: 'BurJuman',
      address: 'Ground Floor, BurJuman Centre, Bur Dubai, UAE',
      latitude: 25.2513,
      longitude: 55.3020,
      phoneNumber: '+971 4 352 0555',
      operatingHours: {
        'Monday': '10:00-22:00',
        'Tuesday': '10:00-22:00',
        'Wednesday': '10:00-22:00',
        'Thursday': '10:00-22:00',
        'Friday': '10:00-00:00',
        'Saturday': '10:00-00:00',
        'Sunday': '10:00-22:00',
      },
      isOpen: true,
      acceptsDelivery: false,
      acceptsPickup: true,
      distanceKm: 8.1,
      estimatedDeliveryMinutes: 40,
    ),
    const LocationModel(
      id: 'salt_city_walk',
      brandId: '1',
      name: 'City Walk',
      address: 'Building 6, City Walk, Al Wasl, Dubai, UAE',
      latitude: 25.2285,
      longitude: 55.2708,
      phoneNumber: '+971 4 317 8888',
      operatingHours: {
        'Monday': '08:00-23:00',
        'Tuesday': '08:00-23:00',
        'Wednesday': '08:00-23:00',
        'Thursday': '08:00-23:00',
        'Friday': '08:00-01:00',
        'Saturday': '08:00-01:00',
        'Sunday': '08:00-23:00',
      },
      isOpen: true,
      acceptsDelivery: true,
      acceptsPickup: true,
      distanceKm: 3.7,
      estimatedDeliveryMinutes: 20,
    ),
    const LocationModel(
      id: 'salt_marina_mall',
      brandId: '1',
      name: 'Marina Mall',
      address: 'Ground Floor, Marina Mall, Dubai Marina, UAE',
      latitude: 25.0779,
      longitude: 55.1415,
      phoneNumber: '+971 4 399 1111',
      operatingHours: {
        'Monday': '10:00-22:00',
        'Tuesday': '10:00-22:00',
        'Wednesday': '10:00-22:00',
        'Thursday': '10:00-22:00',
        'Friday': '10:00-00:00',
        'Saturday': '10:00-00:00',
        'Sunday': '10:00-22:00',
      },
      isOpen: false, // Closed for maintenance
      acceptsDelivery: false,
      acceptsPickup: false,
      distanceKm: 12.3,
      estimatedDeliveryMinutes: 45,
    ),
    // Additional locations for other brands
    const LocationModel(
      id: 'switch_dubai_mall',
      brandId: 'switch_brand',
      name: 'Dubai Mall',
      address: 'Level 2, The Dubai Mall, Downtown Dubai, UAE',
      latitude: 25.1975,
      longitude: 55.2799,
      phoneNumber: '+971 4 339 7777',
      operatingHours: {
        'Monday': '10:00-00:00',
        'Tuesday': '10:00-00:00',
        'Wednesday': '10:00-00:00',
        'Thursday': '10:00-00:00',
        'Friday': '10:00-02:00',
        'Saturday': '10:00-02:00',
        'Sunday': '10:00-00:00',
      },
      isOpen: true,
      acceptsDelivery: true,
      acceptsPickup: true,
      distanceKm: 2.6,
      estimatedDeliveryMinutes: 25,
    ),
    // Additional locations for different filter criteria
    const LocationModel(
      id: 'salt_jbr_beach',
      brandId: '1',
      name: 'JBR Beach Walk',
      address: 'The Beach at JBR, Jumeirah Beach Residence, Dubai, UAE',
      latitude: 25.0657,
      longitude: 55.1364,
      phoneNumber: '+971 4 567 8888',
      operatingHours: {
        'Monday': '08:00-22:00',
        'Tuesday': '08:00-22:00',
        'Wednesday': '08:00-22:00',
        'Thursday': '08:00-22:00',
        'Friday': '08:00-00:00',
        'Saturday': '08:00-00:00',
        'Sunday': '08:00-22:00',
      },
      isOpen: true,
      acceptsDelivery: false, // Pickup only - shows up in different filters
      acceptsPickup: true,
      distanceKm: 1.8,
      estimatedDeliveryMinutes: 20,
    ),
    const LocationModel(
      id: 'salt_downtown_offers',
      brandId: '1',
      name: 'Downtown Business Bay',
      address: 'Bay Square, Business Bay, Dubai, UAE',
      latitude: 25.1896,
      longitude: 55.2627,
      phoneNumber: '+971 4 432 1111',
      operatingHours: {
        'Monday': '07:00-23:00',
        'Tuesday': '07:00-23:00',
        'Wednesday': '07:00-23:00',
        'Thursday': '07:00-23:00',
        'Friday': '07:00-01:00',
        'Saturday': '07:00-01:00',
        'Sunday': '07:00-23:00',
      },
      isOpen: true,
      acceptsDelivery: true, // Has offers and delivery
      acceptsPickup: true,
      distanceKm: 3.2,
      estimatedDeliveryMinutes: 35,
    ),
    const LocationModel(
      id: 'salt_marina_family',
      brandId: '1',
      name: 'Dubai Marina Walk',
      address: 'Marina Walk, Dubai Marina, Dubai, UAE',
      latitude: 25.0769,
      longitude: 55.1413,
      phoneNumber: '+971 4 367 5555',
      operatingHours: {
        'Monday': '09:00-22:00',
        'Tuesday': '09:00-22:00',
        'Wednesday': '09:00-22:00',
        'Thursday': '09:00-22:00',
        'Friday': '09:00-00:00',
        'Saturday': '09:00-00:00',
        'Sunday': '09:00-22:00',
      },
      isOpen: true,
      acceptsDelivery: true,
      acceptsPickup: true,
      distanceKm: 4.1,
      estimatedDeliveryMinutes: 40,
    ),
    const LocationModel(
      id: 'salt_jumeirah_outdoor',
      brandId: '1',
      name: 'Jumeirah Beach Road',
      address: 'Beach Road, Jumeirah 1, Dubai, UAE',
      latitude: 25.2321,
      longitude: 55.2587,
      phoneNumber: '+971 4 394 7777',
      operatingHours: {
        'Monday': '08:00-22:00',
        'Tuesday': '08:00-22:00',
        'Wednesday': '08:00-22:00',
        'Thursday': '08:00-22:00',
        'Friday': '08:00-00:00',
        'Saturday': '08:00-00:00',
        'Sunday': '08:00-22:00',
      },
      isOpen: false, // Currently closed - won't show in "Available Now"
      acceptsDelivery: true,
      acceptsPickup: true,
      distanceKm: 6.5,
      estimatedDeliveryMinutes: 50,
    ),
    const LocationModel(
      id: 'salt_deira_nearby',
      brandId: '1',
      name: 'Deira City Centre',
      address: 'Deira City Centre, Port Saeed, Dubai, UAE',
      latitude: 25.2528,
      longitude: 55.3272,
      phoneNumber: '+971 4 295 1111',
      operatingHours: {
        'Monday': '10:00-22:00',
        'Tuesday': '10:00-22:00',
        'Wednesday': '10:00-22:00',
        'Thursday': '10:00-22:00',
        'Friday': '10:00-00:00',
        'Saturday': '10:00-00:00',
        'Sunday': '10:00-22:00',
      },
      isOpen: true,
      acceptsDelivery: true,
      acceptsPickup: true,
      distanceKm: 1.2, // Very close - shows in "Nearby"
      estimatedDeliveryMinutes: 15,
    ),
    // Locations for Switch brand (id: '2')
    const LocationModel(
      id: 'switch_dubai_mall',
      brandId: '2',
      name: 'Dubai Mall',
      address: 'Level 2, The Dubai Mall, Downtown Dubai, UAE',
      latitude: 25.1972,
      longitude: 55.2796,
      phoneNumber: '+971 4 339 9999',
      operatingHours: {
        'Monday': '10:00-00:00',
        'Tuesday': '10:00-00:00',
        'Wednesday': '10:00-00:00',
        'Thursday': '10:00-00:00',
        'Friday': '10:00-02:00',
        'Saturday': '10:00-02:00',
        'Sunday': '10:00-00:00',
      },
      isOpen: true,
      acceptsDelivery: true,
      acceptsPickup: true,
      distanceKm: 2.7,
      estimatedDeliveryMinutes: 30,
    ),
    const LocationModel(
      id: 'switch_marina',
      brandId: '2',
      name: 'Marina Walk',
      address: 'Dubai Marina Walk, Dubai Marina, UAE',
      latitude: 25.0769,
      longitude: 55.1413,
      phoneNumber: '+971 4 367 6666',
      operatingHours: {
        'Monday': '11:00-23:00',
        'Tuesday': '11:00-23:00',
        'Wednesday': '11:00-23:00',
        'Thursday': '11:00-23:00',
        'Friday': '11:00-01:00',
        'Saturday': '11:00-01:00',
        'Sunday': '11:00-23:00',
      },
      isOpen: true,
      acceptsDelivery: true,
      acceptsPickup: true,
      distanceKm: 4.3,
      estimatedDeliveryMinutes: 45,
    ),
  ];

  @override
  Future<List<LocationEntity>> getLocationsByBrandId(String brandId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    final locations = _mockLocations
        .where((location) => location.brandId == brandId)
        .map((model) => model.toEntity())
        .toList();
    
    // Sort by distance (nearest first)
    locations.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    
    return locations;
  }

  @override
  Future<List<LocationEntity>> getNearbyLocations({
    required double latitude,
    required double longitude,
    double radiusKm = 10.0,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));
    
    // Simple distance filtering (in production, this would be server-side)
    final nearbyLocations = _mockLocations
        .where((location) => location.distanceKm <= radiusKm)
        .map((model) => model.toEntity())
        .toList();
    
    // Sort by distance
    nearbyLocations.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    
    return nearbyLocations;
  }

  @override
  Future<List<LocationEntity>> searchLocations(String query) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));
    
    if (query.isEmpty) return [];
    
    final searchQuery = query.toLowerCase();
    final matchingLocations = _mockLocations
        .where((location) =>
            location.name.toLowerCase().contains(searchQuery) ||
            location.address.toLowerCase().contains(searchQuery))
        .map((model) => model.toEntity())
        .toList();
    
    return matchingLocations;
  }

  @override
  Future<LocationEntity?> getLocationById(String locationId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    try {
      final location = _mockLocations
          .firstWhere((location) => location.id == locationId);
      return location.toEntity();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> isLocationOpen(String locationId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));
    
    try {
      final location = _mockLocations
          .firstWhere((location) => location.id == locationId);
      
      // In production, this would check current time against operating hours
      return location.isOpen;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> isDeliveryAvailable(String locationId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));
    
    try {
      final location = _mockLocations
          .firstWhere((location) => location.id == locationId);
      return location.acceptsDelivery && location.isOpen;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> isPickupAvailable(String locationId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));
    
    try {
      final location = _mockLocations
          .firstWhere((location) => location.id == locationId);
      return location.acceptsPickup && location.isOpen;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<LocationEntity>> getLocationsWithOffers(String brandId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));
    
    // For demo purposes, return locations that accept delivery (simulating offers)
    final locationsWithOffers = _mockLocations
        .where((location) => location.brandId == brandId && location.acceptsDelivery)
        .map((model) => model.toEntity())
        .toList();
    
    // Sort by distance
    locationsWithOffers.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    
    return locationsWithOffers;
  }

  @override
  Future<List<LocationEntity>> getAvailableLocations(String brandId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Return only open locations for the brand
    final availableLocations = _mockLocations
        .where((location) => location.brandId == brandId && location.isOpen)
        .map((model) => model.toEntity())
        .toList();
    
    // Sort by distance (open locations first, then by distance)
    availableLocations.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    
    return availableLocations;
  }
}