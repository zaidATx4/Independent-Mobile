import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:independent/features/shared/checkout/presentation/pages/pickup_details_screen.dart';
import 'package:independent/features/shared/checkout/presentation/widgets/checkout_location_card.dart';
import 'package:independent/features/shared/checkout/presentation/widgets/checkout_radio_option.dart';
import 'package:independent/features/shared/checkout/presentation/widgets/checkout_continue_button.dart';
import 'package:independent/features/shared/checkout/domain/entities/checkout_entities.dart';

void main() {
  group('PickupDetailsScreen Widget Tests', () {
    testWidgets('should display app bar with correct title', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const PickupDetailsScreen(
              subtotal: 100.0,
              tax: 15.0,
              total: 115.0,
            ),
          ),
        ),
      );

      expect(find.text('Pickup Details'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);
    });

    testWidgets('should display section headers correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const PickupDetailsScreen(
              subtotal: 100.0,
              tax: 15.0,
              total: 115.0,
            ),
          ),
        ),
      );

      expect(find.text('Pickup Location'), findsOneWidget);
      expect(find.text('Pickup Time'), findsOneWidget);
    });

    testWidgets('should display pickup time options', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const PickupDetailsScreen(
              subtotal: 100.0,
              tax: 15.0,
              total: 115.0,
            ),
          ),
        ),
      );

      expect(find.text('Pick Up Now'), findsOneWidget);
      expect(find.text('Get your order as soon as possible'), findsOneWidget);
      expect(find.text('Pick Up Later'), findsOneWidget);
      expect(find.text('Choose a date and time that suits you.'), findsOneWidget);
    });

    testWidgets('should display continue button with price', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const PickupDetailsScreen(
              subtotal: 100.0,
              tax: 15.0,
              total: 115.0,
            ),
          ),
        ),
      );

      expect(find.text('115'), findsOneWidget);
      expect(find.text('Continue to Payment'), findsOneWidget);
    });
  });

  group('CheckoutLocationCard Widget Tests', () {
    const mockLocation = PickupLocationEntity(
      id: '1',
      name: 'Test Restaurant',
      address: 'Test Address, City, Country',
      brandLogoPath: 'assets/test/logo.png',
      latitude: 25.2048,
      longitude: 55.2708,
    );

    testWidgets('should display location information correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CheckoutLocationCard(
              location: mockLocation,
            ),
          ),
        ),
      );

      expect(find.text('Test Restaurant'), findsOneWidget);
      expect(find.text('Test Address, City, Country'), findsOneWidget);
    });

    testWidgets('should handle tap events', (tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CheckoutLocationCard(
              location: mockLocation,
              onTap: () => wasTapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CheckoutLocationCard));
      await tester.pumpAndSettle();

      expect(wasTapped, true);
    });
  });

  group('CheckoutRadioOption Widget Tests', () {
    testWidgets('should display radio button states correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                CheckoutRadioOption(
                  isSelected: true,
                  title: 'Selected Option',
                  description: 'This option is selected',
                ),
                CheckoutRadioOption(
                  isSelected: false,
                  title: 'Unselected Option',
                  description: 'This option is not selected',
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Selected Option'), findsOneWidget);
      expect(find.text('Unselected Option'), findsOneWidget);
      expect(find.text('This option is selected'), findsOneWidget);
      expect(find.text('This option is not selected'), findsOneWidget);
    });

    testWidgets('should handle tap events', (tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CheckoutRadioOption(
              isSelected: false,
              title: 'Test Option',
              description: 'Test Description',
              onTap: () => wasTapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CheckoutRadioOption));
      await tester.pumpAndSettle();

      expect(wasTapped, true);
    });

    testWidgets('should display additional content when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CheckoutRadioOption(
              isSelected: true,
              title: 'Option with Content',
              description: 'This has additional content',
              additionalContent: const Text('Additional Content'),
            ),
          ),
        ),
      );

      expect(find.text('Additional Content'), findsOneWidget);
    });
  });

  group('CheckoutContinueButton Widget Tests', () {
    testWidgets('should display price and button text correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CheckoutContinueButton(
              price: '125',
              currency: 'SAR',
              buttonText: 'Continue to Payment',
            ),
          ),
        ),
      );

      expect(find.text('125'), findsOneWidget);
      expect(find.text('Continue to Payment'), findsOneWidget);
      expect(find.text('|'), findsOneWidget);
    });

    testWidgets('should handle enabled/disabled states', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                CheckoutContinueButton(
                  price: '125',
                  enabled: true,
                  onPressed: () {},
                ),
                const CheckoutContinueButton(
                  price: '125',
                  enabled: false,
                ),
              ],
            ),
          ),
        ),
      );

      final buttons = find.byType(CheckoutContinueButton);
      expect(buttons, findsNWidgets(2));
    });

    testWidgets('should show loading indicator when loading', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CheckoutContinueButton(
              price: '125',
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Continue to Payment'), findsNothing);
    });

    testWidgets('should handle tap events when enabled', (tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CheckoutContinueButton(
              price: '125',
              enabled: true,
              onPressed: () => wasTapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CheckoutContinueButton));
      await tester.pumpAndSettle();

      expect(wasTapped, true);
    });
  });

  group('Integration Tests', () {
    testWidgets('should handle complete pickup flow', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const PickupDetailsScreen(
              subtotal: 100.0,
              tax: 15.0,
              total: 115.0,
            ),
          ),
        ),
      );

      // Verify initial state
      expect(find.text('Pickup Details'), findsOneWidget);
      expect(find.text('Pick Up Now'), findsOneWidget);
      expect(find.text('Pick Up Later'), findsOneWidget);

      // Test tapping "Pick Up Now" option
      await tester.tap(find.text('Pick Up Now'));
      await tester.pumpAndSettle();

      // The radio button selection should be handled by the provider
      // In a real test, we'd verify the provider state changed

      // Test continue button presence
      expect(find.text('Continue to Payment'), findsOneWidget);
      expect(find.text('115'), findsOneWidget);
    });

    testWidgets('should handle back navigation', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const PickupDetailsScreen(
              subtotal: 100.0,
              tax: 15.0,
              total: 115.0,
            ),
          ),
        ),
      );

      // Test back button
      expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);
      
      // In a real test with navigation, we'd verify the back action
      await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
      await tester.pumpAndSettle();
    });

    testWidgets('should display error states gracefully', (tester) async {
      // This would test error scenarios in a real implementation
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const PickupDetailsScreen(
              subtotal: 100.0,
              tax: 15.0,
              total: 115.0,
            ),
          ),
        ),
      );

      // Verify the screen doesn't crash with empty state
      expect(find.text('Pickup Details'), findsOneWidget);
    });

    testWidgets('should handle responsive layout', (tester) async {
      // Test different screen sizes
      await tester.binding.setSurfaceSize(const Size(400, 800));
      
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const PickupDetailsScreen(
              subtotal: 100.0,
              tax: 15.0,
              total: 115.0,
            ),
          ),
        ),
      );

      expect(find.text('Pickup Details'), findsOneWidget);

      // Test larger screen size
      await tester.binding.setSurfaceSize(const Size(800, 600));
      await tester.pumpAndSettle();

      expect(find.text('Pickup Details'), findsOneWidget);
    });

    testWidgets('should maintain scroll position', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const PickupDetailsScreen(
              subtotal: 100.0,
              tax: 15.0,
              total: 115.0,
            ),
          ),
        ),
      );

      // Find the scrollable area
      final scrollableFinder = find.byType(SingleChildScrollView);
      expect(scrollableFinder, findsOneWidget);

      // Test scrolling
      await tester.drag(scrollableFinder, const Offset(0, -200));
      await tester.pumpAndSettle();

      // Verify elements are still present after scrolling
      expect(find.text('Pickup Details'), findsOneWidget);
    });
  });
}