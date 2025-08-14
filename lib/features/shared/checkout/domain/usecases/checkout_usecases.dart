import '../entities/checkout_entities.dart';
import '../repositories/checkout_repository.dart';

/// Base class for all checkout use cases
abstract class CheckoutUseCase<Type, Params> {
  Future<Type> call(Params params);
}

/// Use case for getting pickup locations
class GetPickupLocationsUseCase extends CheckoutUseCase<List<PickupLocationEntity>, GetPickupLocationsParams> {
  final CheckoutRepository _repository;

  GetPickupLocationsUseCase(this._repository);

  @override
  Future<List<PickupLocationEntity>> call(GetPickupLocationsParams params) async {
    final locations = await _repository.getPickupLocations(
      brandId: params.brandId,
      locationId: params.locationId,
    );

    // Additional business logic validation
    return locations.where((location) => location.isActive).toList();
  }
}

class GetPickupLocationsParams {
  final String? brandId;
  final String? locationId;

  const GetPickupLocationsParams({
    this.brandId,
    this.locationId,
  });
}

/// Use case for getting pickup location by ID
class GetPickupLocationByIdUseCase extends CheckoutUseCase<PickupLocationEntity?, String> {
  final CheckoutRepository _repository;

  GetPickupLocationByIdUseCase(this._repository);

  @override
  Future<PickupLocationEntity?> call(String locationId) async {
    if (locationId.trim().isEmpty) {
      throw ArgumentError('Location ID cannot be empty');
    }

    final location = await _repository.getPickupLocationById(locationId);
    
    // Validate location is active
    if (location != null && !location.isActive) {
      throw Exception('Location is not available');
    }

    return location;
  }
}

/// Use case for getting payment methods
class GetPaymentMethodsUseCase extends CheckoutUseCase<List<PaymentMethodEntity>, NoParams> {
  final CheckoutRepository _repository;

  GetPaymentMethodsUseCase(this._repository);

  @override
  Future<List<PaymentMethodEntity>> call(NoParams params) async {
    return await _repository.getPaymentMethods();
  }
}

/// Use case for adding payment method with security validation
class AddPaymentMethodUseCase extends CheckoutUseCase<PaymentMethodEntity, AddPaymentMethodParams> {
  final CheckoutRepository _repository;

  AddPaymentMethodUseCase(this._repository);

  @override
  Future<PaymentMethodEntity> call(AddPaymentMethodParams params) async {
    // Security validation
    _validatePaymentData(params.type, params.securePaymentData);

    return await _repository.addPaymentMethod(
      type: params.type,
      securePaymentData: params.securePaymentData,
    );
  }

  void _validatePaymentData(PaymentMethodType type, Map<String, dynamic> paymentData) {
    switch (type) {
      case PaymentMethodType.card:
        if (!paymentData.containsKey('token') || paymentData['token'] == null) {
          throw ArgumentError('Card token is required for card payments');
        }
        break;
      case PaymentMethodType.applePay:
      case PaymentMethodType.googlePay:
        if (!paymentData.containsKey('payment_token') || paymentData['payment_token'] == null) {
          throw ArgumentError('Payment token is required for digital wallet payments');
        }
        break;
      default:
        break;
    }
  }
}

class AddPaymentMethodParams {
  final PaymentMethodType type;
  final Map<String, dynamic> securePaymentData;

  const AddPaymentMethodParams({
    required this.type,
    required this.securePaymentData,
  });
}

/// Use case for creating a new checkout session
class CreateCheckoutUseCase extends CheckoutUseCase<CheckoutStateEntity, CreateCheckoutParams> {
  final CheckoutRepository _repository;

  CreateCheckoutUseCase(this._repository);

  @override
  Future<CheckoutStateEntity> call(CreateCheckoutParams params) async {
    // Business logic validation
    if (params.subtotal < 0) {
      throw ArgumentError('Subtotal cannot be negative');
    }
    if (params.tax < 0) {
      throw ArgumentError('Tax cannot be negative');
    }
    if (params.total < params.subtotal) {
      throw ArgumentError('Total cannot be less than subtotal');
    }

    return await _repository.createCheckout(
      subtotal: params.subtotal,
      tax: params.tax,
      total: params.total,
      currency: params.currency,
      metadata: params.metadata,
    );
  }
}

