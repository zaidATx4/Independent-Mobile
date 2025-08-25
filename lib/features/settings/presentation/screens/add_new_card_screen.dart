import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

// Secure card input data model - never stores sensitive data
class SecureCardInput {
  final String cardNumber;
  final String expiryMonth;
  final String expiryYear;
  final String cvv;
  final String cardHolderName;

  const SecureCardInput({
    required this.cardNumber,
    required this.expiryMonth,
    required this.expiryYear,
    required this.cvv,
    required this.cardHolderName,
  });

  // Security: Validate without storing sensitive data
  bool get isValid {
    return _isValidCardNumber(cardNumber) &&
        _isValidExpiryDate(expiryMonth, expiryYear) &&
        _isValidCVV(cvv) &&
        cardHolderName.trim().isNotEmpty;
  }

  bool _isValidCardNumber(String number) {
    final cleanNumber = number.replaceAll(' ', '');
    return cleanNumber.length >= 13 &&
        cleanNumber.length <= 19 &&
        RegExp(r'^\d+$').hasMatch(cleanNumber);
  }

  bool _isValidExpiryDate(String month, String year) {
    final monthInt = int.tryParse(month);
    final yearInt = int.tryParse(year);
    if (monthInt == null || yearInt == null) return false;
    if (monthInt < 1 || monthInt > 12) return false;

    final currentYear = DateTime.now().year % 100;
    final currentMonth = DateTime.now().month;

    if (yearInt < currentYear) return false;
    if (yearInt == currentYear && monthInt < currentMonth) return false;

    return true;
  }

  bool _isValidCVV(String cvv) {
    return RegExp(r'^\d{3,4}$').hasMatch(cvv);
  }

  // Security: Generate masked version for display
  String get maskedCardNumber {
    if (cardNumber.length < 4) return cardNumber;
    final last4 = cardNumber.substring(cardNumber.length - 4);
    return '**** **** **** $last4';
  }
}

// Secure state providers for card input
final cardNumberProvider = StateProvider<String>((ref) => '');
final expiryMonthProvider = StateProvider<String>((ref) => 'MM');
final expiryYearProvider = StateProvider<String>((ref) => 'YY');
final cvvProvider = StateProvider<String>((ref) => '');
final cardHolderNameProvider = StateProvider<String>((ref) => '');

class AddNewCardScreen extends ConsumerWidget {
  const AddNewCardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isLightTheme = theme.brightness == Brightness.light;

    return Scaffold(
      backgroundColor: isLightTheme
          ? const Color(0xFFFFFCF5)
          : const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context, isLightTheme),

