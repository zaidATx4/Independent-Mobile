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
  awaitingPayment,
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

  /// Create a copy of this entity with updated fields
  CheckoutStateEntity copyWith({
    String? id,
    CheckoutStatus? status,
    PickupDetailsEntity? pickupDetails,
    PaymentMethodEntity? paymentMethod,
    double? subtotal,
    double? tax,
    double? total,
    String? currency,
    DateTime? createdAt,
    DateTime? completedAt,
    String? errorMessage,
    Map<String, dynamic>? metadata,
  }) {
    return CheckoutStateEntity(
      id: id ?? this.id,
      status: status ?? this.status,
      pickupDetails: pickupDetails ?? this.pickupDetails,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      currency: currency ?? this.currency,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      errorMessage: errorMessage ?? this.errorMessage,
      metadata: metadata ?? this.metadata,
    );
  }

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

/// Enum for wallet types
enum WalletType {
  teamLunch,
  personal,
  corporate,
  giftCard,
}

/// Entity representing a user wallet for payment
@immutable
class WalletEntity extends CheckoutEntity {
  final String id;
  final String name;
  final WalletType type;
  final double balance;
  final String currency;
  final String? description;
  final String? iconPath;
  final bool isActive;
  final bool requiresBiometric;
  final DateTime? expiryDate;
  final Map<String, dynamic>? metadata;

  const WalletEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
    this.currency = 'SAR',
    this.description,
    this.iconPath,
    this.isActive = true,
    this.requiresBiometric = false,
    this.expiryDate,
    this.metadata,
  });

  bool get isExpired => expiryDate != null && DateTime.now().isAfter(expiryDate!);
  bool get hasInsufficientBalance => balance <= 0;
  bool get canBeUsed => isActive && !isExpired && !hasInsufficientBalance;
  
  /// Check if wallet has sufficient balance for a given amount
  bool hasSufficientBalance(double amount) => balance >= amount;

  /// Get formatted balance string
  String get formattedBalance => '${balance.toInt()} $currency';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WalletEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'WalletEntity(id: $id, name: $name, type: $type, balance: $balance $currency)';
}

/// Entity representing wallet selection state
@immutable
class WalletSelectionEntity extends CheckoutEntity {
  final List<WalletEntity> availableWallets;
  final WalletEntity? selectedWallet;
  final double transactionAmount;
  final String currency;
  final bool isLoading;
  final String? error;

  const WalletSelectionEntity({
    this.availableWallets = const [],
    this.selectedWallet,
    required this.transactionAmount,
    this.currency = 'SAR',
    this.isLoading = false,
    this.error,
  });

  bool get hasWallets => availableWallets.isNotEmpty;
  bool get hasSelectedWallet => selectedWallet != null;
  bool get canProceed => hasSelectedWallet && 
                        selectedWallet!.canBeUsed && 
                        selectedWallet!.hasSufficientBalance(transactionAmount);

  List<WalletEntity> get usableWallets => availableWallets
      .where((wallet) => wallet.canBeUsed && wallet.hasSufficientBalance(transactionAmount))
      .toList();

  WalletSelectionEntity copyWith({
    List<WalletEntity>? availableWallets,
    WalletEntity? selectedWallet,
    double? transactionAmount,
    String? currency,
    bool? isLoading,
    String? error,
  }) {
    return WalletSelectionEntity(
      availableWallets: availableWallets ?? this.availableWallets,
      selectedWallet: selectedWallet ?? this.selectedWallet,
      transactionAmount: transactionAmount ?? this.transactionAmount,
      currency: currency ?? this.currency,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  String toString() => 'WalletSelectionEntity(wallets: ${availableWallets.length}, selected: ${selectedWallet?.name})';
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