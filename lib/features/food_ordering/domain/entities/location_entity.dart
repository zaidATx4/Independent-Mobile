/// Entity representing a restaurant location for a specific brand
class LocationEntity {
  final String id;
  final String brandId;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String phoneNumber;
  final Map<String, String> operatingHours; // Day -> "09:00-22:00"
  final bool isOpen;
  final bool acceptsDelivery;
  final bool acceptsPickup;
  final double distanceKm;
  final int estimatedDeliveryMinutes;

  const LocationEntity({
    required this.id,
    required this.brandId,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.phoneNumber,
    required this.operatingHours,
    required this.isOpen,
    required this.acceptsDelivery,
    required this.acceptsPickup,
    this.distanceKm = 0.0,
    this.estimatedDeliveryMinutes = 30,
  });

  LocationEntity copyWith({
    String? id,
    String? brandId,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    String? phoneNumber,
    Map<String, String>? operatingHours,
    bool? isOpen,
    bool? acceptsDelivery,
    bool? acceptsPickup,
    double? distanceKm,
    int? estimatedDeliveryMinutes,
  }) {
    return LocationEntity(
      id: id ?? this.id,
      brandId: brandId ?? this.brandId,
      name: name ?? this.name,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      operatingHours: operatingHours ?? this.operatingHours,
      isOpen: isOpen ?? this.isOpen,
      acceptsDelivery: acceptsDelivery ?? this.acceptsDelivery,
      acceptsPickup: acceptsPickup ?? this.acceptsPickup,
      distanceKm: distanceKm ?? this.distanceKm,
      estimatedDeliveryMinutes: estimatedDeliveryMinutes ?? this.estimatedDeliveryMinutes,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          brandId == other.brandId &&
          name == other.name &&
          address == other.address &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          phoneNumber == other.phoneNumber &&
          operatingHours == other.operatingHours &&
          isOpen == other.isOpen &&
          acceptsDelivery == other.acceptsDelivery &&
          acceptsPickup == other.acceptsPickup &&
          distanceKm == other.distanceKm &&
          estimatedDeliveryMinutes == other.estimatedDeliveryMinutes;

  @override
  int get hashCode => Object.hash(
        id,
        brandId,
        name,
        address,
        latitude,
        longitude,
        phoneNumber,
        operatingHours,
        isOpen,
        acceptsDelivery,
        acceptsPickup,
        distanceKm,
        estimatedDeliveryMinutes,
      );

  @override
  String toString() {
    return 'LocationEntity(id: $id, brandId: $brandId, name: $name, address: $address, latitude: $latitude, longitude: $longitude, phoneNumber: $phoneNumber, operatingHours: $operatingHours, isOpen: $isOpen, acceptsDelivery: $acceptsDelivery, acceptsPickup: $acceptsPickup, distanceKm: $distanceKm, estimatedDeliveryMinutes: $estimatedDeliveryMinutes)';
  }
}