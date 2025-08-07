import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cart_provider.dart';

class CartErrorWidget extends ConsumerWidget {
  final String? customMessage;
  final VoidCallback? onRetry;

  const CartErrorWidget({
    super.key,
    this.customMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasError = ref.watch(cartHasErrorProvider);
    final errorMessage = ref.watch(cartErrorMessageProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    if (!hasError && customMessage == null) {
      return const SizedBox.shrink();
    }

    final displayMessage = customMessage ?? errorMessage ?? 'An error occurred';

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade900.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.red.shade700.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red.shade400,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Error',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    height: 21 / 14,
                    color: Colors.red.shade400,
                  ),
                ),
              ),
              
              // Close button
              GestureDetector(
                onTap: () {
                  cartNotifier.clearErrors();
                },
                child: Icon(
                  Icons.close,
                  color: Colors.red.shade400,
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Error message
          Text(
            displayMessage,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 12,
              height: 18 / 12,
              color: Color(0xCCFEFEFF), // indpt/text secondary
            ),
          ),
          
          // Retry button if callback provided
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  cartNotifier.clearErrors();
                  onRetry?.call();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red.shade400,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                child: const Text(
                  'Retry',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    height: 21 / 14,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class CartSuccessWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onClose;
  final Duration duration;

  const CartSuccessWidget({
    super.key,
    required this.message,
    this.onClose,
    this.duration = const Duration(seconds: 3),
  });

  @override
  Widget build(BuildContext context) {
    // Auto-close after duration
    if (onClose != null) {
      Future.delayed(duration, onClose);
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade900.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.green.shade700.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            color: Colors.green.shade400,
            size: 20,
          ),
          const SizedBox(width: 8),
          
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                height: 21 / 14,
                color: Color(0xFFFEFEFF), // indpt/text primary
              ),
            ),
          ),
          
          // Close button
          if (onClose != null)
            GestureDetector(
              onTap: onClose,
              child: Icon(
                Icons.close,
                color: Colors.green.shade400,
                size: 18,
              ),
            ),
        ],
      ),
    );
  }
}

class CartLoadingWidget extends StatelessWidget {
  final String? message;

  const CartLoadingWidget({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              Color(0xFFFFFBF1), // indpt/sand
            ),
          ),
          
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                height: 21 / 14,
                color: Color(0xCCFEFEFF), // indpt/text secondary
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}