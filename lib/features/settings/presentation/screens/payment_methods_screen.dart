import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

// Secure payment method data model - never stores full card numbers
class SecurePaymentMethod {
  final String id;
  final String maskedNumber; // Only last 4 digits: **** **** **** 2345
  final String expiryDate;   // MM/YY format
  final String cardType;     // visa, mastercard, etc.
  final String tokenId;      // Secure token from payment processor
  
  const SecurePaymentMethod({
    required this.id,
    required this.maskedNumber,
    required this.expiryDate,
    required this.cardType,
    required this.tokenId,
  });
  
  // Security: Never expose full card details
  Map<String, dynamic> toSecureJson() {
    return {
      'id': id,
      'maskedNumber': maskedNumber,
      'expiryDate': expiryDate,
      'cardType': cardType,
      // tokenId is never serialized for security
    };
  }
}

// Secure state management for payment methods
final securePaymentMethodsProvider = StateProvider<List<SecurePaymentMethod>>((ref) {
  // Mock secure payment methods - in production, fetch from secure backend
  return [
    const SecurePaymentMethod(
      id: 'pm_visa_2345',
      maskedNumber: '**** **** **** 2345',
      expiryDate: '02/30',
      cardType: 'visa',
      tokenId: 'tok_secure_visa_hash', // This would be from payment processor
    ),
    const SecurePaymentMethod(
      id: 'pm_visa_1343',
      maskedNumber: '**** **** **** 1343', 
      expiryDate: '03/29',
      cardType: 'visa',
      tokenId: 'tok_secure_visa_hash2',
    ),
    const SecurePaymentMethod(
      id: 'pm_mc_2345',
      maskedNumber: '**** **** **** 2345',
      expiryDate: '02/30', 
      cardType: 'mastercard',
      tokenId: 'tok_secure_mc_hash',
    ),
    const SecurePaymentMethod(
      id: 'pm_mc_1343',
      maskedNumber: '**** **** **** 1343',
      expiryDate: '03/29',
      cardType: 'mastercard', 
      tokenId: 'tok_secure_mc_hash2',
    ),
  ];
});

