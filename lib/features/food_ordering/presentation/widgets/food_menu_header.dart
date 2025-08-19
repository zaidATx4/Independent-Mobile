import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/cart/presentation/widgets/cart_count_badge.dart';

/// Food menu header widget matching Figma design
/// Shows back button, menu title, and action buttons (cart and search)
class FoodMenuHeader extends ConsumerWidget {
  final VoidCallback? onBackPressed;
  final VoidCallback? onCartPressed;
  final VoidCallback? onSearchPressed;
  final VoidCallback? onMenuPressed;

  const FoodMenuHeader({
    super.key,
    this.onBackPressed,
    this.onCartPressed,
    this.onSearchPressed,
    this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF1A1A1A), // indpt/neutral background
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ), // px-4 py-2
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: onBackPressed ?? () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFFEFEFF)),
                borderRadius: BorderRadius.circular(44),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Color(0xFFFEFEFF),
                size: 16,
              ),
            ),
          ),

          const SizedBox(width: 16.0), // gap-4
          // Menu title
          const Expanded(
            child: Text(
              'Menu',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xCCFEFEFF),
                height: 32 / 24,
              ),
            ),
          ),

          // Action buttons row
          Row(
            children: [
              // Cart button with count badge
              CartCountBadge(
                onTap: onCartPressed ?? () => context.push('/cart'),
                iconColor: const Color(0xFFFEFEFF),
                backgroundColor: Colors.transparent,
                borderColor: const Color(0xFFFEFEFF),
                badgeColor: const Color(0xFFFF4444),
                badgeTextColor: Colors.white,
                size: 40.0,
                iconSize: 16.0,
              ),

              const SizedBox(width: 8.0), // gap-2
              // Search button
              GestureDetector(
                onTap: onSearchPressed,
                child: Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(44.0),
                    border: Border.all(
                      color: const Color(0xFFFEFEFF),
                      width: 1.0,
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/images/icons/SVGs/Loyalty/Search_icon.svg',
                      width: 16.0,
                      height: 16.0,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFFEFEFF),
                        BlendMode.srcIn,
                      ),
                    ),
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

/// Location info widget for displaying selected restaurant location
/// Shows brand logo, location name, and address
class LocationInfoWidget extends StatelessWidget {
  final String? brandLogoPath;
  final String locationName;
  final String locationAddress;

  const LocationInfoWidget({
    super.key,
    this.brandLogoPath,
    required this.locationName,
    required this.locationAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ), // px-4 py-2
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A), // indpt/neutral background
        border: Border(
          top: BorderSide(color: Color(0xFF4D4E52), width: 1.0), // indpt/stroke
          bottom: BorderSide(color: Color(0xFF4D4E52), width: 1.0),
        ),
      ),
      child: Row(
        children: [
          // Brand logo
          Container(
            width: 64.0, // size-16 = 64px
            height: 64.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0), // rounded-2xl
              color: const Color(0xFF242424), // Default background
            ),
            child: brandLogoPath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Image.asset(
                      brandLogoPath!,
                      width: 64.0,
                      height: 64.0,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildDefaultLogo();
                      },
                    ),
                  )
                : _buildDefaultLogo(),
          ),

          const SizedBox(width: 16.0), // gap-4
          // Location details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Location name
                Text(
                  locationName,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500, // Medium
                    color: Color(0xFFFEFEFF), // indpt/text primary
                    height: 1.5, // line-height: 21px / 14px
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 2.0), // Small gap
                // Location address with icon
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/icons/SVGs/Select_Location_Icon.svg',
                      width: 12.0,
                      height: 12.0,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF9C9C9D), // indpt/text tertiary
                        BlendMode.srcIn,
                      ),
                    ),

                    const SizedBox(width: 4.0), // gap-1

                    Expanded(
                      child: Text(
                        locationAddress,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400, // Regular
                          color: Color(0xFF9C9C9D), // indpt/text tertiary
                          height: 1.5, // line-height: 18px / 12px
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build default brand logo when image is not available
  Widget _buildDefaultLogo() {
    return Container(
      width: 64.0,
      height: 64.0,
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: const Center(
        child: Text(
          'SALT',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 12.0,
            fontWeight: FontWeight.w700,
            color: Color(0xFFFFFBF1),
          ),
        ),
      ),
    );
  }
}
