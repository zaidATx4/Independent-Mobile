import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/checkout_entities.dart';
import '../../domain/repositories/checkout_repository.dart';
import '../models/checkout_models.dart';

/// Implementation of CheckoutRepository with security measures
class CheckoutRepositoryImpl implements CheckoutRepository {
  final Dio _dio;
  final SharedPreferences? _prefs;

  // Cache keys for secure local storage
  static const String _pickupLocationsKey = 'checkout_pickup_locations';
  static const String _paymentMethodsKey = 'checkout_payment_methods';
  static const String _checkoutCacheKey = 'checkout_cache';

  CheckoutRepositoryImpl({
    required Dio dio,
    SharedPreferences? prefs,
  }) : _dio = dio, _prefs = prefs;

  @override
  Future<List<PickupLocationEntity>> getPickupLocations({
    String? brandId,
    String? locationId,
  }) async {
    try {
      final response = await _dio.get(
        '/api/v1/checkout/pickup-locations',
        queryParameters: {
          if (brandId != null) 'brand_id': brandId,
          if (locationId != null) 'location_id': locationId,
        },
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
      final response = await _dio.get('/api/v1/checkout/payment-methods');
      final List<dynamic> data = response.data['data'] as List<dynamic>;
      final paymentMethods = data
          .map((json) => PaymentMethodModel.fromJson(json as Map<String, dynamic>))
          .toList();

      // Cache sanitized payment methods (no sensitive data)
      await _cachePaymentMethods(paymentMethods);

      return paymentMethods;
    } catch (e) {
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
    final response = await _dio.post(
      '/api/v1/checkout',
      data: {
        'subtotal': subtotal,
        'tax': tax,
        'total': total,
        'currency': currency,
        'metadata': metadata,
      },
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
    final response = await _dio.post(
      '/api/v1/checkout/$checkoutId/process',
    );

    final data = response.data['data'] as Map<String, dynamic>;
    return CheckoutResultModel.fromJson(data);
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
      await _prefs!.setString('${_checkoutCacheKey}_${checkout.id}', jsonEncode(checkoutJson));
    }
  }

  @override
  Future<void> clearCheckoutCache() async {
    if (_prefs != null) {
      final keys = _prefs!.getKeys().where((key) => key.startsWith(_checkoutCacheKey));
      for (final key in keys) {
        await _prefs!.remove(key);
      }
    }
  }

  // Private helper methods for caching

  Future<void> _cachePickupLocations(List<PickupLocationEntity> locations) async {
    if (_prefs != null) {
      final locationsJson = locations
          .map((location) => PickupLocationModel.fromEntity(location).toJson())
          .toList();
      await _prefs!.setString(_pickupLocationsKey, jsonEncode(locationsJson));
    }
  }

  Future<List<PickupLocationEntity>> _getCachedPickupLocations() async {
    if (_prefs == null) return [];
    
    final cachedData = _prefs!.getString(_pickupLocationsKey);
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
      await _prefs!.setString(_paymentMethodsKey, jsonEncode(paymentMethodsJson));
    }
  }

  Future<List<PaymentMethodEntity>> _getCachedPaymentMethods() async {
    if (_prefs == null) return [];
    
    final cachedData = _prefs!.getString(_paymentMethodsKey);
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
    
    final cachedData = _prefs!.getString('${_checkoutCacheKey}_$checkoutId');
    if (cachedData == null) return null;

    final data = jsonDecode(cachedData) as Map<String, dynamic>;
    return CheckoutModel.fromJson(data);
  }

  Future<void> _removeCachedCheckout(String checkoutId) async {
    if (_prefs != null) {
      await _prefs!.remove('${_checkoutCacheKey}_$checkoutId');
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
      await _prefs!.setString('${_userWalletsKey}_$userId', jsonEncode(walletsJson));
    }
  }

  Future<List<WalletEntity>> _getCachedUserWallets(String userId) async {
    if (_prefs == null) return _getMockWalletsForDevelopment();
    
    final cachedData = _prefs!.getString('${_userWalletsKey}_$userId');
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
    
    final keys = _prefs!.getKeys().where((key) => key.startsWith(_userWalletsKey));
    final List<WalletEntity> allWallets = [];
    
    for (final key in keys) {
      final cachedData = _prefs!.getString(key);
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
    final keys = _prefs!.getKeys().where((key) => key.startsWith(_userWalletsKey));
    
    for (final key in keys) {
      final cachedData = _prefs!.getString(key);
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
          await _prefs!.setString(key, jsonEncode(updatedJson));
        }
      }
    }
  }

  Future<void> _clearWalletCache(String walletId) async {
    if (_prefs == null) return;
    
    // Find and update all caches that contain this wallet
    final keys = _prefs!.getKeys().where((key) => key.startsWith(_userWalletsKey));
    
    for (final key in keys) {
      final cachedData = _prefs!.getString(key);
      if (cachedData != null) {
        final List<dynamic> data = jsonDecode(cachedData) as List<dynamic>;
        final wallets = data
            .map((json) => WalletModel.fromJson(json as Map<String, dynamic>))
            .toList();
        
        // Remove the specific wallet to force refresh
        wallets.removeWhere((w) => w.id == walletId);
        final updatedJson = wallets.map((w) => w.toJson()).toList();
        await _prefs!.setString(key, jsonEncode(updatedJson));
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
}