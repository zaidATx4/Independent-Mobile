import 'package:meta/meta.dart';
import '../../domain/entities/checkout_entities.dart';

/// Data model for pickup location with JSON serialization
@immutable
class PickupLocationModel extends PickupLocationEntity {
  const PickupLocationModel({
    required super.id,
    required super.name,
    required super.address,
    required super.brandLogoPath,
    required super.latitude,
    required super.longitude,
    super.isActive,
    super.metadata,
  });

  factory PickupLocationModel.fromJson(Map<String, dynamic> json) {
    return PickupLocationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      brandLogoPath: json['brand_logo_path'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      isActive: json['is_active'] as bool? ?? true,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'brand_logo_path': brandLogoPath,
      'latitude': latitude,
      'longitude': longitude,
      'is_active': isActive,
      'metadata': metadata,
    };
  }

  factory PickupLocationModel.fromEntity(PickupLocationEntity entity) {
    return PickupLocationModel(
      id: entity.id,
      name: entity.name,
      address: entity.address,
      brandLogoPath: entity.brandLogoPath,
      latitude: entity.latitude,
      longitude: entity.longitude,
      isActive: entity.isActive,
      metadata: entity.metadata,
    );
  }

  PickupLocationEntity toEntity() {
    return PickupLocationEntity(
      id: id,
      name: name,
      address: address,
      brandLogoPath: brandLogoPath,
      latitude: latitude,
      longitude: longitude,
      isActive: isActive,
      metadata: metadata,
    );
  }
}

/// Data model for pickup time with JSON serialization
@immutable
class PickupTimeModel extends PickupTimeEntity {
  const PickupTimeModel({
    required super.type,
    super.scheduledTime,
    required super.displayText,
    required super.description,
  });

