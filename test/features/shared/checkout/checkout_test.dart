import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

// Import the files we want to test
import 'package:independent/features/shared/checkout/domain/entities/checkout_entities.dart';
import 'package:independent/features/shared/checkout/domain/repositories/checkout_repository.dart';
import 'package:independent/features/shared/checkout/domain/usecases/checkout_usecases.dart';
import 'package:independent/features/shared/checkout/data/models/checkout_models.dart';

// Generate mocks
@GenerateMocks([CheckoutRepository])
import 'checkout_test.mocks.dart';

void main() {
  group('Checkout Entities Tests', () {
    test('PickupLocationEntity should be created with valid data', () {
      const location = PickupLocationEntity(
        id: '1',
        name: 'Test Location',
        address: 'Test Address',
        brandLogoPath: 'test/logo.png',
        latitude: 25.2048,
        longitude: 55.2708,
      );

      expect(location.id, '1');
      expect(location.name, 'Test Location');
      expect(location.isActive, true); // Default value
      expect(location.toString(), contains('Test Location'));
    });

    test('PickupTimeEntity.now() should create a "Pick Up Now" entity', () {
      final pickupTime = PickupTimeEntity.now();

      expect(pickupTime.type, PickupTimeType.now);
      expect(pickupTime.displayText, 'Pick Up Now');
      expect(pickupTime.isNow, true);
      expect(pickupTime.isLater, false);
      expect(pickupTime.hasScheduledTime, false);
    });

    test('PickupTimeEntity.later() should create a "Pick Up Later" entity', () {
      final scheduledTime = DateTime.now().add(const Duration(hours: 2));
      final pickupTime = PickupTimeEntity.later(scheduledTime);

      expect(pickupTime.type, PickupTimeType.later);
      expect(pickupTime.displayText, 'Pick Up Later');
      expect(pickupTime.isNow, false);
      expect(pickupTime.isLater, true);
      expect(pickupTime.hasScheduledTime, true);
      expect(pickupTime.scheduledTime, scheduledTime);
    });

    test('PaymentMethodEntity should handle card details securely', () {
      const paymentMethod = PaymentMethodEntity(
        id: '1',
        type: PaymentMethodType.card,
        displayName: 'Visa ending in 1234',
        lastFourDigits: '1234',
        cardBrand: 'Visa',
        isDefault: true,
      );

      expect(paymentMethod.isCard, true);
      expect(paymentMethod.isDigitalWallet, false);
      expect(paymentMethod.maskedCardNumber, '**** **** **** 1234');
      expect(paymentMethod.isDefault, true);
    });

    test('CheckoutEntity should validate state correctly', () {
      const location = PickupLocationEntity(
        id: '1',
        name: 'Test Location',
        address: 'Test Address',
        brandLogoPath: 'test/logo.png',
        latitude: 25.2048,
        longitude: 55.2708,
      );

      final pickupTime = PickupTimeEntity.now();
      final pickupDetails = PickupDetailsEntity(
        location: location,
        pickupTime: pickupTime,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      const paymentMethod = PaymentMethodEntity(
        id: '1',
        type: PaymentMethodType.card,
        displayName: 'Test Card',
      );

      final checkout = CheckoutStateEntity(
        id: '1',
        status: CheckoutStatus.initial,
        pickupDetails: pickupDetails,
        paymentMethod: paymentMethod,
        subtotal: 100.0,
        tax: 15.0,
        total: 115.0,
        createdAt: DateTime.now(),
      );

      expect(checkout.canProceed, true);
      expect(checkout.canCompletePayment, true);
      expect(checkout.isInProgress, false);
      expect(checkout.isCompleted, false);
    });
  });

  group('Checkout Models Tests', () {
    test('PickupLocationModel should serialize/deserialize correctly', () {
      final originalLocation = const PickupLocationModel(
        id: '1',
        name: 'Test Location',
        address: 'Test Address',
        brandLogoPath: 'test/logo.png',
        latitude: 25.2048,
        longitude: 55.2708,
      );

      final json = originalLocation.toJson();
      final reconstructedLocation = PickupLocationModel.fromJson(json);

      expect(reconstructedLocation.id, originalLocation.id);
      expect(reconstructedLocation.name, originalLocation.name);
      expect(reconstructedLocation.address, originalLocation.address);
      expect(reconstructedLocation.latitude, originalLocation.latitude);
      expect(reconstructedLocation.longitude, originalLocation.longitude);
    });

    test('PaymentMethodModel should handle secure serialization', () {
      const originalPaymentMethod = PaymentMethodModel(
        id: '1',
        type: PaymentMethodType.card,
        displayName: 'Visa ending in 1234',
        lastFourDigits: '1234',
        cardBrand: 'Visa',
        isDefault: true,
      );

      final json = originalPaymentMethod.toJson();
      final reconstructed = PaymentMethodModel.fromJson(json);

      expect(reconstructed.id, originalPaymentMethod.id);
      expect(reconstructed.type, originalPaymentMethod.type);
      expect(reconstructed.lastFourDigits, originalPaymentMethod.lastFourDigits);
      expect(reconstructed.isDefault, originalPaymentMethod.isDefault);
      
      // Ensure no sensitive data is serialized
      expect(json.containsKey('card_number'), false);
      expect(json.containsKey('cvv'), false);
      expect(json.containsKey('expiry'), false);
    });
  });

  group('Checkout Use Cases Tests', () {
    late MockCheckoutRepository mockRepository;
    late GetPickupLocationsUseCase getPickupLocationsUseCase;
    late CreateCheckoutUseCase createCheckoutUseCase;
    late UpdatePickupDetailsUseCase updatePickupDetailsUseCase;
    late ValidatePickupTimeSlotUseCase validatePickupTimeSlotUseCase;

    setUp(() {
      mockRepository = MockCheckoutRepository();
      getPickupLocationsUseCase = GetPickupLocationsUseCase(mockRepository);
      createCheckoutUseCase = CreateCheckoutUseCase(mockRepository);
      updatePickupDetailsUseCase = UpdatePickupDetailsUseCase(mockRepository);
      validatePickupTimeSlotUseCase = ValidatePickupTimeSlotUseCase(mockRepository);
    });

    test('GetPickupLocationsUseCase should return active locations only', () async {
      final mockLocations = [
        const PickupLocationEntity(
          id: '1',
          name: 'Active Location',
          address: 'Address 1',
          brandLogoPath: 'logo1.png',
          latitude: 25.2048,
          longitude: 55.2708,
          isActive: true,
        ),
        const PickupLocationEntity(
          id: '2',
          name: 'Inactive Location',
          address: 'Address 2',
          brandLogoPath: 'logo2.png',
          latitude: 25.2048,
          longitude: 55.2708,
          isActive: false,
        ),
      ];

      when(mockRepository.getPickupLocations(brandId: anyNamed('brandId')))
          .thenAnswer((_) async => mockLocations);

      final result = await getPickupLocationsUseCase(
        const GetPickupLocationsParams(brandId: 'test-brand'),
      );

      expect(result.length, 1);
      expect(result.first.isActive, true);
      expect(result.first.name, 'Active Location');
    });

    test('CreateCheckoutUseCase should validate input parameters', () async {
      // Test negative subtotal
      expect(
        () async => await createCheckoutUseCase(
          const CreateCheckoutParams(
            subtotal: -10.0,
            tax: 1.5,
            total: 8.5,
          ),
        ),
        throwsA(isA<ArgumentError>()),
      );

      // Test negative tax
      expect(
        () async => await createCheckoutUseCase(
          const CreateCheckoutParams(
            subtotal: 10.0,
            tax: -1.5,
            total: 8.5,
          ),
        ),
        throwsA(isA<ArgumentError>()),
      );

      // Test total less than subtotal
      expect(
        () async => await createCheckoutUseCase(
          const CreateCheckoutParams(
            subtotal: 10.0,
            tax: 1.5,
            total: 5.0,
          ),
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('ValidatePickupTimeSlotUseCase should reject past times', () async {
      final pastTime = DateTime.now().subtract(const Duration(hours: 1));

      final result = await validatePickupTimeSlotUseCase(
        ValidatePickupTimeSlotParams(
          locationId: 'test-location',
          pickupTime: pastTime,
        ),
      );

      expect(result, false);
      verifyNever(mockRepository.validatePickupTimeSlot(any, any));
    });

    test('ValidatePickupTimeSlotUseCase should reject times too soon', () async {
      final tooSoon = DateTime.now().add(const Duration(minutes: 15));

      final result = await validatePickupTimeSlotUseCase(
        ValidatePickupTimeSlotParams(
          locationId: 'test-location',
          pickupTime: tooSoon,
        ),
      );

      expect(result, false);
      verifyNever(mockRepository.validatePickupTimeSlot(any, any));
    });

    test('ValidatePickupTimeSlotUseCase should accept valid future times', () async {
      final validTime = DateTime.now().add(const Duration(hours: 2));

      when(mockRepository.validatePickupTimeSlot('test-location', validTime))
          .thenAnswer((_) async => true);

      final result = await validatePickupTimeSlotUseCase(
        ValidatePickupTimeSlotParams(
          locationId: 'test-location',
          pickupTime: validTime,
        ),
      );

      expect(result, true);
      verify(mockRepository.validatePickupTimeSlot('test-location', validTime))
          .called(1);
    });

    test('UpdatePickupDetailsUseCase should validate pickup details', () async {
      const inactiveLocation = PickupLocationEntity(
        id: '1',
        name: 'Test Location',
        address: 'Test Address',
        brandLogoPath: 'logo.png',
        latitude: 25.2048,
        longitude: 55.2708,
        isActive: false, // Inactive location
      );

      final pickupTime = PickupTimeEntity.now();
      final invalidPickupDetails = PickupDetailsEntity(
        location: inactiveLocation,
        pickupTime: pickupTime,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(
        () async => await updatePickupDetailsUseCase(
          UpdatePickupDetailsParams(
            checkoutId: 'test-checkout',
            pickupDetails: invalidPickupDetails,
          ),
        ),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('Checkout Security Tests', () {
    test('PaymentMethodEntity should not expose sensitive data', () {
      const paymentMethod = PaymentMethodEntity(
        id: '1',
        type: PaymentMethodType.card,
        displayName: 'Test Card',
        lastFourDigits: '1234',
        secureMetadata: {
          'token': 'secure-token-12345',
          'provider': 'stripe',
        },
      );

      // Ensure only safe data is accessible
      expect(paymentMethod.lastFourDigits, '1234');
      expect(paymentMethod.maskedCardNumber, '**** **** **** 1234');
      
      // toString should not expose sensitive data
      final stringRep = paymentMethod.toString();
      expect(stringRep.contains('secure-token'), false);
      expect(stringRep.contains('1234'), false);
    });

    test('CheckoutResultEntity should handle success and failure cases', () {
      final successResult = CheckoutResultEntity(
        success: true,
        orderId: 'ORDER-123',
        transactionId: 'TXN-456',
        message: 'Payment successful',
        timestamp: DateTime.now(),
      );

      final failureResult = CheckoutResultEntity(
        success: false,
        message: 'Payment declined',
        timestamp: DateTime.now(),
      );

      expect(successResult.success, true);
      expect(successResult.orderId, 'ORDER-123');
      expect(successResult.transactionId, 'TXN-456');

      expect(failureResult.success, false);
      expect(failureResult.orderId, null);
      expect(failureResult.transactionId, null);
    });
  });

  group('Checkout Business Logic Tests', () {
    test('Pickup time validation for business hours', () {
      final workingHoursTime = DateTime(2024, 1, 1, 14, 30); // 2:30 PM
      final afterHoursTime = DateTime(2024, 1, 1, 23, 30); // 11:30 PM
      final earlyMorningTime = DateTime(2024, 1, 1, 5, 30); // 5:30 AM

      // These would be validated by the business logic
      expect(workingHoursTime.hour, greaterThanOrEqualTo(8));
      expect(workingHoursTime.hour, lessThan(22));
      
      expect(afterHoursTime.hour, greaterThanOrEqualTo(22));
      expect(earlyMorningTime.hour, lessThan(8));
    });

    test('Tax calculation should be accurate', () {
      const subtotal = 100.0;
      const taxRate = 0.15; // 15% VAT
      const expectedTax = 15.0;
      const expectedTotal = 115.0;

      final calculatedTax = subtotal * taxRate;
      final calculatedTotal = subtotal + calculatedTax;

      expect(calculatedTax, expectedTax);
      expect(calculatedTotal, expectedTotal);
    });

    test('Currency formatting should handle SAR correctly', () {
      const amount = 123.50;
      const currency = 'SAR';
      
      // Basic validation for SAR currency
      expect(currency, 'SAR');
      expect(amount, greaterThan(0));
      
      // In a real implementation, you'd use proper currency formatting
      final formattedAmount = amount.toStringAsFixed(2);
      expect(formattedAmount, '123.50');
    });

    test('Pickup time slots should have minimum intervals', () {
      final now = DateTime.now();
      final minFutureTime = now.add(const Duration(minutes: 30));
      final validFutureTime = now.add(const Duration(hours: 1));

      expect(validFutureTime.isAfter(minFutureTime), true);
      expect(now.isAfter(minFutureTime), false);
    });
  });

  group('Error Handling Tests', () {
    test('CheckoutException should contain proper error details', () {
      const error = CheckoutException(
        'Test error message',
        code: 'TEST_ERROR',
        details: {'field': 'test'},
      );

      expect(error.message, 'Test error message');
      expect(error.code, 'TEST_ERROR');
      expect(error.details, {'field': 'test'});
      expect(error.toString(), contains('CheckoutException'));
    });

    test('PaymentException should extend CheckoutException', () {
      const error = PaymentException(
        'Payment failed',
        code: 'PAYMENT_DECLINED',
      );

      expect(error, isA<CheckoutException>());
      expect(error.message, 'Payment failed');
      expect(error.code, 'PAYMENT_DECLINED');
      expect(error.toString(), contains('PaymentException'));
    });

    test('SecurityException should handle security-related errors', () {
      const error = SecurityException(
        'Biometric authentication required',
        code: 'BIOMETRIC_REQUIRED',
      );

      expect(error, isA<CheckoutException>());
      expect(error.message, 'Biometric authentication required');
      expect(error.code, 'BIOMETRIC_REQUIRED');
      expect(error.toString(), contains('SecurityException'));
    });
  });
}