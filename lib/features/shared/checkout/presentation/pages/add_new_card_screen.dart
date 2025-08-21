import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../widgets/secure_card_input.dart';
import '../utils/card_validation_utils.dart';
import '../providers/checkout_providers.dart';
import '../../domain/entities/checkout_entities.dart';

/// Add New Card Screen - PCI Compliant Implementation
/// Follows Figma design specifications with security-first approach
class AddNewCardScreen extends ConsumerStatefulWidget {
  final double total;
  final String currency;

  const AddNewCardScreen({Key? key, required this.total, this.currency = 'SAR'})
    : super(key: key);

  @override
  ConsumerState<AddNewCardScreen> createState() => _AddNewCardScreenState();
}

class _AddNewCardScreenState extends ConsumerState<AddNewCardScreen> {
  // Form controllers - SECURITY NOTE: These never store sensitive data permanently
  late final TextEditingController _cardholderNameController;
  late final TextEditingController _cardNumberController;
  late final TextEditingController _expiryDateController;
  late final TextEditingController _cvvController;

  // Focus nodes for proper keyboard navigation
  late final FocusNode _cardholderNameFocus;
  late final FocusNode _cardNumberFocus;
  late final FocusNode _expiryDateFocus;
  late final FocusNode _cvvFocus;

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // State variables
  CardType _currentCardType = CardType.unknown;
  bool _isProcessing = false;
  String? _errorMessage;

  // Validation error states
  String? _cardholderNameError;
  String? _cardNumberError;
  String? _expiryDateError;
  String? _cvvError;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with security considerations
    _cardholderNameController = TextEditingController();
    _cardNumberController = TextEditingController();
    _expiryDateController = TextEditingController();
    _cvvController = TextEditingController();

    // Initialize focus nodes
    _cardholderNameFocus = FocusNode();
    _cardNumberFocus = FocusNode();
    _expiryDateFocus = FocusNode();
    _cvvFocus = FocusNode();

