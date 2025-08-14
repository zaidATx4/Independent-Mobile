import '../../domain/entities/location_entity.dart';

class LocationModel {
  final String id;
  final String brandId;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String phoneNumber;
  final Map<String, String> operatingHours;
  final bool isOpen;
  final bool acceptsDelivery;
  final bool acceptsPickup;
  final double distanceKm;
  final int estimatedDeliveryMinutes;

  const LocationModel({
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

  /// Create model from JSON
  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] as String,
      brandId: json['brandId'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      phoneNumber: json['phoneNumber'] as String,
      operatingHours: Map<String, String>.from(json['operatingHours'] ?? {}),
      isOpen: json['isOpen'] as bool,
      acceptsDelivery: json['acceptsDelivery'] as bool,
      acceptsPickup: json['acceptsPickup'] as bool,
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 0.0,
      estimatedDeliveryMinutes: json['estimatedDeliveryMinutes'] as int? ?? 30,
    );
  }

  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brandId': brandId,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'phoneNumber': phoneNumber,
      'operatingHours': operatingHours,
      'isOpen': isOpen,
      'acceptsDelivery': acceptsDelivery,
      'acceptsPickup': acceptsPickup,
      'distanceKm': distanceKm,
      'estimatedDeliveryMinutes': estimatedDeliveryMinutes,
    };
  }

  /// Convert model to entity
  LocationEntity toEntity() => LocationEntity(
        id: id,
        brandId: brandId,
        name: name,
        address: address,
        latitude: latitude,
        longitude: longitude,
        phoneNumber: phoneNumber,
        operatingHours: operatingHours,
        isOpen: isOpen,
        acceptsDelivery: acceptsDelivery,
        acceptsPickup: acceptsPickup,
        distanceKm: distanceKm,
        estimatedDeliveryMinutes: estimatedDeliveryMinutes,
      );

  /// Create model from entity
  factory LocationModel.fromEntity(LocationEntity entity) => LocationModel(
        id: entity.id,
        brandId: entity.brandId,
        name: entity.name,
        address: entity.address,
        latitude: entity.latitude,
        longitude: entity.longitude,
        phoneNumber: entity.phoneNumber,
        operatingHours: entity.operatingHours,
        isOpen: entity.isOpen,
        acceptsDelivery: entity.acceptsDelivery,
        acceptsPickup: entity.acceptsPickup,
        distanceKm: entity.distanceKm,
        estimatedDeliveryMinutes: entity.estimatedDeliveryMinutes,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationModel &&
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
    return 'LocationModel(id: $id, brandId: $brandId, name: $name, address: $address, latitude: $latitude, longitude: $longitude, phoneNumber: $phoneNumber, operatingHours: $operatingHours, isOpen: $isOpen, acceptsDelivery: $acceptsDelivery, acceptsPickup: $acceptsPickup, distanceKm: $distanceKm, estimatedDeliveryMinutes: $estimatedDeliveryMinutes)';
  }
}