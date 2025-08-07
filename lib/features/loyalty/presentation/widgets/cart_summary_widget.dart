import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../providers/cart_provider.dart';

class CartSummaryWidget extends ConsumerWidget {
  const CartSummaryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemCount = ref.watch(cartItemCountProvider);
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF4D4E52), // indpt/stroke
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Number of Items',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 12,
              height: 18 / 12,
              color: Color(0xCCFEFEFF), // indpt/text secondary
            ),
          ),
          Text(
            '${itemCount.toString().padLeft(2, '0')} items',
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 12,
              height: 18 / 12,
              color: Color(0xCCFEFEFF), // indpt/text secondary
            ),
          ),
        ],
      ),
    );
  }
}

class CartPricingWidget extends ConsumerWidget {
  const CartPricingWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subtotal = ref.watch(cartSubtotalProvider);
    final tax = ref.watch(cartTaxProvider);
    final total = ref.watch(cartTotalProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF4D4E52),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Subtotal
          _buildPriceRow('Subtotal', subtotal),
          const SizedBox(height: 8),
          
          // Tax (VAT)
          _buildPriceRow('Tax (VAT 15%)', tax),
          const SizedBox(height: 12),
          
          // Divider
          Container(
            height: 1,
            color: const Color(0xFF4D4E52),
          ),
          const SizedBox(height: 12),
          
          // Total
          _buildPriceRow('Total', total, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
            fontSize: isTotal ? 16 : 14,
            height: isTotal ? 24 / 16 : 21 / 14,
            color: const Color(0xFFFEFEFF), // indpt/text primary
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              amount.toStringAsFixed(2),
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
                fontSize: isTotal ? 18 : 16,
                height: isTotal ? 27 / 18 : 24 / 16,
                color: const Color(0xFFFEFEFF), // indpt/text primary
              ),
            ),
            const SizedBox(width: 4),
            SvgPicture.asset(
              'assets/images/icons/SVGs/Loyalty/SAR.svg',
              width: 14,
              height: 16,
              colorFilter: const ColorFilter.mode(
                Color(0xFF9C9C9D), // indpt/text tertiary
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CheckoutButton extends ConsumerWidget {
  final VoidCallback? onCheckout;

  const CheckoutButton({
    super.key,
    this.onCheckout,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEmpty = ref.watch(cartIsEmptyProvider);
    final isCheckingOut = ref.watch(cartIsCheckingOutProvider);
    final isLoading = ref.watch(cartIsLoadingProvider);

    final isDisabled = isEmpty || isCheckingOut || isLoading;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Semantics(
        label: isEmpty 
          ? 'Cart is empty, cannot checkout' 
          : isCheckingOut 
            ? 'Processing checkout...' 
            : 'Checkout cart',
        button: true,
        child: ElevatedButton(
          onPressed: isDisabled ? null : onCheckout,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFFBF1), // indpt/sand
          foregroundColor: const Color(0xFF242424), // indpt/accent
          disabledBackgroundColor: const Color(0xFF4D4E52), // indpt/stroke
          disabledForegroundColor: const Color(0xFF9C9C9D), // indpt/text tertiary
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(44),
          ),
          elevation: 0,
        ),
        child: SizedBox(
          height: 24,
          child: Center(
            child: isCheckingOut
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF242424), // indpt/accent
                      ),
                    ),
                  )
                : const Text(
                    'Checkout',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      height: 24 / 16,
                    ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class EmptyCartWidget extends StatelessWidget {
  const EmptyCartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Empty cart icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF4D4E52).withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(
                Icons.shopping_cart_outlined,
                size: 40,
                color: Color(0xFF9C9C9D), // indpt/text tertiary
              ),
            ),
            const SizedBox(height: 24),
            
            // Title
            const Text(
              'Your cart is empty',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: 20,
                height: 30 / 20,
                color: Color(0xFFFEFEFF), // indpt/text primary
              ),
            ),
            const SizedBox(height: 8),
            
            // Description
            const Text(
              'Add items to your cart to get started',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                height: 21 / 14,
                color: Color(0xCCFEFEFF), // indpt/text secondary
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}