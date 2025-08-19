import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Food menu header widget matching Figma design
/// Shows back button, menu title, and action buttons (cart and search)
class FoodMenuHeader extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Container(
      width: double.infinity,
      color: isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFFEFEFF),
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
              width: 40.0, // p-[8px] = 32px + 8px padding = 40px total
              height: 40.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(44.0), // rounded-[44px]
                border: Border.all(
                  color: isDarkMode ? const Color(0xFFFEFEFF) : const Color(0xFF1A1A1A),
                  width: 1.0,
                ),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: isDarkMode ? const Color(0xFFFEFEFF) : const Color(0xFF1A1A1A),
                size: 14.0,
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
                fontSize: 24.0,
                fontWeight: FontWeight.w700, // Bold
                color: isDarkMode ? const Color(0xCCFEFEFF) : const Color(0xCC1A1A1A),
                height: 1.33, // line-height: 32px / 24px
              ),
            ),
          ),

          // Action buttons row
          Row(
            children: [
              // Cart button
              GestureDetector(
                onTap: onCartPressed,
                child: Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(44.0),
                    border: Border.all(
                      color: isDarkMode ? const Color(0xFFFEFEFF) : const Color(0xFF1A1A1A),
                      width: 1.0,
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/images/icons/SVGs/Loyalty/Cart_icon.svg',
                      width: 16.0,
                      height: 16.0,
                      colorFilter: ColorFilter.mode(
                        isDarkMode ? const Color(0xFFFEFEFF) : const Color(0xFF1A1A1A),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
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
                      color: isDarkMode ? const Color(0xFFFEFEFF) : const Color(0xFF1A1A1A),
                      width: 1.0,
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/images/icons/SVGs/Loyalty/Search_icon.svg',
                      width: 16.0,
                      height: 16.0,
                      colorFilter: ColorFilter.mode(
                        isDarkMode ? const Color(0xFFFEFEFF) : const Color(0xFF1A1A1A),
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
        color: Color(0xFFFFFCF5), // Light theme background
        border: Border(
          top: BorderSide(color: Color(0xFFD9D9D9), width: 1.0), // Light theme stroke
          bottom: BorderSide(color: Color(0xFFD9D9D9), width: 1.0),
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
                    color: Color(0xFF1A1A1A), // Dark text on light theme
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
                        Color(0xFF878787), // Light theme tertiary text color
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
                          color: Color(0xFF878787), // Light theme tertiary text color
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
