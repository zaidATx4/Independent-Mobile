import 'package:flutter/material.dart';
import '../../domain/entities/brand_entity.dart';

/// Brand card widget matching Figma design specifications
class BrandCard extends StatelessWidget {
  final BrandEntity brand;
  final VoidCallback onTap;

  const BrandCard({super.key, required this.brand, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Responsive dimensions based on Figma design
    final cardHeight = 80.0; // Fixed height from Figma
    final horizontalPadding = 8.0; // 8px padding
    final iconSize = 64.0; // 64px (size-16 in Tailwind = 4rem = 64px)
    final iconRadius = 42.0; // rounded-[42px] from Figma
    final cardRadius = 106.0; // rounded-[106px] from Figma
    final gap = 16.0; // gap-4 = 16px

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: cardHeight,
        decoration: BoxDecoration(
          // Backdrop blur effect with glassmorphism
          color: Colors.white.withOpacity(0.25), // bg-[rgba(255,255,255,0.25)]
          borderRadius: BorderRadius.circular(cardRadius),
          border: Border.all(
            color: Colors.white.withOpacity(
              0.45,
            ), // border-[rgba(255,255,255,0.45)]
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(horizontalPadding),
          child: Row(
            children: [
              // Brand icon/logo
              ClipRRect(
                borderRadius: BorderRadius.circular(iconRadius),
                child: Container(
                  width: iconSize,
                  height: iconSize,
                  color: Colors.white, // White background for brand logos
                  child: _buildLogoImage(),
                ),
              ),

              SizedBox(width: gap),

              // Brand info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Brand name
                    Text(
                      brand.name,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 20.0, // text-[20px]
                        fontWeight: FontWeight.w600, // font-semibold
                        color: Color(0xFFFFFFFF), // text-[#ffffff]
                        height: 1.5, // leading-[30px] / 20px = 1.5
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 2),

                    // View locations text
                    Text(
                      'View Locations',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12.0, // text-[12px]
                        fontWeight: FontWeight.w400, // font-normal
                        color: Colors.white.withOpacity(
                          0.75,
                        ), // text-[rgba(255,255,255,0.75)]
                        height: 1.5, // leading-[18px] / 12px = 1.5
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build brand logo image with resilient fallbacks
  /// Tries brand.logoUrl first, then common alternatives under assets/images/logos/brands
  Widget _buildLogoImage() {
    final candidates = <String>[
      if (brand.logoUrl.isNotEmpty) brand.logoUrl,
      ..._logoAltPathsForBrandName(brand.name),
    ];

    // Build nested fallbacks using errorBuilder chaining
    Widget widget = _buildPlaceholderIcon();
    for (final path in candidates.reversed) {
      widget = Image.asset(
        path,
        fit: BoxFit.cover, // Changed to cover to zoom in and fill the container
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stack) => widget,
      );
    }
    return widget;
  }

  /// Produce likely logo asset paths in our repo structure
  List<String> _logoAltPathsForBrandName(String name) {
    // Known file names from assets/images/logos/brands
    final Map<String, String> known = {
      'Salt': 'Salt.png',
      'Switch': 'Switch.png',
      'Somewhere': 'Somewhere.png',
      'Joe & Juice': 'Joe_and _juice.png',
      'Parkers': 'Parkers.png',
    };
    final List<String> out = [];
    if (known.containsKey(name)) {
      out.add('assets/images/logos/brands/${known[name]}');
    }
    // Generic guess: TitleCased without spaces
    final generic = name.replaceAll('&', 'and').replaceAll(' ', '_');
    out.add('assets/images/logos/brands/$generic.png');
    return out.toSet().toList();
  }

  /// Build placeholder icon for brands without images
  Widget _buildPlaceholderIcon() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(42.0),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _getBrandGradientColors(),
        ),
      ),
      child: Center(
        child: Text(
          _getBrandInitials(),
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// Get brand initials for placeholder
  String _getBrandInitials() {
    final words = brand.name.split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return brand.name
        .substring(0, brand.name.length >= 2 ? 2 : 1)
        .toUpperCase();
  }

  /// Get gradient colors based on brand name for visual variety
  List<Color> _getBrandGradientColors() {
    final hash = brand.name.hashCode;
    final colors = [
      [const Color(0xFF6366F1), const Color(0xFF8B5CF6)], // Indigo to Purple
      [const Color(0xFFEF4444), const Color(0xFFF97316)], // Red to Orange
      [const Color(0xFF10B981), const Color(0xFF059669)], // Emerald
      [const Color(0xFF3B82F6), const Color(0xFF1D4ED8)], // Blue
      [const Color(0xFFF59E0B), const Color(0xFFD97706)], // Amber
      [const Color(0xFFEC4899), const Color(0xFFBE185D)], // Pink
    ];
    return colors[hash.abs() % colors.length];
  }
}
