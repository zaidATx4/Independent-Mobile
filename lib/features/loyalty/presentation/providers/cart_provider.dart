import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/cart_models.dart';
import '../../data/repositories/cart_repository.dart';
import '../../domain/entities/cart_entities.dart';
import '../../domain/usecases/cart_usecases.dart';

// Repository provider
final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepositoryImpl();
});

// Use case providers
final getCurrentCartUseCaseProvider = Provider<GetCurrentCartUseCase>((ref) {
  final repository = ref.watch(cartRepositoryProvider);
  return GetCurrentCartUseCase(repository);
});

final addItemToCartUseCaseProvider = Provider<AddItemToCartUseCase>((ref) {
  final repository = ref.watch(cartRepositoryProvider);
  return AddItemToCartUseCase(repository);
});

final removeItemFromCartUseCaseProvider = Provider<RemoveItemFromCartUseCase>((ref) {
  final repository = ref.watch(cartRepositoryProvider);
  return RemoveItemFromCartUseCase(repository);
});

final updateItemQuantityUseCaseProvider = Provider<UpdateItemQuantityUseCase>((ref) {
  final repository = ref.watch(cartRepositoryProvider);
  return UpdateItemQuantityUseCase(repository);
});

final clearCartUseCaseProvider = Provider<ClearCartUseCase>((ref) {
  final repository = ref.watch(cartRepositoryProvider);
  return ClearCartUseCase(repository);
});

final checkoutUseCaseProvider = Provider<CheckoutUseCase>((ref) {
  final repository = ref.watch(cartRepositoryProvider);
  return CheckoutUseCase(repository);
});

// Cart state notifier
class CartNotifier extends StateNotifier<CartState> {
  final GetCurrentCartUseCase _getCurrentCartUseCase;
  final AddItemToCartUseCase _addItemToCartUseCase;
  final RemoveItemFromCartUseCase _removeItemFromCartUseCase;
  final UpdateItemQuantityUseCase _updateItemQuantityUseCase;
  final ClearCartUseCase _clearCartUseCase;
  final CheckoutUseCase _checkoutUseCase;

  CartNotifier(
    this._getCurrentCartUseCase,
    this._addItemToCartUseCase,
    this._removeItemFromCartUseCase,
    this._updateItemQuantityUseCase,
    this._clearCartUseCase,
    this._checkoutUseCase,
  ) : super(const CartState()) {
    _initializeCart();
  }

