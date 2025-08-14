// Domain entities for cart functionality
abstract class CartEntity {
  const CartEntity();
}

class CartItemEntity extends CartEntity {
  final String id;
  final String name;
  final String description;
  final double price;
  final String currency;
  final String imageUrl;
  final String brandName;
  final String brandLogoUrl;
  final int quantity;
  final Map<String, dynamic>? customizations;

  const CartItemEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.currency = 'SAR',
    required this.imageUrl,
    required this.brandName,
    required this.brandLogoUrl,
    this.quantity = 1,
    this.customizations,
  });

  double get totalPrice => price * quantity;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItemEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'CartItemEntity(id: $id, name: $name, quantity: $quantity, price: $price)';
}

class CartDomainEntity extends CartEntity {
  final String id;
  final List<CartItemEntity> items;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CartDomainEntity({
    required this.id,
    this.items = const [],
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  int get totalItemCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get tax => subtotal * 0.15; // 15% VAT as per Saudi Arabia

  double get total => subtotal + tax;

  bool get isEmpty => items.isEmpty;

  bool get isNotEmpty => items.isNotEmpty;

  CartItemEntity? findItem(String itemId) {
    try {
      return items.firstWhere((item) => item.id == itemId);
    } catch (e) {
      return null;
    }
  }

  bool containsItem(String itemId) => findItem(itemId) != null;

  @override
  String toString() => 'CartDomainEntity(id: $id, itemCount: ${items.length}, total: $total)';
}

class CheckoutResult extends CartEntity {
  final bool success;
  final String? orderId;
  final String? message;
  final Map<String, dynamic>? data;

  const CheckoutResult({
    required this.success,
    this.orderId,
    this.message,
    this.data,
  });

  @override
  String toString() => 'CheckoutResult(success: $success, orderId: $orderId, message: $message)';
}