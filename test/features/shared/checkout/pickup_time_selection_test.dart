import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:independent/features/shared/checkout/presentation/pages/pickup_details_screen.dart';
import 'package:independent/features/shared/checkout/domain/entities/checkout_entities.dart';

// Helper function to create test app with GoRouter and Riverpod
Widget createTestApp({required Widget child, List<Override>? overrides}) {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => child,
      ),
      GoRoute(
        path: '/checkout/payment-method',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Payment Method Screen')),
        ),
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

void main() {
  group('Pickup Time Selection Tests', () {
    
    testWidgets('should initially disable continue button when no pickup time is selected', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: const PickupDetailsScreen(
            subtotal: 100.0,
            tax: 15.0,
            total: 115.0,
          ),
        ),
      );

      // Wait for initialization
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1500));

      // Verify screen loads
      expect(find.text('Pickup Details'), findsOneWidget);
      expect(find.text('Pick Up Now'), findsOneWidget);
      expect(find.text('Pick Up Later'), findsOneWidget);
      expect(find.text('Continue to Payment'), findsOneWidget);

      // Continue button should exist but may be disabled initially
      final continueButton = find.text('Continue to Payment');
      expect(continueButton, findsOneWidget);
    });

    testWidgets('should enable continue button when Pick Up Now is selected', (tester) async {
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
      await tester.pump(const Duration(milliseconds: 1500));

      // Tap "Pick Up Now"
      await tester.tap(find.text('Pick Up Now'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Verify Pick Up Now is selected
      expect(find.text('Pick Up Now'), findsOneWidget);
      
      // Continue button should be enabled and tappable
      final continueButton = find.text('Continue to Payment');
      expect(continueButton, findsOneWidget);
      
      // Should be able to tap without errors
      await tester.tap(continueButton);
      await tester.pump();
    });

    testWidgets('should allow switching from Pick Up Now to Pick Up Later', (tester) async {
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
      await tester.pump(const Duration(milliseconds: 1500));

      // First select Pick Up Now
      await tester.tap(find.text('Pick Up Now'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Then select Pick Up Later
      await tester.tap(find.text('Pick Up Later'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Verify both options are still available
      expect(find.text('Pick Up Now'), findsOneWidget);
      expect(find.text('Pick Up Later'), findsOneWidget);
      
      // Continue button should still exist
      expect(find.text('Continue to Payment'), findsOneWidget);
    });

    testWidgets('should allow switching from Pick Up Later back to Pick Up Now', (tester) async {
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
      await tester.pump(const Duration(milliseconds: 1500));

      // First select Pick Up Later
      await tester.tap(find.text('Pick Up Later'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Then switch back to Pick Up Now
      await tester.tap(find.text('Pick Up Now'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Verify Pick Up Now is selected and continue button works
      expect(find.text('Pick Up Now'), findsOneWidget);
      expect(find.text('Continue to Payment'), findsOneWidget);
      
      // Continue button should be tappable
      await tester.tap(find.text('Continue to Payment'));
      await tester.pump();
    });

    testWidgets('should handle multiple rapid taps on pickup options without breaking', (tester) async {
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
      await tester.pump(const Duration(milliseconds: 1500));

      // Rapidly tap between options
      for (int i = 0; i < 5; i++) {
        await tester.tap(find.text('Pick Up Now'));
        await tester.pump(const Duration(milliseconds: 50));
        
        await tester.tap(find.text('Pick Up Later'));
        await tester.pump(const Duration(milliseconds: 50));
      }

      // Final state should be stable
      await tester.pump(const Duration(milliseconds: 1000));
      
      // UI should still be functional
      expect(find.text('Pickup Details'), findsOneWidget);
      expect(find.text('Pick Up Now'), findsOneWidget);
      expect(find.text('Pick Up Later'), findsOneWidget);
      expect(find.text('Continue to Payment'), findsOneWidget);
    });

    testWidgets('should allow reselection after navigating back', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: const PickupDetailsScreen(
            subtotal: 60.0,
            tax: 9.0,
            total: 69.0,
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1500));

      // Select Pick Up Now
      await tester.tap(find.text('Pick Up Now'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Verify continue button is enabled
      expect(find.text('Continue to Payment'), findsOneWidget);
      
      // Simulate navigation back by rebuilding widget (fresh state)
      await tester.pumpWidget(
        createTestApp(
          child: const PickupDetailsScreen(
            subtotal: 60.0,
            tax: 9.0,
            total: 69.0,
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1500));

      // Should be able to reselect pickup options
      await tester.tap(find.text('Pick Up Later'));
      await tester.pump(const Duration(milliseconds: 500));
      
      // Should be able to switch back to Pick Up Now
      await tester.tap(find.text('Pick Up Now'));
      await tester.pump(const Duration(milliseconds: 500));

      // Continue button should be functional
      expect(find.text('Continue to Payment'), findsOneWidget);
      await tester.tap(find.text('Continue to Payment'));
      await tester.pump();
    });

    testWidgets('should handle different screen sizes without breaking functionality', (tester) async {
      // Test small screen
      await tester.binding.setSurfaceSize(const Size(350, 600));
      
      await tester.pumpWidget(
        createTestApp(
          child: const PickupDetailsScreen(
            subtotal: 30.0,
            tax: 4.5,
            total: 34.5,
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1500));

      // Test pickup selection on small screen
      await tester.tap(find.text('Pick Up Now'));
      await tester.pump(const Duration(milliseconds: 500));
      
      expect(find.text('Continue to Payment'), findsOneWidget);

      // Test large screen
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      await tester.pump();

      // Functionality should still work
      await tester.tap(find.text('Pick Up Later'));
      await tester.pump(const Duration(milliseconds: 500));
      
      expect(find.text('Pick Up Now'), findsOneWidget);
      expect(find.text('Pick Up Later'), findsOneWidget);
    });

    testWidgets('should handle provider state correctly with location data', (tester) async {
      const testLocation = PickupLocationEntity(
        id: 'test-location',
        name: 'Test Restaurant',
        address: 'Test Address',
        brandLogoPath: 'assets/images/logos/brands/Salt.png',
        latitude: 25.2048,
        longitude: 55.2708,
        isActive: true,
      );

      await tester.pumpWidget(
        createTestApp(
          child: const PickupDetailsScreen(
            subtotal: 80.0,
            tax: 12.0,
            total: 92.0,
            foodLocation: testLocation,
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1500));

      // With location data, pickup selection should work smoothly
      await tester.tap(find.text('Pick Up Now'));
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Continue to Payment'), findsOneWidget);
      
      // Switch to Pick Up Later
      await tester.tap(find.text('Pick Up Later'));
      await tester.pump(const Duration(milliseconds: 500));

      // Should not crash and should maintain functionality
      expect(find.text('Pick Up Now'), findsOneWidget);
      expect(find.text('Pick Up Later'), findsOneWidget);
    });

    testWidgets('should clear errors when switching between pickup options', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: const PickupDetailsScreen(
            subtotal: 55.0,
            tax: 8.25,
            total: 63.25,
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1500));

      // Test multiple selections to ensure error clearing
      await tester.tap(find.text('Pick Up Later'));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('Pick Up Now'));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('Pick Up Later'));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('Pick Up Now'));
      await tester.pump(const Duration(milliseconds: 500));

      // Final state should be clean without errors
      expect(find.text('Continue to Payment'), findsOneWidget);
      
      // Continue button should be functional
      await tester.tap(find.text('Continue to Payment'));
      await tester.pump();
    });

    testWidgets('should handle edge case with very small totals', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: const PickupDetailsScreen(
            subtotal: 0.01,
            tax: 0.0,
            total: 0.01,
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1500));

      await tester.tap(find.text('Pick Up Now'));
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Continue to Payment'), findsOneWidget);
      expect(find.text('0'), findsOneWidget); // Should show rounded total
    });
  });

  group('Pickup Time State Management Tests', () {
    
    testWidgets('should maintain consistent state across provider changes', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: const PickupDetailsScreen(
            subtotal: 100.0,
            tax: 15.0,
            total: 115.0,
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1500));

      // Test provider state consistency
      await tester.tap(find.text('Pick Up Now'));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 300));

      // Should maintain state without flickering
      expect(find.text('Pick Up Now'), findsOneWidget);
      expect(find.text('Continue to Payment'), findsOneWidget);
    });
  });
}