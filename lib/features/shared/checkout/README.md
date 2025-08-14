# Secure Checkout Flow Module

A comprehensive, security-first checkout implementation for the Independent Mobile restaurant management app, following Clean Architecture principles and providing pixel-perfect Figma design implementation.

## Features

### 🔒 Security-First Design
- **PCI DSS Compliance**: Never stores raw card data, uses secure tokenization
- **Encryption**: All sensitive data encrypted at rest and in transit
- **Biometric Authentication**: Support for fingerprint/face ID for saved payment methods
- **Input Validation**: Comprehensive sanitization and validation
- **Fraud Prevention**: Built-in security checks and monitoring

### 🎨 Pixel-Perfect UI
- **Figma Compliance**: Exact implementation of provided designs
- **Dark Theme**: Consistent with app's color scheme (`indpt/neutral: #1A1A1A`)
- **Responsive Design**: Adapts to different screen sizes
- **Smooth Animations**: Matching Figma specifications
- **Accessibility**: Full accessibility support

### ⚡ Performance & UX
- **Sub-2 Second Transitions**: Optimized for speed
- **Offline Support**: Smart caching with offline capabilities
- **Error Recovery**: Comprehensive error handling with user-friendly messages
- **State Management**: Robust Riverpod-based state management

## Architecture

```
lib/features/shared/checkout/
├── domain/
│   ├── entities/           # Core business objects
│   ├── repositories/       # Repository interfaces
│   └── usecases/          # Business logic operations
├── data/
│   ├── models/            # Data transfer objects
│   └── repositories/      # Repository implementations
├── presentation/
│   ├── pages/             # Screen implementations
│   ├── widgets/           # Reusable UI components
│   ├── providers/         # Riverpod state management
│   └── utils/            # UI utilities and helpers
└── checkout.dart         # Public API exports
```

## Quick Start

### 1. Navigation to Checkout
```dart
import 'package:go_router/go_router.dart';

// Navigate from cart to checkout
context.push('/checkout/pickup-details', extra: {
  'subtotal': 100.0,
  'tax': 15.0,
  'total': 115.0,
  'brandId': 'salt-brand-id',
  'locationId': 'mall-emirates-location',
});
```

### 2. Listen to Checkout State
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:independent/features/shared/checkout/checkout.dart';

class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkoutState = ref.watch(checkoutProvider);
    
    return Column(
      children: [
        if (checkoutState.isLoading) 
          CircularProgressIndicator(),
        if (checkoutState.error != null)
          Text('Error: ${checkoutState.error}'),
        // Your UI here
      ],
    );
  }
}
```

### 3. Handle Error States
```dart
import 'package:independent/features/shared/checkout/presentation/utils/checkout_error_handler.dart';

// Listen for errors and show user-friendly messages
ref.listen<CheckoutState>(checkoutProvider, (previous, next) {
  if (next.error != null) {
    final message = CheckoutErrorHandler.getErrorMessage(next.error);
    CheckoutErrorHandler.showErrorSnackBar(context, message);
  }
});
```

## Key Components

### Pickup Details Screen
The main screen following Figma design exactly:
- Location selection with brand logos
- "Pick Now" vs "Pick Later" radio options
- Date/time picker for scheduled pickup
- Continue button with price display

### Secure UI Components
- `CheckoutLocationCard`: Restaurant location display
- `CheckoutRadioOption`: Custom radio buttons matching design
- `CheckoutDatePicker`: Custom date/time selection
- `CheckoutContinueButton`: Price display and action button

### State Management
- `CheckoutNotifier`: Main state controller
- Real-time validation and error handling
- Optimistic updates with rollback on failure
- Comprehensive loading and error states

## Security Features

### Payment Data Handling
```dart
// ✅ CORRECT: Use tokenized payment data
final paymentMethod = PaymentMethodEntity(
  id: 'pm_123',
  type: PaymentMethodType.card,
  displayName: 'Visa ending in 1234',
  lastFourDigits: '1234', // Only last 4 digits
  // No raw card data stored
);

// ❌ INCORRECT: Never store raw payment data
// final cardNumber = '4111111111111111'; // Never do this!
```

### Secure API Communication
```dart
// Repository handles secure communication
final repository = CheckoutRepositoryImpl(
  dio: dio, // Configured with certificate pinning
  prefs: prefs, // Encrypted local storage
);
```

### Validation & Sanitization
```dart
// All inputs are validated and sanitized
final useCase = UpdatePickupDetailsUseCase(repository);
await useCase(UpdatePickupDetailsParams(
  checkoutId: sanitizedId,
  pickupDetails: validatedDetails,
));
```

## Testing

### Unit Tests
```bash
flutter test test/features/shared/checkout/checkout_test.dart
```

### Widget Tests  
```bash
flutter test test/features/shared/checkout/pickup_details_screen_test.dart
```

### Integration Tests
```bash
flutter drive --target=test_driver/checkout_flow_test.dart
```

## Color Scheme (Figma Compliant)

```dart
// Primary colors from Figma design
const primaryText = Color(0xFFFEFEFF);      // indpt/text primary
const tertiaryText = Color(0xFF9C9C9D);     // indpt/text tertiary
const strokeColor = Color(0xFF4D4E52);      // indpt/stroke
const sandColor = Color(0xFFFFFBF1);        // indpt/sand
const accentColor = Color(0xFF242424);      // indpt/accent
const neutralBg = Color(0xFF1A1A1A);        // indpt/neutral
```

## API Integration

### Configuration
Update the base URL in `checkout_providers.dart`:
```dart
dio.options = BaseOptions(
  baseUrl: 'https://your-api.com', // Replace with actual API
  // ... other configurations
);
```

### Expected API Endpoints
- `GET /api/v1/checkout/pickup-locations` - Get available pickup locations
- `POST /api/v1/checkout` - Create checkout session
- `PATCH /api/v1/checkout/{id}/pickup-details` - Update pickup details
- `POST /api/v1/checkout/{id}/process` - Process payment

## Error Handling

The module provides comprehensive error handling:
- Network errors with retry options
- Validation errors with specific messages
- Payment processing errors with alternative suggestions
- Security errors with appropriate actions

```dart
// Custom exception types
throw CheckoutException('Location not available');
throw PaymentException('Payment declined', code: 'CARD_DECLINED');
throw SecurityException('Biometric required', code: 'BIOMETRIC_REQUIRED');
```

## Development & Debugging

### Mock Data
Use `MockCheckoutData` for development:
```dart
import 'package:independent/features/shared/checkout/data/mock_checkout_data.dart';

final mockLocations = MockCheckoutData.pickupLocations;
final mockPaymentMethods = MockCheckoutData.paymentMethods;
```

### Logging
Enable detailed logging for debugging:
```dart
// Add to dio configuration
dio.interceptors.add(LogInterceptor(
  requestBody: true,
  responseBody: true,
  logPrint: (obj) => debugPrint(obj.toString()),
));
```

## Performance Optimization

- **Lazy Loading**: Components load data only when needed
- **Caching**: Smart caching with expiration policies
- **Memory Management**: Proper disposal of resources
- **Network Optimization**: Request batching and retry logic

## Contributing

1. Follow Clean Architecture principles
2. Maintain security best practices
3. Keep UI pixel-perfect to Figma designs
4. Write comprehensive tests
5. Update documentation for new features

## Support

For issues or questions about the checkout module:
1. Check the error logs and messages
2. Verify network connectivity and API availability
3. Ensure proper state management setup
4. Test with mock data for development scenarios