  factory PickupTimeModel.fromJson(Map<String, dynamic> json) {
    final typeString = json['type'] as String;
    final type = PickupTimeType.values.firstWhere(
      (e) => e.toString().split('.').last == typeString,
      orElse: () => PickupTimeType.now,
    );

    DateTime? scheduledTime;
    if (json['scheduled_time'] != null) {
      scheduledTime = DateTime.parse(json['scheduled_time'] as String);
    }

    return PickupTimeModel(
      type: type,
      scheduledTime: scheduledTime,
      displayText: json['display_text'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'scheduled_time': scheduledTime?.toIso8601String(),
      'display_text': displayText,
      'description': description,
    };
  }

  factory PickupTimeModel.fromEntity(PickupTimeEntity entity) {
    return PickupTimeModel(
      type: entity.type,
      scheduledTime: entity.scheduledTime,
      displayText: entity.displayText,
      description: entity.description,
    );
  }

  PickupTimeEntity toEntity() {
    return PickupTimeEntity(
      type: type,
      scheduledTime: scheduledTime,
      displayText: displayText,
      description: description,
    );
  }
}

/// Data model for payment method with security considerations
/// SECURITY NOTE: Never store sensitive payment data in this model
@immutable
class PaymentMethodModel extends PaymentMethodEntity {
  const PaymentMethodModel({
    required super.id,
    required super.type,
    required super.displayName,
    super.lastFourDigits,
    super.cardBrand,
    super.iconPath,
    super.isDefault,
    super.requiresBiometric,
    super.secureMetadata,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    final typeString = json['type'] as String;
    final type = PaymentMethodType.values.firstWhere(
      (e) => e.toString().split('.').last == typeString,
      orElse: () => PaymentMethodType.card,
    );

    return PaymentMethodModel(
      id: json['id'] as String,
      type: type,
      displayName: json['display_name'] as String,
      lastFourDigits: json['last_four_digits'] as String?,
      cardBrand: json['card_brand'] as String?,
      iconPath: json['icon_path'] as String?,
      isDefault: json['is_default'] as bool? ?? false,
      requiresBiometric: json['requires_biometric'] as bool? ?? false,
      secureMetadata: json['secure_metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'display_name': displayName,
      'last_four_digits': lastFourDigits,
      'card_brand': cardBrand,
      'icon_path': iconPath,
      'is_default': isDefault,
      'requires_biometric': requiresBiometric,
      'secure_metadata': secureMetadata,
    };
  }

  factory PaymentMethodModel.fromEntity(PaymentMethodEntity entity) {
    return PaymentMethodModel(
      id: entity.id,
      type: entity.type,
      displayName: entity.displayName,
      lastFourDigits: entity.lastFourDigits,
      cardBrand: entity.cardBrand,
      iconPath: entity.iconPath,
      isDefault: entity.isDefault,
      requiresBiometric: entity.requiresBiometric,
      secureMetadata: entity.secureMetadata,
    );
  }

  PaymentMethodEntity toEntity() {
    return PaymentMethodEntity(
      id: id,
      type: type,
      displayName: displayName,
      lastFourDigits: lastFourDigits,
      cardBrand: cardBrand,
      iconPath: iconPath,
      isDefault: isDefault,
      requiresBiometric: requiresBiometric,
      secureMetadata: secureMetadata,
    );
  }
}

/// Data model for pickup details with JSON serialization
@immutable
class PickupDetailsModel extends PickupDetailsEntity {
  const PickupDetailsModel({
    required super.location,
    required super.pickupTime,
    required super.createdAt,
    required super.updatedAt,
  });

  factory PickupDetailsModel.fromJson(Map<String, dynamic> json) {
    return PickupDetailsModel(
      location: PickupLocationModel.fromJson(json['location'] as Map<String, dynamic>),
      pickupTime: PickupTimeModel.fromJson(json['pickup_time'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location is PickupLocationModel 
          ? (location as PickupLocationModel).toJson()
          : PickupLocationModel.fromEntity(location).toJson(),
      'pickup_time': pickupTime is PickupTimeModel 
          ? (pickupTime as PickupTimeModel).toJson()
          : PickupTimeModel.fromEntity(pickupTime).toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory PickupDetailsModel.fromEntity(PickupDetailsEntity entity) {
    return PickupDetailsModel(
      location: entity.location,
      pickupTime: entity.pickupTime,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  PickupDetailsEntity toEntity() {
    return PickupDetailsEntity(
      location: location,
      pickupTime: pickupTime,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

/// Data model for the main checkout with JSON serialization
@immutable
class CheckoutModel extends CheckoutStateEntity {
  const CheckoutModel({
    required super.id,
    required super.status,
    super.pickupDetails,
    super.paymentMethod,
    required super.subtotal,
    required super.tax,
    required super.total,
    super.currency,
    required super.createdAt,
    super.completedAt,
    super.errorMessage,
    super.metadata,
  });

  factory CheckoutModel.fromJson(Map<String, dynamic> json) {
    final statusString = json['status'] as String;
    final status = CheckoutStatus.values.firstWhere(
      (e) => e.toString().split('.').last == statusString,
      orElse: () => CheckoutStatus.initial,
    );

    PickupDetailsModel? pickupDetails;
    if (json['pickup_details'] != null) {
      pickupDetails = PickupDetailsModel.fromJson(json['pickup_details'] as Map<String, dynamic>);
    }

    PaymentMethodModel? paymentMethod;
    if (json['payment_method'] != null) {
      paymentMethod = PaymentMethodModel.fromJson(json['payment_method'] as Map<String, dynamic>);
    }

    DateTime? completedAt;
    if (json['completed_at'] != null) {
      completedAt = DateTime.parse(json['completed_at'] as String);
    }

    return CheckoutModel(
      id: json['id'] as String,
      status: status,
      pickupDetails: pickupDetails,
      paymentMethod: paymentMethod,
      subtotal: (json['subtotal'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'SAR',
      createdAt: DateTime.parse(json['created_at'] as String),
      completedAt: completedAt,
      errorMessage: json['error_message'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status.toString().split('.').last,
      'pickup_details': pickupDetails != null ? (pickupDetails as PickupDetailsModel).toJson() : null,
      'payment_method': paymentMethod != null ? (paymentMethod as PaymentMethodModel).toJson() : null,
      'subtotal': subtotal,
      'tax': tax,
      'total': total,
      'currency': currency,
      'created_at': createdAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'error_message': errorMessage,
      'metadata': metadata,
    };
  }

  factory CheckoutModel.fromEntity(CheckoutStateEntity entity) {
    return CheckoutModel(
      id: entity.id,
      status: entity.status,
      pickupDetails: entity.pickupDetails,
      paymentMethod: entity.paymentMethod,
      subtotal: entity.subtotal,
      tax: entity.tax,
      total: entity.total,
      currency: entity.currency,
      createdAt: entity.createdAt,
      completedAt: entity.completedAt,
      errorMessage: entity.errorMessage,
      metadata: entity.metadata,
    );
  }

  CheckoutStateEntity toEntity() {
    return CheckoutStateEntity(
      id: id,
      status: status,
      pickupDetails: pickupDetails,
      paymentMethod: paymentMethod,
      subtotal: subtotal,
      tax: tax,
      total: total,
      currency: currency,
      createdAt: createdAt,
      completedAt: completedAt,
      errorMessage: errorMessage,
      metadata: metadata,
    );
  }
}

/// Data model for wallet with JSON serialization and security considerations
/// SECURITY NOTE: Wallet data must be encrypted at rest and in transit
@immutable
class WalletModel extends WalletEntity {
  const WalletModel({
    required super.id,
    required super.name,
    required super.type,
    required super.balance,
    super.currency,
    super.description,
    super.iconPath,
    super.isActive,
    super.requiresBiometric,
    super.expiryDate,
    super.metadata,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    final typeString = json['type'] as String;
    final type = WalletType.values.firstWhere(
      (e) => e.toString().split('.').last == typeString,
      orElse: () => WalletType.personal,
    );

    DateTime? expiryDate;
    if (json['expiry_date'] != null) {
      expiryDate = DateTime.parse(json['expiry_date'] as String);
    }

    return WalletModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: type,
      balance: (json['balance'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'SAR',
      description: json['description'] as String?,
      iconPath: json['icon_path'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      requiresBiometric: json['requires_biometric'] as bool? ?? false,
      expiryDate: expiryDate,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.toString().split('.').last,
      'balance': balance,
      'currency': currency,
      'description': description,
      'icon_path': iconPath,
      'is_active': isActive,
      'requires_biometric': requiresBiometric,
      'expiry_date': expiryDate?.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory WalletModel.fromEntity(WalletEntity entity) {
    return WalletModel(
      id: entity.id,
      name: entity.name,
      type: entity.type,
      balance: entity.balance,
      currency: entity.currency,
      description: entity.description,
      iconPath: entity.iconPath,
      isActive: entity.isActive,
      requiresBiometric: entity.requiresBiometric,
      expiryDate: entity.expiryDate,
      metadata: entity.metadata,
    );
  }

  WalletEntity toEntity() {
    return WalletEntity(
      id: id,
      name: name,
      type: type,
      balance: balance,
      currency: currency,
      description: description,
      iconPath: iconPath,
      isActive: isActive,
      requiresBiometric: requiresBiometric,
      expiryDate: expiryDate,
      metadata: metadata,
    );
  }
}

/// Data model for wallet selection state
@immutable
class WalletSelectionModel extends WalletSelectionEntity {
  const WalletSelectionModel({
    super.availableWallets,
    super.selectedWallet,
    required super.transactionAmount,
    super.currency,
    super.isLoading,
    super.error,
  });

  factory WalletSelectionModel.fromJson(Map<String, dynamic> json) {
    final walletsJson = json['available_wallets'] as List<dynamic>? ?? [];
    final availableWallets = walletsJson
        .map((walletJson) => WalletModel.fromJson(walletJson as Map<String, dynamic>))
        .toList();

    WalletModel? selectedWallet;
    if (json['selected_wallet'] != null) {
      selectedWallet = WalletModel.fromJson(json['selected_wallet'] as Map<String, dynamic>);
    }

    return WalletSelectionModel(
      availableWallets: availableWallets,
      selectedWallet: selectedWallet,
      transactionAmount: (json['transaction_amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'SAR',
      isLoading: json['is_loading'] as bool? ?? false,
      error: json['error'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'available_wallets': availableWallets
          .map((wallet) => (wallet as WalletModel).toJson())
          .toList(),
      'selected_wallet': selectedWallet != null 
          ? WalletModel.fromEntity(selectedWallet!).toJson() 
          : null,
      'transaction_amount': transactionAmount,
      'currency': currency,
      'is_loading': isLoading,
      'error': error,
    };
  }

  factory WalletSelectionModel.fromEntity(WalletSelectionEntity entity) {
    return WalletSelectionModel(
      availableWallets: entity.availableWallets,
      selectedWallet: entity.selectedWallet,
      transactionAmount: entity.transactionAmount,
      currency: entity.currency,
      isLoading: entity.isLoading,
      error: entity.error,
    );
  }

  WalletSelectionEntity toEntity() {
    return WalletSelectionEntity(
      availableWallets: availableWallets,
      selectedWallet: selectedWallet,
      transactionAmount: transactionAmount,
      currency: currency,
      isLoading: isLoading,
      error: error,
    );
  }

  @override
  WalletSelectionModel copyWith({
    List<WalletEntity>? availableWallets,
    WalletEntity? selectedWallet,
    double? transactionAmount,
    String? currency,
    bool? isLoading,
    String? error,
  }) {
    return WalletSelectionModel(
      availableWallets: availableWallets ?? this.availableWallets,
      selectedWallet: selectedWallet ?? this.selectedWallet,
      transactionAmount: transactionAmount ?? this.transactionAmount,
      currency: currency ?? this.currency,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// Data model for checkout result
@immutable
class CheckoutResultModel extends CheckoutResultEntity {
  const CheckoutResultModel({
    required super.success,
    super.orderId,
    super.transactionId,
    super.message,
    super.checkout,
    required super.timestamp,
    super.data,
  });

  factory CheckoutResultModel.fromJson(Map<String, dynamic> json) {
    CheckoutModel? checkout;
    if (json['checkout'] != null) {
      checkout = CheckoutModel.fromJson(json['checkout'] as Map<String, dynamic>);
    }

    return CheckoutResultModel(
      success: json['success'] as bool,
      orderId: json['order_id'] as String?,
      transactionId: json['transaction_id'] as String?,
      message: json['message'] as String?,
      checkout: checkout,
      timestamp: DateTime.parse(json['timestamp'] as String),
      data: json['data'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'order_id': orderId,
      'transaction_id': transactionId,
      'message': message,
      'checkout': checkout != null ? (checkout as CheckoutModel).toJson() : null,
      'timestamp': timestamp.toIso8601String(),
      'data': data,
    };
  }

  factory CheckoutResultModel.fromEntity(CheckoutResultEntity entity) {
    return CheckoutResultModel(
      success: entity.success,
      orderId: entity.orderId,
      transactionId: entity.transactionId,
      message: entity.message,
      checkout: entity.checkout,
      timestamp: entity.timestamp,
      data: entity.data,
    );
  }

  CheckoutResultEntity toEntity() {
    return CheckoutResultEntity(
      success: success,
      orderId: orderId,
      transactionId: transactionId,
      message: message,
      checkout: checkout,
      timestamp: timestamp,
      data: data,
    );
  }
}