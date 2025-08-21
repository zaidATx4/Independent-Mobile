import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

/// Individual wallet details screen - shows specific wallet details
/// Displays wallet balance, QR code, and transaction history for a specific wallet
class MyWalletScreen extends ConsumerStatefulWidget {
  final String walletId;
  
  const MyWalletScreen({
    super.key,
    required this.walletId,
  });

  @override
  ConsumerState<MyWalletScreen> createState() => _MyWalletScreenState();
}

class _MyWalletScreenState extends ConsumerState<MyWalletScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A), // indpt/neutral
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and title
            _buildHeader(context),
            
            // Main content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    
                    // Balance cards section
                    _buildBalanceCards(),
                    
                    const SizedBox(height: 32),
                    
                    // QR Code section
                    _buildQRCodeSection(),
                    
                    const SizedBox(height: 32),
                    
                    // Action buttons
                    _buildActionButtons(),
                    
                    const SizedBox(height: 32),
                    
                    // Recent transactions
                    _buildRecentTransactionsSection(),
                    
                    const SizedBox(height: 100), // Bottom padding
                  ],
                ),
              ),
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
          
          // Title with dynamic wallet info
          Expanded(
            child: Text(
              'Team Lunch Wallet', // This should be dynamic based on walletId in production
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 24,
                fontWeight: FontWeight.w700, // Bold
                color: Color(0xFFFEFEFF), // indpt/text primary
                height: 32 / 24, // lineHeight
              ),
            ),
          ),
          
          // Menu dots
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
                onTap: () => context.push('/wallet/manage'),
                borderRadius: BorderRadius.circular(20),
                child: SvgPicture.asset(
                  'assets/images/icons/SVGs/3_Dots.svg',
                  width: 16,
                  height: 16,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFFFEFEFF), // indpt/text primary
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCards() {
    return Column(
      children: [
        // Main balance card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF2A2A2A),
                Color(0xFF1A1A1A),
              ],
            ),
            border: Border.all(
              color: const Color(0xFF4D4E52), // indpt/stroke
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total Balance',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xCCFEFEFF), // indpt/text secondary
                  height: 21 / 14,
                ),
              ),
              
              const SizedBox(height: 8),
              
              Row(
                children: [
                  const Text(
                    '4,550',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 32,
                      fontWeight: FontWeight.w600, // SemiBold
                      color: Color(0xFFFEFEFF), // indpt/text primary
                      height: 48 / 32,
                    ),
                  ),
                  
                  const SizedBox(width: 8),
                  
                  SvgPicture.asset(
                    'assets/images/icons/Payment_Methods/SAR.svg',
                    width: 20,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFFFEFEFF), // indpt/text primary
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Secondary balance cards
        Row(
          children: [
            // Gift card balance
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFF2A2A2A),
                  border: Border.all(
                    color: const Color(0xFF4D4E52), // indpt/stroke
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Gift Cards',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xCCFEFEFF), // indpt/text secondary
                        height: 18 / 12,
                      ),
                    ),
                    
                    const SizedBox(height: 4),
                    
                    Row(
                      children: [
                        const Text(
                          '1,105',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFFEFEFF), // indpt/text primary
                            height: 30 / 20,
                          ),
                        ),
                        
                        const SizedBox(width: 4),
                        
                        SvgPicture.asset(
                          'assets/images/icons/Payment_Methods/SAR.svg',
                          width: 12,
                          height: 14,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFFFEFEFF), // indpt/text primary
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Loyalty points
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFF2A2A2A),
                  border: Border.all(
                    color: const Color(0xFF4D4E52), // indpt/stroke
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Loyalty',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xCCFEFEFF), // indpt/text secondary
                        height: 18 / 12,
                      ),
                    ),
                    
                    const SizedBox(height: 4),
                    
                    Row(
                      children: [
                        const Text(
                          '300',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFFEFEFF), // indpt/text primary
                            height: 30 / 20,
                          ),
                        ),
                        
                        const SizedBox(width: 4),
                        
                        const Text(
                          'Pts',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xCCFEFEFF), // indpt/text secondary
                            height: 18 / 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQRCodeSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFF2A2A2A),
        border: Border.all(
          color: const Color(0xFF4D4E52), // indpt/stroke
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // QR Code image
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFFFEFEFF), // White background for QR
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: SvgPicture.asset(
                'assets/images/Static/qr_code.svg',
                fit: BoxFit.contain,
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          const Text(
            'Scan this QR code to pay or send money.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xCCFEFEFF), // indpt/text secondary
              height: 21 / 14,
            ),
          ),
          
          const SizedBox(height: 8),
          
          const Text(
            'Share download',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFF9C9C9D), // indpt/text tertiary
              height: 18 / 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        // Transactions button
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(44),
              border: Border.all(
                color: const Color(0xFFFEFEFF), // indpt/text primary
                width: 1,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => context.push('/wallet/transactions'),
                borderRadius: BorderRadius.circular(44),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'Transactions',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w500, // Medium
                      color: Color(0xFFFEFEFF), // indpt/text primary
                      height: 24 / 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        
        const SizedBox(width: 12),
        
        // Add Money button
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(44),
              color: const Color(0xFFFFFBF1), // indpt/sand
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => context.push('/wallet/add-money'),
                borderRadius: BorderRadius.circular(44),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'Add Money',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w500, // Medium
                      color: Color(0xFF242424), // indpt/accent
                      height: 24 / 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTransactionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Transactions',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            fontWeight: FontWeight.w500, // Medium
            color: Color(0xFFFEFEFF), // indpt/text primary
            height: 24 / 16,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Mock transaction items
        _buildTransactionItem(
          title: 'Team Lunch',
          subtitle: 'Payment to Restaurant',
          amount: '-125',
          time: '2h ago',
          isPayment: true,
        ),
        
        const SizedBox(height: 12),
        
        _buildTransactionItem(
          title: 'Wallet Top-up',
          subtitle: 'Added via Credit Card',
          amount: '+500',
          time: '1 day ago',
          isPayment: false,
        ),
        
        const SizedBox(height: 12),
        
        _buildTransactionItem(
          title: 'Coffee Break',
          subtitle: 'Payment to Joe & Juice',
          amount: '-25',
          time: '2 days ago',
          isPayment: true,
        ),
      ],
    );
  }

  Widget _buildTransactionItem({
    required String title,
    required String subtitle,
    required String amount,
    required String time,
    required bool isPayment,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFF2A2A2A),
        border: Border.all(
          color: const Color(0xFF4D4E52), // indpt/stroke
          width: 1,
        ),
      ),
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
        ],
      ),
    );
  }
}