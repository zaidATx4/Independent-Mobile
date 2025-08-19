import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/card_validation_utils.dart';

/// Secure text input formatter for card numbers
class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove all non-digits
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    
    // Limit to maximum card length (19 digits for longest cards)
    final limitedDigits = digitsOnly.length > 19 
        ? digitsOnly.substring(0, 19) 
        : digitsOnly;

    // Format the number with spaces
    final formatted = CardValidationUtils.formatCardNumber(limitedDigits);
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Secure text input formatter for expiry dates
class ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove all non-digits
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    
    // Limit to 4 digits (MMYY)
    final limitedDigits = digitsOnly.length > 4 
        ? digitsOnly.substring(0, 4) 
        : digitsOnly;

    // Format as MM/YY
    final formatted = CardValidationUtils.formatExpiryDate(limitedDigits);
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Secure text input formatter for CVV
class CvvInputFormatter extends TextInputFormatter {
  final CardType cardType;

  CvvInputFormatter(this.cardType);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove all non-digits
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    
    // Limit based on card type
    final maxLength = CardValidationUtils.getCvvLength(cardType);
    final limitedDigits = digitsOnly.length > maxLength 
        ? digitsOnly.substring(0, maxLength) 
        : digitsOnly;
    
    return TextEditingValue(
      text: limitedDigits,
      selection: TextSelection.collapsed(offset: limitedDigits.length),
    );
  }
}

/// Secure card number input field with real-time validation and card type detection
class SecureCardNumberField extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final ValueChanged<CardType>? onCardTypeChanged;
  final String? errorText;
  final bool enabled;
  final FocusNode? focusNode;

  const SecureCardNumberField({
    Key? key,
    required this.controller,
    this.validator,
    this.onCardTypeChanged,
    this.errorText,
    this.enabled = true,
    this.focusNode,
  }) : super(key: key);

  @override
  State<SecureCardNumberField> createState() => _SecureCardNumberFieldState();
}

class _SecureCardNumberFieldState extends State<SecureCardNumberField> {
  CardType _currentCardType = CardType.unknown;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onCardNumberChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onCardNumberChanged);
    super.dispose();
  }

  void _onCardNumberChanged() {
    final cardType = CardValidationUtils.detectCardType(widget.controller.text);
    if (cardType != _currentCardType) {
      setState(() {
        _currentCardType = cardType;
      });
      widget.onCardTypeChanged?.call(cardType);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Card Number',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: isDark 
                ? const Color(0xFFFEFEFF).withValues(alpha: 0.8)
                : const Color(0xFF242424).withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(34),
            border: Border.all(
              color: widget.errorText != null 
                  ? const Color(0xFFE53E3E)
                  : const Color(0xFFFEFEFF).withValues(alpha: 0.64),
            ),
            color: Colors.transparent,
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            enabled: widget.enabled,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CardNumberInputFormatter(),
            ],
            validator: widget.validator,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: isDark 
                  ? const Color(0xFFFEFEFF)
                  : const Color(0xFF242424),
            ),
            decoration: InputDecoration(
              hintText: '4007 7028 3553 2454',
              hintStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF9C9C9D),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              filled: true,
              fillColor: Colors.transparent,
              suffixIcon: _currentCardType != CardType.unknown
                  ? Padding(
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset(
                        CardValidationUtils.getCardTypeIcon(_currentCardType),
                        width: 32,
                        height: 20,
                        fit: BoxFit.contain,
                      ),
                    )
                  : null,
            ),
            onChanged: (value) {
              // Clear error when user starts typing
              if (widget.errorText != null) {
                setState(() {});
              }
            },
          ),
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            widget.errorText!,
            style: const TextStyle(
              color: Color(0xFFE53E3E),
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}

/// Secure cardholder name input field
class SecureCardholderNameField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? errorText;
  final bool enabled;
  final FocusNode? focusNode;

  const SecureCardholderNameField({
    Key? key,
    required this.controller,
    this.validator,
    this.errorText,
    this.enabled = true,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Card Holder\'s Name',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: isDark 
                ? const Color(0xFFFEFEFF).withValues(alpha: 0.8)
                : const Color(0xFF242424).withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(34),
            border: Border.all(
              color: errorText != null 
                  ? const Color(0xFFE53E3E)
                  : const Color(0xFFFEFEFF).withValues(alpha: 0.64),
            ),
            color: Colors.transparent,
          ),
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            enabled: enabled,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s\-\']")),
              LengthLimitingTextInputFormatter(50),
            ],
            validator: validator,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: isDark 
                  ? const Color(0xFFFEFEFF)
                  : const Color(0xFF242424),
            ),
            decoration: const InputDecoration(
              hintText: 'John Smith',
              hintStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF9C9C9D),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              filled: true,
              fillColor: Colors.transparent,
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: const TextStyle(
              color: Color(0xFFE53E3E),
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}

