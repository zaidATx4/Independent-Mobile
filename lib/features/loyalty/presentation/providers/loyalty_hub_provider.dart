import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/loyalty_member.dart';

class LoyaltyHubNotifier extends StateNotifier<LoyaltyHubState> {
  LoyaltyHubNotifier() : super(const LoyaltyHubState()) {
    _loadMockData();
  }

  void _loadMockData() {
    // Mock data for development - replace with actual API call later
    final mockMember = LoyaltyMember(
      id: '1',
      name: 'John Doe',
      points: 10500,
      tier: 'Gold Member',
      pointsToNextTier: 5000,
      nextTier: 'Platinum',
      rewards: [
        LoyaltyReward(
          id: '1',
          title: 'Cheeseburger',
          description: 'Delicious cheeseburger',
          expiryDate: 'Expires on April 6, 2025',
          foodImageUrl: 'assets/images/Static/burger.png',
          brandName: 'Salt',
          brandLogoUrl: 'assets/images/logos/brands/Salt.png',
          isRedeemed: true, // Mark as redeemed for scan tab demonstration
        ),
        LoyaltyReward(
          id: '2',
          title: 'Chicken taco',
          description: 'Spicy chicken taco',
          expiryDate: 'Expires on April 6, 2025',
          foodImageUrl: 'assets/images/Static/Chicken_taco.png',
          brandName: 'Somewhere',
          brandLogoUrl: 'assets/images/logos/brands/Somewhere.png',
          isRedeemed: true, // Mark as redeemed for scan tab demonstration
        ),
        LoyaltyReward(
          id: '3',
          title: 'Greek Salad',
          description: 'Fresh Greek salad',
          expiryDate: 'Expires on April 6, 2025',
          foodImageUrl: 'assets/images/Static/greek_salad.png',
          brandName: 'Joe & Juice',
          brandLogoUrl: 'assets/images/logos/brands/Joe_and _juice.png',
          isRedeemed: false, // Keep as available for redeem tab
        ),
        // Additional available rewards for redeem tab
        LoyaltyReward(
          id: '4',
          title: 'Fish & Chips',
          description: 'Classic fish and chips',
          expiryDate: 'Expires on April 10, 2025',
          foodImageUrl: 'assets/images/Static/burger.png', // Using existing asset
          brandName: 'Salt',
          brandLogoUrl: 'assets/images/logos/brands/Salt.png',
          isRedeemed: false,
        ),
        LoyaltyReward(
          id: '5',
          title: 'Beef Burrito',
          description: 'Hearty beef burrito',
          expiryDate: 'Expires on April 15, 2025',
          foodImageUrl: 'assets/images/Static/Chicken_taco.png', // Using existing asset
          brandName: 'Somewhere',
          brandLogoUrl: 'assets/images/logos/brands/Somewhere.png',
          isRedeemed: false,
        ),
      ],
      transactions: [
        LoyaltyTransaction(
          id: '1',
          type: 'earned',
          points: 250,
          description: 'Purchased at Salt, Dubai Mall',
          date: 'March 25, 2025',
          restaurantName: 'Salt',
          restaurantLogo: 'assets/images/logos/brands/Salt.png',
        ),
        LoyaltyTransaction(
          id: '2',
          type: 'redeemed',
          points: -250,
          description: 'Redeemed Buy 1 Get 1 Burger',
          date: 'March 25, 2025',
          restaurantName: 'Salt',
          restaurantLogo: 'assets/images/logos/brands/Salt.png',
        ),
        LoyaltyTransaction(
          id: '3',
          type: 'earned',
          points: 250,
          description: 'Purchased at Salt, Dubai Mall',
          date: 'March 25, 2025',
          restaurantName: 'Salt',
          restaurantLogo: 'assets/images/logos/brands/Salt.png',
        ),
        LoyaltyTransaction(
          id: '4',
          type: 'earned',
          points: 250,
          description: 'Purchased at Salt, Dubai Mall',
          date: 'March 25, 2025',
          restaurantName: 'Salt',
          restaurantLogo: 'assets/images/logos/brands/Salt.png',
        ),
        LoyaltyTransaction(
          id: '5',
          type: 'earned',
          points: 250,
          description: 'Purchased at Salt, Dubai Mall',
          date: 'March 25, 2025',
          restaurantName: 'Salt',
          restaurantLogo: 'assets/images/logos/brands/Salt.png',
        ),
        LoyaltyTransaction(
          id: '6',
          type: 'redeemed',
          points: -250,
          description: 'Redeemed Buy 1 Get 1 Burger',
          date: 'March 25, 2025',
          restaurantName: 'Salt',
          restaurantLogo: 'assets/images/logos/brands/Salt.png',
        ),
        LoyaltyTransaction(
          id: '7',
          type: 'earned',
          points: 175,
          description: 'Purchased at Somewhere Cafe',
          date: 'March 20, 2025',
          restaurantName: 'Somewhere',
          restaurantLogo: 'assets/images/logos/brands/Somewhere.png',
        ),
        LoyaltyTransaction(
          id: '8',
          type: 'expired',
          points: -100,
          description: '100 points expired',
          date: 'March 15, 2025',
        ),
      ],
    );

    state = state.copyWith(member: mockMember, isLoading: false);
  }

