import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/theme_service.dart';
import '../../data/models/cart_models.dart';
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

  @override
  void initState() {
    super.initState();
    // Initialize cart on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cartProvider.notifier).refreshCart();
    });
  }

  void _handleCheckout() {
    final cartState = ref.read(cartProvider);
    final cart = cartState.cart;
    
    if (cart == null || cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Your cart is empty'),
          backgroundColor: context.getThemedColor(
            lightColor: Colors.red.shade600,
            darkColor: Colors.red.shade900,
          ),
        ),
      );
      return;
    }

    // Extract brandId and locationId from cart items
    // For now, we'll use the brand and location from the first item
    // In a real implementation, all items should be from the same brand/location
    final firstItem = cart.items.first;
    final brandId = _extractBrandIdFromItem(firstItem);
    final locationId = _extractLocationIdFromItem(firstItem);

    // Navigate to pickup details screen with cart data
    context.push(
      '/checkout/pickup-details',
      extra: {
        'subtotal': cart.subtotal,
        'tax': cart.tax,
        'total': cart.total,
        'brandId': brandId,
        'locationId': locationId,
      },
    );
  }

  String? _extractBrandIdFromItem(CartItem item) {
    // This would normally come from the item data or be stored during cart creation
    // For now, return a mock brandId based on brand name
    switch (item.brandName.toLowerCase()) {
      case 'salt':
        return 'brand_1';
      case 'sweet spot':
        return 'brand_2';
      case 'drink house':
        return 'brand_3';
      case 'healthy bites':
        return 'brand_4';
      default:
        return 'brand_1';
    }
  }

  String? _extractLocationIdFromItem(CartItem item) {
    // This would normally come from the item data or be stored during cart creation
    // For now, return a mock locationId
    return 'location_1';
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartItemsProvider);
    final isEmpty = ref.watch(cartIsEmptyProvider);
    final isLoading = ref.watch(cartIsLoadingProvider);

    return Scaffold(
      backgroundColor: context.getThemedColor(
        lightColor: const Color(0xFFFFFCF5), // light theme background
        darkColor: const Color(0xFF1A1A1A), // dark theme background
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            
            
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
                  color: context.getThemedColor(
                    lightColor: const Color(0xFF1A1A1A), // light theme border
                    darkColor: const Color(0xFFFEFEFF), // dark theme border
                  ),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(44),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 16,
                color: context.getThemedColor(
                  lightColor: const Color(0xFF1A1A1A), // light theme icon
                  darkColor: const Color(0xFFFEFEFF), // dark theme icon
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Title
          Expanded(
            child: Text(
              'Cart',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w700,
                fontSize: 24,
                height: 32 / 24,
                color: context.getThemedColor(
                  lightColor: const Color(0xCC1A1A1A), // light theme text
                  darkColor: const Color(0xCCFEFEFF), // dark theme text
                ),
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
                  backgroundColor: context.getThemedColor(
                    lightColor: const Color(0xFFD9D9D9),
                    darkColor: const Color(0xFF4D4E52),
                  ),
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
      padding: EdgeInsets.fromLTRB(16, 24, 16, MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: context.getThemedColor(
          lightColor: const Color(0xFFFFFCF5), // light theme background
          darkColor: const Color(0xFF1A1A1A), // dark theme background
        ),
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
              color: context.getThemedColor(
                lightColor: const Color(0xFF878787), // light theme tertiary
                darkColor: const Color(0xFF9C9C9D), // dark theme tertiary
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Your cart is empty',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: 18,
                height: 27 / 18,
                color: context.getThemedColor(
                  lightColor: const Color(0xCC1A1A1A), // light theme text
                  darkColor: const Color(0xCCFEFEFF), // dark theme text
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add items to your cart to see them here',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                height: 21 / 14,
                color: context.getThemedColor(
                  lightColor: const Color(0xFF878787), // light theme tertiary
                  darkColor: const Color(0xFF9C9C9D), // dark theme tertiary
                ),
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
        onPressed: isLoading ? null : () => _handleCheckout(),
        style: ElevatedButton.styleFrom(
          backgroundColor: context.getThemedColor(
            lightColor: const Color(0xFF1A1A1A), // light theme button bg
            darkColor: const Color(0xFFFFFBF1), // dark theme button bg
          ),
          foregroundColor: context.getThemedColor(
            lightColor: const Color(0xFFFEFEFF), // light theme button text
            darkColor: const Color(0xFF1A1A1A), // dark theme button text
          ),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        child: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  context.getThemedColor(
                    lightColor: const Color(0xFFFEFEFF), // light theme progress
                    darkColor: const Color(0xFF1A1A1A), // dark theme progress
                  ),
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

}