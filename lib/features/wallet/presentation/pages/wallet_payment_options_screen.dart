import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class WalletPaymentOptionsScreen extends ConsumerStatefulWidget {
  const WalletPaymentOptionsScreen({super.key});

  @override
  ConsumerState<WalletPaymentOptionsScreen> createState() =>
      _WalletPaymentOptionsScreenState();
}

class _WalletPaymentOptionsScreenState
    extends ConsumerState<WalletPaymentOptionsScreen> {
  String? _selectedPaymentMethod;

  List<PaymentOption> get _paymentOptions {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return [
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
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDarkMode
          ? const Color(0xFF1A1A1A)
          : AppColors.lightBackground,
      body: Column(
        children: [
          SafeArea(bottom: false, child: _buildHeader(context, isDarkMode)),
          Expanded(child: _buildPaymentOptionsList(isDarkMode)),
          _buildBottomButton(context, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          _circleButton(
            onTap: () => context.pop(),
            border: true,
            isDarkMode: isDarkMode,
            child: Icon(
              Icons.arrow_back_ios_new,
              size: 16,
              color: isDarkMode
                  ? const Color(0xFFFEFEFF)
                  : AppColors.lightOnSurface,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Payment Options',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: isDarkMode
                    ? const Color(0xFFFEFEFF)
                    : AppColors.lightOnSurface,
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
    bool isDarkMode = true,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: fill ?? Colors.transparent,
        border: border
            ? Border.all(
                color: isDarkMode
                    ? const Color(0xFFFEFEFF)
                    : AppColors.lightOnSurface,
                width: 1,
              )
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

  Widget _buildPaymentOptionsList(bool isDarkMode) {
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
                color: isDarkMode
                    ? const Color(0xFF454545)
                    : AppColors.lightOutline,
                margin: const EdgeInsets.only(bottom: 8),
              ),
            _buildPaymentOptionItem(option, isSelected, isDarkMode),
            // Bottom border for all items
            Container(
              height: 1,
              color: isDarkMode
                  ? const Color(0xFF454545)
                  : AppColors.lightOutline,
              margin: const EdgeInsets.only(top: 4, bottom: 4),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPaymentOptionItem(PaymentOption option, bool isSelected, bool isDarkMode) {
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
                    color: isDarkMode
                        ? const Color(0xFFFEFEFF)
                        : AppColors.lightOnSurface,
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
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode
                          ? const Color(0xFFFEFEFF)
                          : AppColors.lightOnSurface,
                      height: 24 / 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    option.subtitle,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      color: isDarkMode
                          ? const Color(0xCCFEFEFF)
                          : AppColors.lightOnSurfaceVariant,
                      height: 21 / 14,
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
                  color: isSelected
                      ? (isDarkMode
                            ? const Color(0xFFFFFBF1)
                            : AppColors.lightOnSurface)
                      : (isDarkMode
                            ? const Color(0xFF9C9C9D)
                            : AppColors.lightOutline),
                  width: 2,
                ),
                color: Colors.transparent,
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDarkMode
                              ? const Color(0xFFFFFBF1)
                              : AppColors.lightOnSurface,
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

  Widget _buildBottomButton(BuildContext context, bool isDarkMode) {
    final canProceed = _selectedPaymentMethod != null;
    
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        12,
        24,
        MediaQuery.of(context).padding.bottom,
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: canProceed
                ? (isDarkMode
                      ? const Color(0xFFFFFBF1)
                      : const Color(0xFF1A1A1A))
                : (isDarkMode
                      ? const Color(0xFF454545)
                      : const Color(0xFF454545)),
            foregroundColor: canProceed
                ? (isDarkMode
                      ? const Color(0xFF242424)
                      : const Color(0xFFFEFEFF))
                : (isDarkMode
                      ? const Color(0xFF9C9C9D)
                      : const Color(0xFF9C9C9D)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            padding: const EdgeInsets.symmetric(vertical: 18),
            elevation: 0,
            textStyle: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              height: 24 / 16,
            ),
          ),
          onPressed: canProceed
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
