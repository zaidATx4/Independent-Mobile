import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

/// Transaction detail screen
/// Shows detailed information about a specific transaction
class TransactionDetailScreen extends ConsumerStatefulWidget {
  final String transactionId;
  
  const TransactionDetailScreen({
    super.key,
    required this.transactionId,
  });

  @override
  ConsumerState<TransactionDetailScreen> createState() => _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends ConsumerState<TransactionDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A), // indpt/neutral
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    
                    // Transaction status and amount
                    _buildTransactionHeader(),
                    
                    const SizedBox(height: 32),
                    
                    // Transaction details
                    _buildTransactionDetails(),
                    
                    const SizedBox(height: 32),
                    
                    // Receipt information
                    _buildReceiptSection(),
                    
                    const SizedBox(height: 100),
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
          
          // Title
          const Expanded(
            child: Text(
              'Team Lunch',
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

  Widget _buildTransactionHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
          // Status icon
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF2BE519).withValues(alpha: 0.1), // Success with opacity
            ),
            child: const Icon(
              Icons.check,
              color: Color(0xFF2BE519), // indpt/Success/500
              size: 30,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Status text
          const Text(
            'Payment Successful',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              fontWeight: FontWeight.w500, // Medium
              color: Color(0xFF2BE519), // indpt/Success/500
              height: 24 / 16,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '-125',
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
          
          const SizedBox(height: 4),
          
          // Date and time
          const Text(
            'Today, 2:30 PM',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF9C9C9D), // indpt/text tertiary
              height: 21 / 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Transaction Details',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            fontWeight: FontWeight.w500, // Medium
            color: Color(0xFFFEFEFF), // indpt/text primary
            height: 24 / 16,
          ),
        ),
        
        const SizedBox(height: 16),
        
        Container(
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
            children: [
              _buildDetailRow('To', 'Salt Restaurant'),
              _buildDivider(),
              _buildDetailRow('From', 'My Wallet'),
              _buildDivider(),
              _buildDetailRow('Transaction ID', 'TXN123456789'),
              _buildDivider(),
              _buildDetailRow('Payment Method', 'Wallet Balance'),
              _buildDivider(),
              _buildDetailRow('Date', 'Dec 18, 2024 at 2:30 PM'),
              _buildDivider(),
              _buildDetailRow('Status', 'Completed', 
                  valueColor: const Color(0xFF2BE519)), // indpt/Success/500
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF9C9C9D), // indpt/text tertiary
                height: 21 / 14,
              ),
            ),
          ),
          
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w500, // Medium
                color: valueColor ?? const Color(0xFFFEFEFF), // indpt/text primary
                height: 21 / 14,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: const Color(0xFF4D4E52), // indpt/stroke
      margin: const EdgeInsets.symmetric(vertical: 4),
    );
  }

  Widget _buildReceiptSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Receipt',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            fontWeight: FontWeight.w500, // Medium
            color: Color(0xFFFEFEFF), // indpt/text primary
            height: 24 / 16,
          ),
        ),
        
        const SizedBox(height: 16),
        
        Container(
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
              // Restaurant info
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xFF4D4E52), // Placeholder for restaurant logo
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Salt Restaurant',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            fontWeight: FontWeight.w500, // Medium
                            color: Color(0xFFFEFEFF), // indpt/text primary
                            height: 21 / 14,
                          ),
                        ),
                        
                        SizedBox(height: 2),
                        
                        Text(
                          'Mall of the Emirates',
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
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              _buildDivider(),
              
              const SizedBox(height: 16),
              
              // Order items
              _buildReceiptItem('Chicken Burger', '1x', '45'),
              const SizedBox(height: 8),
              _buildReceiptItem('French Fries', '2x', '30'),
              const SizedBox(height: 8),
              _buildReceiptItem('Coca Cola', '2x', '20'),
              
              const SizedBox(height: 16),
              
              _buildDivider(),
              
              const SizedBox(height: 16),
              
              // Totals
              _buildReceiptItem('Subtotal', '', '95', isSubtotal: true),
              const SizedBox(height: 4),
              _buildReceiptItem('Service Fee', '', '15', isSubtotal: true),
              const SizedBox(height: 4),
              _buildReceiptItem('Tax', '', '15', isSubtotal: true),
              
              const SizedBox(height: 12),
              
              _buildDivider(),
              
              const SizedBox(height: 12),
              
              _buildReceiptItem('Total', '', '125', isTotal: true),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Action buttons
        Row(
          children: [
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
                    onTap: () {
                      // Download receipt functionality
                    },
                    borderRadius: BorderRadius.circular(44),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.download,
                            color: Color(0xFFFEFEFF), // indpt/text primary
                            size: 16,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Download',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              fontWeight: FontWeight.w500, // Medium
                              color: Color(0xFFFEFEFF), // indpt/text primary
                              height: 21 / 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: 12),
            
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
                    onTap: () {
                      // Share receipt functionality
                    },
                    borderRadius: BorderRadius.circular(44),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.share,
                            color: Color(0xFFFEFEFF), // indpt/text primary
                            size: 16,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Share',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              fontWeight: FontWeight.w500, // Medium
                              color: Color(0xFFFEFEFF), // indpt/text primary
                              height: 21 / 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReceiptItem(String name, String quantity, String amount, {
    bool isSubtotal = false, 
    bool isTotal = false
  }) {
    final textColor = isTotal 
        ? const Color(0xFFFEFEFF) // indpt/text primary
        : isSubtotal 
            ? const Color(0xFF9C9C9D) // indpt/text tertiary
            : const Color(0xFFFEFEFF); // indpt/text primary
    
    final fontWeight = isTotal ? FontWeight.w600 : FontWeight.w400;
    
    return Row(
      children: [
        Expanded(
          child: Text(
            name,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              fontWeight: fontWeight,
              color: textColor,
              height: 21 / 14,
            ),
          ),
        ),
        
        if (quantity.isNotEmpty) ...[
          Text(
            quantity,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              fontWeight: fontWeight,
              color: textColor,
              height: 21 / 14,
            ),
          ),
          const SizedBox(width: 16),
        ],
        
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              amount,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: fontWeight,
                color: textColor,
                height: 21 / 14,
              ),
            ),
            
            const SizedBox(width: 4),
            
            SvgPicture.asset(
              'assets/images/icons/Payment_Methods/SAR.svg',
              width: 10,
              height: 12,
              colorFilter: ColorFilter.mode(
                textColor,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ],
    );
  }
}