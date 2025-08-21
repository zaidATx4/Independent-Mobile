import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../domain/entities/checkout_entities.dart';

class CheckoutLocationCard extends StatelessWidget {
  final PickupLocationEntity location;
  final VoidCallback? onTap;
  final bool isSelected;

  const CheckoutLocationCard({
    super.key,
    required this.location,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Theme-aware colors based on Figma design
    final borderColor = isDarkMode ? const Color(0xFF4D4E52) : const Color(0xFFD9D9D9); // #d9d9d9 from Figma light theme
    final primaryTextColor = isDarkMode ? const Color(0xFFFEFEFF) : const Color(0xFF1A1A1A); // #1a1a1a from Figma
    final tertiaryTextColor = isDarkMode ? const Color(0xFF9C9C9D) : const Color(0xFF878787); // #878787 from Figma
    
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor, // Theme-aware border color
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Brand Logo
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: AssetImage(location.brandLogoPath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Location Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Location Name
                      Text(
                        location.name,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: primaryTextColor, // Theme-aware primary text from Figma
                          height: 21 / 14, // lineHeight / fontSize
                        ),
                      ),
                      // Address with location icon
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Location Icon
                          Container(
                            width: 12,
                            height: 12,
                            margin: const EdgeInsets.only(top: 3),
                            child: SvgPicture.asset(
                              'assets/images/icons/SVGs/Select_Location_Icon.svg',
                              colorFilter: ColorFilter.mode(
                                tertiaryTextColor, // Theme-aware tertiary text from Figma
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          // Address Text
                          Expanded(
                            child: Text(
                              location.address,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: tertiaryTextColor, // Theme-aware tertiary text from Figma
                                height: 18 / 12, // lineHeight / fontSize
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CheckoutLocationCardSkeleton extends StatelessWidget {
  const CheckoutLocationCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDarkMode ? const Color(0xFF4D4E52) : const Color(0xFFD9D9D9);
    final skeletonColor = isDarkMode ? const Color(0xFF4D4E52) : const Color(0xFFD9D9D9);
    
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Brand Logo Skeleton
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: skeletonColor,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(width: 16),
            // Details Skeleton
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Name Skeleton
                  Container(
                    height: 21,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: skeletonColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Address Skeleton
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: skeletonColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Container(
                          height: 18,
                          decoration: BoxDecoration(
                            color: skeletonColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}