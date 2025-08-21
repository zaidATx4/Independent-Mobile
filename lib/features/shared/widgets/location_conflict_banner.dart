import 'package:flutter/material.dart';

/// Bottom banner widget that appears when user tries to order from different branch
/// Matches exact Figma design specifications for "Switching Brands" banner
class LocationConflictBanner extends StatelessWidget {
  final String currentLocationName;
  final String newLocationName;
  final VoidCallback onClearCart;
  final VoidCallback onCancel;

  const LocationConflictBanner({
    super.key,
    required this.currentLocationName,
    required this.newLocationName,
    required this.onClearCart,
    required this.onCancel,
  });

  /// Show the banner from bottom with slide animation
  static void show({
    required BuildContext context,
    required String currentLocationName,
    required String newLocationName,
    required VoidCallback onClearCart,
    required VoidCallback onCancel,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => LocationConflictBanner(
        currentLocationName: currentLocationName,
        newLocationName: newLocationName,
        onClearCart: onClearCart,
        onCancel: onCancel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode
            ? const Color(0xFF1A1A1A) // Dark: indpt/neutral
            : const Color(0xFFFFFCF5), // Light: dark/neutral
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Home Indicator (drag handle)
          Container(
            height: 21,
            width: double.infinity,
            child: Center(
              child: Container(
                width: 55,
                height: 5,
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? const Color(0xFF9C9C9D) // Dark: indpt/text tertiary
                      : const Color(0xFF878787), // Light: dark/text tertiary
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),

          // Title section with border
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Column(
              children: [
                Text(
                  'Switching Brands',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    fontWeight: FontWeight.w500, // Medium weight
                    color: isDarkMode
                        ? const Color(0xCCFEFEFF) // Dark: indpt/text secondary
                        : const Color(0xCC1A1A1A), // Light: dark/text secondary
                    height: 24 / 16, // line-height 24px
                  ),
                ),
                const SizedBox(height: 8),
                // Border that matches content width
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  height: 1,
                  color: isDarkMode
                      ? const Color(0xFF4D4E52) // Dark: indpt/stroke
                      : const Color(0xFFD9D9D9), // Light: dark/stroke
                ),
              ],
            ),
          ),

          // Content section
          Container(
            width: 361,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'You have items from $currentLocationName in your cart. Adding an item from $newLocationName will clear your current cart. Do you want to continue?',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w400, // Regular weight
                color: isDarkMode
                    ? const Color(0xCCFEFEFF) // Dark: indpt/text secondary
                    : const Color(0xCC1A1A1A), // Light: dark/text secondary
                height: 21 / 14, // line-height 21px
              ),
            ),
          ),

          // Button section with top border
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              0,
              8,
              0,
              MediaQuery.of(context).padding.bottom + 8,
            ),
            child: Column(
              children: [
                // Border that matches button width
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  height: 1,
                  color: isDarkMode
                      ? const Color(0xFF4D4E52) // Dark: indpt/stroke
                      : const Color(0xFFD9D9D9), // Light: dark/stroke
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      // Cancel button
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: OutlinedButton(
                            onPressed: onCancel,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: isDarkMode
                                  ? const Color(
                                      0xFFFEFEFF,
                                    ) // Dark: indpt/text primary
                                  : const Color(
                                      0xFF1A1A1A,
                                    ), // Light: dark/text primary
                              side: BorderSide(
                                color: isDarkMode
                                    ? const Color(
                                        0xFFFEFEFF,
                                      ) // Dark: indpt/text primary border
                                    : const Color(
                                        0xFF1A1A1A,
                                      ), // Light: dark/text primary border
                                width: 1,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(44),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 16,
                                fontWeight: FontWeight.w500, // Medium weight
                                height: 24 / 16, // line-height 24px
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Continue button
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: ElevatedButton(
                            onPressed: onClearCart,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDarkMode
                                  ? const Color(0xFFFFFBF1) // Dark: indpt/sand
                                  : const Color(
                                      0xFF1A1A1A,
                                    ), // Light: dark/neutral
                              foregroundColor: isDarkMode
                                  ? const Color(
                                      0xFF242424,
                                    ) // Dark: indpt/accent
                                  : const Color(
                                      0xFFFEFEFF,
                                    ), // Light: dark/text primary
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(44),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Continue',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 16,
                                fontWeight: FontWeight.w500, // Medium weight
                                height: 24 / 16, // line-height 24px
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
