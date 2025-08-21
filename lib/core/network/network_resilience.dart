import 'dart:async';
import 'dart:math';
import 'package:dio/dio.dart';

/// Network resilience manager for handling retries, timeouts, and error recovery
class NetworkResilienceManager {
  static const int _maxRetries = 3;
  static const Duration _baseDelay = Duration(seconds: 1);
  
  // Singleton instance
  static final NetworkResilienceManager _instance = NetworkResilienceManager._internal();
  static NetworkResilienceManager get instance => _instance;
  
  NetworkResilienceManager._internal();

  /// Execute a network request with retry logic and exponential backoff using operation name
  Future<T> executeWithResilience<T>(
    String operationName,
    Future<T> Function() request, {
    int maxRetries = _maxRetries,
    Duration baseDelay = _baseDelay,
    bool Function(Exception)? shouldRetry,
  }) async {
    return execute(
      request: request,
      maxRetries: maxRetries,
      baseDelay: baseDelay,
      shouldRetry: shouldRetry,
    );
  }

  /// Execute a network request with retry logic and exponential backoff
  static Future<T> execute<T>({
    required Future<T> Function() request,
    int maxRetries = _maxRetries,
    Duration baseDelay = _baseDelay,
    bool Function(Exception)? shouldRetry,
  }) async {
    Exception? lastException;

    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        return await request();
      } catch (e) {
        lastException = e is Exception ? e : Exception(e.toString());

        // Don't retry on the last attempt
        if (attempt == maxRetries) {
          break;
        }

        // Check if we should retry this error
        if (shouldRetry != null && !shouldRetry(lastException)) {
          break;
        }

        // Default retry logic for common network errors
        if (!_shouldRetryByDefault(lastException)) {
          break;
        }

        // Wait with exponential backoff
        final delay = _calculateDelay(attempt, baseDelay);
        await Future.delayed(delay);
      }
    }

    throw lastException ?? Exception('Network request failed');
  }

  /// Calculate exponential backoff delay with jitter
  static Duration _calculateDelay(int attempt, Duration baseDelay) {
    final multiplier = pow(2, attempt);
    final delayMs = baseDelay.inMilliseconds * multiplier;
    
    // Add jitter (random variation of ±25%)
    final random = Random();
    final jitter = 1.0 + (random.nextDouble() - 0.5) * 0.5;
    final finalDelayMs = (delayMs * jitter).round();
    
    return Duration(milliseconds: finalDelayMs);
  }

  /// Default retry logic for common network errors
  static bool _shouldRetryByDefault(Exception exception) {
    if (exception is DioException) {
      switch (exception.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.connectionError:
          return true;
        case DioExceptionType.badResponse:
          // Retry on server errors (5xx), but not client errors (4xx)
          final statusCode = exception.response?.statusCode;
          return statusCode != null && statusCode >= 500;
        case DioExceptionType.cancel:
        case DioExceptionType.badCertificate:
        case DioExceptionType.unknown:
          return false;
      }
    }

    return false;
  }

  /// Create a configured Dio interceptor for automatic retry
  static Interceptor createRetryInterceptor({
    int maxRetries = _maxRetries,
    Duration baseDelay = _baseDelay,
  }) {
    return InterceptorsWrapper(
      onError: (error, handler) async {
        if (_shouldRetryByDefault(error) && 
            (error.requestOptions.extra['retryCount'] ?? 0) < maxRetries) {
          
          final retryCount = (error.requestOptions.extra['retryCount'] ?? 0) + 1;
          error.requestOptions.extra['retryCount'] = retryCount;

          // Wait with exponential backoff
          final delay = _calculateDelay(retryCount - 1, baseDelay);
          await Future.delayed(delay);

          try {
            final response = await Dio().fetch(error.requestOptions);
            handler.resolve(response);
          } catch (e) {
            handler.next(error);
          }
        } else {
          handler.next(error);
        }
      },
    );
  }

  /// Circuit breaker pattern for preventing cascade failures
  static CircuitBreaker createCircuitBreaker({
    int failureThreshold = 5,
    Duration timeout = const Duration(minutes: 1),
  }) {
    return CircuitBreaker(
      failureThreshold: failureThreshold,
      timeout: timeout,
    );
  }
}

/// Simple circuit breaker implementation
class CircuitBreaker {
  final int failureThreshold;
  final Duration timeout;
  
  int _failureCount = 0;
  DateTime? _lastFailureTime;
  CircuitBreakerState _state = CircuitBreakerState.closed;

  CircuitBreaker({
    required this.failureThreshold,
    required this.timeout,
  });

  /// Execute a request through the circuit breaker
  Future<T> execute<T>(Future<T> Function() request) async {
    if (_state == CircuitBreakerState.open) {
      if (_shouldAttemptReset()) {
        _state = CircuitBreakerState.halfOpen;
      } else {
        throw CircuitBreakerOpenException();
      }
    }

    try {
      final result = await request();
      _onSuccess();
      return result;
    } catch (e) {
      _onFailure();
      rethrow;
    }
  }

  bool _shouldAttemptReset() {
    return _lastFailureTime != null &&
           DateTime.now().difference(_lastFailureTime!) > timeout;
  }

  void _onSuccess() {
    _failureCount = 0;
    _state = CircuitBreakerState.closed;
  }

  void _onFailure() {
    _failureCount++;
    _lastFailureTime = DateTime.now();
    
    if (_failureCount >= failureThreshold) {
      _state = CircuitBreakerState.open;
    }
  }

  CircuitBreakerState get state => _state;
}

enum CircuitBreakerState {
  closed,
  open,
  halfOpen,
}

class CircuitBreakerOpenException implements Exception {
  @override
  String toString() => 'Circuit breaker is open';
}