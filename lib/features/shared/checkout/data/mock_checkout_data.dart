/// Mock data for checkout development and testing
/// This file provides sample data that matches the Figma design specifications

import '../domain/entities/checkout_entities.dart';

/// Mock pickup locations matching the Figma design
class MockCheckoutData {
  static const List<PickupLocationEntity> pickupLocations = [
    PickupLocationEntity(
      id: 'salt-mall-emirates',
      name: 'Mall of the Emirates',
      address: 'North Beach, Jumeirah 1, Dubai, UAE',
      brandLogoPath: 'assets/images/logos/brands/Salt.png',
      latitude: 25.2048,
      longitude: 55.2708,
      isActive: true,
      metadata: {
        'brand': 'Salt',
        'opening_hours': '10:00-22:00',
        'phone': '+971 4 123 4567',
      },
    ),
    PickupLocationEntity(
      id: 'joe-juice-downtown',
      name: 'Downtown Dubai',
      address: 'Dubai Mall, Downtown, Dubai, UAE',
      brandLogoPath: 'assets/images/logos/brands/Joe_and _juice.png',
      latitude: 25.1972,
      longitude: 55.2744,
      isActive: true,
      metadata: {
        'brand': 'Joe & The Juice',
        'opening_hours': '08:00-23:00',
        'phone': '+971 4 987 6543',
      },
    ),
    PickupLocationEntity(
      id: 'somewhere-jbr',
      name: 'Jumeirah Beach Residence',
      address: 'JBR, Dubai Marina, Dubai, UAE',
      brandLogoPath: 'assets/images/logos/brands/Somewhere.png',
      latitude: 25.0657,
      longitude: 55.1377,
      isActive: true,
      metadata: {
        'brand': 'Somewhere',
        'opening_hours': '09:00-24:00',
        'phone': '+971 4 555 0123',
      },
    ),
  ];

  static const List<PaymentMethodEntity> paymentMethods = [
    PaymentMethodEntity(
      id: 'card-visa-1234',
      type: PaymentMethodType.card,
      displayName: 'Visa ending in 1234',
      lastFourDigits: '1234',
      cardBrand: 'Visa',
      iconPath: 'assets/images/icons/Payment_Methods/Visa.svg',
      isDefault: true,
      requiresBiometric: true,
      secureMetadata: {
        'token': 'tok_visa_1234567890',
        'provider': 'stripe',
      },
    ),
    PaymentMethodEntity(
      id: 'card-mastercard-5678',
      type: PaymentMethodType.card,
      displayName: 'Mastercard ending in 5678',
      lastFourDigits: '5678',
      cardBrand: 'Mastercard',
      iconPath: 'assets/images/icons/Payment_Methods/Mastercard.svg',
      isDefault: false,
      requiresBiometric: true,
      secureMetadata: {
        'token': 'tok_mc_0987654321',
        'provider': 'stripe',
      },
    ),
    PaymentMethodEntity(
      id: 'apple-pay-001',
      type: PaymentMethodType.applePay,
      displayName: 'Apple Pay',
      iconPath: 'assets/images/icons/Payment_Methods/Apple_Pay.svg',
      isDefault: false,
      requiresBiometric: true,
      secureMetadata: {
        'device_id': 'device_apple_12345',
        'provider': 'apple',
      },
    ),
    PaymentMethodEntity(
      id: 'google-pay-001',
      type: PaymentMethodType.googlePay,
      displayName: 'Google Pay',
      iconPath: 'assets/images/icons/Payment_Methods/Google_Pay.svg',
      isDefault: false,
      requiresBiometric: false,
      secureMetadata: {
        'account_id': 'google_pay_67890',
        'provider': 'google',
      },
    ),
    PaymentMethodEntity(
      id: 'wallet-balance',
      type: PaymentMethodType.wallet,
      displayName: 'Wallet Balance (SAR 250.00)',
      iconPath: 'assets/images/icons/Payment_Methods/Wallet.svg',
      isDefault: false,
      requiresBiometric: false,
      secureMetadata: {
        'balance': '250.00',
        'currency': 'SAR',
      },
    ),
  ];

