import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../domain/entities/location_entity.dart';

/// Location card widget matching Figma design specifications
/// Displays individual location with brand icon, name, and address
class LocationCard extends StatelessWidget {
  final LocationEntity location;
  final String brandLogoPath;
  final VoidCallback onTap;
  final bool isFirstItem;

  const LocationCard({
    super.key,
    required this.location,
    required this.brandLogoPath,
    required this.onTap,
    this.isFirstItem = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          // Border configuration - top border for first item, bottom border for all
          border: Border(
            top: isFirstItem ? BorderSide(
              color: const Color(0xFFFEFEFF).withOpacity(0.45), // Use #FEFEFF color
              width: 1.0,
            ) : BorderSide.none,
            bottom: BorderSide(
              color: const Color(0xFFFEFEFF).withOpacity(0.45), // Use #FEFEFF color
              width: 1.0,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0), // py-2 = 8px
          child: Row(
            children: [
              // Brand icon - 64x64px with rounded corners
              _buildBrandIcon(),

              const SizedBox(width: 16.0), // gap-4 = 16px
              // Location details
              Expanded(child: _buildLocationDetails()),
            ],
          ),
        ),
      ),
    );
  }

  /// Build brand icon with 64x64 size and rounded corners
  Widget _buildBrandIcon() {
    return Container(
      width: 64.0, // size-16 = 64px
      height: 64.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0), // rounded-2xl = 16px
        color: Colors.white, // White background for brand logos
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: _buildBrandImage(),
      ),
    );
  }

  /// Build brand image with fallback
  Widget _buildBrandImage() {
    if (brandLogoPath.isNotEmpty) {
      return Image.asset(
        brandLogoPath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stack) => _buildPlaceholderIcon(),
      );
    }
    return _buildPlaceholderIcon();
  }

  /// Build placeholder icon when brand image is not available
  Widget _buildPlaceholderIcon() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6366F1), // Indigo
            Color(0xFF8B5CF6), // Purple
          ],
        ),
      ),
      child: const Center(
        child: Icon(Icons.restaurant, color: Colors.white, size: 32.0),
      ),
    );
  }

  /// Build location details section
  Widget _buildLocationDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Location name
        Text(
          location.name,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14.0, // text-[14px]
            fontWeight: FontWeight.w500, // font-medium
            color: Color(0xFFFEFEFF), // indpt/text primary
            height: 1.5, // line-height: 21px / 14px = 1.5
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: 2.0), // Small gap between name and address
        // Location address with icon
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Location icon
            SvgPicture.asset(
              'assets/images/icons/SVGs/Select_Location_Icon.svg',
              width: 12.0,
              height: 12.0,
              colorFilter: const ColorFilter.mode(
                Color(0xFF9C9C9D), // indpt/text tertiary
                BlendMode.srcIn,
              ),
            ),

            const SizedBox(width: 4.0), // gap-1 = 4px
            // Address text
            Expanded(
              child: Text(
                location.address,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 12.0, // text-[12px]
                  fontWeight: FontWeight.w400, // font-normal
                  color: Color(0xFF9C9C9D), // indpt/text tertiary
                  height: 1.5, // line-height: 18px / 12px = 1.5
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),

        // Remove all status indicators as requested
      ],
    );
  }

}
