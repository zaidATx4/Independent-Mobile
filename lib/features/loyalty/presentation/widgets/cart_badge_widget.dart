import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../providers/cart_provider.dart';

class CartBadgeWidget extends ConsumerWidget {
  final double? width;
  final double? height;
  final double? iconSize;
  final VoidCallback? onTap;

  const CartBadgeWidget({
    super.key,
    this.width,
    this.height,
    this.iconSize = 16,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItemCount = ref.watch(cartItemCountProvider);

    return Semantics(
      label: cartItemCount == 0 
        ? 'Shopping cart is empty' 
        : 'Shopping cart with $cartItemCount item${cartItemCount == 1 ? '' : 's'}',
      button: true,
      child: GestureDetector(
        onTap: onTap ?? () => context.push('/cart'),
        child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: width,
            height: height,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBF1), // indpt/sand
              borderRadius: BorderRadius.circular(44),
            ),
            child: SvgPicture.asset(
              'assets/images/icons/SVGs/Loyalty/Cart_icon.svg',
              width: iconSize,
              height: iconSize,
              colorFilter: const ColorFilter.mode(
                Color(0xFF242424), // indpt/accent
                BlendMode.srcIn,
              ),
            ),
          ),
          // Cart item count badge
          if (cartItemCount > 0)
            Positioned(
              right: -6,
              top: -6,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red.shade600,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF1A1A1A), // indpt/neutral
                    width: 2,
                  ),
                ),
                constraints: const BoxConstraints(
                  minWidth: 20,
                  minHeight: 20,
                ),
                child: Text(
                  cartItemCount > 99 ? '99+' : cartItemCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    height: 1.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
        ),
      ),
    );
  }
}

// Reusable quantity control icons with fallbacks
class QuantityControlIcon extends StatelessWidget {
  final String type; // 'plus', 'minus', 'trash'
  final double size;
  final Color color;

  const QuantityControlIcon({
    super.key,
    required this.type,
    this.size = 16,
    this.color = const Color(0xFF242424),
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case 'plus':
        return Icon(
          Icons.add,
          size: size,
          color: color,
        );
      case 'minus':
        return Icon(
          Icons.remove,
          size: size,
          color: color,
        );
      case 'trash':
        return Icon(
          Icons.delete_outline,
          size: size,
          color: color,
        );
      default:
        return Icon(
          Icons.help_outline,
          size: size,
          color: color,
        );
    }
  }
}

// SAR currency icon fallback
class SarIcon extends StatelessWidget {
  final double? width;
  final double? height;
  final Color color;

  const SarIcon({
    super.key,
    this.width = 14,
    this.height = 16,
    this.color = const Color(0xFFFEFEFF),
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/icons/SVGs/Loyalty/SAR.svg',
      width: width,
      height: height,
      colorFilter: ColorFilter.mode(
        color,
        BlendMode.srcIn,
      ),
    );
  }
}

// Back arrow icon fallback
class BackArrowIcon extends StatelessWidget {
  final double size;
  final Color color;

  const BackArrowIcon({
    super.key,
    this.size = 16,
    this.color = const Color(0xFFFEFEFF),
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.arrow_back,
      size: size,
      color: color,
    );
  }
}