  /// Generate mock checkout with sample totals
  static CheckoutStateEntity createMockCheckout({
    double subtotal = 100.0,
    double tax = 15.0,
    String currency = 'SAR',
  }) {
    final total = subtotal + tax;
    final now = DateTime.now();

    return CheckoutStateEntity(
      id: 'checkout_${now.millisecondsSinceEpoch}',
      status: CheckoutStatus.initial,
      subtotal: subtotal,
      tax: tax,
      total: total,
      currency: currency,
      createdAt: now,
      metadata: {
        'session_id': 'sess_${now.millisecondsSinceEpoch}',
        'user_id': 'user_demo',
        'app_version': '1.0.0',
      },
    );
  }

  /// Generate mock pickup time options
  static List<PickupTimeEntity> getPickupTimeOptions() {
    final now = DateTime.now();
    
    return [
      PickupTimeEntity.now(),
      PickupTimeEntity.later(now.add(const Duration(hours: 1))),
      PickupTimeEntity.later(now.add(const Duration(hours: 2))),
      PickupTimeEntity.later(now.add(const Duration(hours: 3))),
    ];
  }

  /// Generate mock fees calculation
  static Map<String, double> getMockFees({
    PickupTimeType pickupType = PickupTimeType.now,
    String locationId = 'salt-mall-emirates',
  }) {
    // Simulate different fees based on pickup type and location
    final baseFee = pickupType == PickupTimeType.now ? 0.0 : 5.0;
    final locationFee = locationId.contains('downtown') ? 3.0 : 0.0;
    
    return {
      'service_fee': baseFee,
      'location_fee': locationFee,
      'total_fees': baseFee + locationFee,
    };
  }

  /// Generate successful checkout result
  static CheckoutResultEntity createSuccessResult({
    String? orderId,
    String? transactionId,
  }) {
    return CheckoutResultEntity(
      success: true,
      orderId: orderId ?? 'ORDER_${DateTime.now().millisecondsSinceEpoch}',
      transactionId: transactionId ?? 'TXN_${DateTime.now().millisecondsSinceEpoch}',
      message: 'Payment processed successfully',
      timestamp: DateTime.now(),
      data: {
        'confirmation_code': 'CONF${DateTime.now().millisecondsSinceEpoch}',
        'estimated_ready_time': DateTime.now().add(const Duration(minutes: 15)).toIso8601String(),
      },
    );
  }

  /// Generate failed checkout result
  static CheckoutResultEntity createFailureResult({
    String? reason,
  }) {
    return CheckoutResultEntity(
      success: false,
      message: reason ?? 'Payment processing failed',
      timestamp: DateTime.now(),
      data: {
        'error_code': 'PAYMENT_DECLINED',
        'retry_allowed': true,
      },
    );
  }

  /// Sample cart data for checkout initialization
  static Map<String, dynamic> getSampleCartData() {
    return {
      'items': [
        {
          'id': 'item_001',
          'name': 'Classic Burger',
          'price': 45.0,
          'quantity': 2,
        },
        {
          'id': 'item_002',
          'name': 'French Fries',
          'price': 15.0,
          'quantity': 1,
        },
        {
          'id': 'item_003',
          'name': 'Soft Drink',
          'price': 10.0,
          'quantity': 2,
        },
      ],
      'subtotal': 115.0,
      'tax': 17.25, // 15% VAT
      'total': 132.25,
      'currency': 'SAR',
    };
  }

  /// Simulate network delays for development testing
  static Future<T> simulateNetworkDelay<T>(T value, {
    Duration delay = const Duration(milliseconds: 1500),
  }) async {
    await Future.delayed(delay);
    return value;
  }

  /// Simulate network errors for testing error handling
  static Future<T> simulateNetworkError<T>({
    String message = 'Network connection failed',
    Duration delay = const Duration(milliseconds: 1000),
  }) async {
    await Future.delayed(delay);
    throw Exception(message);
  }

  /// Validate mock data matches Figma design
  static bool validateFigmaCompliance() {
    // Check that mock data has the required fields for Figma design
    final saltLocation = pickupLocations.first;
    
    return saltLocation.name == 'Mall of the Emirates' &&
           saltLocation.address.contains('Jumeirah') &&
           saltLocation.brandLogoPath.contains('Salt') &&
           paymentMethods.isNotEmpty &&
           paymentMethods.any((method) => method.type == PaymentMethodType.card);
  }
}