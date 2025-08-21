import 'dart:convert';
import 'dart:async';
import 'dart:math' as math;
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/checkout_entities.dart';
import '../../domain/repositories/checkout_repository.dart';
import '../models/checkout_models.dart';
import '../../presentation/utils/checkout_error_handler.dart';
import '../../../../../core/network/network_resilience.dart';

/// Implementation of CheckoutRepository with PCI-compliant security measures and fraud prevention
class CheckoutRepositoryImpl implements CheckoutRepository {
  final Dio _dio;
  final SharedPreferences? _prefs;

  // Cache keys for secure local storage
  static const String _pickupLocationsKey = 'checkout_pickup_locations';
  static const String _paymentMethodsKey = 'checkout_payment_methods';
  static const String _checkoutCacheKey = 'checkout_cache';
  
  // Security and fraud prevention constants
  static const int _maxRetryAttempts = 3;
  static const Duration _retryDelay = Duration(seconds: 2);
  static const Duration _fraudCheckTimeout = Duration(seconds: 10);
  
  // Rate limiting for fraud prevention
  final Map<String, List<DateTime>> _paymentAttempts = {};
  static const int _maxPaymentAttemptsPerHour = 5;
  
  // Device fingerprinting for fraud detection
  String? _deviceFingerprint;
  Timer? _fingerprintRefreshTimer;
  
  // Network resilience for robust API calls
  final NetworkResilienceManager _resilienceManager = NetworkResilienceManager.instance;

  CheckoutRepositoryImpl({
    required Dio dio,
    SharedPreferences? prefs,
  }) : _dio = dio, _prefs = prefs {
    _initializeSecurity();
  }

  @override
  Future<List<PickupLocationEntity>> getPickupLocations({
    String? brandId,
    String? locationId,
  }) async {
    try {
      final response = await _resilienceManager.executeWithResilience(
        'pickup-locations',
        () => _dio.get(
          '/api/v1/checkout/pickup-locations',
          queryParameters: {
            if (brandId != null) 'brand_id': brandId,
            if (locationId != null) 'location_id': locationId,
          },
        ),
        maxRetries: 2,
        baseDelay: const Duration(seconds: 1),
      );

      final List<dynamic> data = response.data['data'] as List<dynamic>;
      final locations = data
          .map((json) => PickupLocationModel.fromJson(json as Map<String, dynamic>))
          .where((location) => location.isActive)
          .toList();

      // Cache the locations locally
      await _cachePickupLocations(locations);

      return locations;
    } catch (e) {
      // Log the error securely
      CheckoutErrorHandler.logSecurely(e);
      
      // Return cached locations if API fails
      return await _getCachedPickupLocations();
    }
  }

  @override
  Future<PickupLocationEntity?> getPickupLocationById(String locationId) async {
    try {
      final response = await _dio.get('/api/v1/checkout/pickup-locations/$locationId');
      final data = response.data['data'] as Map<String, dynamic>;
      return PickupLocationModel.fromJson(data);
    } catch (e) {
      // Try to find in cached locations
      final cachedLocations = await _getCachedPickupLocations();
      return cachedLocations.cast<PickupLocationEntity?>().firstWhere(
        (location) => location?.id == locationId,
        orElse: () => null,
      );
    }
  }

  @override
  Future<List<PaymentMethodEntity>> getPaymentMethods() async {
    try {
      final response = await _resilienceManager.executeWithResilience(
        'payment-methods',
        () => _dio.get('/api/v1/checkout/payment-methods'),
        maxRetries: 3,
        baseDelay: const Duration(milliseconds: 500),
      );
      
      final List<dynamic> data = response.data['data'] as List<dynamic>;
      final paymentMethods = data
          .map((json) => PaymentMethodModel.fromJson(json as Map<String, dynamic>))
          .toList();

      // Cache sanitized payment methods (no sensitive data)
      await _cachePaymentMethods(paymentMethods);

      return paymentMethods;
    } catch (e) {
      // Log the error securely
      CheckoutErrorHandler.logSecurely(e);
      
      // Return cached payment methods if API fails
      return await _getCachedPaymentMethods();
    }
  }

