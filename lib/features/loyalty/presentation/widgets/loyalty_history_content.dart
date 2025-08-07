import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/loyalty_hub_provider.dart';
import 'loyalty_transaction_item.dart';

class LoyaltyHistoryContent extends ConsumerWidget {
  const LoyaltyHistoryContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(loyaltyLoadingProvider);
    final transactions = ref.watch(filteredLoyaltyTransactionsProvider);
    final selectedFilter = ref.watch(loyaltyHubProvider).selectedTransactionFilter;

    return Column(
      children: [
        // Filter chips
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _buildFilterChip(
                'All',
                selectedFilter == 'All',
                () => ref.read(loyaltyHubProvider.notifier).selectTransactionFilter('All'),
              ),
              const SizedBox(width: 4),
              _buildFilterChip(
                'Earned',
                selectedFilter == 'Earned',
                () => ref.read(loyaltyHubProvider.notifier).selectTransactionFilter('Earned'),
              ),
              const SizedBox(width: 4),
              _buildFilterChip(
                'Redeemed',
                selectedFilter == 'Redeemed',
                () => ref.read(loyaltyHubProvider.notifier).selectTransactionFilter('Redeemed'),
              ),
              const SizedBox(width: 4),
              _buildFilterChip(
                'Expired',
                selectedFilter == 'Expired',
                () => ref.read(loyaltyHubProvider.notifier).selectTransactionFilter('Expired'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Transaction list
        Expanded(
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFFFFBF1), // indpt/sand
                    strokeWidth: 2.0,
                  ),
                )
              : transactions.isEmpty
                  ? SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.history,
                                size: 64,
                                color: const Color(0xFF9C9C9D), // indpt/text tertiary
                              ),
                              const SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 32),
                                child: Text(
                                  _getEmptyMessage(selectedFilter),
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    height: 24 / 16,
                                    color: Color(0xFF9C9C9D), // indpt/text tertiary
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      backgroundColor: const Color(0xFF1A1A1A), // indpt/neutral
                      color: const Color(0xFFFFFBF1), // indpt/sand
                      onRefresh: () async {
                        return ref.read(loyaltyHubProvider.notifier).refreshMemberData();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: transactions.length,
                          padding: const EdgeInsets.only(bottom: 100), // Space for bottom navigation
                          itemBuilder: (context, index) {
                            final transaction = transactions[index];
                            return LoyaltyTransactionItem(transaction: transaction);
                          },
                        ),
                      ),
                    ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String title, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFFBF1) : Colors.transparent, // indpt/sand
          borderRadius: BorderRadius.circular(21),
          border: Border.all(
            color: isSelected 
                ? const Color(0xFFFFFBF1) // indpt/sand
                : const Color(0xFF9C9C9D), // indpt/text tertiary
            width: 1,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400, // Regular
            fontSize: 12,
            height: 18 / 12, // lineHeight / fontSize
            color: isSelected
                ? const Color(0xFF242424) // indpt/accent
                : const Color(0xFF9C9C9D), // indpt/text tertiary
          ),
        ),
      ),
    );
  }

  String _getEmptyMessage(String filter) {
    switch (filter.toLowerCase()) {
      case 'earned':
        return 'No earned points transactions yet.\nStart earning points by making purchases!';
      case 'redeemed':
        return 'No redeemed transactions yet.\nRedeem your points for rewards!';
      case 'expired':
        return 'No expired transactions.\nYour points are still active!';
      case 'all':
      default:
        return 'No transaction history available.\nYour loyalty activity will appear here.';
    }
  }
}