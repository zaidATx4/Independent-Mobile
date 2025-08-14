import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/theme/theme_service.dart';
import '../../data/models/cart_models.dart';
import '../providers/cart_provider.dart';

class CartItemWidget extends ConsumerWidget {
  final CartItem item;
  final VoidCallback? onRemove;

  const CartItemWidget({
    super.key,
    required this.item,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartNotifier = ref.read(cartProvider.notifier);
    final isLoading = ref.watch(cartIsLoadingProvider);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: context.getThemedColor(
              lightColor: const Color(0xFFD9D9D9), // light theme stroke
              darkColor: const Color(0xFF4D4E52), // dark theme stroke
            ),
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Product image
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: AssetImage(item.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Product details and controls
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product name
                Text(
                  item.name,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    height: 21 / 14,
                    color: context.getThemedColor(
                      lightColor: const Color(0xFF1A1A1A), // light theme text
                      darkColor: const Color(0xFFFEFEFF), // dark theme text
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                
                // Quantity controls
                QuantityControls(
                  quantity: item.quantity,
                  onDecrease: isLoading ? null : () {
                    cartNotifier.decreaseQuantity(item.id);
                  },
                  onIncrease: isLoading ? null : () {
                    cartNotifier.increaseQuantity(item.id);
                  },
                ),
              ],
            ),
          ),
          
          // Price and delete button
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Price
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.totalPrice.toStringAsFixed(1),
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      height: 30 / 20,
                      color: context.getThemedColor(
                        lightColor: const Color(0xFF1A1A1A), // light theme text
                        darkColor: const Color(0xFFFEFEFF), // dark theme text
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  // SAR icon
                  SvgPicture.asset(
                    'assets/images/icons/SVGs/Loyalty/SAR.svg',
                    width: 14,
                    height: 16,
                    colorFilter: ColorFilter.mode(
                      context.getThemedColor(
                        lightColor: const Color(0xFF1A1A1A), // light theme icon
                        darkColor: const Color(0xFFFEFEFF), // dark theme icon
                      ),
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              
              // Delete button
              Semantics(
                label: 'Remove ${item.name} from cart',
                button: true,
                child: GestureDetector(
                  onTap: isLoading ? null : () {
                    cartNotifier.removeItem(item.id);
                    onRemove?.call();
                  },
                  child: Builder(
                    builder: (context) {
                      final theme = Theme.of(context);
                      final isDark = theme.brightness == Brightness.dark;
                      
                      return SvgPicture.asset(
                        isDark 
                            ? 'assets/images/icons/SVGs/Loyalty/Bin_Icon.svg' // Original for dark theme
                            : 'assets/images/icons/SVGs/Loyalty/Bin_Icon_light.svg', // Light theme with built-in background
                        width: 24,
                        height: 24,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class QuantityControls extends StatelessWidget {
  final int quantity;
  final VoidCallback? onDecrease;
  final VoidCallback? onIncrease;

  const QuantityControls({
    super.key,
    required this.quantity,
    this.onDecrease,
    this.onIncrease,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Increase button (plus on left)
        Semantics(
          label: 'Increase quantity',
          button: true,
          child: GestureDetector(
            onTap: onIncrease,
            child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: context.getThemedColor(
                lightColor: const Color(0xFF1A1A1A), // light theme button
                darkColor: const Color(0xFFFFFBF1), // dark theme button
              ),
              borderRadius: BorderRadius.circular(44),
            ),
              child: Center(
                child: Icon(
                  Icons.add,
                  size: 14,
                  color: context.getThemedColor(
                    lightColor: const Color(0xFFFEFEFF), // light theme icon
                    darkColor: const Color(0xFF242424), // dark theme icon
                  ),
                ),
              ),
            ),
          ),
        ),
        
        // Quantity display
        Semantics(
          label: 'Quantity: $quantity',
          child: Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(
                color: context.getThemedColor(
                  lightColor: const Color(0xFF878787), // light theme border
                  darkColor: const Color(0xFF9C9C9D), // dark theme border
                ),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Center(
              child: Text(
                quantity.toString(),
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  height: 21 / 14,
                  color: context.getThemedColor(
                    lightColor: const Color(0xCC1A1A1A), // light theme text
                    darkColor: const Color(0xCCFEFEFF), // dark theme text
                  ),
                ),
              ),
            ),
          ),
        ),
        
        // Decrease button (minus on right)
        Semantics(
          label: 'Decrease quantity',
          button: true,
          child: GestureDetector(
            onTap: onDecrease,
            child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: context.getThemedColor(
                lightColor: const Color(0xFF1A1A1A), // light theme button
                darkColor: const Color(0xFFFFFBF1), // dark theme button
              ),
              borderRadius: BorderRadius.circular(44),
            ),
              child: Center(
                child: Icon(
                  Icons.remove,
                  size: 14,
                  color: context.getThemedColor(
                    lightColor: const Color(0xFFFEFEFF), // light theme icon
                    darkColor: const Color(0xFF242424), // dark theme icon
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}