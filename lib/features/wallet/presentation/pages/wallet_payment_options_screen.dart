import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class WalletPaymentOptionsScreen extends ConsumerStatefulWidget {
  const WalletPaymentOptionsScreen({super.key});

  @override
  ConsumerState<WalletPaymentOptionsScreen> createState() => _WalletPaymentOptionsScreenState();
}

class _WalletPaymentOptionsScreenState extends ConsumerState<WalletPaymentOptionsScreen> {
  String? _selectedPaymentMethod;

  final List<PaymentOption> _paymentOptions = [
    PaymentOption(
      id: 'visa_4242',
      icon: 'assets/images/icons/Payment_Methods/Visa.svg',
      title: 'Visa Ending in 4242',
      subtitle: 'Expires 08/26',
    ),
    PaymentOption(
      id: 'mastercard_1837',
      icon: 'assets/images/icons/Payment_Methods/Mastercard.svg',
      title: 'Mastercard Ending in 1837',
      subtitle: 'Expires 02/27',
    ),
    PaymentOption(
      id: 'apple_pay',
      icon: 'assets/images/icons/Payment_Methods/Apple_Pay.svg',
      title: 'Apple Pay',
      subtitle: 'Quick checkout using Apple Pay',
    ),
    PaymentOption(
      id: 'google_pay',
      icon: 'assets/images/icons/Payment_Methods/Google_Pay.svg',
      title: 'Google Pay',
      subtitle: 'Quick checkout using Google Pay',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: _buildHeader(context),
          ),
          Expanded(
            child: _buildPaymentOptionsList(),
          ),
          _buildBottomButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          _circleButton(
            onTap: () => context.pop(),
            border: true,
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 16,
              color: Color(0xFFFEFEFF),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Payment Options',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFFFEFEFF),
                height: 32 / 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleButton({
    required VoidCallback onTap,
    required Widget child,
    bool border = false,
    Color? fill,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: fill ?? Colors.transparent,
        border: border
            ? Border.all(color: const Color(0xFFFEFEFF), width: 1)
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Center(child: child),
        ),
      ),
    );
  }

  Widget _buildPaymentOptionsList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      itemCount: _paymentOptions.length,
      itemBuilder: (context, index) {
        final option = _paymentOptions[index];
        final isSelected = _selectedPaymentMethod == option.id;
        final isFirst = index == 0;
        
        return Column(
          children: [
            // Top border for first item
            if (isFirst)
              Container(
                height: 1,
                color: const Color(0xFF454545),
                margin: const EdgeInsets.only(bottom: 8),
              ),
            _buildPaymentOptionItem(option, isSelected),
            // Bottom border for all items
            Container(
              height: 1,
              color: const Color(0xFF454545),
              margin: const EdgeInsets.only(top: 4, bottom: 4),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPaymentOptionItem(PaymentOption option, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentMethod = option.id),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Row(
          children: [
            // Payment method icon
            Container(
              padding: const EdgeInsets.all(4),
              child: SvgPicture.asset(
                option.icon,
                width: 52,
                height: 52,
                // Remove colorFilter to preserve original SVG colors
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    _getIconForPaymentMethod(option.id),
                    color: const Color(0xFFFEFEFF),
                    size: 52,
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            
            // Payment method details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFEFEFF),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    option.subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xCCFEFEFF),
                    ),
                  ),
                ],
              ),
            ),
            
            // Selection radio button
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFFFFFBF1) : const Color(0xFF9C9C9D),
                  width: 2,
                ),
                color: Colors.transparent,
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFFFBF1),
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForPaymentMethod(String paymentId) {
    switch (paymentId) {
      case 'visa_4242':
      case 'mastercard_1837':
        return Icons.credit_card;
      case 'apple_pay':
        return Icons.apple;
      case 'google_pay':
        return Icons.account_balance_wallet;
      default:
        return Icons.payment;
    }
  }

  Widget _buildBottomButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 12, 24, 28 + MediaQuery.of(context).padding.bottom),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _selectedPaymentMethod != null 
                ? const Color(0xFFFFFBF1) 
                : const Color(0xFF454545),
            foregroundColor: _selectedPaymentMethod != null 
                ? const Color(0xFF242424) 
                : const Color(0xFF9C9C9D),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            padding: const EdgeInsets.symmetric(vertical: 18),
            elevation: 0,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          onPressed: _selectedPaymentMethod != null 
              ? () {
                  // TODO: Implement payment confirmation logic
                  context.pop();
                }
              : null,
          child: const Text('Confirm Payment'),
        ),
      ),
    );
  }
}

class PaymentOption {
  final String id;
  final String icon;
  final String title;
  final String subtitle;

  PaymentOption({
    required this.id,
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}