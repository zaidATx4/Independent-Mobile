import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:io';
import '../../domain/usecases/checkout_usecases.dart';

/// Exception types for enhanced error categorization
enum CheckoutErrorType {
  network,
  security,
  payment,
  validation,
  timeout,
  biometric,
  fraud,
  unknown,
}

/// Enhanced checkout exception with security considerations
class EnhancedCheckoutException implements Exception {
  final CheckoutErrorType type;
  final String message;
  final String? code;
  final Map<String, dynamic>? metadata;
  final DateTime timestamp;
  final bool isSensitive;

  const EnhancedCheckoutException({
    required this.type,
    required this.message,
    this.code,
    this.metadata,
    required this.timestamp,
    this.isSensitive = false,
  });

  @override
  String toString() => 'EnhancedCheckoutException(type: $type, code: $code)';
}

/// Enhanced utility class for handling checkout-specific errors with security focus
class CheckoutErrorHandler {
  /// Get secure error message that doesn't expose sensitive information
  static String getSecureErrorMessage(dynamic error) {
    // First sanitize any potentially sensitive information
    final sanitizedError = _sanitizeError(error);
    return _getErrorMessage(sanitizedError);
  }
  
  /// Legacy method for backward compatibility
  static String getErrorMessage(dynamic error) {
    return getSecureErrorMessage(error);
  }
  
  static String _getErrorMessage(dynamic error) {
    if (error is EnhancedCheckoutException) {
      return _getEnhancedCheckoutErrorMessage(error);
    } else if (error is CheckoutException) {
      return _getCheckoutErrorMessage(error);
    } else if (error is PaymentException) {
      return _getPaymentErrorMessage(error);
    } else if (error is SecurityException) {
      return _getSecurityErrorMessage(error);
    } else if (error is ArgumentError) {
      return _getArgumentErrorMessage(error);
    } else if (error is SocketException || error is TimeoutException) {
      return _getNetworkErrorMessage(error);
    } else {
      return _getGenericErrorMessage(error);
    }
  }

  static String _getCheckoutErrorMessage(CheckoutException error) {
    switch (error.code) {
      case 'CHECKOUT_NOT_FOUND':
        return 'Checkout session not found. Please start over.';
      case 'CHECKOUT_EXPIRED':
        return 'Your checkout session has expired. Please start over.';
      case 'INVALID_PICKUP_DETAILS':
        return 'Please select valid pickup location and time.';
      case 'LOCATION_UNAVAILABLE':
        return 'Selected pickup location is not available.';
      case 'TIME_SLOT_UNAVAILABLE':
        return 'Selected time slot is not available. Please choose a different time.';
      default:
        return error.message.isNotEmpty ? error.message : 'An error occurred during checkout.';
    }
  }

  static String _getPaymentErrorMessage(PaymentException error) {
    switch (error.code) {
      case 'PAYMENT_DECLINED':
        return 'Your payment was declined. Please try a different payment method.';
      case 'CARD_EXPIRED':
        return 'Your card has expired. Please use a different payment method.';
      case 'INSUFFICIENT_FUNDS':
        return 'Insufficient funds. Please check your account balance.';
      case 'PAYMENT_METHOD_INVALID':
        return 'Payment method is invalid. Please select a different payment method.';
      case 'AUTHENTICATION_REQUIRED':
        return 'Additional authentication is required. Please complete the verification.';
      case 'NETWORK_ERROR':
        return 'Network error occurred. Please check your connection and try again.';
      default:
        return error.message.isNotEmpty ? error.message : 'Payment processing failed.';
    }
  }

