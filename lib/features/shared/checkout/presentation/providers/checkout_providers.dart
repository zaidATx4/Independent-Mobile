import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/repositories/checkout_repository_impl.dart';
import '../../domain/repositories/checkout_repository.dart';
import '../../domain/usecases/checkout_usecases.dart';
import '../../domain/entities/checkout_entities.dart';

// SharedPreferences provider
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return SharedPreferences.getInstance();
});

// Dio provider with configuration
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  
  // Configure Dio with base URL and interceptors
  dio.options = BaseOptions(
    baseUrl: 'https://api.independent-mobile.com', // Replace with actual API base URL
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  );

  // Add logging interceptor for development
  // dio.interceptors.add(LogInterceptor(
  //   requestBody: true,
  //   responseBody: true,
  // ));

  return dio;
});

// Repository Provider
final checkoutRepositoryProvider = Provider<CheckoutRepository>((ref) {
  final sharedPrefsAsync = ref.watch(sharedPreferencesProvider);
  
  return sharedPrefsAsync.when(
    data: (prefs) => CheckoutRepositoryImpl(
      dio: ref.watch(dioProvider),
      prefs: prefs,
    ),
    loading: () => throw Exception('Loading preferences...'),
    error: (error, stack) => throw Exception('Failed to initialize preferences: $error'),
  );
});

// Use Case Providers
final getPickupLocationsUseCaseProvider = Provider<GetPickupLocationsUseCase>((ref) {
  return GetPickupLocationsUseCase(ref.watch(checkoutRepositoryProvider));
});

final getPickupLocationByIdUseCaseProvider = Provider<GetPickupLocationByIdUseCase>((ref) {
  return GetPickupLocationByIdUseCase(ref.watch(checkoutRepositoryProvider));
});

final getPaymentMethodsUseCaseProvider = Provider<GetPaymentMethodsUseCase>((ref) {
  return GetPaymentMethodsUseCase(ref.watch(checkoutRepositoryProvider));
});

final createCheckoutUseCaseProvider = Provider<CreateCheckoutUseCase>((ref) {
  return CreateCheckoutUseCase(ref.watch(checkoutRepositoryProvider));
});

final updatePickupDetailsUseCaseProvider = Provider<UpdatePickupDetailsUseCase>((ref) {
  return UpdatePickupDetailsUseCase(ref.watch(checkoutRepositoryProvider));
});

final updatePaymentMethodUseCaseProvider = Provider<UpdatePaymentMethodUseCase>((ref) {
  return UpdatePaymentMethodUseCase(ref.watch(checkoutRepositoryProvider));
});

final processPaymentUseCaseProvider = Provider<ProcessPaymentUseCase>((ref) {
  return ProcessPaymentUseCase(ref.watch(checkoutRepositoryProvider));
});

final validatePickupTimeSlotUseCaseProvider = Provider<ValidatePickupTimeSlotUseCase>((ref) {
  return ValidatePickupTimeSlotUseCase(ref.watch(checkoutRepositoryProvider));
});

final calculateFeesUseCaseProvider = Provider<CalculateFeesUseCase>((ref) {
  return CalculateFeesUseCase(ref.watch(checkoutRepositoryProvider));
});

// State Classes for complex state management
class CheckoutState {
  final CheckoutStateEntity? checkout;
  final PickupDetailsEntity? pickupDetails;
  final List<PickupLocationEntity> availableLocations;
  final List<PaymentMethodEntity> paymentMethods;
  final PickupLocationEntity? selectedLocation;
  final PickupTimeEntity? selectedPickupTime;
  final PaymentMethodEntity? selectedPaymentMethod;
  final bool isLoading;
  final String? error;
  final Map<String, double>? fees;

  const CheckoutState({
    this.checkout,
    this.pickupDetails,
    this.availableLocations = const [],
    this.paymentMethods = const [],
    this.selectedLocation,
    this.selectedPickupTime,
    this.selectedPaymentMethod,
    this.isLoading = false,
    this.error,
    this.fees,
  });