  // Initialize cart on startup
  Future<void> _initializeCart() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    try {
      final cart = await _getCurrentCartUseCase.call(const NoParams());
      state = state.copyWith(cart: cart, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load cart: ${e.toString()}',
      );
    }
  }

  // Refresh cart data
  Future<void> refreshCart() async {
    await _initializeCart();
  }

  // Add item to cart
  Future<void> addItem(CartItem item) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    try {
      final updatedCart = await _addItemToCartUseCase.call(AddItemParams(item));
      state = state.copyWith(cart: updatedCart, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to add item: ${e.toString()}',
      );
    }
  }

  // Remove item from cart
  Future<void> removeItem(String itemId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    try {
      final updatedCart = await _removeItemFromCartUseCase.call(RemoveItemParams(itemId));
      state = state.copyWith(cart: updatedCart, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to remove item: ${e.toString()}',
      );
    }
  }

  // Update item quantity
  Future<void> updateQuantity(String itemId, int quantity) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    try {
      final updatedCart = await _updateItemQuantityUseCase.call(
        UpdateQuantityParams(itemId, quantity),
      );
      state = state.copyWith(cart: updatedCart, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update quantity: ${e.toString()}',
      );
    }
  }

  // Increase item quantity by 1
  Future<void> increaseQuantity(String itemId) async {
    final cart = state.cart;
    if (cart == null) return;

    final item = cart.findItem(itemId);
    if (item == null) return;

    await updateQuantity(itemId, item.quantity + 1);
  }

  // Decrease item quantity by 1
  Future<void> decreaseQuantity(String itemId) async {
    final cart = state.cart;
    if (cart == null) return;

    final item = cart.findItem(itemId);
    if (item == null) return;

    if (item.quantity <= 1) {
      // Remove item if quantity would go to 0
      await removeItem(itemId);
    } else {
      await updateQuantity(itemId, item.quantity - 1);
    }
  }

  // Clear entire cart
  Future<void> clearCart() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    try {
      final updatedCart = await _clearCartUseCase.call(const NoParams());
      state = state.copyWith(cart: updatedCart, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to clear cart: ${e.toString()}',
      );
    }
  }

  // Checkout
  Future<CheckoutResult> checkout() async {
    final cart = state.cart;
    if (cart == null) {
      return const CheckoutResult(
        success: false,
        message: 'No cart available for checkout',
      );
    }

    state = state.copyWith(isCheckingOut: true, checkoutError: null);
    
    try {
      final result = await _checkoutUseCase.call(CheckoutParams(cart));
      
      if (result.success) {
        // Refresh cart to get the cleared cart
        await refreshCart();
      }
      
      state = state.copyWith(
        isCheckingOut: false,
        checkoutError: result.success ? null : result.message,
      );
      
      return result;
    } catch (e) {
      state = state.copyWith(
        isCheckingOut: false,
        checkoutError: 'Checkout failed: ${e.toString()}',
      );
      
      return CheckoutResult(
        success: false,
        message: e.toString(),
      );
    }
  }

  // Clear errors
  void clearErrors() {
    state = state.clearErrors();
  }

  // Check if cart contains specific item
  bool containsItem(String itemId) {
    return state.cart?.containsItem(itemId) ?? false;
  }

  // Get item quantity
  int getItemQuantity(String itemId) {
    final item = state.cart?.findItem(itemId);
    return item?.quantity ?? 0;
  }
}

// Main cart provider
final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  final getCurrentCartUseCase = ref.watch(getCurrentCartUseCaseProvider);
  final addItemToCartUseCase = ref.watch(addItemToCartUseCaseProvider);
  final removeItemFromCartUseCase = ref.watch(removeItemFromCartUseCaseProvider);
  final updateItemQuantityUseCase = ref.watch(updateItemQuantityUseCaseProvider);
  final clearCartUseCase = ref.watch(clearCartUseCaseProvider);
  final checkoutUseCase = ref.watch(checkoutUseCaseProvider);

  return CartNotifier(
    getCurrentCartUseCase,
    addItemToCartUseCase,
    removeItemFromCartUseCase,
    updateItemQuantityUseCase,
    clearCartUseCase,
    checkoutUseCase,
  );
});

// Convenience providers for specific parts of cart state
final cartItemsProvider = Provider<List<CartItem>>((ref) {
  return ref.watch(cartProvider).cart?.items ?? [];
});

final cartItemCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).itemCount;
});

final cartTotalProvider = Provider<double>((ref) {
  return ref.watch(cartProvider).total;
});

final cartSubtotalProvider = Provider<double>((ref) {
  return ref.watch(cartProvider).subtotal;
});

final cartTaxProvider = Provider<double>((ref) {
  return ref.watch(cartProvider).tax;
});

final cartIsEmptyProvider = Provider<bool>((ref) {
  return ref.watch(cartProvider).isEmpty;
});

final cartIsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(cartProvider).isLoading;
});

final cartIsCheckingOutProvider = Provider<bool>((ref) {
  return ref.watch(cartProvider).isCheckingOut;
});

final cartHasErrorProvider = Provider<bool>((ref) {
  return ref.watch(cartProvider).hasError;
});

final cartErrorMessageProvider = Provider<String?>((ref) {
  final state = ref.watch(cartProvider);
  return state.errorMessage ?? state.checkoutError;
});

final cartLoyaltyPointsProvider = Provider<int>((ref) {
  final total = ref.watch(cartTotalProvider);
  // 1 point per $1 spent (rounded down)
  return total.floor();
});