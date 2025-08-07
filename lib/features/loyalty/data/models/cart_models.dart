// Cart data models for the loyalty module
class CartItem {
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

  const CartItem({
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

  CartItem copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? currency,
    String? imageUrl,
    String? brandName,
    String? brandLogoUrl,
    int? quantity,
    Map<String, dynamic>? customizations,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      imageUrl: imageUrl ?? this.imageUrl,
      brandName: brandName ?? this.brandName,
      brandLogoUrl: brandLogoUrl ?? this.brandLogoUrl,
      quantity: quantity ?? this.quantity,
      customizations: customizations ?? this.customizations,
    );
  }

  double get totalPrice => price * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'SAR',
      imageUrl: json['imageUrl'] as String,
      brandName: json['brandName'] as String,
      brandLogoUrl: json['brandLogoUrl'] as String,
      quantity: json['quantity'] as int? ?? 1,
      customizations: json['customizations'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'currency': currency,
      'imageUrl': imageUrl,
      'brandName': brandName,
      'brandLogoUrl': brandLogoUrl,
      'quantity': quantity,
      'customizations': customizations,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class Cart {
  final String id;
  final List<CartItem> items;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Cart({
    required this.id,
    this.items = const [],
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  Cart copyWith({
    String? id,
    List<CartItem>? items,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Cart(
      id: id ?? this.id,
      items: items ?? this.items,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  int get totalItemCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get tax => subtotal * 0.15; // 15% VAT as per Saudi Arabia

  double get total => subtotal + tax;

  bool get isEmpty => items.isEmpty;

  bool get isNotEmpty => items.isNotEmpty;

  CartItem? findItem(String itemId) {
    try {
      return items.firstWhere((item) => item.id == itemId);
    } catch (e) {
      return null;
    }
  }

  bool containsItem(String itemId) => findItem(itemId) != null;

  Cart addItem(CartItem item) {
    final existingItemIndex = items.indexWhere((i) => i.id == item.id);
    List<CartItem> updatedItems;

    if (existingItemIndex != -1) {
      // Item already exists, update quantity
      updatedItems = List<CartItem>.from(items);
      updatedItems[existingItemIndex] = items[existingItemIndex].copyWith(
        quantity: items[existingItemIndex].quantity + item.quantity,
      );
    } else {
      // Add new item
      updatedItems = [...items, item];
    }

    return copyWith(items: updatedItems);
  }

  Cart removeItem(String itemId) {
    final updatedItems = items.where((item) => item.id != itemId).toList();
    return copyWith(items: updatedItems);
  }

  Cart updateItemQuantity(String itemId, int quantity) {
    if (quantity <= 0) {
      return removeItem(itemId);
    }

    final updatedItems = items.map((item) {
      if (item.id == itemId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();

    return copyWith(items: updatedItems);
  }

  Cart clearCart() {
    return copyWith(items: []);
  }

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'] as String,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList() ?? const <CartItem>[],
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((e) => e.toJson()).toList(),
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class CartState {
  final Cart? cart;
  final bool isLoading;
  final String? errorMessage;
  final bool isCheckingOut;
  final String? checkoutError;

  const CartState({
    this.cart,
    this.isLoading = false,
    this.errorMessage,
    this.isCheckingOut = false,
    this.checkoutError,
  });

  CartState copyWith({
    Cart? cart,
    bool? isLoading,
    String? errorMessage,
    bool? isCheckingOut,
    String? checkoutError,
  }) {
    return CartState(
      cart: cart ?? this.cart,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isCheckingOut: isCheckingOut ?? this.isCheckingOut,
      checkoutError: checkoutError ?? this.checkoutError,
    );
  }

  CartState clearErrors() {
    return copyWith(
      errorMessage: null,
      checkoutError: null,
    );
  }

  // Convenience getters
  bool get hasError => errorMessage != null || checkoutError != null;
  bool get hasCart => cart != null;
  bool get isEmpty => cart?.isEmpty ?? true;
  bool get isNotEmpty => cart?.isNotEmpty ?? false;
  int get itemCount => cart?.totalItemCount ?? 0;
  double get total => cart?.total ?? 0.0;
  double get subtotal => cart?.subtotal ?? 0.0;
  double get tax => cart?.tax ?? 0.0;
}