  CheckoutState copyWith({
    CheckoutStateEntity? checkout,
    PickupDetailsEntity? pickupDetails,
    List<PickupLocationEntity>? availableLocations,
    List<PaymentMethodEntity>? paymentMethods,
    PickupLocationEntity? selectedLocation,
    PickupTimeEntity? selectedPickupTime,
    PaymentMethodEntity? selectedPaymentMethod,
    bool? isLoading,
    String? error,
    Map<String, double>? fees,
  }) {
    return CheckoutState(
      checkout: checkout ?? this.checkout,
      pickupDetails: pickupDetails ?? this.pickupDetails,
      availableLocations: availableLocations ?? this.availableLocations,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      selectedPickupTime: selectedPickupTime ?? this.selectedPickupTime,
      selectedPaymentMethod: selectedPaymentMethod ?? this.selectedPaymentMethod,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      fees: fees ?? this.fees,
    );
  }

  bool get canProceedToPayment => 
      selectedLocation != null && 
      selectedPickupTime != null &&
      error == null;

  bool get hasValidPickupDetails => pickupDetails?.isValid == true;

  double get totalAmount {
    final feeMap = fees;
    if (feeMap == null) return 0.0;
    return feeMap.values.whereType<double>().fold(0.0, (sum, fee) => sum + fee);
  }
}

// Main Checkout State Notifier
class CheckoutNotifier extends StateNotifier<CheckoutState> {
  final CheckoutRepository _repository;
  final GetPickupLocationsUseCase _getPickupLocationsUseCase;
  final GetPaymentMethodsUseCase _getPaymentMethodsUseCase;
  final CreateCheckoutUseCase _createCheckoutUseCase;
  final UpdatePickupDetailsUseCase _updatePickupDetailsUseCase;
  final ValidatePickupTimeSlotUseCase _validatePickupTimeSlotUseCase;
  final CalculateFeesUseCase _calculateFeesUseCase;
  final ProcessPaymentUseCase _processPaymentUseCase;

  CheckoutNotifier(
    this._repository,
    this._getPickupLocationsUseCase,
    this._getPaymentMethodsUseCase,
    this._createCheckoutUseCase,
    this._updatePickupDetailsUseCase,
    this._validatePickupTimeSlotUseCase,
    this._calculateFeesUseCase,
    this._processPaymentUseCase,
  ) : super(const CheckoutState());

