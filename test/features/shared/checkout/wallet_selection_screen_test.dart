import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:independent/features/shared/checkout/presentation/pages/wallet_selection_screen.dart';
import 'package:independent/features/shared/checkout/domain/entities/checkout_entities.dart';

void main() {
  group('WalletSelectionScreen', () {
    testWidgets('displays header with title and back button', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const WalletSelectionScreen(
              total: 10.0,
              currency: 'SAR',
            ),
          ),
        ),
      );

      // Wait for the screen to load
      await tester.pumpAndSettle();

      // Verify header elements
      expect(find.text('Choose Your Wallet'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);
    });

    testWidgets('displays payment amount correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const WalletSelectionScreen(
              total: 25.0,
              currency: 'SAR',
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify payment amount display
      expect(find.text('To Pay: '), findsOneWidget);
      expect(find.text('25'), findsAtLeastNWidgets(1)); // Amount appears in header and button
    });

    testWidgets('displays continue button', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const WalletSelectionScreen(
              total: 15.0,
              currency: 'SAR',
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify continue button
      expect(find.text('Review Order'), findsOneWidget);
      expect(find.text('15'), findsAtLeastNWidgets(1)); // Amount on button
    });

    testWidgets('continue button is disabled when no wallet selected', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const WalletSelectionScreen(
              total: 10.0,
              currency: 'SAR',
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find the continue button
      final continueButton = find.widgetWithText(ElevatedButton, 'Review Order');
      expect(continueButton, findsOneWidget);

      // Verify button is disabled (should be grayed out)
      final button = tester.widget<ElevatedButton>(continueButton);
      expect(button.onPressed, isNull); // Disabled buttons have null onPressed
    });
  });

  group('WalletEntity', () {
    test('hasSufficientBalance returns correct values', () {
      const wallet = WalletEntity(
        id: 'test_wallet',
        name: 'Test Wallet',
        type: WalletType.teamLunch,
        balance: 100.0,
        currency: 'SAR',
      );

      expect(wallet.hasSufficientBalance(50.0), isTrue);
      expect(wallet.hasSufficientBalance(100.0), isTrue);
      expect(wallet.hasSufficientBalance(150.0), isFalse);
    });

    test('canBeUsed returns correct values', () {
      const activeWallet = WalletEntity(
        id: 'active_wallet',
        name: 'Active Wallet',
        type: WalletType.teamLunch,
        balance: 100.0,
        currency: 'SAR',
        isActive: true,
      );

      const inactiveWallet = WalletEntity(
        id: 'inactive_wallet',
        name: 'Inactive Wallet',
        type: WalletType.teamLunch,
        balance: 100.0,
        currency: 'SAR',
        isActive: false,
      );

      final expiredWallet = WalletEntity(
        id: 'expired_wallet',
        name: 'Expired Wallet',
        type: WalletType.teamLunch,
        balance: 100.0,
        currency: 'SAR',
        isActive: true,
        expiryDate: DateTime.now().subtract(const Duration(days: 1)),
      );

      expect(activeWallet.canBeUsed, isTrue);
      expect(inactiveWallet.canBeUsed, isFalse);
      expect(expiredWallet.canBeUsed, isFalse);
    });

    test('formattedBalance returns correct format', () {
      const wallet = WalletEntity(
        id: 'test_wallet',
        name: 'Test Wallet',
        type: WalletType.teamLunch,
        balance: 4250.0,
        currency: 'SAR',
      );

      expect(wallet.formattedBalance, equals('4250 SAR'));
    });
  });
}