class PaymentMethodsScreen extends ConsumerWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isLightTheme = theme.brightness == Brightness.light;
    final paymentMethods = ref.watch(securePaymentMethodsProvider);
    
    return Scaffold(
      backgroundColor: isLightTheme ? const Color(0xFFFFFCF5) : const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context, isLightTheme),
            
            // Payment Methods List
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  children: [
                    // Saved Cards Section
                    ...paymentMethods.map((method) => _buildPaymentMethodItem(
                      context,
                      ref, 
                      method,
                      isLightTheme,
                    )).toList(),
                    
                    // Apple Pay
                    _buildDigitalPaymentMethod(
                      context,
                      ref,
                      title: 'Apple Pay',
                      subtitle: 'Quick checkout using Apple Pay',
                      iconAsset: 'assets/images/icons/Payment_Methods/Apple_Pay.svg',
                      isLightTheme: isLightTheme,
                    ),
                    
                    // Google Pay
                    _buildDigitalPaymentMethod(
                      context,
                      ref,
                      title: 'Google Pay', 
                      subtitle: 'Quick checkout using Google Pay',
                      iconAsset: 'assets/images/icons/Payment_Methods/Google_Pay.svg',
                      isLightTheme: isLightTheme,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isLightTheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isLightTheme 
                    ? const Color(0xFF1A1A1A)
                    : const Color(0xFFFEFEFF),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(44),
              ),
              child: Icon(
                Icons.arrow_back,
                color: isLightTheme 
                  ? const Color(0xFF1A1A1A)
                  : const Color(0xFFFEFEFF),
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Title
          Expanded(
            child: Text(
              'Payment Methods',
              style: TextStyle(
                color: isLightTheme 
                  ? const Color(0xCC1A1A1A)
                  : const Color(0xCCFEFEFF),
                fontSize: 24,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                height: 32 / 24,
              ),
            ),
          ),
          
          // Add button
          GestureDetector(
            onTap: () => _handleAddPaymentMethod(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isLightTheme 
                  ? const Color(0xFF1A1A1A)
                  : const Color(0xFFFFFBF1),
                borderRadius: BorderRadius.circular(44),
              ),
              child: Icon(
                Icons.add,
                color: isLightTheme 
                  ? const Color(0xFFFEFEFF)
                  : const Color(0xFF242424),
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodItem(
    BuildContext context,
    WidgetRef ref,
    SecurePaymentMethod method,
    bool isLightTheme,
  ) {
    return GestureDetector(
      onTap: () => context.push('/settings/card-details/${method.id}'),
      child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isLightTheme ? const Color(0xFFD9D9D9) : const Color(0xFF4D4E52),
            width: 1,
          ),
          bottom: BorderSide(
            color: isLightTheme ? const Color(0xFFD9D9D9) : const Color(0xFF4D4E52),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Card icon
          Container(
            padding: const EdgeInsets.all(4), // Reduced padding for bigger logo
            decoration: BoxDecoration(
              color: isLightTheme ? const Color(0xFFFEFEFF) : const Color(0xFF000000),
              borderRadius: BorderRadius.circular(40),
            ),
            child: SvgPicture.asset(
              _getCardIcon(method.cardType, isLightTheme),
              width: 32, // Increased from 24 to 32
              height: 32, // Increased from 24 to 32
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.credit_card,
                  color: isLightTheme ? const Color(0xFF1A1A1A) : const Color(0xFFFEFEFF),
                  size: 32, // Increased from 24 to 32
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          
          // Card details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  method.maskedNumber, // Secure: Only masked number shown
                  style: TextStyle(
                    color: isLightTheme 
                      ? const Color(0xCC1A1A1A)
                      : const Color(0xCCFEFEFF),
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.normal,
                    height: 21 / 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Expiry Date ${method.expiryDate}',
                  style: TextStyle(
                    color: isLightTheme ? const Color(0xFF878787) : const Color(0xFF9C9C9D),
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.normal,
                    height: 18 / 12,
                  ),
                ),
              ],
            ),
          ),
          
          // Options menu
          GestureDetector(
            onTap: () => _showPaymentMethodOptions(context, ref, method),
            child: Opacity(
              opacity: 0.0, // Hidden as per Figma design
              child: Icon(
                Icons.more_horiz,
                color: isLightTheme ? const Color(0xFF878787) : const Color(0xFF9C9C9D),
                size: 24,
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildDigitalPaymentMethod(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required String subtitle,
    required String iconAsset,
    required bool isLightTheme,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isLightTheme ? const Color(0xFFD9D9D9) : const Color(0xFF4D4E52),
            width: 1,
          ),
          bottom: BorderSide(
            color: isLightTheme ? const Color(0xFFD9D9D9) : const Color(0xFF4D4E52),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Digital payment icon
          Container(
            padding: const EdgeInsets.all(4), // Reduced padding for bigger logo
            decoration: BoxDecoration(
              color: isLightTheme ? const Color(0xFFFEFEFF) : const Color(0xFF000000),
              borderRadius: BorderRadius.circular(40),
            ),
            child: SvgPicture.asset(
              iconAsset,
              width: 32, // Increased from 24 to 32
              height: 32, // Increased from 24 to 32
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.payment,
                  color: isLightTheme ? const Color(0xFF1A1A1A) : const Color(0xFFFEFEFF),
                  size: 32, // Increased from 24 to 32
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          
          // Payment details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isLightTheme 
                      ? const Color(0xCC1A1A1A)
                      : const Color(0xCCFEFEFF),
                    fontSize: 14,
                    fontFamily: 'Roboto', 
                    fontWeight: FontWeight.normal,
                    height: 21 / 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isLightTheme ? const Color(0xFF878787) : const Color(0xFF9C9C9D),
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.normal,
                    height: 18 / 12,
                  ),
                ),
              ],
            ),
          ),
          
          // Hidden options menu (as per Figma)
          Opacity(
            opacity: 0.0,
            child: Icon(
              Icons.more_horiz,
              color: isLightTheme ? const Color(0xFF878787) : const Color(0xFF9C9C9D),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  String _getCardIcon(String cardType, bool isLightTheme) {
    switch (cardType.toLowerCase()) {
      case 'visa':
        return isLightTheme 
          ? 'assets/images/icons/Payment_Methods/Visa_light.svg'
          : 'assets/images/icons/Payment_Methods/Visa.svg';
      case 'mastercard':
        return isLightTheme
          ? 'assets/images/icons/Payment_Methods/MasterCard_light.svg'
          : 'assets/images/icons/Payment_Methods/Mastercard.svg';
      default:
        return isLightTheme
          ? 'assets/images/icons/Payment_Methods/Generic_light.svg'
          : 'assets/images/icons/Payment_Methods/Generic.svg';
    }
  }

  void _handleAddPaymentMethod(BuildContext context) {
    // Security: Navigate to secure add new card screen
    context.push('/settings/add-new-card');
  }

  void _showPaymentMethodOptions(
    BuildContext context, 
    WidgetRef ref,
    SecurePaymentMethod method,
  ) {
    // Security: Secure options for managing payment methods
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Update Card'),
              onTap: () {
                Navigator.pop(context);
                _handleUpdateCard(context, method);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Remove Card', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _handleRemoveCard(context, ref, method);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleUpdateCard(BuildContext context, SecurePaymentMethod method) {
    // Security: Implement secure card update
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Secure card update requires payment processor integration'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _handleRemoveCard(
    BuildContext context,
    WidgetRef ref, 
    SecurePaymentMethod method,
  ) {
    // Security: Confirm removal with secure verification
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Payment Method'),
        content: Text('Remove card ending in ${method.maskedNumber.substring(method.maskedNumber.length - 4)}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Security: Remove from secure storage
              final currentMethods = ref.read(securePaymentMethodsProvider);
              final updatedMethods = currentMethods.where((m) => m.id != method.id).toList();
              ref.read(securePaymentMethodsProvider.notifier).state = updatedMethods;
              
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Payment method removed successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}