/// Secure expiry date input field
class SecureExpiryDateField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? errorText;
  final bool enabled;
  final FocusNode? focusNode;

  const SecureExpiryDateField({
    Key? key,
    required this.controller,
    this.validator,
    this.errorText,
    this.enabled = true,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: 94,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        border: Border.all(
          color: errorText != null 
              ? const Color(0xFFE53E3E)
              : const Color(0xFFFEFEFF).withValues(alpha: 0.64),
        ),
        color: Colors.transparent,
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        enabled: enabled,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          ExpiryDateInputFormatter(),
        ],
        validator: validator,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: isDark 
              ? const Color(0xFFFEFEFF)
              : const Color(0xFF242424),
        ),
        decoration: const InputDecoration(
          hintText: 'MM/YY',
          hintStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFF9C9C9D),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          filled: true,
          fillColor: Colors.transparent,
        ),
      ),
    );
  }
}

/// Secure CVV input field with masking
class SecureCvvField extends StatefulWidget {
  final TextEditingController controller;
  final CardType cardType;
  final String? Function(String?)? validator;
  final String? errorText;
  final bool enabled;
  final FocusNode? focusNode;

  const SecureCvvField({
    Key? key,
    required this.controller,
    required this.cardType,
    this.validator,
    this.errorText,
    this.enabled = true,
    this.focusNode,
  }) : super(key: key);

  @override
  State<SecureCvvField> createState() => _SecureCvvFieldState();
}

class _SecureCvvFieldState extends State<SecureCvvField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cvvLength = CardValidationUtils.getCvvLength(widget.cardType);
    final cvvName = widget.cardType == CardType.amex ? 'CID' : 'CVV';
    
    return Container(
      width: 94,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        border: Border.all(
          color: widget.errorText != null 
              ? const Color(0xFFE53E3E)
              : const Color(0xFFFEFEFF).withValues(alpha: 0.64),
        ),
        color: Colors.transparent,
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        enabled: widget.enabled,
        keyboardType: TextInputType.number,
        obscureText: _isObscured,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          CvvInputFormatter(widget.cardType),
        ],
        validator: widget.validator,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: isDark 
              ? const Color(0xFFFEFEFF)
              : const Color(0xFF242424),
        ),
        decoration: InputDecoration(
          hintText: cvvName,
          hintStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFF9C9C9D),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          filled: true,
          fillColor: Colors.transparent,
          suffixIcon: IconButton(
            padding: const EdgeInsets.all(0),
            constraints: const BoxConstraints(
              minWidth: 24,
              minHeight: 24,
            ),
            onPressed: () {
              setState(() {
                _isObscured = !_isObscured;
              });
            },
            icon: Icon(
              _isObscured ? Icons.visibility : Icons.visibility_off,
              size: 16,
              color: const Color(0xFF9C9C9D),
            ),
          ),
        ),
        onChanged: (value) {
          // Auto-hide after typing CVV for security
          if (value.length == cvvLength && !_isObscured) {
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                setState(() {
                  _isObscured = true;
                });
              }
            });
          }
        },
      ),
    );
  }
}

/// Widget displaying available card types with icons
class CardTypeSelector extends StatelessWidget {
  final List<CardType> supportedTypes;
  final double iconSize;

  const CardTypeSelector({
    Key? key,
    this.supportedTypes = const [
      CardType.visa,
      CardType.mastercard,
      CardType.amex,
      CardType.discover,
    ],
    this.iconSize = 38.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Row(
      children: supportedTypes.map((cardType) {
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Container(
            height: iconSize,
            width: 55,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFFF3F3F3),
              ),
            ),
            child: Center(
              child: SvgPicture.asset(
                CardValidationUtils.getCardTypeIcon(cardType),
                width: iconSize * 0.8,
                height: iconSize * 0.6,
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}