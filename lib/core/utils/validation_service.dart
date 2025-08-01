import '../../features/country/presentation/country_selection_screen.dart';

class ValidationService {
  // Phone number validation patterns for each country
  static final Map<Country, RegExp> _phonePatterns = {
    Country.uae: RegExp(r'^(50|51|52|54|55|56|58)[0-9]{7}$'), // UAE mobile patterns
    Country.saudi: RegExp(r'^(50|51|52|53|54|55|56|57|58|59)[0-9]{7}$'), // Saudi mobile patterns
    Country.qatar: RegExp(r'^(3|4|5|6|7)[0-9]{7}$'), // Qatar mobile patterns
    Country.uk: RegExp(r'^7[0-9]{9}$'), // UK mobile patterns (starts with 7, 10 digits total)
  };

  // Expected phone number lengths for each country (without country code)
  static const Map<Country, int> _phoneLength = {
    Country.uae: 9,
    Country.saudi: 9,
    Country.qatar: 8,
    Country.uk: 10,
  };

  // Validate phone number for specific country
  static String? validatePhoneNumber(String phoneNumber, Country country) {
    if (phoneNumber.isEmpty) {
      return 'Phone number is required';
    }

    // Remove any spaces, dashes, or parentheses
    String cleanNumber = phoneNumber.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    // Check if it's only digits
    if (!RegExp(r'^[0-9]+$').hasMatch(cleanNumber)) {
      return 'Phone number must contain only digits';
    }

    // Check length
    int expectedLength = _phoneLength[country]!;
    if (cleanNumber.length != expectedLength) {
      return 'Phone number must be $expectedLength digits for ${country.displayName}';
    }

    // Check pattern
    RegExp pattern = _phonePatterns[country]!;
    if (!pattern.hasMatch(cleanNumber)) {
      return _getCountrySpecificError(country);
    }

    return null; // Valid
  }

  static String _getCountrySpecificError(Country country) {
    switch (country) {
      case Country.uae:
        return 'UAE mobile numbers must start with 50, 51, 52, 54, 55, 56, or 58';
      case Country.saudi:
        return 'Saudi mobile numbers must start with 50-59';
      case Country.qatar:
        return 'Qatar mobile numbers must start with 3, 4, 5, 6, or 7';
      case Country.uk:
        return 'UK mobile numbers must start with 7';
    }
  }

  // Validate email
  static String? validateEmail(String email) {
    if (email.isEmpty) {
      return 'Email is required';
    }

    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email)) {
      return 'Please enter a valid email address';
    }

    return null; // Valid
  }

  // Validate username
  static String? validateUsername(String username) {
    if (username.isEmpty) {
      return 'Username is required';
    }

    if (username.length < 3) {
      return 'Username must be at least 3 characters';
    }

    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username)) {
      return 'Username can only contain letters, numbers, and underscores';
    }

    return null; // Valid
  }

  // Validate OTP
  static String? validateOTP(String otp) {
    if (otp.isEmpty) {
      return 'OTP is required';
    }

    if (otp.length != 6) {
      return 'OTP must be 6 digits';
    }

    if (!RegExp(r'^[0-9]{6}$').hasMatch(otp)) {
      return 'OTP must contain only digits';
    }

    return null; // Valid
  }

  // Get sample phone number format for country
  static String getSampleFormat(Country country) {
    switch (country) {
      case Country.uae:
        return 'e.g., 501234567';
      case Country.saudi:
        return 'e.g., 501234567';
      case Country.qatar:
        return 'e.g., 31234567';
      case Country.uk:
        return 'e.g., 7123456789';
    }
  }
}