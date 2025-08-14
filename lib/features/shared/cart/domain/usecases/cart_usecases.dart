import '../../data/models/cart_models.dart';
import '../../data/repositories/cart_repository.dart';
import '../entities/cart_entities.dart';

// Base use case class
abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

// Use case parameters
class NoParams {
  const NoParams();
}

class AddItemParams {
  final CartItem item;
  const AddItemParams(this.item);
}

class RemoveItemParams {
  final String itemId;
  const RemoveItemParams(this.itemId);
}

class UpdateQuantityParams {
  final String itemId;
  final int quantity;
  const UpdateQuantityParams(this.itemId, this.quantity);
}

class CheckoutParams {
  final Cart cart;
  const CheckoutParams(this.cart);
}

class CompleteOrderParams {
  final Cart cart;
  final String paymentId;
  const CompleteOrderParams(this.cart, this.paymentId);
}

// Get current cart use case
class GetCurrentCartUseCase implements UseCase<Cart?, NoParams> {
  final CartRepository repository;

  const GetCurrentCartUseCase(this.repository);

  @override
  Future<Cart?> call(NoParams params) async {
    return await repository.getCurrentCart();
  }
}

// Add item to cart use case
class AddItemToCartUseCase implements UseCase<Cart, AddItemParams> {
  final CartRepository repository;

  const AddItemToCartUseCase(this.repository);

  @override
  Future<Cart> call(AddItemParams params) async {
    // Business logic: Validate item before adding
    if (params.item.price < 0) {
      throw Exception('Invalid item price');
    }
    if (params.item.quantity <= 0) {
      throw Exception('Invalid item quantity');
    }
    if (params.item.name.trim().isEmpty) {
      throw Exception('Item name cannot be empty');
    }

    return await repository.addItemToCart(params.item);
  }
}

// Remove item from cart use case
class RemoveItemFromCartUseCase implements UseCase<Cart, RemoveItemParams> {
  final CartRepository repository;

  const RemoveItemFromCartUseCase(this.repository);

  @override
  Future<Cart> call(RemoveItemParams params) async {
    if (params.itemId.trim().isEmpty) {
      throw Exception('Item ID cannot be empty');
    }

    return await repository.removeItemFromCart(params.itemId);
  }
}

// Update item quantity use case
class UpdateItemQuantityUseCase implements UseCase<Cart, UpdateQuantityParams> {
  final CartRepository repository;

  const UpdateItemQuantityUseCase(this.repository);

  @override
  Future<Cart> call(UpdateQuantityParams params) async {
    if (params.itemId.trim().isEmpty) {
      throw Exception('Item ID cannot be empty');
    }
    if (params.quantity < 0) {
      throw Exception('Quantity cannot be negative');
    }
    
    // Note: quantity of 0 will remove the item (handled in repository)

    return await repository.updateItemQuantity(params.itemId, params.quantity);
  }
}

// Clear cart use case
class ClearCartUseCase implements UseCase<Cart, NoParams> {
  final CartRepository repository;

  const ClearCartUseCase(this.repository);

  @override
  Future<Cart> call(NoParams params) async {
    return await repository.clearCart();
  }
}

// Checkout use case with business logic
class CheckoutUseCase implements UseCase<CheckoutResult, CheckoutParams> {
  final CartRepository repository;

  const CheckoutUseCase(this.repository);

  @override
  Future<CheckoutResult> call(CheckoutParams params) async {
    final cart = params.cart;

    // Business validations before checkout
    if (cart.isEmpty) {
      return const CheckoutResult(
        success: false,
        message: 'Cannot checkout with empty cart',
      );
    }

    // Validate minimum order amount (example: 10 SAR)
    const minOrderAmount = 10.0;
    if (cart.total < minOrderAmount) {
      return CheckoutResult(
        success: false,
        message: 'Minimum order amount is $minOrderAmount SAR',
      );
    }

    // Validate each item in cart
    for (final item in cart.items) {
      if (item.quantity <= 0) {
        return CheckoutResult(
          success: false,
          message: 'Invalid quantity for item: ${item.name}',
        );
      }
      if (item.price <= 0) {
        return CheckoutResult(
          success: false,
          message: 'Invalid price for item: ${item.name}',
        );
      }
    }

    // All validations passed, proceed with checkout
    try {
      return await repository.checkout(cart);
    } catch (e) {
      return CheckoutResult(
        success: false,
        message: 'Checkout failed: ${e.toString()}',
      );
    }
  }
}

// Complete order use case (after payment)
class CompleteOrderUseCase implements UseCase<CheckoutResult, CompleteOrderParams> {
  final CartRepository repository;

  const CompleteOrderUseCase(this.repository);

  @override
  Future<CheckoutResult> call(CompleteOrderParams params) async {
    final cart = params.cart;
    final paymentId = params.paymentId;

    // Business validations before completing order
    if (cart.isEmpty) {
      return const CheckoutResult(
        success: false,
        message: 'Cannot complete order with empty cart',
      );
    }

    if (paymentId.trim().isEmpty) {
      return const CheckoutResult(
        success: false,
        message: 'Payment ID is required to complete order',
      );
    }

    // All validations passed, complete the order
    try {
      return await repository.completeOrder(cart, paymentId);
    } catch (e) {
      return CheckoutResult(
        success: false,
        message: 'Order completion failed: ${e.toString()}',
      );
    }
  }
}

// Calculate loyalty points use case
class CalculateLoyaltyPointsUseCase implements UseCase<int, CheckoutParams> {
  const CalculateLoyaltyPointsUseCase();

  @override
  Future<int> call(CheckoutParams params) async {
    // Business rule: 1 point per 1 SAR spent
    final cart = params.cart;
    final points = cart.total.floor(); // Round down to nearest integer
    
    return points;
  }
}

// Validate cart use case
class ValidateCartUseCase implements UseCase<CartValidationResult, CheckoutParams> {
  const ValidateCartUseCase();

  @override
  Future<CartValidationResult> call(CheckoutParams params) async {
    final cart = params.cart;
    final errors = <String>[];

    if (cart.isEmpty) {
      errors.add('Cart is empty');
    }

    for (final item in cart.items) {
      if (item.quantity <= 0) {
        errors.add('Invalid quantity for ${item.name}');
      }
      if (item.price <= 0) {
        errors.add('Invalid price for ${item.name}');
      }
      if (item.name.trim().isEmpty) {
        errors.add('Item name is required');
      }
    }

    return CartValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      itemCount: cart.totalItemCount,
      total: cart.total,
    );
  }
}

// Cart validation result
class CartValidationResult {
  final bool isValid;
  final List<String> errors;
  final int itemCount;
  final double total;

  const CartValidationResult({
    required this.isValid,
    required this.errors,
    required this.itemCount,
    required this.total,
  });

  @override
  String toString() => 'CartValidationResult(isValid: $isValid, errors: $errors)';
}