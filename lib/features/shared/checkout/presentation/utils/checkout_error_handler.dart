import 'package:flutter/material.dart';
import '../../domain/usecases/checkout_usecases.dart';

/// Utility class for handling checkout-specific errors with user-friendly messages
class CheckoutErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error is CheckoutException) {
      return _getCheckoutErrorMessage(error);
    } else if (error is PaymentException) {
      return _getPaymentErrorMessage(error);
    } else if (error is SecurityException) {
      return _getSecurityErrorMessage(error);
    } else if (error is ArgumentError) {
      return _getArgumentErrorMessage(error);
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

  static String _getSecurityErrorMessage(SecurityException error) {
    switch (error.code) {
      case 'BIOMETRIC_REQUIRED':
        return 'Biometric authentication is required for this payment method.';
      case 'TOKEN_EXPIRED':
        return 'Security token has expired. Please refresh and try again.';
      case 'FRAUD_DETECTED':
        return 'Security check failed. Please contact support.';
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
    final message = getErrorMessage(error);
    showErrorSnackBar(context, message);
  }
}