import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui' as ui;
import '../../domain/entities/food_item_entity.dart';

/// Food item card widget matching Figma design
/// Displays food items in a grid layout with image, name, price, and add button
class FoodItemCard extends StatelessWidget {
  final FoodItemEntity foodItem;
  final VoidCallback? onTap;
  final VoidCallback? onAddPressed;
  final bool isCompact;

  const FoodItemCard({
    super.key,
    required this.foodItem,
    this.onTap,
    this.onAddPressed,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isCompact ? 172.0 : 173.0,
        height: 245.0, // Fixed height from Figma
        child: Stack(
          children: [
            // Background image covering full card
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.asset(
                foodItem.imagePath,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: isDarkMode ? const Color(0xFF242424) : const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.restaurant,
                          color: isDarkMode ? const Color(0xFF9C9C9D) : const Color(0xFF878787),
                          size: 48.0,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Image not found',
                          style: TextStyle(
                            color: isDarkMode ? const Color(0xFF9C9C9D) : const Color(0xFF878787),
                            fontSize: 10.0,
                          ),
                        ),
                        Text(
                          foodItem.imagePath,
                          style: TextStyle(
                            color: isDarkMode ? const Color(0xFF9C9C9D) : const Color(0xFF878787),
                            fontSize: 8.0,
                          ),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Overlay content container with blur and gradient
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(
                    sigmaX: 15.0,
                    sigmaY: 15.0,
                  ), // backdrop-blur-[15px]
                  child: Container(
                    width: double.infinity,
                    // padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      // Dark overlay for contrast - same for both themes to ensure readability
                      color: const Color.fromRGBO(0, 0, 0, 0.4),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        // indpt/glass-fill: rgba(255, 255, 255, 0.25) or #ffffff40
                        color: const Color(0x40FFFFFF), // #ffffff40
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          // Food details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  foodItem.name,
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    color: isDarkMode ? const Color(0xCCFEFEFF) : const Color(0xCC1A1A1A), // Theme-aware text color
                                    shadows: [
                                      Shadow(
                                        offset: const Offset(0, 1),
                                        blurRadius: 2.0,
                                        color: isDarkMode ? const Color.fromRGBO(0, 0, 0, 0.3) : const Color.fromRGBO(0, 0, 0, 0.1),
                                      ),
                                    ],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4.0),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/icons/SVGs/Loyalty/SAR.svg',
                                      width: 12.0,
                                      height: 12.0,
                                      colorFilter: ColorFilter.mode(
                                        isDarkMode ? const Color(0xFFFEFEFF) : const Color(0xFF1A1A1A), // Theme-aware icon color
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    const SizedBox(width: 4.0),
                                    Text(
                                      '${foodItem.price.toInt()}',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w400,
                                        color: isDarkMode ? const Color(0xFFFEFEFF) : const Color(0xFF1A1A1A), // Theme-aware text color
                                        shadows: [
                                          Shadow(
                                            offset: const Offset(0, 1),
                                            blurRadius: 2.0,
                                            color: isDarkMode ? const Color.fromRGBO(0, 0, 0, 0.3) : const Color.fromRGBO(0, 0, 0, 0.1),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Menu button with 3 lines
                          GestureDetector(
                            onTap: onAddPressed,
                            child: Container(
                              width: 32.0,
                              height: 32.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color.fromRGBO(0, 0, 0, 0.25),
                                    blurRadius: 4.0,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: SvgPicture.asset(
                                'assets/images/icons/SVGs/3_Lines_Icon.svg',
                                width: 32.0,
                                height: 32.0,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
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