  /// Handle enhanced checkout exceptions with better security messaging
  static String _getEnhancedCheckoutErrorMessage(EnhancedCheckoutException error) {
    switch (error.type) {
      case CheckoutErrorType.security:
        return 'Security verification required. Please try again.';
      case CheckoutErrorType.payment:
        return _getPaymentErrorByCode(error.code);
      case CheckoutErrorType.network:
        return 'Network connection issue. Please check your internet and try again.';
      case CheckoutErrorType.timeout:
        return 'Request timed out. Please try again.';
      case CheckoutErrorType.biometric:
        return 'Biometric authentication is required for secure payments.';
      case CheckoutErrorType.fraud:
        return 'Transaction blocked for security reasons. Please contact support.';
      case CheckoutErrorType.validation:
        return 'Please check your information and try again.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
  
  static String _getSecurityErrorMessage(SecurityException error) {
    switch (error.code) {
      case 'BIOMETRIC_REQUIRED':
        return 'Biometric authentication is required for this payment method.';
      case 'TOKEN_EXPIRED':
        return 'Security session expired. Please try again.';
      case 'FRAUD_DETECTED':
        return 'Security check failed. Please contact support.';
      case 'DEVICE_NOT_SECURE':
        return 'Device security verification failed. Please ensure your device is secure.';
      case 'SESSION_EXPIRED':
        return 'Your secure session has expired. Please start over.';
      default:
        return 'Security verification failed. Please try again.';
    }
  }

  static String _getArgumentErrorMessage(ArgumentError error) {
    final message = error.message?.toString() ?? '';
    
    if (message.contains('empty')) {
      return 'Required information is missing. Please fill in all fields.';
    } else if (message.contains('negative')) {
      return 'Invalid amount entered. Please check your order.';
    } else if (message.contains('scheduled time')) {
      return 'Please select a valid pickup time.';
    } else {
      return 'Invalid input provided. Please check your information.';
    }
  }

  /// Get network-specific error messages
  static String _getNetworkErrorMessage(dynamic error) {
    if (error is SocketException) {
      return 'Network connection unavailable. Please check your internet connection.';
    } else if (error is TimeoutException) {
      return 'Request timed out. Please try again.';
    }
    return 'Network error occurred. Please try again.';
  }
  
  /// Get payment error by code
  static String _getPaymentErrorByCode(String? code) {
    switch (code?.toLowerCase()) {
      case 'card_declined':
        return 'Your card was declined. Please try a different payment method.';
      case 'insufficient_funds':
        return 'Insufficient funds. Please check your account balance.';
      case 'expired_card':
        return 'Your card has expired. Please use a different payment method.';
      case 'invalid_cvv':
        return 'Invalid security code. Please check and try again.';
      case 'processing_error':
        return 'Payment processing error. Please try again.';
      case 'fraud_detected':
        return 'Transaction blocked for security reasons. Please contact support.';
      case 'wallet_insufficient':
        return 'Insufficient wallet balance. Please select a different wallet or add funds.';
      case 'biometric_failed':
        return 'Biometric authentication failed. Please try again.';
      default:
        return 'Payment failed. Please try again or use a different payment method.';
    }
  }
  
  static String _getGenericErrorMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    if (errorString.contains('network') || errorString.contains('connection')) {
      return 'Network connection error. Please check your internet connection.';
    } else if (errorString.contains('timeout')) {
      return 'Request timed out. Please try again.';
    } else if (errorString.contains('unauthorized') || errorString.contains('401')) {
      return 'Session expired. Please log in again.';
    } else if (errorString.contains('forbidden') || errorString.contains('403')) {
      return 'Access denied. Please contact support.';
    } else if (errorString.contains('not found') || errorString.contains('404')) {
      return 'Resource not found. Please try again.';
    } else if (errorString.contains('server') || errorString.contains('500')) {
      return 'Server error occurred. Please try again later.';
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }
  
  /// Sanitize error object to remove sensitive information
  static dynamic _sanitizeError(dynamic error) {
    if (error == null) return error;
    
    final errorString = error.toString();
    final sanitizedString = _sanitizeErrorString(errorString);
    
    // Return original error type but with sanitized string representation
    if (error is EnhancedCheckoutException) {
      return EnhancedCheckoutException(
        type: error.type,
        message: sanitizedString,
        code: error.code,
        timestamp: error.timestamp,
        isSensitive: false, // Mark as sanitized
      );
    }
    
    return sanitizedString;
  }
  
  /// Sanitize error strings to remove sensitive data
  static String _sanitizeErrorString(String errorString) {
    return errorString
        // Remove card numbers
        .replaceAll(RegExp(r'\b\d{4}\s?\d{4}\s?\d{4}\s?\d{4}\b'), '**** **** **** ****')
        // Remove CVV codes
        .replaceAll(RegExp(r'\b\d{3,4}\b'), '***')
        // Remove tokens and keys
        .replaceAll(RegExp(r'(token|key|secret)[\s:=]+[a-zA-Z0-9]+', caseSensitive: false), 'token: [REDACTED]')
        // Remove email addresses
        .replaceAll(RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b'), '[EMAIL]')
        // Remove URLs with sensitive params
        .replaceAll(RegExp(r'https?://[^\s]+'), '[URL]')
        // Remove phone numbers
        .replaceAll(RegExp(r'\b\d{3}-\d{3}-\d{4}\b'), '[PHONE]');
  }
  
  /// Create an enhanced checkout exception with proper categorization
  static EnhancedCheckoutException createException({
    required String message,
    String? code,
    Object? originalError,
    Map<String, dynamic>? metadata,
    bool isSensitive = false,
  }) {
    final type = _categorizeErrorType(message, originalError);
    
    return EnhancedCheckoutException(
      type: type,
      message: message,
      code: code,
      metadata: metadata,
      timestamp: DateTime.now(),
      isSensitive: isSensitive,
    );
  }
  
  /// Categorize error type based on content
  static CheckoutErrorType _categorizeErrorType(String message, Object? originalError) {
    final lowerMessage = message.toLowerCase();
    
    if (originalError is SocketException || lowerMessage.contains('network') || lowerMessage.contains('connection')) {
      return CheckoutErrorType.network;
    } else if (originalError is TimeoutException || lowerMessage.contains('timeout')) {
      return CheckoutErrorType.timeout;
    } else if (lowerMessage.contains('biometric') || lowerMessage.contains('fingerprint') || lowerMessage.contains('face id')) {
      return CheckoutErrorType.biometric;
    } else if (lowerMessage.contains('fraud') || lowerMessage.contains('suspicious') || lowerMessage.contains('blocked')) {
      return CheckoutErrorType.fraud;
    } else if (lowerMessage.contains('security') || lowerMessage.contains('auth') || lowerMessage.contains('token')) {
      return CheckoutErrorType.security;
    } else if (lowerMessage.contains('payment') || lowerMessage.contains('card') || lowerMessage.contains('wallet')) {
      return CheckoutErrorType.payment;
    } else if (lowerMessage.contains('validation') || lowerMessage.contains('invalid') || lowerMessage.contains('format')) {
      return CheckoutErrorType.validation;
    }
    
    return CheckoutErrorType.unknown;
  }
  
  /// Log error securely without exposing sensitive data
  static void logSecurely(Object error, [StackTrace? stackTrace]) {
    if (kDebugMode) {
      final sanitizedError = _sanitizeError(error);
      debugPrint('Secure Checkout Error: $sanitizedError');
      if (stackTrace != null) {
        debugPrint('Stack Trace: $stackTrace');
      }
    }
    
    // In production, send to secure logging service
    _sendToSecureLoggingService(error, stackTrace);
  }
  
  /// Send to secure logging service (placeholder)
  static void _sendToSecureLoggingService(Object error, StackTrace? stackTrace) {
    // In production: Firebase Crashlytics, Sentry, etc.
    // Ensure no PII or sensitive payment data is logged
  }
  
  /// Retry mechanism with exponential backoff
  static Future<T> withRetry<T>(
    Future<T> Function() operation, {
    int maxRetries = 3,
    Duration baseDelay = const Duration(seconds: 1),
    double backoffFactor = 2.0,
    bool Function(Object)? retryIf,
  }) async {
    int attempt = 0;
    Duration delay = baseDelay;
    
    while (attempt < maxRetries) {
      try {
        return await operation();
      } catch (error) {
        attempt++;
        
        // Log retry attempt securely
        logSecurely('Retry attempt $attempt/$maxRetries for operation');
        
        // Check if we should retry
        if (attempt >= maxRetries || (retryIf != null && !retryIf(error))) {
          rethrow;
        }
        
        // Wait before retrying with exponential backoff
        await Future.delayed(delay);
        delay = Duration(milliseconds: (delay.inMilliseconds * backoffFactor).round());
      }
    }
    
    throw EnhancedCheckoutException(
      type: CheckoutErrorType.unknown,
      message: 'Max retries exceeded',
      timestamp: DateTime.now(),
    );
  }
  
  /// Check if error should be retried
  static bool isRetryableError(Object error) {
    if (error is SocketException || error is TimeoutException) return true;
    if (error is EnhancedCheckoutException) {
      return error.type == CheckoutErrorType.network || 
             error.type == CheckoutErrorType.timeout;
    }
    
    final message = error.toString().toLowerCase();
    return message.contains('network') || 
           message.contains('timeout') || 
           message.contains('connection') ||
           message.contains('temporary');
  }

  /// Show secure error dialog with proper categorization
  static Future<bool> showSecureErrorDialog({
    required BuildContext context,
    required Object error,
    VoidCallback? onRetry,
  }) async {
    final errorContent = _getErrorDialogContent(error);
    return await showErrorDialog(
      context: context,
      title: errorContent['title']!,
      message: errorContent['message']!,
      showRetry: isRetryableError(error),
      onRetry: onRetry,
    );
  }
  
  /// Get error dialog content based on error type
  static Map<String, String> _getErrorDialogContent(Object error) {
    if (error is EnhancedCheckoutException) {
      switch (error.type) {
        case CheckoutErrorType.network:
          return {
            'title': 'Connection Error',
            'message': 'Please check your internet connection and try again.',
          };
        case CheckoutErrorType.security:
          return {
            'title': 'Security Error',
            'message': 'Security verification failed. Please try again.',
          };
        case CheckoutErrorType.payment:
          return {
            'title': 'Payment Error',
            'message': getSecureErrorMessage(error),
          };
        case CheckoutErrorType.biometric:
          return {
            'title': 'Authentication Required',
            'message': 'Biometric authentication is required for secure payments.',
          };
        case CheckoutErrorType.fraud:
          return {
            'title': 'Security Alert',
            'message': 'Transaction blocked for security reasons. Please contact support.',
          };
        default:
          return {
            'title': 'Error',
            'message': getSecureErrorMessage(error),
          };
      }
    }
    
    return {
      'title': 'Error',
      'message': getSecureErrorMessage(error),
    };
  }
  
  /// Show error dialog with retry option
  static Future<bool> showErrorDialog({
    required BuildContext context,
    required String title,
    required String message,
    bool showRetry = true,
    VoidCallback? onRetry,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFFFEFEFF),
            ),
          ),
          content: Text(
            message,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF9C9C9D),
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF9C9C9D),
                ),
              ),
            ),
            if (showRetry)
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  onRetry?.call();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFFBF1),
                  foregroundColor: const Color(0xFF242424),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Retry',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        );
      },
    );

    return result ?? false;
  }

  /// Show error snackbar with quick dismiss
  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFE53E3E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// Show success snackbar
  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Convenience method to handle any error and show appropriate message
  static void handleError(BuildContext context, dynamic error) {
    // Log error securely first
    logSecurely(error);
    
    final message = getSecureErrorMessage(error);
    showErrorSnackBar(context, message);
  }
  
  /// Handle error with security considerations and optional callback
  static Future<void> handleSecureError({
    required BuildContext context,
    required Object error,
    bool showDialog = false,
    VoidCallback? onRetry,
  }) async {
    // Log error securely
    logSecurely(error);
    
    if (showDialog) {
      await showSecureErrorDialog(
        context: context,
        error: error,
        onRetry: onRetry,
      );
    } else {
      final message = getSecureErrorMessage(error);
      showErrorSnackBar(context, message);
    }
  }
}