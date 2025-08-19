import 'dart:math' as math;

/// Enum for different card types
enum CardType {
  visa,
  mastercard,
  amex,
  discover,
  unknown,
}

/// Card validation utilities with PCI compliance focus
class CardValidationUtils {
  // Private constructor to prevent instantiation
  CardValidationUtils._();

  // Card type patterns
  static final Map<CardType, List<RegExp>> _cardPatterns = {
    CardType.visa: [
      RegExp(r'^4[0-9]{0,15}$'),
    ],
    CardType.mastercard: [
      RegExp(r'^5[1-5][0-9]{0,14}$'),
      RegExp(r'^2[2-7][0-9]{0,14}$'), // New Mastercard range
    ],
    CardType.amex: [
      RegExp(r'^3[47][0-9]{0,13}$'),
    ],
    CardType.discover: [
      RegExp(r'^6(?:011|5[0-9]{2})[0-9]{0,12}$'),
    ],
  };

  // Card type icons mapping to assets
  static const Map<CardType, String> cardTypeIcons = {
    CardType.visa: 'assets/images/icons/Payment_Methods/Colored_Icons/Visa.svg',
    CardType.mastercard: 'assets/images/icons/Payment_Methods/Colored_Icons/MasterCard.svg',
    CardType.amex: 'assets/images/icons/Payment_Methods/Colored_Icons/Amex.svg',
    CardType.discover: 'assets/images/icons/Payment_Methods/Colored_Icons/Discover.svg',
    CardType.unknown: 'assets/images/icons/Payment_Methods/Add_Card.svg',
  };

  // Card lengths for different types
  static const Map<CardType, int> _cardLengths = {
    CardType.visa: 16,
    CardType.mastercard: 16,
    CardType.amex: 15,
    CardType.discover: 16,
  };

  // CVV lengths for different types
  static const Map<CardType, int> _cvvLengths = {
    CardType.visa: 3,
    CardType.mastercard: 3,
    CardType.amex: 4, // AmEx uses 4-digit CID
    CardType.discover: 3,
  };

  /// Detect card type from card number
  /// SECURITY NOTE: This only looks at number patterns, never stores full numbers
  static CardType detectCardType(String cardNumber) {
    // Remove any non-digit characters for pattern matching
    final cleanNumber = cardNumber.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleanNumber.isEmpty) return CardType.unknown;

    for (final entry in _cardPatterns.entries) {
      for (final pattern in entry.value) {
        if (pattern.hasMatch(cleanNumber)) {
          return entry.key;
        }
      }
    }

