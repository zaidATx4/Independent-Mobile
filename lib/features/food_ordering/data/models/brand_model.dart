import '../../domain/entities/brand_entity.dart';

class BrandModel {
  final String id;
  final String name;
  final String logoUrl;
  final String description;
  final List<String> locationIds;
  final bool isActive;
  final List<String> cuisineTypes;
  final double rating;
  final int reviewCount;
  final int estimatedDeliveryMinutes;
  final double deliveryFee;
  final double minimumOrderAmount;

  const BrandModel({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.description,
    required this.locationIds,
    required this.isActive,
    this.cuisineTypes = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
    this.estimatedDeliveryMinutes = 30,
    this.deliveryFee = 0.0,
    this.minimumOrderAmount = 0.0,
  });

  /// Create model from JSON
  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id'] as String,
      name: json['name'] as String,
      logoUrl: json['logoUrl'] as String,
      description: json['description'] as String,
      locationIds: List<String>.from(json['locationIds'] ?? []),
      isActive: json['isActive'] as bool,
      cuisineTypes: List<String>.from(json['cuisineTypes'] ?? []),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      estimatedDeliveryMinutes: json['estimatedDeliveryMinutes'] as int? ?? 30,
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble() ?? 0.0,
      minimumOrderAmount: (json['minimumOrderAmount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logoUrl': logoUrl,
      'description': description,
      'locationIds': locationIds,
      'isActive': isActive,
      'cuisineTypes': cuisineTypes,
      'rating': rating,
      'reviewCount': reviewCount,
      'estimatedDeliveryMinutes': estimatedDeliveryMinutes,
      'deliveryFee': deliveryFee,
      'minimumOrderAmount': minimumOrderAmount,
    };
  }

  /// Convert model to entity
  BrandEntity toEntity() => BrandEntity(
        id: id,
        name: name,
        logoUrl: logoUrl,
        description: description,
        locationIds: locationIds,
        isActive: isActive,
        cuisineTypes: cuisineTypes,
        rating: rating,
        reviewCount: reviewCount,
        estimatedDeliveryMinutes: estimatedDeliveryMinutes,
        deliveryFee: deliveryFee,
        minimumOrderAmount: minimumOrderAmount,
      );

  /// Create model from entity
  factory BrandModel.fromEntity(BrandEntity entity) => BrandModel(
        id: entity.id,
        name: entity.name,
        logoUrl: entity.logoUrl,
        description: entity.description,
        locationIds: entity.locationIds,
        isActive: entity.isActive,
        cuisineTypes: entity.cuisineTypes,
        rating: entity.rating,
        reviewCount: entity.reviewCount,
        estimatedDeliveryMinutes: entity.estimatedDeliveryMinutes,
        deliveryFee: entity.deliveryFee,
        minimumOrderAmount: entity.minimumOrderAmount,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrandModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          logoUrl == other.logoUrl &&
          description == other.description &&
          locationIds == other.locationIds &&
          isActive == other.isActive &&
          cuisineTypes == other.cuisineTypes &&
          rating == other.rating &&
          reviewCount == other.reviewCount &&
          estimatedDeliveryMinutes == other.estimatedDeliveryMinutes &&
          deliveryFee == other.deliveryFee &&
          minimumOrderAmount == other.minimumOrderAmount;

  @override
  int get hashCode => Object.hash(
        id,
        name,
        logoUrl,
        description,
        locationIds,
        isActive,
        cuisineTypes,
        rating,
        reviewCount,
        estimatedDeliveryMinutes,
        deliveryFee,
        minimumOrderAmount,
      );

  @override
  String toString() {
    return 'BrandModel(id: $id, name: $name, logoUrl: $logoUrl, description: $description, locationIds: $locationIds, isActive: $isActive, cuisineTypes: $cuisineTypes, rating: $rating, reviewCount: $reviewCount, estimatedDeliveryMinutes: $estimatedDeliveryMinutes, deliveryFee: $deliveryFee, minimumOrderAmount: $minimumOrderAmount)';
  }
}