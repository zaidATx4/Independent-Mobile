class LoyaltyMember {
  final String id;
  final String name;
  final int points;
  final String tier;
  final int pointsToNextTier;
  final String nextTier;
  final List<LoyaltyReward> rewards;
  final List<LoyaltyTransaction> transactions;

  const LoyaltyMember({
    required this.id,
    required this.name,
    required this.points,
    required this.tier,
    required this.pointsToNextTier,
    required this.nextTier,
    this.rewards = const [],
    this.transactions = const [],
  });

  factory LoyaltyMember.fromJson(Map<String, dynamic> json) {
    return LoyaltyMember(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      points: json['points'] as int? ?? 0,
      tier: json['tier'] as String? ?? '',
      pointsToNextTier: json['pointsToNextTier'] as int? ?? 0,
      nextTier: json['nextTier'] as String? ?? '',
      rewards: (json['rewards'] as List<dynamic>?)
          ?.map((e) => LoyaltyReward.fromJson(e as Map<String, dynamic>))
          .toList() ?? const <LoyaltyReward>[],
      transactions: (json['transactions'] as List<dynamic>?)
          ?.map((e) => LoyaltyTransaction.fromJson(e as Map<String, dynamic>))
          .toList() ?? const <LoyaltyTransaction>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'points': points,
      'tier': tier,
      'pointsToNextTier': pointsToNextTier,
      'nextTier': nextTier,
      'rewards': rewards.map((e) => e.toJson()).toList(),
      'transactions': transactions.map((e) => e.toJson()).toList(),
    };
  }
}

class LoyaltyReward {
  final String id;
  final String title;
  final String description;
  final String expiryDate;
  final String foodImageUrl;
  final String brandName;
  final String brandLogoUrl;
  final bool isRedeemed;

  const LoyaltyReward({
    required this.id,
    required this.title,
    required this.description,
    required this.expiryDate,
    required this.foodImageUrl,
    required this.brandName,
    required this.brandLogoUrl,
    this.isRedeemed = false,
  });

  factory LoyaltyReward.fromJson(Map<String, dynamic> json) {
    return LoyaltyReward(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      expiryDate: json['expiryDate'] as String,
      foodImageUrl: json['foodImageUrl'] as String,
      brandName: json['brandName'] as String,
      brandLogoUrl: json['brandLogoUrl'] as String,
      isRedeemed: json['isRedeemed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'expiryDate': expiryDate,
      'foodImageUrl': foodImageUrl,
      'brandName': brandName,
      'brandLogoUrl': brandLogoUrl,
      'isRedeemed': isRedeemed,
    };
  }
}

class LoyaltyHubState {
  final String selectedTab;
  final String selectedTransactionFilter;
  final LoyaltyMember? member;
  final bool isLoading;
  final String? errorMessage;

  const LoyaltyHubState({
    this.selectedTab = 'Discover',
    this.selectedTransactionFilter = 'All',
    this.member,
    this.isLoading = false,
    this.errorMessage,
  });

  LoyaltyHubState copyWith({
    String? selectedTab,
    String? selectedTransactionFilter,
    LoyaltyMember? member,
    bool? isLoading,
    String? errorMessage,
  }) {
    return LoyaltyHubState(
      selectedTab: selectedTab ?? this.selectedTab,
      selectedTransactionFilter: selectedTransactionFilter ?? this.selectedTransactionFilter,
      member: member ?? this.member,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class LoyaltyTransaction {
  final String id;
  final String type; // 'earned', 'redeemed', 'expired'
  final int points;
  final String description;
  final String date;
  final String? restaurantName;
  final String? restaurantLogo;

  const LoyaltyTransaction({
    required this.id,
    required this.type,
    required this.points,
    required this.description,
    required this.date,
    this.restaurantName,
    this.restaurantLogo,
  });

  factory LoyaltyTransaction.fromJson(Map<String, dynamic> json) {
    return LoyaltyTransaction(
      id: json['id'] as String,
      type: json['type'] as String,
      points: json['points'] as int,
      description: json['description'] as String,
      date: json['date'] as String,
      restaurantName: json['restaurantName'] as String?,
      restaurantLogo: json['restaurantLogo'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'points': points,
      'description': description,
      'date': date,
      'restaurantName': restaurantName,
      'restaurantLogo': restaurantLogo,
    };
  }
}