import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

/// Add money confirmation screen
/// Shows the final confirmation before processing the wallet top-up
class AddMoneyConfirmationScreen extends ConsumerStatefulWidget {
  final String amount;
  final String paymentMethod;
  
  const AddMoneyConfirmationScreen({
    super.key,
    required this.amount,
    required this.paymentMethod,
  });

  @override
  ConsumerState<AddMoneyConfirmationScreen> createState() => _AddMoneyConfirmationScreenState();
}

class _AddMoneyConfirmationScreenState extends ConsumerState<AddMoneyConfirmationScreen> {
  bool isProcessing = false;
  
  // Payment method display info
  Map<String, Map<String, String>> get paymentMethodInfo => {
    'visa': {
      'title': 'Visa',
      'subtitle': '**** **** **** 1234',
      'icon': 'assets/images/icons/Payment_Methods/Visa.svg',
    },
    'mastercard': {
      'title': 'Mastercard',
      'subtitle': '**** **** **** 5678',
      'icon': 'assets/images/icons/Payment_Methods/Mastercard.svg',
    },
    'apple_pay': {
      'title': 'Apple Pay',
      'subtitle': 'Touch ID or Face ID',
      'icon': 'assets/images/icons/Payment_Methods/Apple_Pay.svg',
    },
    'google_pay': {
      'title': 'Google Pay',
      'subtitle': 'Fingerprint or PIN',
      'icon': 'assets/images/icons/Payment_Methods/Google_Pay.svg',
    },
  };

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
                    
                    // Amount confirmation card
                    _buildAmountCard(),
                    
                    const SizedBox(height: 32),
                    
                    // Transaction details
                    _buildTransactionDetails(),
                    
                    const SizedBox(height: 32),
                    
                    // Payment method confirmation
                    _buildPaymentMethodCard(),
                    
                    const SizedBox(height: 32),
                    
                    // Terms and conditions
                    _buildTermsSection(),
                    
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            
            // Confirm button
            _buildBottomSection(),
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
              'Add Wallet',
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

  Widget _buildAmountCard() {
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
          const Text(
            'Amount to Add',
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '+${widget.amount}',
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 32,
                  fontWeight: FontWeight.w600, // SemiBold
                  color: Color(0xFF2BE519), // indpt/Success/500
                  height: 48 / 32,
                ),
              ),
              
              const SizedBox(width: 8),
              
              SvgPicture.asset(
                'assets/images/icons/Payment_Methods/SAR.svg',
                width: 20,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF2BE519), // indpt/Success/500
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          const Text(
            'This amount will be added to your wallet',
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

  Widget _buildTransactionDetails() {
    final processingFee = (double.parse(widget.amount) * 0.025).toStringAsFixed(2); // 2.5% processing fee
    final total = (double.parse(widget.amount) + double.parse(processingFee)).toStringAsFixed(2);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Transaction Summary',
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
              _buildSummaryRow('Amount', widget.amount),
              _buildDivider(),
              _buildSummaryRow('Processing Fee', processingFee),
              _buildDivider(),
              _buildSummaryRow('Total', total, isTotal: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String amount, {bool isTotal = false}) {
    final textColor = isTotal 
        ? const Color(0xFFFEFEFF) // indpt/text primary
        : const Color(0xFF9C9C9D); // indpt/text tertiary
    
    final fontWeight = isTotal ? FontWeight.w600 : FontWeight.w400;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: fontWeight,
                color: textColor,
                height: 21 / 14,
              ),
            ),
          ),
          
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

  Widget _buildPaymentMethodCard() {
    final methodInfo = paymentMethodInfo[widget.paymentMethod]!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method',
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
              color: const Color(0xFFFFFBF1), // indpt/sand (selected)
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Payment method icon
              Container(
                width: 40,
                height: 40,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xFF4D4E52).withValues(alpha: 0.3),
                ),
                child: SvgPicture.asset(
                  methodInfo['icon']!,
                  fit: BoxFit.contain,
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Payment method details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      methodInfo['title']!,
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
                      methodInfo['subtitle']!,
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
              
              // Selected indicator
              Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFFFBF1), // indpt/sand
                ),
                child: const Center(
                  child: Icon(
                    Icons.check,
                    color: Color(0xFF242424), // indpt/accent
                    size: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTermsSection() {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: const Color(0xFFFFFBF1), // indpt/sand
                size: 16,
              ),
              
              const SizedBox(width: 8),
              
              const Text(
                'Important Information',
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
          
          const SizedBox(height: 12),
          
          const Text(
            '• This transaction is secure and encrypted\n'
            '• Funds will be added to your wallet immediately\n'
            '• A 2.5% processing fee applies to all top-ups\n'
            '• Refunds may take 3-5 business days',
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

  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A), // indpt/neutral
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(44),
              color: isProcessing
                  ? const Color(0xFF4D4E52) // indpt/stroke (disabled)
                  : const Color(0xFFFFFBF1), // indpt/sand
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isProcessing ? null : _processPayment,
                borderRadius: BorderRadius.circular(44),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: isProcessing
                      ? const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFF9C9C9D), // indpt/text tertiary
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Confirm & Add ${widget.amount}',
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 16,
                                fontWeight: FontWeight.w500, // Medium
                                color: Color(0xFF242424), // indpt/accent
                                height: 24 / 16,
                              ),
                            ),
                            
                            const SizedBox(width: 8),
                            
                            SvgPicture.asset(
                              'assets/images/icons/Payment_Methods/SAR.svg',
                              width: 12,
                              height: 14,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFF242424), // indpt/accent
                                BlendMode.srcIn,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> _processPayment() async {
    if (isProcessing) return;
    
    setState(() {
      isProcessing = true;
    });
    
    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      setState(() {
        isProcessing = false;
      });
      
      // Navigate back to wallet with success message
      context.go('/wallet', extra: {
        'showSuccess': true,
        'message': 'Successfully added ${widget.amount} SAR to your wallet',
      });
    }
  }
}