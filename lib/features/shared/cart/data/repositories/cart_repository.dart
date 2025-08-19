import '../models/cart_models.dart';
import '../../domain/entities/cart_entities.dart';

// Repository interface for cart operations
abstract class CartRepository {
  /// Get the current user's cart
  Future<Cart?> getCurrentCart();

  /// Create a new cart for the user
  Future<Cart> createCart(String userId);

  /// Add item to cart
  Future<Cart> addItemToCart(CartItem item);

  /// Remove item from cart
  Future<Cart> removeItemFromCart(String itemId);

  /// Update item quantity in cart
  Future<Cart> updateItemQuantity(String itemId, int quantity);

  /// Clear all items from cart
  Future<Cart> clearCart();

  /// Process checkout
  Future<CheckoutResult> checkout(Cart cart);

  /// Complete the order and clear cart after successful payment
  Future<CheckoutResult> completeOrder(Cart cart, String paymentId);

  /// Save cart locally (for offline support)
  Future<void> saveCartLocally(Cart cart);

  /// Load cart from local storage
  Future<Cart?> loadCartLocally();
}

// Implementation of cart repository
class CartRepositoryImpl implements CartRepository {
  // Mock data for development - replace with actual API calls and local storage
  Cart? _currentCart;
  final String _mockUserId = 'user_123';

  @override
  Future<Cart?> getCurrentCart() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    // If no cart exists, create one
    _currentCart ??= Cart(
      id: 'cart_${DateTime.now().millisecondsSinceEpoch}',
      userId: _mockUserId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      items: _getMockCartItems(), // Start with some mock items for demo
    );

    return _currentCart;
  }

  @override
  Future<Cart> createCart(String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    _currentCart = Cart(
      id: 'cart_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return _currentCart!;
  }

  @override
  Future<Cart> addItemToCart(CartItem item) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    _currentCart ??= await createCart(_mockUserId);
    _currentCart = _currentCart!.addItem(item);
    
    // Save to local storage
    await saveCartLocally(_currentCart!);
    
    return _currentCart!;
  }

  @override
  Future<Cart> removeItemFromCart(String itemId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    if (_currentCart == null) {
      throw Exception('No cart found');
    }

    _currentCart = _currentCart!.removeItem(itemId);
    await saveCartLocally(_currentCart!);
    
    return _currentCart!;
  }

  @override
  Future<Cart> updateItemQuantity(String itemId, int quantity) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    if (_currentCart == null) {
      throw Exception('No cart found');
    }

    _currentCart = _currentCart!.updateItemQuantity(itemId, quantity);
    await saveCartLocally(_currentCart!);
    
    return _currentCart!;
  }

  @override
  Future<Cart> clearCart() async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    if (_currentCart == null) {
      throw Exception('No cart found');
    }

    _currentCart = _currentCart!.clearCart();
    await saveCartLocally(_currentCart!);
    
    return _currentCart!;
  }

  @override
  Future<CheckoutResult> checkout(Cart cart) async {
    // Simulate checkout process
    await Future.delayed(const Duration(seconds: 2));
    
    try {
      // Mock checkout logic
      if (cart.isEmpty) {
        return const CheckoutResult(
          success: false,
          message: 'Cart is empty',
        );
      }

      // Simulate successful checkout
      final orderId = 'order_${DateTime.now().millisecondsSinceEpoch}';
      
      // NOTE: Cart should NOT be cleared here automatically
      // Cart will be cleared only after complete order processing (payment + confirmation)
      // This method now only validates and processes the order, but preserves cart state

      return CheckoutResult(
        success: true,
        orderId: orderId,
        message: 'Order placed successfully',
        data: {
          'total': cart.total,
          'itemCount': cart.totalItemCount,
          'estimatedDelivery': '30-45 minutes',
        },
      );
    } catch (e) {
      return CheckoutResult(
        success: false,
        message: 'Checkout failed: ${e.toString()}',
      );
    }
  }

  /// Complete the order and clear the cart - called only after successful payment
  @override
  Future<CheckoutResult> completeOrder(Cart cart, String paymentId) async {
    await Future.delayed(const Duration(seconds: 1));
    
    try {
      if (cart.isEmpty) {
        return const CheckoutResult(
          success: false,
          message: 'Cart is empty',
        );
      }

      // Process final order completion
      final orderId = 'order_${DateTime.now().millisecondsSinceEpoch}';
      
      // Clear the cart only after successful payment and order completion
      _currentCart = _currentCart?.clearCart();
      if (_currentCart != null) {
        await saveCartLocally(_currentCart!);
      }

      return CheckoutResult(
        success: true,
        orderId: orderId,
        message: 'Order completed successfully',
        data: {
          'total': cart.total,
          'itemCount': cart.totalItemCount,
          'estimatedDelivery': '30-45 minutes',
          'paymentId': paymentId,
        },
      );
    } catch (e) {
      return CheckoutResult(
        success: false,
        message: 'Order completion failed: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> saveCartLocally(Cart cart) async {
    // TODO: Implement local storage using SharedPreferences or Hive
    // For now, this is a placeholder
    await Future.delayed(const Duration(milliseconds: 50));
    // TODO: Implement actual local storage
    // For now, this is a placeholder for local storage implementation
  }

  @override
  Future<Cart?> loadCartLocally() async {
    // TODO: Implement loading from local storage
    await Future.delayed(const Duration(milliseconds: 50));
    return null; // For now, always return null
  }

  // Mock data for demonstration - removed default items as requested
  List<CartItem> _getMockCartItems() {
    return [
      // No default items - cart starts empty for location-based ordering
    ];
  }
}