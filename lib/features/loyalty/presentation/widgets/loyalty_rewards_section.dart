import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'loyalty_reward_item.dart';
import 'loyalty_scan_content.dart';
import 'loyalty_transaction_item.dart';
import '../providers/loyalty_hub_provider.dart';
import '../../data/models/loyalty_member.dart';

class LoyaltyRewardsSection extends ConsumerWidget {
  const LoyaltyRewardsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(loyaltySelectedTabProvider);
    final rewards = ref.watch(loyaltyRewardsProvider);
    final transactions = ref.watch(loyaltyTransactionsProvider);
    
    // Show different content based on selected tab
    switch (selectedTab) {
      case 'Scan':
        return const LoyaltyScanContent();
      case 'History':
        return _buildHistoryContent(transactions);
      case 'Discover':
      default:
        return _buildDiscoverContent(rewards);
    }
  }

  Widget _buildDiscoverContent(List<LoyaltyReward> rewards) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            width: double.infinity,
            child: const Text(
              'Rewards',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500, // Medium
                fontSize: 18,
                height: 27 / 18, // lineHeight / fontSize
                color: Color(0xCCFEFEFF), // indpt/text secondary
              ),
            ),
          ),
          // Reward items from provider - show available rewards
          ...rewards.where((reward) => !reward.isRedeemed).map((reward) => LoyaltyRewardItem(
            title: reward.title,
            expiryDate: reward.expiryDate,
            foodImagePath: reward.foodImageUrl,
            brandLogoPath: reward.brandLogoUrl,
          )),
        ],
      ),
    );
  }

  Widget _buildHistoryContent(List<LoyaltyTransaction> transactions) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            width: double.infinity,
            child: const Text(
              'Transaction History',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500, // Medium
                fontSize: 18,
                height: 27 / 18, // lineHeight / fontSize
                color: Color(0xCCFEFEFF), // indpt/text secondary
              ),
            ),
          ),
          // Show transaction history
          if (transactions.isNotEmpty)
            ...transactions.map((transaction) => LoyaltyTransactionItem(
              transaction: transaction,
            ))
          else
            Container(
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              child: const Text(
                'No transaction history available',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  height: 21 / 14,
                  color: Color(0xCCFEFEFF), // indpt/text secondary
                ),
              ),
            ),
        ],
      ),
    );
  }
}