    // Add listeners for real-time validation
    _cardholderNameController.addListener(_validateCardholderName);
    _cardNumberController.addListener(_validateCardNumber);
    _expiryDateController.addListener(_validateExpiryDate);
    _cvvController.addListener(_validateCvv);
  }

  @override
  void dispose() {
    // Remove listeners before disposing
    _cardholderNameController.removeListener(_validateCardholderName);
    _cardNumberController.removeListener(_validateCardNumber);
    _expiryDateController.removeListener(_validateExpiryDate);
    _cvvController.removeListener(_validateCvv);

    // SECURITY: Clear sensitive data before disposal (without setState)
    _cardNumberController.clear();
    _expiryDateController.clear();
    _cvvController.clear();

    // Dispose controllers and focus nodes
    _cardholderNameController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();

    _cardholderNameFocus.dispose();
    _cardNumberFocus.dispose();
    _expiryDateFocus.dispose();
    _cvvFocus.dispose();

    super.dispose();
  }

  /// SECURITY: Clear sensitive data from memory
  void _clearSensitiveData() {
    _cardNumberController.clear();
    _expiryDateController.clear();
    _cvvController.clear();
    // Note: In production, consider using secure memory clearing techniques
  }

  void _validateCardholderName() {
    final error = CardValidationUtils.getCardholderNameError(
      _cardholderNameController.text,
    );
    if (_cardholderNameError != error) {
      setState(() {
        _cardholderNameError = error;
      });
    }
  }

  void _validateCardNumber() {
    final error = CardValidationUtils.getCardNumberError(
      _cardNumberController.text,
    );
    if (_cardNumberError != error) {
      setState(() {
        _cardNumberError = error;
      });
    }
  }

  void _validateExpiryDate() {
    final error = CardValidationUtils.getExpiryDateError(
      _expiryDateController.text,
    );
    if (_expiryDateError != error) {
      setState(() {
        _expiryDateError = error;
      });
    }
  }

  void _validateCvv() {
    final error = CardValidationUtils.getCvvError(
      _cvvController.text,
      _currentCardType,
    );
    if (_cvvError != error) {
      setState(() {
        _cvvError = error;
      });
    }
  }

  void _onCardTypeChanged(CardType cardType) {
    setState(() {
      _currentCardType = cardType;
    });
    // Revalidate CVV when card type changes
    _validateCvv();
  }

  bool get _isFormValid {
    return _cardholderNameError == null &&
        _cardNumberError == null &&
        _expiryDateError == null &&
        _cvvError == null &&
        _cardholderNameController.text.isNotEmpty &&
        _cardNumberController.text.isNotEmpty &&
        _expiryDateController.text.isNotEmpty &&
        _cvvController.text.isNotEmpty;
  }

  Future<void> _processCardPayment() async {
    if (!_isFormValid) {
      setState(() {
        _errorMessage = 'Please fill in all fields correctly';
      });
      return;
    }

    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      // SECURITY: Create secure token instead of storing card data
      final cardToken = CardValidationUtils.createCardToken(
        cardNumber: _cardNumberController.text,
        expiryMonth: _expiryDateController.text.split('/')[0],
        expiryYear: _expiryDateController.text.split('/')[1],
        cvv: _cvvController.text,
        cardholderName: _cardholderNameController.text,
      );

      // Create PaymentMethodEntity with tokenized data only
      final paymentMethod = PaymentMethodEntity(
        id: cardToken['token_id'] as String,
        type: PaymentMethodType.card,
        displayName:
            '${CardValidationUtils.getCardTypeDisplayName(_currentCardType)} ending in ${cardToken['last_four']}',
        lastFourDigits: cardToken['last_four'] as String,
        cardBrand: cardToken['card_type'] as String,
        iconPath: CardValidationUtils.getCardTypeIcon(_currentCardType),
        isDefault: false,
        requiresBiometric: false,
        secureMetadata: {
          'token_id': cardToken['token_id'],
          'secure_hash': cardToken['secure_hash'],
          'expiry_month': cardToken['expiry_month'],
          'expiry_year': cardToken['expiry_year'],
          'cardholder_name': cardToken['cardholder_name'],
        },
      );

      // Select this payment method in the checkout flow
      ref.read(checkoutProvider.notifier).selectPaymentMethod(paymentMethod);

      // SECURITY: Clear sensitive data immediately after processing
      _clearSensitiveData();

      // Navigate to review order screen after card is added and selected
      if (mounted) {
        context.go('/checkout/review-order');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to add card. Please try again.';
        _isProcessing = false;
      });

      // SECURITY: Clear sensitive data even on error
      _clearSensitiveData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF1A1A1A)
          : const Color(0xFFFFFCF5),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Header with back button and title
            SafeArea(child: _buildHeader(context, isDark)),

            // Main content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),

                    // Bank Card section
                    _buildBankCardSection(isDark),
                    const SizedBox(height: 24),

                    // Cardholder name field
                    SecureCardholderNameField(
                      controller: _cardholderNameController,
                      focusNode: _cardholderNameFocus,
                      errorText: _cardholderNameError,
                      enabled: !_isProcessing,
                    ),
                    const SizedBox(height: 16),

                    // Card number field
                    SecureCardNumberField(
                      controller: _cardNumberController,
                      focusNode: _cardNumberFocus,
                      onCardTypeChanged: _onCardTypeChanged,
                      errorText: _cardNumberError,
                      enabled: !_isProcessing,
                    ),
                    const SizedBox(height: 16),

                    // Expiration date and CVV section
                    _buildExpirationSection(isDark),

                    const SizedBox(height: 32),

                    // Error message
                    if (_errorMessage != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE53E3E).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(
                              0xFFE53E3E,
                            ).withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: const Color(0xFFE53E3E),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(
                                  color: const Color(0xFFE53E3E),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Bottom button
            _buildBottomButton(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () {
              // SECURITY: Clear sensitive data before navigation
              _clearSensitiveData();
              context.pop();
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isDark
                      ? const Color(0xFFFEFEFF)
                      : const Color(0xFF1A1A1A),
                ),
                borderRadius: BorderRadius.circular(44),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: isDark
                    ? const Color(0xFFFEFEFF)
                    : const Color(0xFF1A1A1A),
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Title
          Expanded(
            child: Text(
              'Add New Card and Pay',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? const Color(0xCCFEFEFF)
                    : const Color(0xFF1A1A1A),
                height: 32 / 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankCardSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bank Card',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: isDark
                ? const Color(0xFFFEFEFF).withValues(alpha: 0.8)
                : const Color(0xFF242424).withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 8),
        _buildCardTypeIcons(),
      ],
    );
  }

  /// Build card type icons row matching Figma design exactly
  Widget _buildCardTypeIcons() {
    final cardTypes = [
      {
        'type': 'Visa',
        'path': 'assets/images/icons/Payment_Methods/Colored_Icons/Visa.svg',
      },
      {
        'type': 'Mastercard',
        'path':
            'assets/images/icons/Payment_Methods/Colored_Icons/MasterCard.svg',
      },
      {
        'type': 'American Express',
        'path': 'assets/images/icons/Payment_Methods/Colored_Icons/Amex.svg',
      },
      {
        'type': 'Discover',
        'path':
            'assets/images/icons/Payment_Methods/Colored_Icons/Discover.svg',
      },
    ];

    return Row(
      children: cardTypes.asMap().entries.map((entry) {
        final index = entry.key;
        final card = entry.value;

        return Container(
          margin: EdgeInsets.only(right: index < cardTypes.length - 1 ? 8 : 0),
          width: 52,
          height: 32,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Colors.white, // White background for card icons
            border: Border.all(
              color: const Color(0xFF4D4E52).withValues(alpha: 0.2),
              width: 0.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: SvgPicture.asset(
              card['path']!,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.withValues(alpha: 0.3),
                  child: const Center(
                    child: Icon(
                      Icons.credit_card,
                      color: Colors.grey,
                      size: 16,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildExpirationSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Expiration Date',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: isDark
                ? const Color(0xFFFEFEFF).withValues(alpha: 0.8)
                : const Color(0xFF242424).withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // MM field
            _buildDropdownField('MM', isDark),
            const SizedBox(width: 8),

            // YY field
            _buildDropdownField('YY', isDark),
            const Spacer(),

            // CVV field
            SizedBox(
              width: 120,
              child: SecureCvvField(
                controller: _cvvController,
                cardType: _currentCardType,
                focusNode: _cvvFocus,
                errorText: _cvvError,
                enabled: !_isProcessing,
              ),
            ),
          ],
        ),

        // Hidden working expiry date field for functionality
        const SizedBox(height: 16),
        Opacity(
          opacity: 0.0, // Completely invisible but functional
          child: SizedBox(
            height: 1,
            child: SecureExpiryDateField(
              controller: _expiryDateController,
              focusNode: _expiryDateFocus,
              errorText: _expiryDateError,
              enabled: !_isProcessing,
            ),
          ),
        ),
      ],
    );
  }

  /// Build MM/YY dropdown fields matching Figma design
  Widget _buildDropdownField(String label, bool isDark) {
    return Container(
      width: 94,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34), // Half circular ends
        border: Border.all(
          color: _expiryDateError != null
              ? const Color(0xFFE53E3E)
              : isDark
              ? const Color(0xFFFEFEFF).withValues(alpha: 0.64)
              : const Color(0xFF1A1A1A).withValues(alpha: 0.64),
        ),
        color: Colors.transparent,
      ),
      child: TextFormField(
        controller: TextEditingController(
          text: label,
        ), // Show the label as text
        enabled: false, // Disabled to show as dropdown placeholder
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(0xFF9C9C9D),
        ),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          filled: true,
          fillColor: Colors.transparent,
          suffixIcon: Icon(
            Icons.keyboard_arrow_down,
            color: Color(0xFF9C9C9D),
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Continue button with total amount
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFFFFFBF1) : const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(44),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(44),
                onTap: _isProcessing || !_isFormValid
                    ? null
                    : _processCardPayment,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isProcessing) ...[
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isDark
                                  ? const Color(0xFF242424)
                                  : const Color(0xFFFEFEFF),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],

                      // Amount
                      Text(
                        '${widget.total.toInt()}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? const Color(0xFF242424)
                              : const Color(0xFFFEFEFF),
                        ),
                      ),
                      const SizedBox(width: 4),

                      // SAR icon
                      SvgPicture.asset(
                        'assets/images/icons/Payment_Methods/SAR.svg',
                        width: 11,
                        height: 12,
                        colorFilter: ColorFilter.mode(
                          isDark
                              ? const Color(0xFF242424)
                              : const Color(0xFFFEFEFF),
                          BlendMode.srcIn,
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Divider
                      Text(
                        '|',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? const Color(0xFF242424)
                              : const Color(0xFFFEFEFF),
                        ),
                      ),

                      const SizedBox(width: 10),

                      // Button text
                      Text(
                        _isProcessing
                            ? 'Processing...'
                            : 'Add Card & Review Order',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? const Color(0xFF242424)
                              : const Color(0xFFFEFEFF),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
