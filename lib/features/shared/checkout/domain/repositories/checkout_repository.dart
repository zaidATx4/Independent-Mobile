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
}