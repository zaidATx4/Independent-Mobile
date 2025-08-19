import '../entities/checkout_entities.dart';

/// Abstract repository interface for checkout operations
/// Defines the contract for secure checkout functionality
abstract class CheckoutRepository {
  /// Retrieve available pickup locations for a given brand or location
  Future<List<PickupLocationEntity>> getPickupLocations({
    String? brandId,
    String? locationId,
  });

  /// Get a specific pickup location by ID
  Future<PickupLocationEntity?> getPickupLocationById(String locationId);

  /// Retrieve available payment methods for the user
  /// Returns sanitized payment methods (no sensitive data)
  Future<List<PaymentMethodEntity>> getPaymentMethods();

  /// Add a new payment method (requires secure tokenization)
  /// Should handle PCI DSS compliance for card tokenization
  Future<PaymentMethodEntity> addPaymentMethod({
    required PaymentMethodType type,
    required Map<String, dynamic> securePaymentData,
  });

  /// Remove a payment method by ID
  Future<bool> removePaymentMethod(String paymentMethodId);

  /// Set default payment method
  Future<bool> setDefaultPaymentMethod(String paymentMethodId);

  /// Create a new checkout session
  Future<CheckoutStateEntity> createCheckout({
    required double subtotal,
    required double tax,
    required double total,
    String currency = 'SAR',
    Map<String, dynamic>? metadata,
  });

  /// Update pickup details for a checkout
  Future<CheckoutStateEntity> updatePickupDetails(
    String checkoutId,
    PickupDetailsEntity pickupDetails,
  );

  /// Update payment method for a checkout
  Future<CheckoutStateEntity> updatePaymentMethod(
    String checkoutId,
    String paymentMethodId,
  );

  /// Process the checkout payment
  /// This method should handle secure payment processing
  Future<CheckoutResultEntity> processPayment(String checkoutId);

  /// Get checkout by ID
  Future<CheckoutStateEntity?> getCheckout(String checkoutId);

  /// Cancel a checkout
  Future<bool> cancelCheckout(String checkoutId);

  /// Get checkout history for the user
  Future<List<CheckoutStateEntity>> getCheckoutHistory({
    int limit = 20,
    int offset = 0,
  });

  /// Validate pickup time slot availability
  Future<bool> validatePickupTimeSlot(
    String locationId,
    DateTime pickupTime,
  );

  /// Calculate delivery/pickup fees based on location and time
  Future<Map<String, double>> calculateFees({
    required String locationId,
    required PickupTimeType pickupType,
    DateTime? scheduledTime,
  });

  /// Verify payment method before processing
  Future<bool> verifyPaymentMethod(String paymentMethodId);

  /// Handle payment authentication (e.g., 3D Secure)
  Future<Map<String, dynamic>> authenticatePayment({
    required String checkoutId,
    required String paymentMethodId,
    Map<String, dynamic>? authData,
  });

  /// Store encrypted order details locally for offline access
  Future<void> cacheCheckoutLocally(CheckoutStateEntity checkout);

  /// Clear local checkout cache
  Future<void> clearCheckoutCache();

  // Wallet-related methods

  /// Get user wallets with security validation
  /// Returns only active and accessible wallets
  Future<List<WalletEntity>> getUserWallets(String userId);

  /// Get specific wallet by ID with security checks
  Future<WalletEntity?> getWalletById(String walletId);

  /// Validate wallet transaction before processing
  /// Performs security checks and balance validation
  Future<bool> validateWalletTransaction({
    required String walletId,
    required double amount,
    String currency = 'SAR',
  });

  /// Process wallet payment with atomic transaction handling
  /// Ensures rollback capability on failure
  Future<CheckoutResultEntity> processWalletPayment({
    required String checkoutId,
    required String walletId,
    required double amount,
    String currency = 'SAR',
    Map<String, dynamic>? metadata,
  });

  /// Rollback wallet transaction in case of failure
  /// Critical for maintaining transaction integrity
  Future<bool> rollbackWalletTransaction(String checkoutId, String walletId);

  /// Get wallet transaction history for audit purposes
  Future<List<Map<String, dynamic>>> getWalletTransactionHistory({
    required String walletId,
    int limit = 20,
    int offset = 0,
  });

  /// Refresh wallet balance securely
  Future<WalletEntity> refreshWalletBalance(String walletId);

  /// Lock wallet for transaction processing
  /// Prevents concurrent transactions on the same wallet
  Future<bool> lockWallet(String walletId, String transactionId);

  /// Unlock wallet after transaction completion
  Future<bool> unlockWallet(String walletId, String transactionId);
}