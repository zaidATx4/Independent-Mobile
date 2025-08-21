import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../providers/checkout_providers.dart';
import '../../domain/entities/checkout_entities.dart';
import '../../../../../core/theme/app_colors.dart';

enum PaymentMethod {
  visa,
  mastercard,
  wallet,
  applePay,
  googlePay,
  cashOnPickup,
  addNewCard,
}

final selectedPaymentMethodProvider = StateProvider<PaymentMethod?>(
  (ref) => null,
);

class PaymentMethodScreen extends ConsumerWidget {
  final double total;
  final String currency;

  const PaymentMethodScreen({
    super.key,
    required this.total,
    this.currency = 'SAR',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMethod = ref.watch(selectedPaymentMethodProvider);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? const Color(0xFF1A1A1A)
          : AppColors.lightBackground,
      body: Column(
        children: [
          // Header with SafeArea
          SafeArea(child: _buildHeader(context, isDarkMode)),

          // Payment amount
          _buildPaymentAmount(isDarkMode),

          // Payment options list
          Expanded(
            child: _buildPaymentOptions(
              context,
              ref,
              selectedMethod,
              isDarkMode,
            ),
          ),

          // Continue button
          _buildContinueButton(context, ref, selectedMethod, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDarkMode) {
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
                  color: isDarkMode
                      ? const Color(0xFFFEFEFF)
                      : AppColors.lightOnSurface,
                ),
                borderRadius: BorderRadius.circular(44),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: isDarkMode
                    ? const Color(0xFFFEFEFF)
                    : AppColors.lightOnSurface,
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Title
          Expanded(
            child: Text(
              'Payment Options',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDarkMode
                    ? const Color(0xCCFEFEFF)
                    : AppColors.lightOnSurface,
                height: 32 / 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentAmount(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'To Pay :',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDarkMode
                  ? const Color(0xFFFEFEFF)
                  : AppColors.lightOnSurface,
              height: 32 / 24,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            total.toInt().toString(),
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDarkMode
                  ? const Color(0xFFFEFEFF)
                  : AppColors.lightOnSurface,
              height: 32 / 24,
            ),
          ),
          const SizedBox(width: 4),
          SvgPicture.asset(
            'assets/images/icons/Payment_Methods/SAR.svg',
            width: 14,
            height: 16,
            colorFilter: ColorFilter.mode(
              isDarkMode ? const Color(0xFFFEFEFF) : AppColors.lightOnSurface,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOptions(
    BuildContext context,
    WidgetRef ref,
    PaymentMethod? selectedMethod,
    bool isDarkMode,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Visa card
          _buildPaymentOption(
            context: context,
            ref: ref,
            method: PaymentMethod.visa,
            icon: isDarkMode
                ? 'assets/images/icons/Payment_Methods/Visa.svg'
                : 'assets/images/icons/Payment_Methods/Visa_light.svg',
            title: 'Visa Ending in 4242',
            subtitle: 'Expires 08/26',
            isSelected: selectedMethod == PaymentMethod.visa,
            isDarkMode: isDarkMode,
          ),

          // Mastercard
          _buildPaymentOption(
            context: context,
            ref: ref,
            method: PaymentMethod.mastercard,
            icon: isDarkMode
                ? 'assets/images/icons/Payment_Methods/Mastercard.svg'
                : 'assets/images/icons/Payment_Methods/MasterCard_light.svg',
            title: 'Mastercard Ending in 1837',
            subtitle: 'Expires 02/27',
            isSelected: selectedMethod == PaymentMethod.mastercard,
            isDarkMode: isDarkMode,
          ),

          // Pay with Wallet
          _buildPaymentOption(
            context: context,
            ref: ref,
            method: PaymentMethod.wallet,
            icon: isDarkMode
                ? 'assets/images/icons/Payment_Methods/Wallet.svg'
                : 'assets/images/icons/Payment_Methods/Wallet_light.svg',
            title: 'Pay with Wallet',
            subtitle: 'Select a wallet to complete your payment',
            isSelected: selectedMethod == PaymentMethod.wallet,
            isDarkMode: isDarkMode,
          ),

          // Apple Pay
          _buildPaymentOption(
            context: context,
            ref: ref,
            method: PaymentMethod.applePay,
            icon: isDarkMode
                ? 'assets/images/icons/Payment_Methods/Apple_Pay.svg'
                : 'assets/images/icons/Payment_Methods/Apple_Pay_light.svg',
            title: 'Apple Pay',
            subtitle: 'Quick checkout using Apple Pay',
            isSelected: selectedMethod == PaymentMethod.applePay,
            isDarkMode: isDarkMode,
          ),

          // Google Pay
          _buildPaymentOption(
            context: context,
            ref: ref,
            method: PaymentMethod.googlePay,
            icon: isDarkMode
                ? 'assets/images/icons/Payment_Methods/Google_Pay.svg'
                : 'assets/images/icons/Payment_Methods/Google_Pay_light.svg',
            title: 'Google Pay',
            subtitle: 'Quick checkout using Google Pay',
            isSelected: selectedMethod == PaymentMethod.googlePay,
            isDarkMode: isDarkMode,
          ),

          // Cash on Pickup
          _buildPaymentOption(
            context: context,
            ref: ref,
            method: PaymentMethod.cashOnPickup,
            icon: isDarkMode
                ? 'assets/images/icons/Payment_Methods/Cash.svg'
                : 'assets/images/icons/Payment_Methods/Cash_light.svg',
            title: 'Cash on Pickup',
            subtitle: 'Pay with cash when you pick up your order',
            isSelected: selectedMethod == PaymentMethod.cashOnPickup,
            isDarkMode: isDarkMode,
          ),

          // Add New Card
          _buildPaymentOption(
            context: context,
            ref: ref,
            method: PaymentMethod.addNewCard,
            icon: isDarkMode
                ? 'assets/images/icons/Payment_Methods/Add_Card.svg'
                : 'assets/images/icons/Payment_Methods/AddNew_light.svg',
            title: 'Add New Card and Pay',
            subtitle: 'Proceed without saving your card details',
            isSelected: selectedMethod == PaymentMethod.addNewCard,
            isDarkMode: isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required BuildContext context,
    required WidgetRef ref,
    required PaymentMethod method,
    required String icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required bool isDarkMode,
  }) {
    return GestureDetector(
      onTap: () => _onPaymentMethodSelected(context, ref, method),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isDarkMode
                  ? const Color(0xFF4D4E52)
                  : AppColors.lightOutline,
              width: 1,
            ),
            bottom: BorderSide(
              color: isDarkMode
                  ? const Color(0xFF4D4E52)
                  : AppColors.lightOutline,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            // Icon container - significantly enlarged for maximum visibility
            Container(
              padding: const EdgeInsets.all(6),
              child: SvgPicture.asset(
                icon,
                width: 52,
                height: 52,
                // Remove colorFilter to preserve original SVG colors
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.payment,
                    color: isDarkMode
                        ? const Color(0xCCFEFEFF)
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
                    title,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: isDarkMode
                          ? const Color(0xCCFEFEFF)
                          : AppColors.lightOnSurface,
                      height: 21 / 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: isDarkMode
                          ? const Color(0xFF9C9C9D)
                          : AppColors.lightOnSurfaceVariant,
                      height: 18 / 12,
                    ),
                  ),
                ],
              ),
            ),

            // Radio button
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? (isDarkMode
                            ? const Color(0xFFFEFEFF)
                            : AppColors.lightOnSurface)
                      : (isDarkMode
                            ? const Color(0xFF4D4E52)
                            : AppColors.lightOutline),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDarkMode
                              ? const Color(0xFFFEFEFF)
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

  Widget _buildContinueButton(
    BuildContext context,
    WidgetRef ref,
    PaymentMethod? selectedMethod,
    bool isDarkMode,
  ) {
    final canProceed = selectedMethod != null;

    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).padding.bottom,
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: canProceed
              ? () => _onContinuePressed(context, ref, selectedMethod)
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: canProceed
                ? (isDarkMode
                      ? const Color(0xFFFFFBF1)
                      : const Color(0xFF1A1A1A))
                : (isDarkMode
                      ? const Color(0xFF4D4E52)
                      : const Color(0xFF4D4E52)),
            foregroundColor: canProceed
                ? (isDarkMode
                      ? const Color(0xFF242424)
                      : const Color(0xFFFEFEFF))
                : (isDarkMode
                      ? const Color(0xFF9C9C9D)
                      : const Color(0xFF9C9C9D)),
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(44),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                total.toInt().toString(),
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 24 / 16,
                ),
              ),
              const SizedBox(width: 4),
              SvgPicture.asset(
                'assets/images/icons/Payment_Methods/SAR.svg',
                width: 11,
                height: 12,
                colorFilter: ColorFilter.mode(
                  canProceed
                      ? (isDarkMode
                            ? const Color(0xFF242424)
                            : const Color(0xFFFEFEFF))
                      : (isDarkMode
                            ? const Color(0xFF9C9C9D)
                            : const Color(0xFF9C9C9D)),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '|',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 24 / 16,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Review Order',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 24 / 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onPaymentMethodSelected(
    BuildContext context,
    WidgetRef ref,
    PaymentMethod method,
  ) {
    // For wallet payment, navigate immediately to wallet selection screen
    if (method == PaymentMethod.wallet) {
      try {
        context.push(
          '/checkout/wallet-selection',
          extra: {'total': total, 'currency': currency},
        );
      } catch (e) {
        // Handle navigation error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Navigation error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // For add new card, navigate immediately to add card screen
    if (method == PaymentMethod.addNewCard) {
      try {
        context.push(
          '/checkout/add-new-card',
          extra: {'total': total, 'currency': currency},
        );
      } catch (e) {
        // Handle navigation error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Navigation error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // For other payment methods, just update the selected state
    ref.read(selectedPaymentMethodProvider.notifier).state = method;
  }

  void _onContinuePressed(
    BuildContext context,
    WidgetRef ref,
    PaymentMethod? method,
  ) {
    if (method == null) return;

    try {
      // Convert enum to PaymentMethodEntity and store in checkout state
      final paymentMethodEntity = _convertToPaymentMethodEntity(method);
      if (paymentMethodEntity != null) {
        ref
            .read(checkoutProvider.notifier)
            .selectPaymentMethod(paymentMethodEntity);
      }

      // Navigate to order review screen for non-wallet payments
      // (wallet payments are handled immediately in _onPaymentMethodSelected)
      context.push('/checkout/review-order');
    } catch (e) {
      // Handle navigation error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Navigation error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  PaymentMethodEntity? _convertToPaymentMethodEntity(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.visa:
        return const PaymentMethodEntity(
          id: 'visa_default',
          type: PaymentMethodType.card,
          displayName: 'Visa',
          iconPath: 'assets/images/icons/Payment_Methods/Visa_light.svg',
        );
      case PaymentMethod.mastercard:
        return const PaymentMethodEntity(
          id: 'mastercard_default',
          type: PaymentMethodType.card,
          displayName: 'Mastercard',
          iconPath: 'assets/images/icons/Payment_Methods/MasterCard_light.svg',
        );
      case PaymentMethod.applePay:
        return const PaymentMethodEntity(
          id: 'apple_pay',
          type: PaymentMethodType.applePay,
          displayName: 'Apple Pay',
          iconPath: 'assets/images/icons/Payment_Methods/Apple_Pay_light.svg',
        );
      case PaymentMethod.googlePay:
        return const PaymentMethodEntity(
          id: 'google_pay',
          type: PaymentMethodType.googlePay,
          displayName: 'Google Pay',
          iconPath: 'assets/images/icons/Payment_Methods/Google_Pay_light.svg',
        );
      case PaymentMethod.cashOnPickup:
        return const PaymentMethodEntity(
          id: 'cash_on_pickup',
          type: PaymentMethodType.cash,
          displayName: 'Cash on Pickup',
          iconPath: 'assets/images/icons/Payment_Methods/Cash_light.svg',
        );
      case PaymentMethod.wallet:
      case PaymentMethod.addNewCard:
        // These are handled separately
        return null;
    }
  }
}
