import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../providers/checkout_providers.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../widgets/checkout_continue_button.dart';

class ReviewOrderScreen extends ConsumerStatefulWidget {
  const ReviewOrderScreen({super.key});

  @override
  ConsumerState<ReviewOrderScreen> createState() => _ReviewOrderScreenState();
}

class _ReviewOrderScreenState extends ConsumerState<ReviewOrderScreen> {
  bool _isProcessingPayment = false;

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final checkoutState = ref.watch(checkoutProvider);
    final isLoading = ref.watch(isCheckoutLoadingProvider);
    final error = ref.watch(checkoutErrorProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFFFFCF5),
      body: Column(
        children: [
          // Header with SafeArea
          SafeArea(child: _buildHeader(context, isDarkMode)),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order Items Section
                  _buildOrderSection(cartState, isDarkMode),

                  const SizedBox(height: 24),

                  // Location Section
                  _buildLocationSection(checkoutState, isDarkMode),

                  // Error Display
                  if (error != null) ...[
                    const SizedBox(height: 16),
                    _buildErrorWidget(error),
                  ],
                ],
              ),
            ),
          ),

          // Bottom Section with totals and checkout button
          _buildBottomSection(checkoutState, cartState, isLoading, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Back Button
          InkWell(
            onTap: () => context.pop(),
            borderRadius: BorderRadius.circular(44),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: isDarkMode ? const Color(0xFFFEFEFF) : const Color(0xFF1A1A1A)),
                borderRadius: BorderRadius.circular(44),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: isDarkMode ? const Color(0xFFFEFEFF) : const Color(0xFF1A1A1A),
                size: 16,
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Title
          Expanded(
            child: Text(
              'Checkout',
              style: TextStyle(
                color: isDarkMode ? const Color(0xCCFEFEFF) : const Color(0xFF1A1A1A),
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSection(cartState, bool isDarkMode) {
    final cart = cartState.cart;
    if (cart == null || cart.items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Order Section Title
        Text(
          'Order',
          style: TextStyle(
            color: isDarkMode ? const Color(0xCCFEFEFF) : const Color(0xFF1A1A1A),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Roboto',
          ),
        ),

        const SizedBox(height: 16),

        // Order Items List
        Column(
          children: cart.items
              .map<Widget>((item) => _buildOrderItem(item, isDarkMode))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildOrderItem(item, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDarkMode ? const Color(0xFF4D4E52) : const Color(0xFFD9D9D9), 
            width: 1
          ),
          bottom: BorderSide(
            color: isDarkMode ? const Color(0xFF4D4E52) : const Color(0xFFD9D9D9), 
            width: 1
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Quantity
          Text(
            '${item.quantity}x',
            style: TextStyle(
              color: isDarkMode ? const Color(0xCCFEFEFF) : const Color(0xFF1A1A1A),
              fontSize: 14,
              fontFamily: 'Roboto',
            ),
          ),

          const SizedBox(width: 10),

          // Item Name
          Expanded(
            child: Text(
              item.name,
              style: TextStyle(
                color: isDarkMode ? const Color(0xCCFEFEFF) : const Color(0xFF1A1A1A),
                fontSize: 14,
                fontFamily: 'Roboto',
              ),
            ),
          ),

          // Price
          Text(
            '${item.totalPrice.toInt()}',
            style: TextStyle(
              color: isDarkMode ? const Color(0xCCFEFEFF) : const Color(0xFF1A1A1A),
              fontSize: 14,
              fontFamily: 'Roboto',
            ),
          ),

          const SizedBox(width: 4),

          // SAR Icon
          SvgPicture.asset(
            'assets/images/icons/Payment_Methods/SAR.svg',
            width: 11,
            height: 12,
            colorFilter: ColorFilter.mode(
              isDarkMode ? const Color(0xCCFEFEFF) : const Color(0xFF1A1A1A),
              BlendMode.srcIn,
            ),
          ),

          const SizedBox(width: 10),

          // Remove Icon (disabled in review - just for design consistency)
          Icon(Icons.close, color: isDarkMode ? const Color(0xCCFEFEFF) : const Color(0xFF1A1A1A), size: 16),
        ],
      ),
    );
  }

  Widget _buildLocationSection(CheckoutState checkoutState, bool isDarkMode) {
    final selectedLocation = checkoutState.selectedLocation;

    if (selectedLocation == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Location Section Title
        Text(
          'Location',
          style: TextStyle(
            color: isDarkMode ? const Color(0xCCFEFEFF) : const Color(0xFF1A1A1A),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Roboto',
          ),
        ),

        const SizedBox(height: 16),

        // Location Details
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Location Name
              Text(
                selectedLocation.name,
                style: TextStyle(
                  color: isDarkMode ? const Color(0xCCFEFEFF) : const Color(0xFF1A1A1A),
                  fontSize: 16,
                  fontFamily: 'Roboto',
                ),
              ),

              const SizedBox(height: 4),

              // Location Address
              Text(
                selectedLocation.address,
                style: TextStyle(
                  color: isDarkMode ? const Color(0xCCFEFEFF) : const Color(0xFF1A1A1A),
                  fontSize: 14,
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorWidget(String error) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade900.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade700),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade300, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              error,
              style: TextStyle(
                color: Colors.red.shade300,
                fontSize: 14,
                fontFamily: 'Roboto',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(
    CheckoutState checkoutState,
    cartState,
    bool isLoading,
    bool isDarkMode,
  ) {
    final cart = cartState.cart;
    final fees = checkoutState.fees;

    // Calculate totals from fees or fallback to cart
    final subtotal = fees?['subtotal'] ?? cart?.subtotal ?? 0.0;
    final serviceCharge = fees?['service_fee'] ?? 0.0;
    final discounts = fees?['discounts'] ?? 0.0;
    final total = fees?['total'] ?? cart?.total ?? 0.0;

    final itemCount = cart?.totalItemCount ?? 0;

    return Container(
      color: isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFFFFCF5),
      child: Column(
        children: [
          // Totals Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              children: [
                // Subtotal
                _buildTotalRow(
                  'Subtotal (x$itemCount)',
                  subtotal,
                  isSecondary: true,
                  isDarkMode: isDarkMode,
                ),

                const SizedBox(height: 4),

                // Service Charge
                _buildTotalRow(
                  'Service Charge',
                  serviceCharge,
                  isSecondary: true,
                  isDarkMode: isDarkMode,
                ),

                const SizedBox(height: 4),

                // Discounts (negative value)
                _buildTotalRow(
                  'Discounts',
                  -discounts.abs(),
                  isSecondary: true,
                  isDarkMode: isDarkMode,
                ),

                const SizedBox(height: 4),

                // Total (primary color)
                _buildTotalRow('Total', total, isSecondary: false, isDarkMode: isDarkMode),
              ],
            ),
          ),

          // Checkout Button Section
          Container(
            padding: EdgeInsets.fromLTRB(
              16,
              16,
              16,
              MediaQuery.of(context).padding.bottom,
            ),
            child: CheckoutContinueButton(
              text: 'Check out',
              isLoading: _isProcessingPayment || isLoading,
              onPressed: _canProceedToPayment(checkoutState, cartState)
                  ? () => _processPayment()
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(
    String label,
    double amount, {
    required bool isSecondary,
    required bool isDarkMode,
  }) {
    final color = isSecondary
        ? const Color(0xFF9C9C9D)
        : (isDarkMode ? const Color(0xFFFEFEFF) : const Color(0xFF1A1A1A));
    final sarColor = isSecondary
        ? const Color(0xFF9C9C9D)
        : (isDarkMode ? const Color(0xFFFEFEFF) : const Color(0xFF1A1A1A));

    return Row(
      children: [
        // Label
        Expanded(
          child: Text(
            label,
            style: TextStyle(color: color, fontSize: 14, fontFamily: 'Roboto'),
          ),
        ),

        // Amount
        Text(
          amount < 0 ? '-${amount.abs().toInt()}' : '${amount.toInt()}',
          style: TextStyle(color: color, fontSize: 14, fontFamily: 'Roboto'),
        ),

        const SizedBox(width: 4),

        // SAR Icon
        SvgPicture.asset(
          'assets/images/icons/Payment_Methods/SAR.svg',
          width: 11,
          height: 12,
          colorFilter: ColorFilter.mode(sarColor, BlendMode.srcIn),
        ),
      ],
    );
  }

  bool _canProceedToPayment(CheckoutState checkoutState, cartState) {
    return !_isProcessingPayment &&
        cartState.cart != null &&
        cartState.cart!.isNotEmpty &&
        checkoutState.selectedLocation != null &&
        checkoutState.selectedPickupTime != null &&
        checkoutState.selectedPaymentMethod != null &&
        checkoutState.error == null;
  }

  Future<void> _processPayment() async {
    if (_isProcessingPayment) return;

    setState(() {
      _isProcessingPayment = true;
    });

    // TEMPORARY: Bypass all payment logic for UI testing
    // TODO: Re-enable payment processing when UI is complete
    await Future.delayed(
      const Duration(seconds: 1),
    ); // Simulate processing time

    if (mounted) {
      setState(() {
        _isProcessingPayment = false;
      });

      // Direct navigation to success screen with mock data
      context.go(
        '/checkout/success',
        extra: {
          'orderNumber': 'ORDER-${DateTime.now().millisecondsSinceEpoch}',
          'locationName': 'Mall of the Emirates',
          'locationAddress': 'North Beach, Jumeirah 1, Dubai, UAE',
          'estimatedTime': '25-30 minutes',
        },
      );
    }

    /* COMMENTED OUT - PAYMENT LOGIC TO RE-ENABLE LATER
    try {
      // Clear any previous errors
      ref.read(checkoutProvider.notifier).clearError();
      
      // Process the payment
      final result = await ref.read(checkoutProvider.notifier).processPayment();
      
      if (result != null && result.success) {
        // Payment successful - navigate to success screen
        if (mounted) {
          // Clear the cart after successful payment
          await ref.read(cartProvider.notifier).completeOrder(result.transactionId ?? 'success');
          
          // Get order details for success screen
          final checkoutState = ref.read(checkoutProvider);
          final selectedLocation = checkoutState.selectedLocation;
          
          // Navigate to success screen with order details
          context.go('/checkout/success', extra: {
            'orderNumber': result.transactionId ?? 'ORDER-${DateTime.now().millisecondsSinceEpoch}',
            'locationName': selectedLocation?.name ?? 'Mall of the Emirates',
            'locationAddress': selectedLocation?.address ?? 'North Beach, Jumeirah 1, Dubai, UAE',
            'estimatedTime': '25-30 minutes',
          });
        }
      } else {
        // Payment failed - error is already set in the provider
        if (mounted) {
          _showPaymentErrorDialog(result?.message ?? 'Payment failed. Please try again.');
        }
      }
    } catch (e) {
      // Handle unexpected errors
      if (mounted) {
        _showPaymentErrorDialog('An unexpected error occurred. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingPayment = false;
        });
      }
    }
    */
  }

  void _showPaymentErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 24),
            SizedBox(width: 12),
            Text(
              'Payment Failed',
              style: TextStyle(
                color: Color(0xFFFEFEFF),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(color: Color(0xCCFEFEFF), fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Try Again',
              style: TextStyle(
                color: Color(0xFFFFFBF1),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