  /// Initialize checkout with cart totals
  Future<void> initializeCheckout({
    required double subtotal,
    required double tax,
    required double total,
    String? brandId,
    String? locationId,
    PickupLocationEntity? foodLocation, // Added food location parameter
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Create checkout session
      final checkout = await _createCheckoutUseCase(
        CreateCheckoutParams(
          subtotal: subtotal,
          tax: tax,
          total: total,
        ),
      );

      // Load pickup locations and payment methods in parallel
      final futures = await Future.wait([
        _getPickupLocationsUseCase(GetPickupLocationsParams(
          brandId: brandId,
          locationId: locationId,
        )),
        _getPaymentMethodsUseCase(const NoParams()),
      ]);

      final locations = futures[0] as List<PickupLocationEntity>;
      final paymentMethods = futures[1] as List<PaymentMethodEntity>;

      // If food location is provided, automatically select it
      PickupLocationEntity? selectedLocation;
      List<PickupLocationEntity> availableLocations = locations;
      
      if (foodLocation != null) {
        selectedLocation = foodLocation;
        // Add food location to available locations if not already present
        if (!locations.any((loc) => loc.id == foodLocation.id)) {
          availableLocations = [foodLocation, ...locations];
        }
      }

      state = state.copyWith(
        checkout: checkout,
        availableLocations: availableLocations,
        paymentMethods: paymentMethods,
        selectedLocation: selectedLocation, // Auto-select food location
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Select pickup location
  Future<void> selectPickupLocation(PickupLocationEntity location) async {
    state = state.copyWith(selectedLocation: location, error: null);
    
    // Calculate fees when location is selected
    if (state.selectedPickupTime != null) {
      await _calculateFees();
    }
  }

  /// Select pickup time
  Future<void> selectPickupTime(PickupTimeEntity pickupTime) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Validate time slot if "Pick Up Later" is selected
      if (pickupTime.type == PickupTimeType.later && 
          pickupTime.scheduledTime != null &&
          state.selectedLocation != null) {
        final isAvailable = await _validatePickupTimeSlotUseCase(
          ValidatePickupTimeSlotParams(
            locationId: state.selectedLocation!.id,
            pickupTime: pickupTime.scheduledTime!,
          ),
        );

        if (!isAvailable) {
          state = state.copyWith(
            isLoading: false,
            error: 'Selected time slot is not available. Please choose a different time.',
          );
          return;
        }
      }

      state = state.copyWith(
        selectedPickupTime: pickupTime,
        isLoading: false,
      );

      // Calculate fees when pickup time is selected
      if (state.selectedLocation != null) {
        await _calculateFees();
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Calculate fees based on selected options
  Future<void> _calculateFees() async {
    if (state.selectedLocation == null || state.selectedPickupTime == null) {
      return;
    }

    try {
      final fees = await _calculateFeesUseCase(
        CalculateFeesParams(
          locationId: state.selectedLocation!.id,
          pickupType: state.selectedPickupTime!.type,
          scheduledTime: state.selectedPickupTime!.scheduledTime,
        ),
      );

      state = state.copyWith(fees: fees);
    } catch (e) {
      // Fees calculation error - don't break the flow
      state = state.copyWith(error: 'Unable to calculate fees: ${e.toString()}');
    }
  }

  /// Confirm pickup details and proceed to payment
  Future<void> confirmPickupDetails() async {
    if (state.selectedLocation == null || state.selectedPickupTime == null) {
      state = state.copyWith(error: 'Please select pickup location and time');
      return;
    }

    if (state.checkout == null) {
      state = state.copyWith(error: 'Checkout session not found');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final pickupDetails = PickupDetailsEntity(
        location: state.selectedLocation!,
        pickupTime: state.selectedPickupTime!,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final updatedCheckout = await _updatePickupDetailsUseCase(
        UpdatePickupDetailsParams(
          checkoutId: state.checkout!.id,
          pickupDetails: pickupDetails,
        ),
      );

      state = state.copyWith(
        checkout: updatedCheckout,
        pickupDetails: pickupDetails,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Select payment method
  void selectPaymentMethod(PaymentMethodEntity paymentMethod) {
    state = state.copyWith(
      selectedPaymentMethod: paymentMethod,
      error: null,
    );
  }

  /// Process the final payment
  Future<CheckoutResultEntity?> processPayment() async {
    if (state.checkout == null) {
      state = state.copyWith(error: 'Checkout session not found');
      return null;
    }

    if (!state.canProceedToPayment) {
      state = state.copyWith(error: 'Please complete pickup details and select payment method');
      return null;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _processPaymentUseCase(state.checkout!.id);
      
      state = state.copyWith(isLoading: false);
      
      if (!result.success) {
        state = state.copyWith(error: result.message ?? 'Payment failed');
      }

      return result;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return null;
    }
  }

  /// Clear error state
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Reset checkout state
  void reset() {
    state = const CheckoutState();
  }
}

// Provider for the main checkout notifier
final checkoutProvider = StateNotifierProvider<CheckoutNotifier, CheckoutState>((ref) {
  return CheckoutNotifier(
    ref.watch(checkoutRepositoryProvider),
    ref.watch(getPickupLocationsUseCaseProvider),
    ref.watch(getPaymentMethodsUseCaseProvider),
    ref.watch(createCheckoutUseCaseProvider),
    ref.watch(updatePickupDetailsUseCaseProvider),
    ref.watch(validatePickupTimeSlotUseCaseProvider),
    ref.watch(calculateFeesUseCaseProvider),
    ref.watch(processPaymentUseCaseProvider),
  );
});

// Derived state providers for specific UI needs
final isCheckoutLoadingProvider = Provider<bool>((ref) {
  return ref.watch(checkoutProvider.select((state) => state.isLoading));
});

final checkoutErrorProvider = Provider<String?>((ref) {
  return ref.watch(checkoutProvider.select((state) => state.error));
});

final canProceedToPaymentProvider = Provider<bool>((ref) {
  return ref.watch(checkoutProvider.select((state) => state.canProceedToPayment));
});

final selectedPickupLocationProvider = Provider<PickupLocationEntity?>((ref) {
  return ref.watch(checkoutProvider.select((state) => state.selectedLocation));
});

final selectedPickupTimeProvider = Provider<PickupTimeEntity?>((ref) {
  return ref.watch(checkoutProvider.select((state) => state.selectedPickupTime));
});

final totalAmountProvider = Provider<double>((ref) {
  return ref.watch(checkoutProvider.select((state) => state.totalAmount));
});

final availableLocationsProvider = Provider<List<PickupLocationEntity>>((ref) {
  return ref.watch(checkoutProvider.select((state) => state.availableLocations));
});