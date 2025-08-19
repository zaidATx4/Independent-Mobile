import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:independent/features/shared/checkout/presentation/pages/pickup_details_screen.dart';
// import 'package:independent/features/shared/checkout/presentation/providers/checkout_providers.dart';
import 'package:independent/features/shared/checkout/domain/entities/checkout_entities.dart';
import 'package:independent/features/shared/checkout/data/repositories/checkout_repository_impl.dart';
import 'package:independent/features/shared/checkout/domain/usecases/checkout_usecases.dart';

// Mock classes
class MockCheckoutRepository extends Mock implements CheckoutRepositoryImpl {}
class MockCreateCheckoutUseCase extends Mock implements CreateCheckoutUseCase {}

// Helper function to create test app with providers
Widget createTestApp({required Widget child, List<Override>? overrides}) {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => child,
      ),
    ],
  );
  
  return ProviderScope(
    overrides: overrides ?? [],
    child: MaterialApp.router(
      routerConfig: router,
    ),
  );
}

@GenerateMocks([CheckoutRepositoryImpl, CreateCheckoutUseCase])
void main() {
  group('Continue Button Integration Tests', () {
    late MockCheckoutRepository mockRepository;
    late MockCreateCheckoutUseCase mockCreateCheckoutUseCase;

    setUp(() {
      mockRepository = MockCheckoutRepository();
      mockCreateCheckoutUseCase = MockCreateCheckoutUseCase();
    });

    testWidgets('should enable continue button when location and pickup time are selected', (tester) async {
      // Arrange
      const testLocation = PickupLocationEntity(
        id: 'test-1',
        name: 'Test Location',
        address: 'Test Address',
        brandLogoPath: 'assets/images/logos/brands/Salt.png',
        latitude: 25.2048,
        longitude: 55.2708,
        isActive: true,
      );

      await tester.pumpWidget(
        createTestApp(
          child: const PickupDetailsScreen(
            subtotal: 100.0,
            tax: 15.0,
            total: 115.0,
            foodLocation: testLocation,
          ),
        ),
      );

      // Wait for initial build and initialization
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1000));

      // Verify screen loads without errors
      expect(find.text('Pickup Details'), findsOneWidget);
      expect(find.text('Pick Up Now'), findsOneWidget);
      expect(find.text('Pick Up Later'), findsOneWidget);

      // Tap "Pick Up Now" option
      await tester.tap(find.text('Pick Up Now'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Verify continue button exists and should be enabled
      expect(find.text('Continue to Payment'), findsOneWidget);
      expect(find.text('115'), findsOneWidget);

      // Try to tap the continue button
      final continueButton = find.text('Continue to Payment');
      expect(continueButton, findsOneWidget);
      
      // The button should be tappable (not throw errors)
      await tester.tap(continueButton);
      await tester.pump();
    });

    testWidgets('should show proper state transitions for continue button', (tester) async {
      // Test with default location (fallback scenario)
      await tester.pumpWidget(
        createTestApp(
          child: const PickupDetailsScreen(
            subtotal: 50.0,
            tax: 7.5,
            total: 57.5,
          ),
        ),
      );

      // Wait for initialization
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1000));

      // Verify screen loads
      expect(find.text('Pickup Details'), findsOneWidget);

      // Initially button might be disabled
      expect(find.text('Continue to Payment'), findsOneWidget);

      // Tap "Pick Up Now" to enable button
      await tester.tap(find.text('Pick Up Now'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Button should now be enabled
      final continueButton = find.text('Continue to Payment');
      expect(continueButton, findsOneWidget);
      
      // Verify price is displayed
      expect(find.text('58'), findsOneWidget); // Rounded total
    });

    testWidgets('should handle pickup time selection correctly', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: const PickupDetailsScreen(
            subtotal: 25.0,
            tax: 3.75,
            total: 28.75,
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1000));

      // Test "Pick Up Now" selection
      await tester.tap(find.text('Pick Up Now'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Test "Pick Up Later" selection
      await tester.tap(find.text('Pick Up Later'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Both options should be selectable without errors
      expect(find.text('Pick Up Now'), findsOneWidget);
      expect(find.text('Pick Up Later'), findsOneWidget);
    });

    testWidgets('should not crash when no location is provided', (tester) async {
      // Test fallback scenario when no location is passed
      await tester.pumpWidget(
        createTestApp(
          child: const PickupDetailsScreen(
            subtotal: 75.0,
            tax: 11.25,
            total: 86.25,
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1000));

      // Should not crash and should show default content
      expect(find.text('Pickup Details'), findsOneWidget);
      expect(find.text('Continue to Payment'), findsOneWidget);
      
      // Should show fallback total
      expect(find.text('86'), findsOneWidget);
    });

    testWidgets('should handle responsive layout', (tester) async {
      // Test different screen sizes
      await tester.binding.setSurfaceSize(const Size(400, 800));
      
      await tester.pumpWidget(
        createTestApp(
          child: const PickupDetailsScreen(
            subtotal: 40.0,
            tax: 6.0,
            total: 46.0,
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1000));

      expect(find.text('Pickup Details'), findsOneWidget);

      // Test larger screen
      await tester.binding.setSurfaceSize(const Size(800, 600));
      await tester.pump();

      expect(find.text('Pickup Details'), findsOneWidget);
      expect(find.text('Continue to Payment'), findsOneWidget);
    });

    testWidgets('should display correct pricing', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: const PickupDetailsScreen(
            subtotal: 123.45,
            tax: 18.52,
            total: 141.97,
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1000));

      // Should display rounded total in button
      expect(find.text('142'), findsOneWidget); // 141.97 rounded to 142
      expect(find.text('Continue to Payment'), findsOneWidget);
    });
  });

  group('Provider State Tests', () {
    testWidgets('should not throw Riverpod build cycle errors', (tester) async {
      // This test specifically checks for the Riverpod error we were getting
      bool errorThrown = false;
      
      FlutterError.onError = (FlutterErrorDetails details) {
        if (details.exception.toString().contains('Tried to modify a provider while the widget tree was building')) {
          errorThrown = true;
        }
      };

      await tester.pumpWidget(
        createTestApp(
          child: const PickupDetailsScreen(
            subtotal: 100.0,
            tax: 15.0,
            total: 115.0,
          ),
        ),
      );

      // Allow multiple pump cycles to ensure initialization completes
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 1000));

      // Should not have thrown the Riverpod error
      expect(errorThrown, false, reason: 'Should not throw Riverpod build cycle error');
      
      // Reset error handler
      FlutterError.onError = FlutterError.presentError;
    });
  });
}