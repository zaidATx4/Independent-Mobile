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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Theme-aware colors
    final headerBgColor = isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFFEFEFF);
    final borderColor = isDarkMode ? const Color(0xFFFEFEFF) : const Color(0xFF1A1A1A);
    final iconColor = isDarkMode ? const Color(0xFFFEFEFF) : const Color(0xFF1A1A1A);
    final textColor = isDarkMode ? const Color(0xFFFEFEFF) : const Color(0xFF1A1A1A);
    
    return Container(
      width: double.infinity,
      color: headerBgColor,
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
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(44),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: iconColor,
                size: 16,
              ),
            ),
          ),

          const SizedBox(width: 16.0), // gap-4
          // Menu title
          Expanded(
            child: Text(
              'Menu',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? const Color(0xCCFEFEFF) : const Color(0xCC1A1A1A), // Theme-aware text with 80% opacity
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
                iconColor: iconColor,
                backgroundColor: Colors.transparent,
                borderColor: borderColor,
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
                      color: borderColor,
                      width: 1.0,
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/images/icons/SVGs/Loyalty/Search_icon.svg',
                      width: 16.0,
                      height: 16.0,
                      colorFilter: ColorFilter.mode(
                        iconColor,
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Theme-aware colors
    final bgColor = isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFFEFEFF);
    final borderColor = isDarkMode ? const Color(0xFF404040) : const Color(0xFFD9D9D9);
    final textPrimaryColor = isDarkMode ? const Color(0xFFFEFEFF) : const Color(0xFF1A1A1A);
    final textSecondaryColor = isDarkMode ? const Color(0xCC878787) : const Color(0xFF878787);
    final defaultLogoBgColor = isDarkMode ? const Color(0xFF404040) : const Color(0xFFE0E0E0);
    final defaultLogoIconColor = isDarkMode ? const Color(0xFF9C9C9D) : const Color(0xFF878787);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ), // px-4 py-2
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          top: BorderSide(color: borderColor, width: 1.0),
          bottom: BorderSide(color: borderColor, width: 1.0),
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
              color: defaultLogoBgColor,
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
                        return _buildDefaultLogo(defaultLogoIconColor);
                      },
                    ),
                  )
                : _buildDefaultLogo(defaultLogoIconColor),
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
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500, // Medium
                    color: textPrimaryColor,
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
                      colorFilter: ColorFilter.mode(
                        textSecondaryColor,
                        BlendMode.srcIn,
                      ),
                    ),

                    const SizedBox(width: 4.0), // gap-1

                    Expanded(
                      child: Text(
                        locationAddress,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400, // Regular
                          color: textSecondaryColor,
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
  Widget _buildDefaultLogo(Color iconColor) {
    return Container(
      width: 64.0,
      height: 64.0,
      decoration: BoxDecoration(
        color: Colors.transparent, // Use the container's background color
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Center(
        child: Text(
          'SALT',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 12.0,
            fontWeight: FontWeight.w700,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
