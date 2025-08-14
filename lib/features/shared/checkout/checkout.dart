/// Checkout Feature Module
/// 
/// This module provides a complete checkout flow implementation for the Independent Mobile
/// restaurant management app, following Clean Architecture principles and security best practices.
/// 
/// Features:
/// - Secure pickup details selection
/// - Payment method management with PCI DSS compliance
/// - Real-time validation and error handling
/// - Pixel-perfect Figma design implementation
/// - Comprehensive state management with Riverpod
/// - Integration with existing app architecture


// Domain Layer Exports
export 'domain/entities/checkout_entities.dart';
export 'domain/repositories/checkout_repository.dart';
export 'domain/usecases/checkout_usecases.dart';

// Data Layer Exports
export 'data/models/checkout_models.dart';
export 'data/repositories/checkout_repository_impl.dart';

// Presentation Layer Exports
export 'presentation/pages/pickup_details_screen.dart';
export 'presentation/providers/checkout_providers.dart';
export 'presentation/widgets/checkout_location_card.dart';
export 'presentation/widgets/checkout_radio_option.dart';
export 'presentation/widgets/checkout_date_picker.dart';
export 'presentation/widgets/checkout_continue_button.dart';
export 'presentation/utils/checkout_error_handler.dart';

/// Usage Example:
/// 
/// ```dart
/// // Navigate to checkout from cart
/// context.push('/checkout/pickup-details', extra: {
///   'subtotal': 100.0,
///   'tax': 15.0,
///   'total': 115.0,
///   'brandId': 'brand-123',
/// });
/// 
/// // Listen to checkout state
/// ref.listen<CheckoutState>(checkoutProvider, (previous, next) {
///   if (next.error != null) {
///     CheckoutErrorHandler.showErrorSnackBar(context, next.error!);
///   }
/// });
/// ```
/// 
/// Security Features:
/// - All payment data is tokenized and encrypted
/// - No sensitive payment information stored locally
/// - PCI DSS compliant payment processing
/// - Biometric authentication support for payment methods
/// - Comprehensive audit logging without exposing PII
/// - Input validation and sanitization throughout
/// 
/// Architecture:
/// - Clean Architecture with clear separation of concerns
/// - Domain-driven design with business logic in use cases
/// - Repository pattern for data access abstraction
/// - Provider pattern for state management with Riverpod
/// - Error handling with user-friendly messages
/// 
/// Performance:
/// - Lazy loading of pickup locations and payment methods
/// - Efficient caching with expiration policies
/// - Optimistic UI updates with rollback on errors
/// - Memory-efficient image loading and disposal