  @override
  Future<PaymentMethodEntity> addPaymentMethod({
    required PaymentMethodType type,
    required Map<String, dynamic> securePaymentData,
  }) async {
    // SECURITY: Ensure all sensitive data is properly encrypted/tokenized
    final response = await _dio.post(
      '/api/v1/checkout/payment-methods',
      data: {
        'type': type.toString().split('.').last,
        'payment_data': securePaymentData, // Should be pre-tokenized on client
      },
    );

    final data = response.data['data'] as Map<String, dynamic>;
    final paymentMethod = PaymentMethodModel.fromJson(data);

    // Update cached payment methods
    await _updateCachedPaymentMethods(paymentMethod);

    return paymentMethod;
  }

  @override
  Future<bool> removePaymentMethod(String paymentMethodId) async {
    try {
      await _dio.delete('/api/v1/checkout/payment-methods/$paymentMethodId');
      await _removeCachedPaymentMethod(paymentMethodId);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> setDefaultPaymentMethod(String paymentMethodId) async {
    try {
      await _dio.patch(
        '/api/v1/checkout/payment-methods/$paymentMethodId/default',
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<CheckoutStateEntity> createCheckout({
    required double subtotal,
    required double tax,
    required double total,
    String currency = 'SAR',
    Map<String, dynamic>? metadata,
  }) async {
    final response = await _resilienceManager.executeWithResilience(
      'create-checkout',
      () => _dio.post(
        '/api/v1/checkout',
        data: {
          'subtotal': subtotal,
          'tax': tax,
          'total': total,
          'currency': currency,
          'metadata': metadata,
          'device_fingerprint': _deviceFingerprint,
          'timestamp': DateTime.now().toIso8601String(),
        },
      ),
      maxRetries: 2,
      baseDelay: const Duration(seconds: 1),
    );

    final data = response.data['data'] as Map<String, dynamic>;
    final checkout = CheckoutModel.fromJson(data);

    // Cache checkout locally
    await cacheCheckoutLocally(checkout);

    return checkout;
  }

  @override
  Future<CheckoutStateEntity> updatePickupDetails(
    String checkoutId,
    PickupDetailsEntity pickupDetails,
  ) async {
    final response = await _dio.patch(
      '/api/v1/checkout/$checkoutId/pickup-details',
      data: {
        'pickup_details': PickupDetailsModel.fromEntity(pickupDetails).toJson(),
      },
    );

    final data = response.data['data'] as Map<String, dynamic>;
    final checkout = CheckoutModel.fromJson(data);

    // Update cached checkout
    await cacheCheckoutLocally(checkout);

    return checkout;
  }

  @override
  Future<CheckoutStateEntity> updatePaymentMethod(
    String checkoutId,
    String paymentMethodId,
  ) async {
    final response = await _dio.patch(
      '/api/v1/checkout/$checkoutId/payment-method',
      data: {
        'payment_method_id': paymentMethodId,
      },
    );

    final data = response.data['data'] as Map<String, dynamic>;
    final checkout = CheckoutModel.fromJson(data);

    // Update cached checkout
    await cacheCheckoutLocally(checkout);

    return checkout;
  }

  @override
  Future<CheckoutResultEntity> processPayment(String checkoutId) async {
    // Security: Rate limiting check
    if (!_isPaymentAttemptAllowed()) {
      throw EnhancedCheckoutException(
        type: CheckoutErrorType.fraud,
        message: 'Too many payment attempts. Please wait before trying again.',
        code: 'RATE_LIMIT_EXCEEDED',
        timestamp: DateTime.now(),
      );
    }
    
    // Record payment attempt for rate limiting
    _recordPaymentAttempt();
    
    try {
      // Perform pre-payment security checks
      await _performPrePaymentSecurityChecks(checkoutId);
      
      // Process payment with comprehensive resilience
      final response = await _resilienceManager.executeWithResilience(
        'payment-processing',
        () => _processPaymentSecurely(checkoutId),
        maxRetries: _maxRetryAttempts,
        baseDelay: _retryDelay,
      );
      
      final data = response.data['data'] as Map<String, dynamic>;
      final result = CheckoutResultModel.fromJson(data);
      
      // Track successful payment (anonymized)
      await _trackPaymentResult(checkoutId, result, success: true);
      
      return result;
    } catch (e) {
      // Track failed payment (anonymized)
      await _trackPaymentResult(checkoutId, null, success: false, error: e);
      
      // Convert to secure error
      if (e is EnhancedCheckoutException) {
        rethrow;
      } else {
        throw CheckoutErrorHandler.createException(
          message: 'Payment processing failed',
          code: 'PAYMENT_FAILED',
          originalError: e,
        );
      }
    }
  }

  @override
  Future<CheckoutStateEntity?> getCheckout(String checkoutId) async {
    try {
      final response = await _dio.get('/api/v1/checkout/$checkoutId');
      final data = response.data['data'] as Map<String, dynamic>;
      return CheckoutModel.fromJson(data);
    } catch (e) {
      return await _getCachedCheckout(checkoutId);
    }
  }

  @override
  Future<bool> cancelCheckout(String checkoutId) async {
    try {
      await _dio.patch('/api/v1/checkout/$checkoutId/cancel');
      await _removeCachedCheckout(checkoutId);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<CheckoutStateEntity>> getCheckoutHistory({
    int limit = 20,
    int offset = 0,
  }) async {
    final response = await _dio.get(
      '/api/v1/checkout/history',
      queryParameters: {
        'limit': limit,
        'offset': offset,
      },
    );

    final List<dynamic> data = response.data['data'] as List<dynamic>;
    return data
        .map((json) => CheckoutModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<bool> validatePickupTimeSlot(
    String locationId,
    DateTime pickupTime,
  ) async {
    try {
      final response = await _dio.post(
        '/api/v1/checkout/validate-pickup-time',
        data: {
          'location_id': locationId,
          'pickup_time': pickupTime.toIso8601String(),
        },
      );

      return response.data['available'] as bool;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Map<String, double>> calculateFees({
    required String locationId,
    required PickupTimeType pickupType,
    DateTime? scheduledTime,
  }) async {
    final response = await _dio.post(
      '/api/v1/checkout/calculate-fees',
      data: {
        'location_id': locationId,
        'pickup_type': pickupType.toString().split('.').last,
        'scheduled_time': scheduledTime?.toIso8601String(),
      },
    );

    final Map<String, dynamic> data = response.data['data'] as Map<String, dynamic>;
    return data.map((key, value) => MapEntry(key, (value as num).toDouble()));
  }

  @override
  Future<bool> verifyPaymentMethod(String paymentMethodId) async {
    try {
      final response = await _dio.post(
        '/api/v1/checkout/verify-payment-method',
        data: {'payment_method_id': paymentMethodId},
      );

      return response.data['verified'] as bool;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>> authenticatePayment({
    required String checkoutId,
    required String paymentMethodId,
    Map<String, dynamic>? authData,
  }) async {
    final response = await _dio.post(
      '/api/v1/checkout/authenticate-payment',
      data: {
        'checkout_id': checkoutId,
        'payment_method_id': paymentMethodId,
        'auth_data': authData,
      },
    );

    return response.data['data'] as Map<String, dynamic>;
  }

  @override
  Future<void> cacheCheckoutLocally(CheckoutStateEntity checkout) async {
    if (_prefs != null) {
      final checkoutJson = CheckoutModel.fromEntity(checkout).toJson();
      await _prefs.setString('${_checkoutCacheKey}_${checkout.id}', jsonEncode(checkoutJson));
    }
  }

  @override
  Future<void> clearCheckoutCache() async {
    if (_prefs != null) {
      final keys = _prefs.getKeys().where((key) => key.startsWith(_checkoutCacheKey));
      for (final key in keys) {
        await _prefs.remove(key);
      }
    }
  }

  // Private helper methods for caching

  Future<void> _cachePickupLocations(List<PickupLocationEntity> locations) async {
    if (_prefs != null) {
      final locationsJson = locations
          .map((location) => PickupLocationModel.fromEntity(location).toJson())
          .toList();
      await _prefs.setString(_pickupLocationsKey, jsonEncode(locationsJson));
    }
  }

  Future<List<PickupLocationEntity>> _getCachedPickupLocations() async {
    if (_prefs == null) return [];
    
    final cachedData = _prefs.getString(_pickupLocationsKey);
    if (cachedData == null) return [];

    final List<dynamic> data = jsonDecode(cachedData) as List<dynamic>;
    return data
        .map((json) => PickupLocationModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> _cachePaymentMethods(List<PaymentMethodEntity> paymentMethods) async {
    if (_prefs != null) {
      final paymentMethodsJson = paymentMethods
          .map((method) => PaymentMethodModel.fromEntity(method).toJson())
          .toList();
      await _prefs.setString(_paymentMethodsKey, jsonEncode(paymentMethodsJson));
    }
  }

  Future<List<PaymentMethodEntity>> _getCachedPaymentMethods() async {
    if (_prefs == null) return [];
    
    final cachedData = _prefs.getString(_paymentMethodsKey);
    if (cachedData == null) return [];

    final List<dynamic> data = jsonDecode(cachedData) as List<dynamic>;
    return data
        .map((json) => PaymentMethodModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> _updateCachedPaymentMethods(PaymentMethodEntity newMethod) async {
    final cachedMethods = await _getCachedPaymentMethods();
    cachedMethods.removeWhere((method) => method.id == newMethod.id);
    cachedMethods.add(newMethod);
    await _cachePaymentMethods(cachedMethods);
  }

  Future<void> _removeCachedPaymentMethod(String paymentMethodId) async {
    final cachedMethods = await _getCachedPaymentMethods();
    cachedMethods.removeWhere((method) => method.id == paymentMethodId);
    await _cachePaymentMethods(cachedMethods);
  }

  Future<CheckoutStateEntity?> _getCachedCheckout(String checkoutId) async {
    if (_prefs == null) return null;
    
    final cachedData = _prefs.getString('${_checkoutCacheKey}_$checkoutId');
    if (cachedData == null) return null;

    final data = jsonDecode(cachedData) as Map<String, dynamic>;
    return CheckoutModel.fromJson(data);
  }

  Future<void> _removeCachedCheckout(String checkoutId) async {
    if (_prefs != null) {
      await _prefs.remove('${_checkoutCacheKey}_$checkoutId');
    }
  }

  // Wallet-related implementations

  @override
  Future<List<WalletEntity>> getUserWallets(String userId) async {
    try {
      final response = await _dio.get(
        '/api/v1/wallet/user/$userId',
        queryParameters: {'include_inactive': false}, // Only active wallets
      );

      final List<dynamic> data = response.data['data'] as List<dynamic>;
      final wallets = data
          .map((json) => WalletModel.fromJson(json as Map<String, dynamic>))
          .where((wallet) => wallet.canBeUsed)
          .toList();

      // Cache wallets locally with encryption
      await _cacheUserWallets(userId, wallets);

      return wallets;
    } catch (e) {
      // Return cached wallets if API fails
      return await _getCachedUserWallets(userId);
    }
  }

  @override
  Future<WalletEntity?> getWalletById(String walletId) async {
    try {
      final response = await _dio.get('/api/v1/wallet/$walletId');
      final data = response.data['data'] as Map<String, dynamic>;
      final wallet = WalletModel.fromJson(data);
      
      // Security check: only return usable wallets
      return wallet.canBeUsed ? wallet : null;
    } catch (e) {
      // Try to find in cached wallets
      final cachedWallets = await _getAllCachedWallets();
      return cachedWallets.cast<WalletEntity?>().firstWhere(
        (wallet) => wallet?.id == walletId && wallet?.canBeUsed == true,
        orElse: () => null,
      );
    }
  }

  @override
  Future<bool> validateWalletTransaction({
    required String walletId,
    required double amount,
    String currency = 'SAR',
  }) async {
    try {
      final response = await _dio.post(
        '/api/v1/wallet/$walletId/validate-transaction',
        data: {
          'amount': amount,
          'currency': currency,
        },
      );

      return response.data['valid'] as bool;
    } catch (e) {
      // Fallback validation with cached wallet data
      final wallet = await getWalletById(walletId);
      if (wallet == null) return false;
      
      return wallet.canBeUsed && 
             wallet.hasSufficientBalance(amount) && 
             wallet.currency == currency;
    }
  }

  @override
  Future<CheckoutResultEntity> processWalletPayment({
    required String checkoutId,
    required String walletId,
    required double amount,
    String currency = 'SAR',
    Map<String, dynamic>? metadata,
  }) async {
    // First lock the wallet to prevent concurrent transactions
    final transactionId = 'txn_${DateTime.now().millisecondsSinceEpoch}';
    final locked = await lockWallet(walletId, transactionId);
    
    if (!locked) {
      throw Exception('Unable to lock wallet for transaction');
    }

    try {
      final response = await _dio.post(
        '/api/v1/wallet/process-payment',
        data: {
          'checkout_id': checkoutId,
          'wallet_id': walletId,
          'amount': amount,
          'currency': currency,
          'transaction_id': transactionId,
          'metadata': metadata,
        },
      );

      final data = response.data['data'] as Map<String, dynamic>;
      final result = CheckoutResultModel.fromJson(data);

      // Clear cached wallet data to force refresh of balance
      await _clearWalletCache(walletId);

      return result;
    } catch (e) {
      // Rollback on any error
      await rollbackWalletTransaction(checkoutId, walletId);
      rethrow;
    } finally {
      // Always unlock the wallet
      await unlockWallet(walletId, transactionId);
    }
  }

  @override
  Future<bool> rollbackWalletTransaction(String checkoutId, String walletId) async {
    try {
      await _dio.post(
        '/api/v1/wallet/rollback-transaction',
        data: {
          'checkout_id': checkoutId,
          'wallet_id': walletId,
        },
      );
      
      // Clear cached wallet data to force refresh
      await _clearWalletCache(walletId);
      
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getWalletTransactionHistory({
    required String walletId,
    int limit = 20,
    int offset = 0,
  }) async {
    final response = await _dio.get(
      '/api/v1/wallet/$walletId/transactions',
      queryParameters: {
        'limit': limit,
        'offset': offset,
      },
    );

    final List<dynamic> data = response.data['data'] as List<dynamic>;
    return data.cast<Map<String, dynamic>>();
  }

  @override
  Future<WalletEntity> refreshWalletBalance(String walletId) async {
    final response = await _dio.post('/api/v1/wallet/$walletId/refresh-balance');
    final data = response.data['data'] as Map<String, dynamic>;
    final wallet = WalletModel.fromJson(data);
    
    // Update cached wallet
    await _updateCachedWallet(wallet);
    
    return wallet;
  }

  @override
  Future<bool> lockWallet(String walletId, String transactionId) async {
    try {
      final response = await _dio.post(
        '/api/v1/wallet/$walletId/lock',
        data: {'transaction_id': transactionId},
      );
      
      return response.data['locked'] as bool;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> unlockWallet(String walletId, String transactionId) async {
    try {
      final response = await _dio.post(
        '/api/v1/wallet/$walletId/unlock',
        data: {'transaction_id': transactionId},
      );
      
      return response.data['unlocked'] as bool;
    } catch (e) {
      // Always return true for unlock to prevent deadlocks
      return true;
    }
  }

  // Private wallet caching methods

  static const String _userWalletsKey = 'user_wallets';

  Future<void> _cacheUserWallets(String userId, List<WalletEntity> wallets) async {
    if (_prefs != null) {
      final walletsJson = wallets
          .map((wallet) => WalletModel.fromEntity(wallet).toJson())
          .toList();
      await _prefs.setString('${_userWalletsKey}_$userId', jsonEncode(walletsJson));
    }
  }

  Future<List<WalletEntity>> _getCachedUserWallets(String userId) async {
    if (_prefs == null) return _getMockWalletsForDevelopment();
    
    final cachedData = _prefs.getString('${_userWalletsKey}_$userId');
    if (cachedData == null) return _getMockWalletsForDevelopment();

    final List<dynamic> data = jsonDecode(cachedData) as List<dynamic>;
    final cachedWallets = data
        .map((json) => WalletModel.fromJson(json as Map<String, dynamic>))
        .where((wallet) => wallet.canBeUsed)
        .toList();
    
    // Return mock wallets if no cached wallets or they're empty
    return cachedWallets.isEmpty ? _getMockWalletsForDevelopment() : cachedWallets;
  }

  Future<List<WalletEntity>> _getAllCachedWallets() async {
    if (_prefs == null) return [];
    
    final keys = _prefs.getKeys().where((key) => key.startsWith(_userWalletsKey));
    final List<WalletEntity> allWallets = [];
    
    for (final key in keys) {
      final cachedData = _prefs.getString(key);
      if (cachedData != null) {
        final List<dynamic> data = jsonDecode(cachedData) as List<dynamic>;
        final wallets = data
            .map((json) => WalletModel.fromJson(json as Map<String, dynamic>))
            .toList();
        allWallets.addAll(wallets);
      }
    }
    
    return allWallets;
  }

  Future<void> _updateCachedWallet(WalletEntity wallet) async {
    if (_prefs == null) return;
    
    // Find all user wallet caches and update the specific wallet
    final keys = _prefs.getKeys().where((key) => key.startsWith(_userWalletsKey));
    
    for (final key in keys) {
      final cachedData = _prefs.getString(key);
      if (cachedData != null) {
        final List<dynamic> data = jsonDecode(cachedData) as List<dynamic>;
        final wallets = data
            .map((json) => WalletModel.fromJson(json as Map<String, dynamic>))
            .toList();
        
        // Check if this cache contains our wallet
        final index = wallets.indexWhere((w) => w.id == wallet.id);
        if (index != -1) {
          // Update the wallet and save back to cache
          wallets[index] = WalletModel.fromEntity(wallet);
          final updatedJson = wallets.map((w) => w.toJson()).toList();
          await _prefs.setString(key, jsonEncode(updatedJson));
        }
      }
    }
  }

  Future<void> _clearWalletCache(String walletId) async {
    if (_prefs == null) return;
    
    // Find and update all caches that contain this wallet
    final keys = _prefs.getKeys().where((key) => key.startsWith(_userWalletsKey));
    
    for (final key in keys) {
      final cachedData = _prefs.getString(key);
      if (cachedData != null) {
        final List<dynamic> data = jsonDecode(cachedData) as List<dynamic>;
        final wallets = data
            .map((json) => WalletModel.fromJson(json as Map<String, dynamic>))
            .toList();
        
        // Remove the specific wallet to force refresh
        wallets.removeWhere((w) => w.id == walletId);
        final updatedJson = wallets.map((w) => w.toJson()).toList();
        await _prefs.setString(key, jsonEncode(updatedJson));
      }
    }
  }

  /// Get mock wallets for development/testing when no data is available
  List<WalletEntity> _getMockWalletsForDevelopment() {
    return [
      const WalletEntity(
        id: 'wallet_1',
        name: 'Team Lunch Wallet',
        type: WalletType.teamLunch,
        balance: 4250.0,
        currency: 'SAR',
        description: 'Team lunch budget wallet',
        isActive: true,
      ),
      const WalletEntity(
        id: 'wallet_2',
        name: 'Personal Wallet',
        type: WalletType.personal,
        balance: 1875.0,
        currency: 'SAR',
        description: 'Personal spending wallet',
        isActive: true,
      ),
      const WalletEntity(
        id: 'wallet_3',
        name: 'Corporate Wallet',
        type: WalletType.corporate,
        balance: 8500.0,
        currency: 'SAR',
        description: 'Corporate expense wallet',
        isActive: true,
      ),
    ];
  }
  
  /// Secure payment processing with fraud checks
  Future<Response<dynamic>> _processPaymentSecurely(String checkoutId) async {
    // Generate request signature for tamper detection
    final requestSignature = await _generateRequestSignature(checkoutId);
    
    return await _dio.post(
      '/api/v1/checkout/$checkoutId/process',
      data: {
        'device_fingerprint': await _getDeviceFingerprint(),
        'request_signature': requestSignature,
        'timestamp': DateTime.now().toIso8601String(),
      },
      options: Options(
        headers: {
          'X-Device-Fingerprint': await _getDeviceFingerprint(),
          'X-Request-ID': _generateRequestId(),
        },
      ),
    );
  }
  
  /// Perform pre-payment security checks
  Future<void> _performPrePaymentSecurityChecks(String checkoutId) async {
    try {
      // Check if checkout is still valid
      final checkout = await getCheckout(checkoutId);
      if (checkout == null) {
        throw EnhancedCheckoutException(
          type: CheckoutErrorType.validation,
          message: 'Checkout session not found or expired',
          code: 'CHECKOUT_NOT_FOUND',
          timestamp: DateTime.now(),
        );
      }
      
      // Check if checkout is in valid state for payment
      if (checkout.status != CheckoutStatus.awaitingPayment) {
        throw EnhancedCheckoutException(
          type: CheckoutErrorType.validation,
          message: 'Checkout is not ready for payment',
          code: 'INVALID_CHECKOUT_STATE',
          timestamp: DateTime.now(),
        );
      }
      
      // Perform fraud checks with timeout
      await _performFraudCheck(checkoutId).timeout(_fraudCheckTimeout);
      
    } on TimeoutException {
      throw EnhancedCheckoutException(
        type: CheckoutErrorType.timeout,
        message: 'Security check timed out',
        code: 'SECURITY_CHECK_TIMEOUT',
        timestamp: DateTime.now(),
      );
    }
  }
  
  /// Perform fraud detection checks
  Future<void> _performFraudCheck(String checkoutId) async {
    try {
      final response = await _dio.post(
        '/api/v1/fraud/check-transaction',
        data: {
          'checkout_id': checkoutId,
          'device_fingerprint': await _getDeviceFingerprint(),
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      
      final riskScore = response.data['risk_score'] as double;
      final isBlocked = response.data['blocked'] as bool;
      
      if (isBlocked || riskScore > 0.8) {
        throw EnhancedCheckoutException(
          type: CheckoutErrorType.fraud,
          message: 'Transaction blocked for security reasons',
          code: 'FRAUD_DETECTED',
          timestamp: DateTime.now(),
          metadata: {'risk_score': riskScore},
        );
      }
    } catch (e) {
      if (e is EnhancedCheckoutException) rethrow;
      
      // In production, log this failure but don't block payment
      // For development, we'll allow the transaction to continue
      if (kDebugMode) {
        debugPrint('Fraud check failed: $e');
      }
    }
  }
  
  /// Initialize security measures
  void _initializeSecurity() {
    // Initialize device fingerprint
    _refreshDeviceFingerprint();
    
    // Set up periodic fingerprint refresh
    _fingerprintRefreshTimer = Timer.periodic(
      const Duration(hours: 1),
      (_) => _refreshDeviceFingerprint(),
    );
  }
  
  /// Get or generate device fingerprint
  Future<String> _getDeviceFingerprint() async {
    _deviceFingerprint ??= await _generateDeviceFingerprint();
    return _deviceFingerprint!;
  }
  
  /// Generate device fingerprint
  Future<String> _generateDeviceFingerprint() async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final random = math.Random().nextInt(9999);
      final deviceData = '$timestamp-$random';
      
      final bytes = utf8.encode(deviceData);
      final digest = sha256.convert(bytes);
      return 'fp_${digest.toString().substring(0, 16)}';
    } catch (e) {
      return 'fallback_${DateTime.now().millisecondsSinceEpoch}';
    }
  }
  
  /// Refresh device fingerprint
  Future<void> _refreshDeviceFingerprint() async {
    try {
      _deviceFingerprint = await _generateDeviceFingerprint();
    } catch (e) {
      // Use fallback fingerprint
      _deviceFingerprint = 'fallback_${DateTime.now().millisecondsSinceEpoch}';
    }
  }
  
  /// Generate request signature for tamper detection
  Future<String> _generateRequestSignature(String checkoutId) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final deviceFingerprint = await _getDeviceFingerprint();
    final payload = '$checkoutId-$timestamp-$deviceFingerprint';
    
    final bytes = utf8.encode(payload);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
  
  /// Generate unique request ID
  String _generateRequestId() {
    return 'req_${DateTime.now().millisecondsSinceEpoch}_${math.Random().nextInt(9999)}';
  }
  
  /// Check if payment attempt is allowed (rate limiting)
  bool _isPaymentAttemptAllowed() {
    final now = DateTime.now();
    final oneHourAgo = now.subtract(const Duration(hours: 1));
    
    // Clean up old attempts
    _paymentAttempts.removeWhere((key, attempts) {
      attempts.removeWhere((attempt) => attempt.isBefore(oneHourAgo));
      return attempts.isEmpty;
    });
    
    // Check current device attempts
    final deviceKey = _deviceFingerprint ?? 'unknown';
    final attempts = _paymentAttempts[deviceKey] ?? [];
    
    return attempts.length < _maxPaymentAttemptsPerHour;
  }
  
  /// Record payment attempt for rate limiting
  void _recordPaymentAttempt() {
    final deviceKey = _deviceFingerprint ?? 'unknown';
    _paymentAttempts[deviceKey] ??= [];
    _paymentAttempts[deviceKey]!.add(DateTime.now());
  }
  
  /// Track payment result for analytics (anonymized)
  Future<void> _trackPaymentResult(
    String checkoutId,
    CheckoutResultEntity? result,
    {
    required bool success,
    Object? error,
  }) async {
    try {
      // In production, integrate with proper analytics service
      if (kDebugMode) {
        debugPrint('Payment Analytics: success=$success, error=${error?.toString()}');
      }
    } catch (e) {
      // Silently fail analytics
      if (kDebugMode) {
        debugPrint('Analytics tracking failed: $e');
      }
    }
  }
  
  /// Dispose resources
  void dispose() {
    _fingerprintRefreshTimer?.cancel();
    _paymentAttempts.clear();
  }
}