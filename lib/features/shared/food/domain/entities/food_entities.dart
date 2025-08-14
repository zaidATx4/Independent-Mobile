class FoodItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String currency;
  final String imagePath;
  final String category;
  final bool isAvailable;
  final double rating;
  final int reviewCount;
  final List<String> tags;

  const FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.currency,
    required this.imagePath,
    required this.category,
    this.isAvailable = true,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.tags = const [],
  });

  FoodItem copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? currency,
    String? imagePath,
    String? category,
    bool? isAvailable,
    double? rating,
    int? reviewCount,
    List<String>? tags,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      imagePath: imagePath ?? this.imagePath,
      category: category ?? this.category,
      isAvailable: isAvailable ?? this.isAvailable,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      tags: tags ?? this.tags,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FoodItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class FoodCategory {
  final String id;
  final String name;
  final String displayName;
  final bool isSelected;

  const FoodCategory({
    required this.id,
    required this.name,
    required this.displayName,
    this.isSelected = false,
  });

  FoodCategory copyWith({
    String? id,
    String? name,
    String? displayName,
    bool? isSelected,
  }) {
    return FoodCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FoodCategory && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class SearchFilters {
  final String searchQuery;
  final List<String> selectedCategories;
  final double? minPrice;
  final double? maxPrice;
  final double? minRating;
  final bool? availableOnly;

  const SearchFilters({
    this.searchQuery = '',
    this.selectedCategories = const [],
    this.minPrice,
    this.maxPrice,
    this.minRating,
    this.availableOnly,
  });

  SearchFilters copyWith({
    String? searchQuery,
    List<String>? selectedCategories,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    bool? availableOnly,
  }) {
    return SearchFilters(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minRating: minRating ?? this.minRating,
      availableOnly: availableOnly ?? this.availableOnly,
    );
  }

  bool get hasFilters {
    return searchQuery.isNotEmpty ||
        selectedCategories.isNotEmpty ||
        minPrice != null ||
        maxPrice != null ||
        minRating != null ||
        availableOnly != null;
  }
}