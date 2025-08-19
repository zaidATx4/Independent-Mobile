import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:independent/features/shared/checkout/presentation/pages/review_order_screen.dart';

void main() {
  group('ReviewOrderScreen', () {
    testWidgets('builds without crashing', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const ReviewOrderScreen(),
          ),
        ),
      );

      // Assert - just check that the screen builds without errors
      expect(find.byType(ReviewOrderScreen), findsOneWidget);
      expect(find.text('Checkout'), findsOneWidget);
    });

    testWidgets('displays header correctly', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const ReviewOrderScreen(),
          ),
        ),
      );

      // Assert
      expect(find.text('Checkout'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);
    });

    testWidgets('displays bottom checkout button', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const ReviewOrderScreen(),
          ),
        ),
      );

      // Assert
      expect(find.text('Check out'), findsOneWidget);
    });

    testWidgets('has correct background color', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const ReviewOrderScreen(),
          ),
        ),
      );

      // Assert
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, const Color(0xFF1A1A1A));
    });
  });
}