  void selectTab(String tab) {
    state = state.copyWith(selectedTab: tab);
  }

  void selectTransactionFilter(String filter) {
    state = state.copyWith(selectedTransactionFilter: filter);
  }

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void setError(String? error) {
    state = state.copyWith(errorMessage: error);
  }

  Future<void> refreshMemberData() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));
      _loadMockData();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load member data: ${e.toString()}',
      );
    }
  }

  Future<void> redeemReward(String rewardId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));
      
      final member = state.member;
      if (member == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'No member data available',
        );
        return;
      }

      // Update the reward as redeemed
      final updatedRewards = member.rewards.map((reward) {
        if (reward.id == rewardId) {
          return LoyaltyReward(
            id: reward.id,
            title: reward.title,
            description: reward.description,
            expiryDate: reward.expiryDate,
            foodImageUrl: reward.foodImageUrl,
            brandName: reward.brandName,
            brandLogoUrl: reward.brandLogoUrl,
            isRedeemed: true,
          );
        }
        return reward;
      }).toList();

      final updatedMember = LoyaltyMember(
        id: member.id,
        name: member.name,
        points: member.points,
        tier: member.tier,
        pointsToNextTier: member.pointsToNextTier,
        nextTier: member.nextTier,
        rewards: updatedRewards,
        transactions: member.transactions,
      );

      state = state.copyWith(member: updatedMember, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to redeem reward: ${e.toString()}',
      );
    }
  }
}

final loyaltyHubProvider = StateNotifierProvider<LoyaltyHubNotifier, LoyaltyHubState>((ref) {
  return LoyaltyHubNotifier();
});

// Convenience providers for specific parts of the state
final loyaltyMemberProvider = Provider<LoyaltyMember?>((ref) {
  return ref.watch(loyaltyHubProvider).member;
});

final loyaltyRewardsProvider = Provider<List<LoyaltyReward>>((ref) {
  final member = ref.watch(loyaltyHubProvider).member;
  if (member == null) return <LoyaltyReward>[];
  return member.rewards;
});

final loyaltySelectedTabProvider = Provider<String>((ref) {
  return ref.watch(loyaltyHubProvider).selectedTab;
});

final loyaltyLoadingProvider = Provider<bool>((ref) {
  return ref.watch(loyaltyHubProvider).isLoading;
});

final loyaltyTransactionsProvider = Provider<List<LoyaltyTransaction>>((ref) {
  final member = ref.watch(loyaltyHubProvider).member;
  if (member == null) return <LoyaltyTransaction>[];
  return member.transactions;
});

final filteredLoyaltyTransactionsProvider = Provider<List<LoyaltyTransaction>>((ref) {
  final member = ref.watch(loyaltyHubProvider).member;
  final filter = ref.watch(loyaltyHubProvider).selectedTransactionFilter;
  
  if (member == null) return <LoyaltyTransaction>[];
  
  final allTransactions = member.transactions;
  
  switch (filter.toLowerCase()) {
    case 'earned':
      return allTransactions.where((transaction) => 
        transaction.type.toLowerCase() == 'earned').toList();
    case 'redeemed':
      return allTransactions.where((transaction) => 
        transaction.type.toLowerCase() == 'redeemed').toList();
    case 'expired':
      return allTransactions.where((transaction) => 
        transaction.type.toLowerCase() == 'expired').toList();
    case 'all':
    default:
      return allTransactions;
  }
});