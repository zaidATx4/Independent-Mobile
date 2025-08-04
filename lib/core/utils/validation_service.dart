import '../../features/country/presentation/country_selection_screen.dart';

class ValidationService {
  // Validate phone number - simplified to only check for digits
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

    // Basic length check - must be at least 6 digits
    if (cleanNumber.length < 6) {
      return 'Phone number must be at least 6 digits';
    }

    return null; // Valid
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
    return 'e.g., 1234567890';
  }
}