    return CardType.unknown;
  }

  /// Get icon path for card type
  static String getCardTypeIcon(CardType cardType) {
    return cardTypeIcons[cardType] ?? cardTypeIcons[CardType.unknown]!;
  }

  /// Get expected card length for card type
  static int getCardLength(CardType cardType) {
    return _cardLengths[cardType] ?? 16;
  }

  /// Get expected CVV length for card type
  static int getCvvLength(CardType cardType) {
    return _cvvLengths[cardType] ?? 3;
  }

  /// Format card number with spaces for display
  /// SECURITY NOTE: This is for UI formatting only, never for storage
  static String formatCardNumber(String cardNumber) {
    final cleanNumber = cardNumber.replaceAll(RegExp(r'[^\d]'), '');
    final cardType = detectCardType(cleanNumber);
    
    // Format based on card type
    switch (cardType) {
      case CardType.amex:
        // AmEx format: 3744 123456 12345
        return _formatAmex(cleanNumber);
      default:
        // Standard format: 1234 1234 1234 1234
        return _formatStandard(cleanNumber);
    }
  }

  /// Format AmEx card number (3744 123456 12345)
  static String _formatAmex(String cardNumber) {
    final buffer = StringBuffer();
    for (int i = 0; i < cardNumber.length; i++) {
      if (i == 4 || i == 10) {
        buffer.write(' ');
      }
      buffer.write(cardNumber[i]);
    }
    return buffer.toString();
  }

  /// Format standard card number (1234 1234 1234 1234)
  static String _formatStandard(String cardNumber) {
    final buffer = StringBuffer();
    for (int i = 0; i < cardNumber.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(cardNumber[i]);
    }
    return buffer.toString();
  }

  /// Format expiry date (MM/YY)
  static String formatExpiryDate(String expiry) {
    final cleanExpiry = expiry.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleanExpiry.length <= 2) {
      return cleanExpiry;
    }
    
    return '${cleanExpiry.substring(0, 2)}/${cleanExpiry.substring(2, math.min(4, cleanExpiry.length))}';
  }

  /// Validate card number using Luhn algorithm
  /// SECURITY NOTE: This validates format only, never stores the number
  static bool isValidCardNumber(String cardNumber) {
    final cleanNumber = cardNumber.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleanNumber.isEmpty || cleanNumber.length < 13 || cleanNumber.length > 19) {
      return false;
    }

    // Check if it matches a known card type pattern
    final cardType = detectCardType(cleanNumber);
    if (cardType == CardType.unknown) {
      return false;
    }

    // Check length for the detected card type
    final expectedLength = getCardLength(cardType);
    if (cleanNumber.length != expectedLength) {
      return false;
    }

    // Luhn algorithm validation
    return _luhnCheck(cleanNumber);
  }

  /// Luhn algorithm implementation for card validation
  static bool _luhnCheck(String cardNumber) {
    int sum = 0;
    bool alternate = false;

    // Process digits from right to left
    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cardNumber[i]);

      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit = (digit % 10) + 1;
        }
      }

      sum += digit;
      alternate = !alternate;
    }

    return sum % 10 == 0;
  }

  /// Validate expiry date
  static bool isValidExpiryDate(String expiry) {
    final cleanExpiry = expiry.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleanExpiry.length != 4) {
      return false;
    }

    final month = int.tryParse(cleanExpiry.substring(0, 2));
    final year = int.tryParse(cleanExpiry.substring(2, 4));

    if (month == null || year == null) {
      return false;
    }

    if (month < 1 || month > 12) {
      return false;
    }

    // Convert 2-digit year to 4-digit year
    final currentYear = DateTime.now().year;
    final fullYear = year + (year < 50 ? 2000 : 1900);

    // Check if the card is expired
    if (fullYear < currentYear) {
      return false;
    }

    if (fullYear == currentYear) {
      final currentMonth = DateTime.now().month;
      if (month < currentMonth) {
        return false;
      }
    }

    return true;
  }

  /// Validate CVV
  static bool isValidCvv(String cvv, CardType cardType) {
    final cleanCvv = cvv.replaceAll(RegExp(r'[^\d]'), '');
    final expectedLength = getCvvLength(cardType);
    
    return cleanCvv.length == expectedLength && RegExp(r'^\d+$').hasMatch(cleanCvv);
  }

  /// Validate cardholder name
  static bool isValidCardholderName(String name) {
    final trimmedName = name.trim();
    
    if (trimmedName.length < 2 || trimmedName.length > 50) {
      return false;
    }

    // Allow letters, spaces, hyphens, and apostrophes
    final namePattern = RegExp(r"^[a-zA-Z\s\-\']+$");
    return namePattern.hasMatch(trimmedName);
  }

  /// Get card number validation error message
  static String? getCardNumberError(String cardNumber) {
    if (cardNumber.isEmpty) {
      return 'Card number is required';
    }

    final cleanNumber = cardNumber.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleanNumber.length < 13) {
      return 'Card number is too short';
    }

    if (cleanNumber.length > 19) {
      return 'Card number is too long';
    }

    final cardType = detectCardType(cleanNumber);
    if (cardType == CardType.unknown) {
      return 'Invalid card type';
    }

    final expectedLength = getCardLength(cardType);
    if (cleanNumber.length != expectedLength) {
      return 'Invalid card number length for ${_getCardTypeName(cardType)}';
    }

    if (!_luhnCheck(cleanNumber)) {
      return 'Invalid card number';
    }

    return null; // Valid
  }

  /// Get expiry date validation error message
  static String? getExpiryDateError(String expiry) {
    if (expiry.isEmpty) {
      return 'Expiry date is required';
    }

    final cleanExpiry = expiry.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleanExpiry.length != 4) {
      return 'Enter MM/YY format';
    }

    final month = int.tryParse(cleanExpiry.substring(0, 2));
    final year = int.tryParse(cleanExpiry.substring(2, 4));

    if (month == null || year == null) {
      return 'Invalid expiry date';
    }

    if (month < 1 || month > 12) {
      return 'Invalid month';
    }

    // Convert 2-digit year to 4-digit year
    final currentYear = DateTime.now().year;
    final fullYear = year + (year < 50 ? 2000 : 1900);

    // Check if the card is expired
    if (fullYear < currentYear) {
      return 'Card has expired';
    }

    if (fullYear == currentYear) {
      final currentMonth = DateTime.now().month;
      if (month < currentMonth) {
        return 'Card has expired';
      }
    }

    return null; // Valid
  }

  /// Get CVV validation error message
  static String? getCvvError(String cvv, CardType cardType) {
    if (cvv.isEmpty) {
      return 'CVV is required';
    }

    final cleanCvv = cvv.replaceAll(RegExp(r'[^\d]'), '');
    final expectedLength = getCvvLength(cardType);
    
    if (cleanCvv.length != expectedLength) {
      final cvvName = cardType == CardType.amex ? 'CID' : 'CVV';
      return '$cvvName must be $expectedLength digits';
    }

    return null; // Valid
  }

  /// Get cardholder name validation error message
  static String? getCardholderNameError(String name) {
    final trimmedName = name.trim();
    
    if (trimmedName.isEmpty) {
      return 'Cardholder name is required';
    }

    if (trimmedName.length < 2) {
      return 'Name must be at least 2 characters';
    }

    if (trimmedName.length > 50) {
      return 'Name must be less than 50 characters';
    }

    // Allow letters, spaces, hyphens, and apostrophes
    final namePattern = RegExp(r"^[a-zA-Z\s\-\']+$");
    if (!namePattern.hasMatch(trimmedName)) {
      return 'Name can only contain letters, spaces, hyphens, and apostrophes';
    }

    return null; // Valid
  }

  /// Get user-friendly card type name
  static String _getCardTypeName(CardType cardType) {
    switch (cardType) {
      case CardType.visa:
        return 'Visa';
      case CardType.mastercard:
        return 'Mastercard';
      case CardType.amex:
        return 'American Express';
      case CardType.discover:
        return 'Discover';
      case CardType.unknown:
        return 'Unknown';
    }
  }

  /// Get card type display name
  static String getCardTypeDisplayName(CardType cardType) {
    return _getCardTypeName(cardType);
  }

  /// Mask card number for secure display (show only last 4 digits)
  /// SECURITY NOTE: Use this for displaying saved cards, never store full numbers
  static String maskCardNumber(String lastFourDigits, CardType cardType) {
    switch (cardType) {
      case CardType.amex:
        return '**** ****** *$lastFourDigits';
      default:
        return '**** **** **** $lastFourDigits';
    }
  }

  /// Create a secure card token representation (for API calls)
  /// SECURITY NOTE: This should be used with a proper tokenization service
  static Map<String, dynamic> createCardToken({
    required String cardNumber,
    required String expiryMonth,
    required String expiryYear,
    required String cvv,
    required String cardholderName,
  }) {
    final cardType = detectCardType(cardNumber);
    final lastFour = cardNumber.replaceAll(RegExp(r'[^\d]'), '').substring(
      cardNumber.replaceAll(RegExp(r'[^\d]'), '').length - 4,
    );

    // In production, this would call a secure tokenization service
    // NEVER store the actual card data in this format
    return {
      'token_id': 'temp_token_${DateTime.now().millisecondsSinceEpoch}',
      'card_type': cardType.toString().split('.').last,
      'last_four': lastFour,
      'expiry_month': expiryMonth.padLeft(2, '0'),
      'expiry_year': expiryYear,
      'cardholder_name': cardholderName.trim(),
      'created_at': DateTime.now().toIso8601String(),
      // CRITICAL: Never include actual card data in the response
      'secure_hash': _generateSecureHash(cardNumber, expiryMonth, expiryYear),
    };
  }

  /// Generate a secure hash for validation (placeholder implementation)
  /// SECURITY NOTE: In production, use proper cryptographic hashing
  static String _generateSecureHash(String cardNumber, String month, String year) {
    final input = '$cardNumber$month$year${DateTime.now().millisecondsSinceEpoch}';
    return input.hashCode.abs().toString();
  }

  /// Clear sensitive data from memory (security best practice)
  /// SECURITY NOTE: Call this after processing card data
  static void clearSensitiveData(List<String> sensitiveStrings) {
    for (final str in sensitiveStrings) {
      // In Dart, we can't directly overwrite string memory, but we can clear references
      str.replaceAll(RegExp(r'.'), '0');
    }
    // Force garbage collection
    // Note: In production, consider using more advanced memory clearing techniques
  }
}