class CreateCheckoutParams {
  final double subtotal;
  final double tax;
  final double total;
  final String currency;
  final Map<String, dynamic>? metadata;

  const CreateCheckoutParams({
    required this.subtotal,
    required this.tax,
    required this.total,
    this.currency = 'SAR',
    this.metadata,
  });
}

/// Use case for updating pickup details
class UpdatePickupDetailsUseCase extends CheckoutUseCase<CheckoutStateEntity, UpdatePickupDetailsParams> {
  final CheckoutRepository _repository;

  UpdatePickupDetailsUseCase(this._repository);

  @override
  Future<CheckoutStateEntity> call(UpdatePickupDetailsParams params) async {
    // Validate pickup details
    if (!params.pickupDetails.isValid) {
      throw Exception('Invalid pickup details');
    }

    // Validate pickup time for "later" option
    if (params.pickupDetails.pickupTime.type == PickupTimeType.later) {
      final scheduledTime = params.pickupDetails.pickupTime.scheduledTime;
      if (scheduledTime == null) {
        throw ArgumentError('Scheduled time is required for "Pick Up Later" option');
      }
      
      if (scheduledTime.isBefore(DateTime.now().add(const Duration(minutes: 30)))) {
        throw ArgumentError('Pickup time must be at least 30 minutes from now');
      }

      // Validate time slot availability
      final isAvailable = await _repository.validatePickupTimeSlot(
        params.pickupDetails.location.id,
        scheduledTime,
      );
      
      if (!isAvailable) {
        throw Exception('Selected pickup time slot is not available');
      }
    }

    return await _repository.updatePickupDetails(
      params.checkoutId,
      params.pickupDetails,
    );
  }
}

class UpdatePickupDetailsParams {
  final String checkoutId;
  final PickupDetailsEntity pickupDetails;

  const UpdatePickupDetailsParams({
    required this.checkoutId,
    required this.pickupDetails,
  });
}

/// Use case for updating payment method
class UpdatePaymentMethodUseCase extends CheckoutUseCase<CheckoutStateEntity, UpdatePaymentMethodParams> {
  final CheckoutRepository _repository;

  UpdatePaymentMethodUseCase(this._repository);

  @override
  Future<CheckoutStateEntity> call(UpdatePaymentMethodParams params) async {
    // Verify payment method exists and is valid
    final isValid = await _repository.verifyPaymentMethod(params.paymentMethodId);
    if (!isValid) {
      throw Exception('Invalid or expired payment method');
    }

    return await _repository.updatePaymentMethod(
      params.checkoutId,
      params.paymentMethodId,
    );
  }
}

class UpdatePaymentMethodParams {
  final String checkoutId;
  final String paymentMethodId;

  const UpdatePaymentMethodParams({
    required this.checkoutId,
    required this.paymentMethodId,
  });
}

/// Use case for processing payment with security checks
class ProcessPaymentUseCase extends CheckoutUseCase<CheckoutResultEntity, String> {
  final CheckoutRepository _repository;

  ProcessPaymentUseCase(this._repository);

  @override
  Future<CheckoutResultEntity> call(String checkoutId) async {
    // Get and validate checkout
    final checkout = await _repository.getCheckout(checkoutId);
    if (checkout == null) {
      throw Exception('Checkout not found');
    }

    if (!checkout.canCompletePayment) {
      throw Exception('Checkout is not ready for payment. Missing pickup details or payment method.');
    }

    if (checkout.isInProgress) {
      throw Exception('Payment is already being processed');
    }

    if (checkout.isCompleted) {
      throw Exception('Payment has already been completed');
    }

    // Additional security validation
    if (checkout.paymentMethod?.requiresBiometric == true) {
      // In a real implementation, this would trigger biometric authentication
      // For now, we'll assume it's handled at the UI level
    }

    try {
      final result = await _repository.processPayment(checkoutId);
      
      if (!result.success) {
        throw Exception(result.message ?? 'Payment processing failed');
      }

      return result;
    } catch (e) {
      // Log the error securely (without exposing sensitive data)
      rethrow;
    }
  }
}

