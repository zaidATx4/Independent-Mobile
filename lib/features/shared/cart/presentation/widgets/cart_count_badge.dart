import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../providers/cart_provider.dart';

/// Cart icon with count badge that shows the number of items in cart
class CartCountBadge extends ConsumerWidget {
  final VoidCallback? onTap;
  final Color iconColor;
  final Color backgroundColor;
  final Color? borderColor;
  final Color badgeColor;
  final Color badgeTextColor;
  final double size;
  final double iconSize;

  const CartCountBadge({
    super.key,
    this.onTap,
    this.iconColor = const Color(0xFFFEFEFF),
    this.backgroundColor = Colors.transparent,
    this.borderColor,
    this.badgeColor = const Color(0xFFFF4444),
    this.badgeTextColor = Colors.white,
    this.size = 40.0,
    this.iconSize = 16.0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final itemCount = cartState.itemCount;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(44.0),
          border: borderColor != null 
              ? Border.all(color: borderColor!, width: 1.0)
              : null,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Cart icon
            Center(
              child: SvgPicture.asset(
                'assets/images/icons/SVGs/Loyalty/Cart_icon.svg',
                width: iconSize,
                height: iconSize,
                colorFilter: ColorFilter.mode(
                  iconColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
            
            // Count badge
            if (itemCount > 0)
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  constraints: const BoxConstraints(minWidth: 16),
                  height: 16,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      itemCount > 99 ? '99+' : itemCount.toString(),
                      style: TextStyle(
                        color: badgeTextColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}