            // Form content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: _buildCardForm(context, ref, isLightTheme),
              ),
            ),

            // Action buttons
            _buildActionButtons(context, ref, isLightTheme),
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
              'Add New Card',
              style: TextStyle(
                color: isLightTheme
                    ? const Color(0xCC1A1A1A)
                    : const Color(0xCCFEFEFF), // rgba(254,254,255,0.8)
                fontSize: 24,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                height: 32 / 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardForm(
    BuildContext context,
    WidgetRef ref,
    bool isLightTheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Card Number field
        _buildSecureTextField(
          context: context,
          ref: ref,
          provider: cardNumberProvider,
          label: 'Card Number',
          hintText: '',
          isLightTheme: isLightTheme,
          keyboardType: TextInputType.number,
          maxLength: 19,
          onChanged: (value) {
            // Format card number with spaces
            final formatted = _formatCardNumber(value);
            ref.read(cardNumberProvider.notifier).state = formatted;
          },
        ),

        const SizedBox(height: 24),

        // Expiry date section
        _buildExpiryDateSection(context, ref, isLightTheme),

        const SizedBox(height: 24),

        // CVV field
        _buildSecureTextField(
          context: context,
          ref: ref,
          provider: cvvProvider,
          label: 'CVV',
          hintText: '',
          isLightTheme: isLightTheme,
          keyboardType: TextInputType.number,
          maxLength: 4,
          obscureText: true,
        ),

        const SizedBox(height: 24),

        // Card Holder Name field
        _buildSecureTextField(
          context: context,
          ref: ref,
          provider: cardHolderNameProvider,
          label: 'Card Holder\'s Name',
          hintText: '',
          isLightTheme: isLightTheme,
          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.words,
        ),
      ],
    );
  }

  Widget _buildExpiryDateSection(
    BuildContext context,
    WidgetRef ref,
    bool isLightTheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Expiration Date',
          style: TextStyle(
            color: isLightTheme
                ? const Color(0xCCFEFEFF)
                : const Color(0xCCFEFEFF), // rgba(254,254,255,0.8)
            fontSize: 14,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.normal,
            height: 21 / 14,
          ),
        ),
        const SizedBox(height: 8),

        Row(
          children: [
            // Month dropdown
            Expanded(
              child: _buildDropdownField(
                context: context,
                ref: ref,
                provider: expiryMonthProvider,
                items: [
                  const DropdownMenuItem(value: 'MM', child: Text('MM')),
                  ...List.generate(12, (index) {
                    final month = (index + 1).toString().padLeft(2, '0');
                    return DropdownMenuItem(value: month, child: Text(month));
                  }),
                ],
                isLightTheme: isLightTheme,
              ),
            ),

            const SizedBox(width: 16),

            // Year dropdown
            Expanded(
              child: _buildDropdownField(
                context: context,
                ref: ref,
                provider: expiryYearProvider,
                items: [
                  const DropdownMenuItem(value: 'YY', child: Text('YY')),
                  ...List.generate(15, (index) {
                    final year = (DateTime.now().year % 100 + index)
                        .toString()
                        .padLeft(2, '0');
                    return DropdownMenuItem(value: year, child: Text(year));
                  }),
                ],
                isLightTheme: isLightTheme,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSecureTextField({
    required BuildContext context,
    required WidgetRef ref,
    required StateProvider<String> provider,
    required String label,
    required String hintText,
    required bool isLightTheme,
    TextInputType? keyboardType,
    int? maxLength,
    bool obscureText = false,
    TextCapitalization textCapitalization = TextCapitalization.none,
    Function(String)? onChanged,
  }) {
    final value = ref.watch(provider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isLightTheme
                ? const Color(0xCCFEFEFF)
                : const Color(0xCCFEFEFF), // rgba(254,254,255,0.8)
            fontSize: 14,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.normal,
            height: 21 / 14,
          ),
        ),
        const SizedBox(height: 8),

        TextFormField(
          initialValue: value,
          keyboardType: keyboardType,
          maxLength: maxLength,
          obscureText: obscureText,
          textCapitalization: textCapitalization,
          style: TextStyle(
            color: isLightTheme
                ? const Color(0xFFFEFEFF)
                : const Color(0xFFFEFEFF),
            fontSize: 16,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.normal,
            height: 24 / 16,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: const Color(0xFF9C9C9D), // Same for both themes
              fontSize: 16,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.normal,
              height: 24 / 16,
            ),
            filled: false,
            fillColor: Colors.transparent,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(34), // Half circles
              borderSide: const BorderSide(
                color: Color(0xA3FEFEFF), // rgba(254,254,255,0.64)
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(34), // Half circles
              borderSide: const BorderSide(
                color: Color(0xA3FEFEFF), // rgba(254,254,255,0.64)
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(34), // Half circles
              borderSide: const BorderSide(
                color: Color(0xCCFEFEFF), // More opaque when focused
                width: 1,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            counterText: '', // Hide character counter
          ),
          onChanged:
              onChanged ??
              (value) {
                ref.read(provider.notifier).state = value;
              },
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required BuildContext context,
    required WidgetRef ref,
    required StateProvider<String> provider,
    required List<DropdownMenuItem<String>> items,
    required bool isLightTheme,
  }) {
    final value = ref.watch(provider);

    return DropdownButtonFormField<String>(
      value: value,
      items: items,
      onChanged: (newValue) {
        if (newValue != null && newValue != 'MM' && newValue != 'YY') {
          ref.read(provider.notifier).state = newValue;
        }
      },
      style: TextStyle(
        color: isLightTheme ? const Color(0xFFFEFEFF) : const Color(0xFFFEFEFF),
        fontSize: 16,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.normal,
        height: 24 / 16,
      ),
      decoration: InputDecoration(
        filled: false,
        fillColor: Colors.transparent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(34), // Half circles
          borderSide: const BorderSide(
            color: Color(0xA3FEFEFF), // rgba(254,254,255,0.64)
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(34), // Half circles
          borderSide: const BorderSide(
            color: Color(0xA3FEFEFF), // rgba(254,254,255,0.64)
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(34), // Half circles
          borderSide: const BorderSide(
            color: Color(0xCCFEFEFF), // More opaque when focused
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      dropdownColor: isLightTheme
          ? const Color(0xFF1A1A1A)
          : const Color(0xFF1A1A1A),
      iconEnabledColor: const Color(0xCCFEFEFF),
      icon: const Icon(Icons.keyboard_arrow_down),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    bool isLightTheme,
  ) {
    final cardNumber = ref.watch(cardNumberProvider);
    final expiryMonth = ref.watch(expiryMonthProvider);
    final expiryYear = ref.watch(expiryYearProvider);
    final cvv = ref.watch(cvvProvider);
    final cardHolderName = ref.watch(cardHolderNameProvider);

    final cardInput = SecureCardInput(
      cardNumber: cardNumber,
      expiryMonth: expiryMonth,
      expiryYear: expiryYear,
      cvv: cvv,
      cardHolderName: cardHolderName,
    );

    final isValid = cardInput.isValid;

    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          // Cancel button
          Expanded(
            child: OutlinedButton(
              onPressed: () => context.pop(),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFFEFEFF), width: 1),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(44),
                ),
                backgroundColor: Colors.transparent,
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFFFEFEFF),
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  height: 24 / 16,
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Add button
          Expanded(
            child: ElevatedButton(
              onPressed: isValid
                  ? () => _handleAddCard(context, ref, cardInput)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isValid
                    ? const Color(0xFFFFFBF1) // Sand color
                    : const Color(0xFF4D4E52), // Disabled color
                foregroundColor: isValid
                    ? const Color(0xFF242424) // Accent color
                    : const Color(0xFF9C9C9D), // Disabled text
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(44),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Add',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  height: 24 / 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatCardNumber(String value) {
    // Remove all non-digits
    final digits = value.replaceAll(RegExp(r'\D'), '');

    // Add spaces every 4 digits
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(digits[i]);
    }

    return buffer.toString();
  }

  void _handleAddCard(
    BuildContext context,
    WidgetRef ref,
    SecureCardInput cardInput,
  ) {
    // Security: In production, this would:
    // 1. Tokenize card data through secure payment processor
    // 2. Store only masked number and token
    // 3. Clear sensitive data from memory
    // 4. Use HTTPS for all communications
    // 5. Implement PCI DSS compliance measures

    // TODO: Remove this when API integration is ready
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'This feature requires secure payment processor integration.',
        ),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 3),
      ),
    );
    return;

    // For demo: Show success message and clear form
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: const Text('Card added successfully! (Demo mode - no actual card saved)'),
    //     backgroundColor: Colors.green,
    //     duration: const Duration(seconds: 3),
    //   ),
    // );

    // // Clear sensitive data from state
    // _clearCardData(ref);

    // // Navigate back to payment methods screen
    // context.pop();
  }

  void _clearCardData(WidgetRef ref) {
    // Security: Clear all sensitive card data from state
    ref.read(cardNumberProvider.notifier).state = '';
    ref.read(expiryMonthProvider.notifier).state = 'MM';
    ref.read(expiryYearProvider.notifier).state = 'YY';
    ref.read(cvvProvider.notifier).state = '';
    ref.read(cardHolderNameProvider.notifier).state = '';
  }
}