/// Use case for validating pickup time slot
class ValidatePickupTimeSlotUseCase extends CheckoutUseCase<bool, ValidatePickupTimeSlotParams> {
  final CheckoutRepository _repository;

  ValidatePickupTimeSlotUseCase(this._repository);

  @override
  Future<bool> call(ValidatePickupTimeSlotParams params) async {
    // Business logic validation
    if (params.pickupTime.isBefore(DateTime.now())) {
      return false; // Cannot schedule pickup in the past
    }

    if (params.pickupTime.isBefore(DateTime.now().add(const Duration(minutes: 30)))) {
      return false; // Minimum 30 minutes notice required
    }

    return await _repository.validatePickupTimeSlot(
      params.locationId,
      params.pickupTime,
    );
  }
}

class ValidatePickupTimeSlotParams {
  final String locationId;
  final DateTime pickupTime;

  const ValidatePickupTimeSlotParams({
    required this.locationId,
    required this.pickupTime,
  });
}

/// Use case for calculating fees
class CalculateFeesUseCase extends CheckoutUseCase<Map<String, double>, CalculateFeesParams> {
  final CheckoutRepository _repository;

  CalculateFeesUseCase(this._repository);

  @override
  Future<Map<String, double>> call(CalculateFeesParams params) async {
    // Validate scheduled time for "later" pickup
    if (params.pickupType == PickupTimeType.later && params.scheduledTime == null) {
      throw ArgumentError('Scheduled time is required for "Pick Up Later" option');
    }

    return await _repository.calculateFees(
      locationId: params.locationId,
      pickupType: params.pickupType,
      scheduledTime: params.scheduledTime,
    );
  }
}

class CalculateFeesParams {
  final String locationId;
  final PickupTimeType pickupType;
  final DateTime? scheduledTime;

  const CalculateFeesParams({
    required this.locationId,
    required this.pickupType,
    this.scheduledTime,
  });
}

/// Use case for getting checkout by ID
class GetCheckoutUseCase extends CheckoutUseCase<CheckoutStateEntity?, String> {
  final CheckoutRepository _repository;

  GetCheckoutUseCase(this._repository);

  @override
  Future<CheckoutStateEntity?> call(String checkoutId) async {
    if (checkoutId.trim().isEmpty) {
      throw ArgumentError('Checkout ID cannot be empty');
    }

    return await _repository.getCheckout(checkoutId);
  }
}

/// Use case for canceling checkout
class CancelCheckoutUseCase extends CheckoutUseCase<bool, String> {
  final CheckoutRepository _repository;

  CancelCheckoutUseCase(this._repository);

  @override
  Future<bool> call(String checkoutId) async {
    if (checkoutId.trim().isEmpty) {
      throw ArgumentError('Checkout ID cannot be empty');
    }

    // Get checkout to validate it can be cancelled
    final checkout = await _repository.getCheckout(checkoutId);
    if (checkout == null) {
      throw Exception('Checkout not found');
    }

    if (checkout.isCompleted) {
      throw Exception('Cannot cancel completed checkout');
    }

    if (checkout.isCancelled) {
      return true; // Already cancelled
    }

    return await _repository.cancelCheckout(checkoutId);
  }
}

/// No parameters class for use cases that don't need parameters
class NoParams {
  const NoParams();
}

/// Exception classes for checkout-specific errors
class CheckoutException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const CheckoutException(
    this.message, {
    this.code,
    this.details,
  });

  @override
  String toString() => 'CheckoutException: $message';
}

class PaymentException extends CheckoutException {
  const PaymentException(
    super.message, {
    super.code,
    super.details,
  });

  @override
  String toString() => 'PaymentException: $message';
}

class SecurityException extends CheckoutException {
  const SecurityException(
    super.message, {
    super.code,
    super.details,
  });

  @override
  String toString() => 'SecurityException: $message';
}