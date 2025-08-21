import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

/// Wallet transactions history screen
/// Shows detailed list of all wallet transactions with filtering options
class WalletTransactionsScreen extends ConsumerStatefulWidget {
  const WalletTransactionsScreen({super.key});

  @override
  ConsumerState<WalletTransactionsScreen> createState() => _WalletTransactionsScreenState();
}

class _WalletTransactionsScreenState extends ConsumerState<WalletTransactionsScreen> {
  String selectedFilter = 'All'; // All, Income, Expenses
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A), // indpt/neutral
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            
            // Filter chips
            _buildFilterChips(),
            
            // Transactions list
            Expanded(
              child: _buildTransactionsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Back button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFFEFEFF), // indpt/text primary
                width: 1,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => context.pop(),
                borderRadius: BorderRadius.circular(20),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Color(0xFFFEFEFF), // indpt/text primary
                  size: 16,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Title
          const Expanded(
            child: Text(
              'Transactions',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 24,
                fontWeight: FontWeight.w700, // Bold
                color: Color(0xFFFEFEFF), // indpt/text primary
                height: 32 / 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildFilterChip('All'),
          const SizedBox(width: 8),
          _buildFilterChip('Income'),
          const SizedBox(width: 8),
          _buildFilterChip('Expenses'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = selectedFilter == label;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isSelected 
            ? const Color(0xFFFFFBF1) // indpt/sand
            : Colors.transparent,
        border: Border.all(
          color: isSelected 
              ? const Color(0xFFFFFBF1) // indpt/sand
              : const Color(0xFF4D4E52), // indpt/stroke
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              selectedFilter = label;
            });
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 12,
                fontWeight: FontWeight.w500, // Medium
                color: isSelected 
                    ? const Color(0xFF242424) // indpt/accent
                    : const Color(0xCCFEFEFF), // indpt/text secondary
                height: 18 / 12,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionsList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 16),
        
        // Today section
        _buildDateHeader('Today'),
        const SizedBox(height: 12),
        
        _buildTransactionItem(
          title: 'Team Lunch',
          subtitle: 'Payment to Restaurant',
          amount: '-125',
          time: '2:30 PM',
          isPayment: true,
          onTap: () => context.push('/wallet/transaction-details', extra: 'team-lunch'),
        ),
        
        const SizedBox(height: 12),
        
        _buildTransactionItem(
          title: 'Coffee Break',
          subtitle: 'Payment to Joe & Juice',
          amount: '-25',
          time: '10:15 AM',
          isPayment: true,
          onTap: () => context.push('/wallet/transaction-details', extra: 'coffee-break'),
        ),
        
        const SizedBox(height: 24),
        
        // Yesterday section
        _buildDateHeader('Yesterday'),
        const SizedBox(height: 12),
        
        _buildTransactionItem(
          title: 'Wallet Top-up',
          subtitle: 'Added via Credit Card',
          amount: '+500',
          time: '6:45 PM',
          isPayment: false,
          onTap: () => context.push('/wallet/transaction-details', extra: 'wallet-topup'),
        ),
        
        const SizedBox(height: 12),
        
        _buildTransactionItem(
          title: 'Dinner Payment',
          subtitle: 'Payment to Salt Restaurant',
          amount: '-85',
          time: '8:20 PM',
          isPayment: true,
          onTap: () => context.push('/wallet/transaction-details', extra: 'dinner-payment'),
        ),
        
        const SizedBox(height: 24),
        
        // This Week section
        _buildDateHeader('This Week'),
        const SizedBox(height: 12),
        
        _buildTransactionItem(
          title: 'Cashback Reward',
          subtitle: 'From Loyalty Program',
          amount: '+15',
          time: 'Mon, 3:20 PM',
          isPayment: false,
          onTap: () => context.push('/wallet/transaction-details', extra: 'cashback'),
        ),
        
        const SizedBox(height: 12),
        
        _buildTransactionItem(
          title: 'Quick Bite',
          subtitle: 'Payment to Food Court',
          amount: '-42',
          time: 'Sun, 1:10 PM',
          isPayment: true,
          onTap: () => context.push('/wallet/transaction-details', extra: 'quick-bite'),
        ),
        
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildDateHeader(String date) {
    return Text(
      date,
      style: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 16,
        fontWeight: FontWeight.w500, // Medium
        color: Color(0xFFFEFEFF), // indpt/text primary
        height: 24 / 16,
      ),
    );
  }

  Widget _buildTransactionItem({
    required String title,
    required String subtitle,
    required String amount,
    required String time,
    required bool isPayment,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFF2A2A2A),
        border: Border.all(
          color: const Color(0xFF4D4E52), // indpt/stroke
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Transaction icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isPayment 
                        ? const Color(0xFFFF2323).withValues(alpha: 0.1) // Error with opacity
                        : const Color(0xFF2BE519).withValues(alpha: 0.1), // Success with opacity
                  ),
                  child: Icon(
                    isPayment ? Icons.arrow_outward : Icons.arrow_downward,
                    color: isPayment 
                        ? const Color(0xFFFF2323) // indpt/Error/500
                        : const Color(0xFF2BE519), // indpt/Success/500
                    size: 20,
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Transaction details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w500, // Medium
                          color: Color(0xFFFEFEFF), // indpt/text primary
                          height: 21 / 14,
                        ),
                      ),
                      
                      const SizedBox(height: 2),
                      
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF9C9C9D), // indpt/text tertiary
                          height: 18 / 12,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Amount and time
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          amount,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            fontWeight: FontWeight.w500, // Medium
                            color: isPayment 
                                ? const Color(0xFFFF2323) // indpt/Error/500
                                : const Color(0xFF2BE519), // indpt/Success/500
                            height: 21 / 14,
                          ),
                        ),
                        
                        const SizedBox(width: 4),
                        
                        SvgPicture.asset(
                          'assets/images/icons/Payment_Methods/SAR.svg',
                          width: 10,
                          height: 12,
                          colorFilter: ColorFilter.mode(
                            isPayment 
                                ? const Color(0xFFFF2323) // indpt/Error/500
                                : const Color(0xFF2BE519), // indpt/Success/500
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 2),
                    
                    Text(
                      time,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF9C9C9D), // indpt/text tertiary
                        height: 15 / 10,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(width: 8),
                
                // Arrow icon
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFF9C9C9D), // indpt/text tertiary
                  size: 12,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}