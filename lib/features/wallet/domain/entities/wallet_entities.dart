/// Wallet balance and account information
class WalletEntity {
  final String id;
  final String userId;
  final double balance;
  final String currency;
  final DateTime lastUpdated;
  final bool isActive;
  final List<WalletTransactionEntity> recentTransactions;
  final WalletType type;
  final String? displayName;
  final DateTime? resetDate;
  final String? backgroundImageUrl;
  final bool canBeUsed;
  final bool isExpired;
  final bool requiresBiometric;

  const WalletEntity({
    required this.id,
    required this.userId,
    required this.balance,
    required this.currency,
    required this.lastUpdated,
    required this.isActive,
    this.recentTransactions = const [],
    this.type = WalletType.personal,
    this.displayName,
    this.resetDate,
    this.backgroundImageUrl,
    this.canBeUsed = true,
    this.isExpired = false,
    this.requiresBiometric = false,
  });

  /// Check if wallet has sufficient balance for a transaction
  bool hasSufficientBalance(double amount) {
    return balance >= amount && canBeUsed && !isExpired;
  }

  /// Get formatted balance string
  String get formattedBalance {
    return balance.toInt().toString();
  }

  /// Get reset date display text
  String get resetDateDisplay {
    if (resetDate == null) return '';
    
    final months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    final day = resetDate!.day;
    final month = months[resetDate!.month];
    
    final suffix = day == 1 ? 'st' : day == 2 ? 'nd' : day == 3 ? 'rd' : 'th';
    
    return 'Resets on $day$suffix $month';
  }
}

/// Individual wallet transaction
class WalletTransactionEntity {
  final String id;
  final String walletId;
  final WalletTransactionType type;
  final double amount;
  final String currency;
  final DateTime timestamp;
  final WalletTransactionStatus status;
  final String? description;
  final String? merchantName;
  final String? orderId;
  final String? referenceId;
  final Map<String, dynamic>? metadata;

  const WalletTransactionEntity({
    required this.id,
    required this.walletId,
    required this.type,
    required this.amount,
    required this.currency,
    required this.timestamp,
    required this.status,
    this.description,
    this.merchantName,
    this.orderId,
    this.referenceId,
    this.metadata,
  });
}

/// Types of wallets
enum WalletType {
  personal,
  teamLunch,
  corporate,
  gift,
}

/// Types of wallet transactions
enum WalletTransactionType {
  addMoney,
  payment,
  refund,
  cashback,
  transfer,
  adjustment,
}

/// Transaction status
enum WalletTransactionStatus {
  pending,
  completed,
  failed,
  cancelled,
  refunded,
}

/// Wallet top-up method
class WalletTopUpMethodEntity {
  final String id;
  final String name;
  final WalletTopUpType type;
  final String iconPath;
  final bool isAvailable;
  final double minAmount;
  final double maxAmount;
  final double? processingFee;
  final String? description;

  const WalletTopUpMethodEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.iconPath,
    required this.isAvailable,
    required this.minAmount,
    required this.maxAmount,
    this.processingFee,
    this.description,
  });
}

/// Available top-up methods
enum WalletTopUpType {
  creditCard,
  debitCard,
  bankTransfer,
  applePay,
  googlePay,
  samsungPay,
}

/// Wallet promotion or offer
class WalletPromotionEntity {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double bonusAmount;
  final double minimumTopUp;
  final DateTime validUntil;
  final bool isActive;
  final String? promoCode;
  final String? terms;

  const WalletPromotionEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.bonusAmount,
    required this.minimumTopUp,
    required this.validUntil,
    required this.isActive,
    this.promoCode,
    this.terms,
  });
}