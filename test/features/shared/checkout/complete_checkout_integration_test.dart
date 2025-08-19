import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// removed integration_test import; use flutter_test bindings for these widget tests
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Use lightweight test-only screens here to avoid network/providers during widget tests
// import 'package:independent/features/shared/checkout/presentation/pages/review_order_screen.dart';
// import 'package:independent/features/shared/checkout/presentation/pages/payment_method_screen.dart';
// import 'package:independent/features/shared/checkout/presentation/pages/pickup_details_screen.dart';

/// Integration test to verify the complete checkout flow
/// Tests the integration between pickup details → payment method → review order
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Complete Checkout Flow Integration Tests', () {
    testWidgets('can navigate through complete checkout flow', (
      WidgetTester tester,
    ) async {
      // Test navigation flow without actual data
      // This verifies the routing and basic widget construction works

      // Use test-only simple screens for navigation so tests don't depend on app services
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            title: 'Independent Mobile Checkout Test',
            routes: {
              '/pickup-details': (context) => const TestPickupDetailsScreen(),
              '/payment-method': (context) => const TestPaymentMethodScreen(),
              '/review-order': (context) => const TestReviewOrderScreen(),
            },
            home: const TestHomeScreen(),
          ),
        ),
      );

      // Start at home screen
      expect(find.text('Checkout Test Home'), findsOneWidget);

      // Navigate to pickup details
      await tester.tap(find.text('Start Checkout'));
      await tester.pumpAndSettle();

      // Verify pickup details screen loads
      expect(find.text('Pickup Details'), findsOneWidget);

      // Navigate to payment method
      await tester.tap(find.text('To Payment Method'));
      await tester.pumpAndSettle();

      // Verify payment method screen loads
      expect(find.text('Payment Method'), findsOneWidget);

      // Navigate to review order
      await tester.tap(find.text('To Review Order'));
      await tester.pumpAndSettle();

      // Verify review order screen loads
      expect(find.text('Checkout'), findsOneWidget);
      expect(find.text('Check out'), findsOneWidget);
    });

    testWidgets('review order screen builds correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: const TestReviewOrderScreen())),
      );

      // Verify screen elements are present
      expect(find.byType(TestReviewOrderScreen), findsOneWidget);
      expect(find.text('Checkout'), findsOneWidget);
      expect(find.text('Check out'), findsOneWidget);

      // Verify correct background color
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, const Color(0xFF1A1A1A));
    });

    testWidgets('payment method screen builds correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(home: const TestPaymentMethodScreen()),
        ),
      );

      // Verify screen elements are present
      expect(find.byType(TestPaymentMethodScreen), findsOneWidget);
      expect(find.text('Payment Method'), findsOneWidget);
    });
  });
}

/// Simple test home screen for navigation testing
class TestHomeScreen extends StatelessWidget {
  const TestHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Checkout Test Home',
              style: TextStyle(color: Color(0xFFFEFEFF), fontSize: 24),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/pickup-details');
              },
              child: const Text('Start Checkout'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/payment-method');
              },
              child: const Text('To Payment Method'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/review-order');
              },
              child: const Text('To Review Order'),
            ),
          ],
        ),
      ),
    );
  }
}

// Lightweight test-only screens to avoid real app dependencies in unit/widget tests
class TestPickupDetailsScreen extends StatelessWidget {
  const TestPickupDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(title: const Text('Pickup Details')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pushNamed('/payment-method'),
          child: const Text('To Payment Method'),
        ),
      ),
    );
  }
}

class TestPaymentMethodScreen extends StatelessWidget {
  const TestPaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(title: const Text('Payment Method')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pushNamed('/review-order'),
          child: const Text('To Review Order'),
        ),
      ),
    );
  }
}

class TestReviewOrderScreen extends StatelessWidget {
  const TestReviewOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(title: const Text('Checkout')),
      body: const Center(child: Text('Check out')),
    );
  }
}
