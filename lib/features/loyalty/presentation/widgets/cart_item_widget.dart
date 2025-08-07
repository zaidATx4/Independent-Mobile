import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../data/models/cart_models.dart';
import '../providers/cart_provider.dart';
import 'cart_badge_widget.dart';

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
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF4D4E52), // indpt/stroke
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    height: 21 / 14,
                    color: Color(0xFFFEFEFF), // indpt/text primary
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
            children: [
              // Price
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.totalPrice.toStringAsFixed(1),
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      height: 30 / 20,
                      color: Color(0xFFFEFEFF), // indpt/text primary
                    ),
                  ),
                  const SizedBox(width: 4),
                  // SAR icon
                  SvgPicture.asset(
                    'assets/images/icons/SVGs/Loyalty/SAR.svg',
                    width: 14,
                    height: 16,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFFFEFEFF), // indpt/text primary
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
                  child: SvgPicture.asset(
                    'assets/images/icons/SVGs/Loyalty/Bin_Icon.svg',
                    width: 24,
                    height: 24,
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
              color: const Color(0xFFFFFBF1), // indpt/sand
              borderRadius: BorderRadius.circular(44),
            ),
              child: const Center(
                child: Icon(
                  Icons.add,
                  size: 14,
                  color: Color(0xFF242424), // indpt/accent
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
                color: const Color(0xFF9C9C9D), // indpt/text tertiary
                width: 1,
              ),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Center(
              child: Text(
                quantity.toString(),
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  height: 21 / 14,
                  color: Color(0xCCFEFEFF), // indpt/text secondary
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
              color: const Color(0xFFFFFBF1), // indpt/sand
              borderRadius: BorderRadius.circular(44),
            ),
              child: const Center(
                child: Icon(
                  Icons.remove,
                  size: 14,
                  color: Color(0xFF242424), // indpt/accent
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}