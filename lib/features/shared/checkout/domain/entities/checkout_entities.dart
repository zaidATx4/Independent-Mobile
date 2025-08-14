import 'package:meta/meta.dart';

/// Base abstract class for all checkout-related entities
abstract class CheckoutEntity {
  const CheckoutEntity();
}

/// Entity representing pickup location details
@immutable
class PickupLocationEntity extends CheckoutEntity {
  final String id;
  final String name;
  final String address;
  final String brandLogoPath;
  final double latitude;
  final double longitude;
  final bool isActive;
  final Map<String, dynamic>? metadata;

  const PickupLocationEntity({
    required this.id,
    required this.name,
    required this.address,
    required this.brandLogoPath,
    required this.latitude,
    required this.longitude,
    this.isActive = true,
    this.metadata,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PickupLocationEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'PickupLocationEntity(id: $id, name: $name, address: $address)';
}

/// Enum for pickup time types
enum PickupTimeType {
  now,
  later,
}

/// Entity representing pickup time selection
@immutable
class PickupTimeEntity extends CheckoutEntity {
  final PickupTimeType type;
  final DateTime? scheduledTime;
  final String displayText;
  final String description;

  const PickupTimeEntity({
    required this.type,
    this.scheduledTime,
    required this.displayText,
    required this.description,
  });

  /// Factory constructor for "Pick Up Now" option
  factory PickupTimeEntity.now() {
    return const PickupTimeEntity(
      type: PickupTimeType.now,
      displayText: 'Pick Up Now',
      description: 'Get your order as soon as possible',
    );
  }

  /// Factory constructor for "Pick Up Later" option
  factory PickupTimeEntity.later(DateTime scheduledTime) {
    return PickupTimeEntity(
      type: PickupTimeType.later,
      scheduledTime: scheduledTime,
      displayText: 'Pick Up Later',
      description: 'Choose a date and time that suits you.',
    );
  }

  bool get isNow => type == PickupTimeType.now;
  bool get isLater => type == PickupTimeType.later;
  bool get hasScheduledTime => scheduledTime != null;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PickupTimeEntity &&
        other.type == type &&
        other.scheduledTime == scheduledTime;
  }

  @override
  int get hashCode => Object.hash(type, scheduledTime);

  @override
  String toString() => 'PickupTimeEntity(type: $type, scheduledTime: $scheduledTime)';
}

/// Enum for payment method types
enum PaymentMethodType {
  card,
  applePay,
  googlePay,
  cash,
  wallet,
}

/// Entity representing payment method with security considerations
@immutable
class PaymentMethodEntity extends CheckoutEntity {
  final String id;
  final PaymentMethodType type;
  final String displayName;
  final String? lastFourDigits; // Only store last 4 digits for cards
  final String? cardBrand; // Visa, Mastercard, etc.
  final String? iconPath;
  final bool isDefault;
  final bool requiresBiometric;
  final Map<String, dynamic>? secureMetadata;

  const PaymentMethodEntity({
    required this.id,
    required this.type,
    required this.displayName,
    this.lastFourDigits,
    this.cardBrand,
    this.iconPath,
    this.isDefault = false,
    this.requiresBiometric = false,
    this.secureMetadata,
  });

  bool get isCard => type == PaymentMethodType.card;
  bool get isDigitalWallet => type == PaymentMethodType.applePay || type == PaymentMethodType.googlePay;
  bool get isCash => type == PaymentMethodType.cash;
  bool get isWallet => type == PaymentMethodType.wallet;

  String get maskedCardNumber => lastFourDigits != null ? '**** **** **** $lastFourDigits' : '';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PaymentMethodEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'PaymentMethodEntity(id: $id, type: $type, displayName: $displayName)';
}

/// Entity representing the complete pickup details
@immutable
class PickupDetailsEntity extends CheckoutEntity {
  final PickupLocationEntity location;
  final PickupTimeEntity pickupTime;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PickupDetailsEntity({
    required this.location,
    required this.pickupTime,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isValid => location.isActive;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PickupDetailsEntity &&
        other.location == location &&
        other.pickupTime == pickupTime;
  }

  @override
  int get hashCode => Object.hash(location, pickupTime);

  @override
  String toString() => 'PickupDetailsEntity(location: ${location.name}, pickupTime: ${pickupTime.type})';
}

/// Enum for checkout status
enum CheckoutStatus {
  initial,
  pickupDetailsSet,
  paymentMethodSelected,
  processing,
  completed,
  failed,
  cancelled,
}

/// Entity representing the complete checkout state
@immutable
class CheckoutStateEntity extends CheckoutEntity {
  final String id;
  final CheckoutStatus status;
  final PickupDetailsEntity? pickupDetails;
  final PaymentMethodEntity? paymentMethod;
  final double subtotal;
  final double tax;
  final double total;
  final String currency;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? errorMessage;
  final Map<String, dynamic>? metadata;

  const CheckoutStateEntity({
    required this.id,
    required this.status,
    this.pickupDetails,
    this.paymentMethod,
    required this.subtotal,
    required this.tax,
    required this.total,
    this.currency = 'SAR',
    required this.createdAt,
    this.completedAt,
    this.errorMessage,
    this.metadata,
  });

  bool get canProceed => pickupDetails != null && pickupDetails!.isValid;
  bool get canCompletePayment => canProceed && paymentMethod != null;
  bool get isInProgress => status == CheckoutStatus.processing;
  bool get isCompleted => status == CheckoutStatus.completed;
  bool get isFailed => status == CheckoutStatus.failed;
  bool get isCancelled => status == CheckoutStatus.cancelled;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CheckoutStateEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'CheckoutStateEntity(id: $id, status: $status, total: $total $currency)';
}

/// Entity representing the result of checkout completion
@immutable
class CheckoutResultEntity extends CheckoutEntity {
  final bool success;
  final String? orderId;
  final String? transactionId;
  final String? message;
  final CheckoutStateEntity? checkout;
  final DateTime timestamp;
  final Map<String, dynamic>? data;

  const CheckoutResultEntity({
    required this.success,
    this.orderId,
    this.transactionId,
    this.message,
    this.checkout,
    required this.timestamp,
    this.data,
  });

  @override
  String toString() => 'CheckoutResultEntity(success: $success, orderId: $orderId, message: $message)';
}