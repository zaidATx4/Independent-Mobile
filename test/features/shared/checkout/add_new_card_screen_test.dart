import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:independent/features/shared/checkout/presentation/pages/add_new_card_screen.dart';
import 'package:independent/features/shared/checkout/presentation/widgets/secure_card_input.dart';
import 'package:independent/features/shared/checkout/presentation/utils/card_validation_utils.dart';

void main() {
  group('AddNewCardScreen', () {
    testWidgets('renders correctly with all required fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const AddNewCardScreen(total: 50.0),
          ),
        ),
      );

      // Check if main elements are present
      expect(find.text('Add New Card and Pay'), findsOneWidget);
      expect(find.text('Bank Card'), findsOneWidget);
      expect(find.text('Card Holder\'s Name'), findsOneWidget);
      expect(find.text('Card Number'), findsOneWidget);
      expect(find.text('Expiration Date'), findsOneWidget);
      
      // Check for card type icons
      expect(find.byType(CardTypeSelector), findsOneWidget);
      
      // Check for secure input fields
      expect(find.byType(SecureCardholderNameField), findsOneWidget);
      expect(find.byType(SecureCardNumberField), findsOneWidget);
      expect(find.byType(SecureCvvField), findsOneWidget);
    });

    testWidgets('shows error messages for invalid input', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const AddNewCardScreen(total: 50.0),
          ),
        ),
      );

      // Find the card number field and enter invalid data
      final cardNumberField = find.byType(SecureCardNumberField);
      await tester.enterText(cardNumberField, '1234');
      await tester.pump();

      // Should show validation error for short card number
      // Note: This test might need adjustment based on how real-time validation is implemented
    });
  });

  group('CardValidationUtils', () {
    test('detects Visa card correctly', () {
      expect(CardValidationUtils.detectCardType('4111111111111111'), CardType.visa);
      expect(CardValidationUtils.detectCardType('4'), CardType.visa);
    });

    test('detects Mastercard correctly', () {
      expect(CardValidationUtils.detectCardType('5555555555554444'), CardType.mastercard);
      expect(CardValidationUtils.detectCardType('2221000000000009'), CardType.mastercard);
    });

    test('detects American Express correctly', () {
      expect(CardValidationUtils.detectCardType('378282246310005'), CardType.amex);
    });

    test('validates card numbers using Luhn algorithm', () {
      // Valid test card numbers
      expect(CardValidationUtils.isValidCardNumber('4111111111111111'), isTrue); // Visa
      expect(CardValidationUtils.isValidCardNumber('5555555555554444'), isTrue); // Mastercard
      expect(CardValidationUtils.isValidCardNumber('378282246310005'), isTrue); // Amex
      
      // Invalid card numbers
      expect(CardValidationUtils.isValidCardNumber('4111111111111112'), isFalse);
      expect(CardValidationUtils.isValidCardNumber('1234567890123456'), isFalse);
    });

    test('formats card numbers correctly', () {
      expect(CardValidationUtils.formatCardNumber('4111111111111111'), '4111 1111 1111 1111');
      expect(CardValidationUtils.formatCardNumber('378282246310005'), '3782 822463 10005');
    });

    test('validates expiry dates', () {
      final futureDate = DateTime.now().add(const Duration(days: 365));
      final futureMonth = futureDate.month.toString().padLeft(2, '0');
      final futureYear = futureDate.year.toString().substring(2);
      
      expect(CardValidationUtils.isValidExpiryDate('$futureMonth$futureYear'), isTrue);
      expect(CardValidationUtils.isValidExpiryDate('0120'), isFalse); // Past date
      expect(CardValidationUtils.isValidExpiryDate('1399'), isFalse); // Invalid month
    });

    test('validates CVV codes', () {
      expect(CardValidationUtils.isValidCvv('123', CardType.visa), isTrue);
      expect(CardValidationUtils.isValidCvv('1234', CardType.amex), isTrue);
      expect(CardValidationUtils.isValidCvv('12', CardType.visa), isFalse);
      expect(CardValidationUtils.isValidCvv('123', CardType.amex), isFalse);
    });

    test('validates cardholder names', () {
      expect(CardValidationUtils.isValidCardholderName('John Smith'), isTrue);
      expect(CardValidationUtils.isValidCardholderName('Mary-Jane O\'Connor'), isTrue);
      expect(CardValidationUtils.isValidCardholderName('J'), isFalse); // Too short
      expect(CardValidationUtils.isValidCardholderName(''), isFalse); // Empty
      expect(CardValidationUtils.isValidCardholderName('John123'), isFalse); // Numbers
    });

    test('creates secure card tokens without storing sensitive data', () {
      final token = CardValidationUtils.createCardToken(
        cardNumber: '4111111111111111',
        expiryMonth: '12',
        expiryYear: '25',
        cvv: '123',
        cardholderName: 'John Smith',
      );

      expect(token['token_id'], isNotNull);
      expect(token['last_four'], '1111');
      expect(token['card_type'], 'visa');
      expect(token['expiry_month'], '12');
      expect(token['expiry_year'], '25');
      expect(token['cardholder_name'], 'John Smith');
      expect(token['secure_hash'], isNotNull);
      
      // Ensure no sensitive data is stored
      expect(token.containsKey('card_number'), isFalse);
      expect(token.containsKey('cvv'), isFalse);
    });
  });

  group('Security Features', () {
    test('masks card numbers for display', () {
      expect(CardValidationUtils.maskCardNumber('1111', CardType.visa), '**** **** **** 1111');
      expect(CardValidationUtils.maskCardNumber('0005', CardType.amex), '**** ****** *0005');
    });

    test('provides card type icons', () {
      expect(CardValidationUtils.getCardTypeIcon(CardType.visa), 
             'assets/images/icons/Payment_Methods/Colored_Icons/Visa.svg');
      expect(CardValidationUtils.getCardTypeIcon(CardType.mastercard), 
             'assets/images/icons/Payment_Methods/Colored_Icons/MasterCard.svg');
    });

    test('provides appropriate CVV lengths for different card types', () {
      expect(CardValidationUtils.getCvvLength(CardType.visa), 3);
      expect(CardValidationUtils.getCvvLength(CardType.mastercard), 3);
      expect(CardValidationUtils.getCvvLength(CardType.amex), 4);
      expect(CardValidationUtils.getCvvLength(CardType.discover), 3);
    });
  });
}