/// Entity representing a restaurant brand available for ordering
class BrandEntity {
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

  const BrandEntity({
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

  BrandEntity copyWith({
    String? id,
    String? name,
    String? logoUrl,
    String? description,
    List<String>? locationIds,
    bool? isActive,
    List<String>? cuisineTypes,
    double? rating,
    int? reviewCount,
    int? estimatedDeliveryMinutes,
    double? deliveryFee,
    double? minimumOrderAmount,
  }) {
    return BrandEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
      description: description ?? this.description,
      locationIds: locationIds ?? this.locationIds,
      isActive: isActive ?? this.isActive,
      cuisineTypes: cuisineTypes ?? this.cuisineTypes,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      estimatedDeliveryMinutes: estimatedDeliveryMinutes ?? this.estimatedDeliveryMinutes,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      minimumOrderAmount: minimumOrderAmount ?? this.minimumOrderAmount,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrandEntity &&
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
    return 'BrandEntity(id: $id, name: $name, logoUrl: $logoUrl, description: $description, locationIds: $locationIds, isActive: $isActive, cuisineTypes: $cuisineTypes, rating: $rating, reviewCount: $reviewCount, estimatedDeliveryMinutes: $estimatedDeliveryMinutes, deliveryFee: $deliveryFee, minimumOrderAmount: $minimumOrderAmount)';
  }
}