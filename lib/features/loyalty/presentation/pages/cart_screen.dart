import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/cart_entities.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_item_widget.dart';
import '../widgets/cart_summary_widget.dart';
import '../widgets/cart_error_widget.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  bool _showSuccessMessage = false;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    // Initialize cart on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cartProvider.notifier).refreshCart();
    });
  }

  Future<void> _handleCheckout() async {
    try {
      final result = await ref.read(cartProvider.notifier).checkout();
      
      if (result.success) {
        setState(() {
          _showSuccessMessage = true;
          _successMessage = result.message ?? 'Order placed successfully!';
        });
        
        // Show success message and navigate back after delay
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            context.pop();
          }
        });
      } else {
        // Error is handled by the provider, just show a snackbar
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.message ?? 'Checkout failed'),
              backgroundColor: Colors.red.shade900,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Checkout failed: ${e.toString()}'),
            backgroundColor: Colors.red.shade900,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartItemsProvider);
    final isEmpty = ref.watch(cartIsEmptyProvider);
    final isLoading = ref.watch(cartIsLoadingProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A), // indpt/neutral
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            
            // Success message overlay
            if (_showSuccessMessage && _successMessage != null)
              CartSuccessWidget(
                message: _successMessage!,
                onClose: () {
                  setState(() {
                    _showSuccessMessage = false;
                    _successMessage = null;
                  });
                },
              ),
            
            // Error handling
            const CartErrorWidget(),
            
            // Content
            Expanded(
              child: _buildContent(cartItems, isEmpty, isLoading),
            ),
            
            // Bottom section with checkout button
            if (!isEmpty) _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFFEFEFF), // indpt/text primary
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(44),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 16,
                color: Color(0xFFFEFEFF), // indpt/text primary
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Title
          const Expanded(
            child: Text(
              'Cart',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w700,
                fontSize: 24,
                height: 32 / 24,
                color: Color(0xCCFEFEFF), // indpt/text secondary
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(List<dynamic> cartItems, bool isEmpty, bool isLoading) {
    if (isLoading && isEmpty) {
      return const CartLoadingWidget(
        message: 'Loading your cart...',
      );
    }

    if (isEmpty) {
      return _buildEmptyCart();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 8),
          
          // Cart summary (item count)
          const CartSummaryWidget(),
          
          // Cart items list
          ...cartItems.map((item) => CartItemWidget(
            key: ValueKey(item.id),
            item: item,
            onRemove: () {
              // Optional: Show removal feedback
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${item.name} removed from cart'),
                  duration: const Duration(seconds: 2),
                  backgroundColor: const Color(0xFF4D4E52),
                ),
              );
            },
          )),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A), // indpt/neutral
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Checkout button only
          _buildCheckoutButton(),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 64,
              color: const Color(0xFF9C9C9D), // indpt/text tertiary
            ),
            const SizedBox(height: 16),
            const Text(
              'Your cart is empty',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: 18,
                height: 27 / 18,
                color: Color(0xCCFEFEFF), // indpt/text secondary
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add items to your cart to see them here',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                height: 21 / 14,
                color: Color(0xFF9C9C9D), // indpt/text tertiary
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutButton() {
    final isLoading = ref.watch(cartIsLoadingProvider);
    
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : _handleCheckout,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFFBF1), // indpt/sand
          foregroundColor: const Color(0xFF1A1A1A), // indpt/neutral
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color(0xFF1A1A1A),
                ),
              ),
            )
          : const Text(
              'Checkout',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                height: 24 / 16,
              ),
            ),
      ),
    );
  }
}

// Additional helper widgets for better organization
class CartScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CartScreenAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF1A1A1A),
      elevation: 0,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: const Icon(
          Icons.arrow_back,
          color: Color(0xFFFEFEFF),
        ),
      ),
      title: const Text(
        'Cart',
        style: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w700,
          fontSize: 24,
          height: 32 / 24,
          color: Color(0xCCFEFEFF),
        ),
      ),
      centerTitle: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// Extension for easier access to cart actions
extension CartScreenMixin on ConsumerState<CartScreen> {
  void showItemAddedFeedback(String itemName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$itemName added to cart'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green.shade900,
      ),
    );
  }

  void showItemRemovedFeedback(String itemName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$itemName removed from cart'),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF4D4E52),
      ),
    );
  }

  void showCheckoutSuccess(CheckoutResult result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF242424),
        title: const Text(
          'Order Placed!',
          style: TextStyle(
            color: Color(0xFFFEFEFF),
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              result.message ?? 'Your order has been placed successfully.',
              style: const TextStyle(
                color: Color(0xCCFEFEFF),
              ),
            ),
            if (result.orderId != null) ...[
              const SizedBox(height: 8),
              Text(
                'Order ID: ${result.orderId}',
                style: const TextStyle(
                  color: Color(0xFFFFFBF1),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.pop(); // Return to previous screen
            },
            child: const Text(
              'OK',
              style: TextStyle(
                color: Color(0xFFFFFBF1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}