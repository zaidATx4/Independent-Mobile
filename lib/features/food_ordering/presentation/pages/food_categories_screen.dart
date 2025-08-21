import 'dart:ui';
import 'package:flutter/material.dart';

/// Food categories screen matching Figma design
/// Shows all available food categories with images and glass morphism effects
/// Supports both light and dark themes based on current theme
class FoodCategoriesScreen extends StatelessWidget {
  final String? locationId;
  final String? brandId;
  final String? brandLogoPath;

  const FoodCategoriesScreen({
    super.key,
    this.locationId,
    this.brandId,
    this.brandLogoPath,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Colors based on theme - matching Figma specifications
    final backgroundColor = isDark 
        ? const Color(0xFF1A1A1A)  // Dark theme background
        : const Color(0xFFFFFCF5); // Light theme background (#fffcf5 from Figma)
    
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          // Status bar spacer
          Container(
            height: MediaQuery.of(context).padding.top,
            color: backgroundColor,
          ),

          // Header with back button and title
          _buildHeader(context),

          // Categories grid
          Expanded(
            child: _buildCategoriesGrid(context),
          ),

          // Bottom navigation spacer (matches Figma)
          _buildBottomSpacer(context),
        ],
      ),
    );
  }

  /// Build header with back button and title matching Figma design
  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Colors based on theme - matching Figma specifications
    final backgroundColor = isDark 
        ? const Color(0xFF1A1A1A)  // Dark theme background
        : const Color(0xFFFFFCF5); // Light theme background (#fffcf5 from Figma)
    
    final borderColor = isDark
        ? const Color(0xFFFEFEFF)  // Light border in dark theme
        : const Color(0xFF1A1A1A); // Dark border in light theme (#1a1a1a from Figma)
    
    final iconColor = isDark
        ? const Color(0xFFFEFEFF)  // Light icon in dark theme
        : const Color(0xFF1A1A1A); // Dark icon in light theme (#1a1a1a from Figma)
    
    final titleColor = isDark
        ? const Color(0xCCFEFEFF)  // Light title with opacity in dark theme
        : const Color(0xCC1A1A1A); // Dark title with opacity in light theme (rgba(26,26,26,0.8) from Figma)
    
    return Container(
      width: double.infinity,
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
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
              child: Icon(
                Icons.arrow_back_ios_new,
                color: iconColor,
                size: 14.0,
              ),
            ),
          ),

          const SizedBox(width: 16.0), // gap-4

          // Categories title
          Expanded(
            child: Text(
              'Categories',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: titleColor,
                height: 32 / 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build categories grid matching Figma layout
  Widget _buildCategoriesGrid(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0, // gap-4
        mainAxisSpacing: 16.0, // gap-4
        childAspectRatio: 171 / 154, // Adjusted height to prevent overflow (72 + 16 + 24 + 24 + 18 text height = 154)
        children: [
          _buildCategoryCard(
            context,
            'Burgers',
            'assets/images/Static/Food_Categories/burger.png',
            'Burgers',
          ),
          _buildCategoryCard(
            context,
            'Fries & Sides',
            'assets/images/Static/Food_Categories/Fries.png',
            'Fries',
          ),
          _buildCategoryCard(
            context,
            'Desserts',
            'assets/images/Static/Food_Categories/Deserts.png',
            'Desserts',
          ),
          _buildCategoryCard(
            context,
            'Coffee',
            'assets/images/Static/Food_Categories/Coffee.png',
            'Coffee',
          ),
          _buildCategoryCard(
            context,
            'Pasta',
            'assets/images/Static/Food_Categories/Pasta.png',
            'Pasta',
          ),
        ],
      ),
    );
  }

  /// Build individual category card with glass morphism effect
  Widget _buildCategoryCard(
    BuildContext context,
    String title,
    String imagePath,
    String categoryFilter,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Colors based on theme - matching Figma specifications
    final cardColor = isDark
        ? const Color(0x40FFFFFF)  // Glass morphism in dark theme
        : const Color(0xFFFEFEFF); // Solid white background in light theme (#fefeff from Figma)
    
    final borderColor = isDark
        ? const Color(0x1AFFFFFF)  // Subtle white border in dark theme
        : const Color(0x1A1A1A1A); // Subtle dark border in light theme
    
    final textColor = isDark
        ? const Color(0xFFFEFEFF)  // Light text in dark theme
        : const Color(0xFF1A1A1A); // Dark text in light theme (#1a1a1a from Figma)
    
    final errorBgColor = isDark
        ? const Color(0xFF1A1A1A)  // Dark background for error state in dark theme
        : const Color(0xFFF5F5F5); // Light gray background for error state in light theme
    
    final errorTextColor = isDark
        ? const Color(0xFFFEFEFF)  // Light text for error in dark theme
        : const Color(0xFF1A1A1A); // Dark text for error in light theme
        
    return GestureDetector(
      onTap: () => _handleCategorySelection(context, categoryFilter),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: isDark ? 15.0 : 0.0, sigmaY: isDark ? 15.0 : 0.0), // Blur only in dark theme
          child: Container(
            padding: const EdgeInsets.all(24.0), // Increased padding to match Figma (24px)
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(
                color: borderColor,
                width: 1.0,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Use minimum space needed
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category image
                SizedBox(
                  width: 68.0, // Fixed width from Figma
                  height: 72.0, // Fixed height from Figma
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            color: errorBgColor,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.restaurant_menu,
                                  color: errorTextColor,
                                  size: 32.0,
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  'Image not found',
                                  style: TextStyle(
                                    color: errorTextColor,
                                    fontSize: 10.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 16.0), // Gap from Figma (gap-4)

                // Category title
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: textColor, // Theme-aware text color
                    height: 24 / 16, // Line height 24px for 16px font (from Figma)
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Handle category selection and navigate back to food menu with filter
  void _handleCategorySelection(BuildContext context, String category) {
    // Navigate back to food menu with selected category
    Navigator.of(context).pop(category);
  }

  /// Build bottom spacer - just safe area padding
  Widget _buildBottomSpacer(BuildContext context) {
    return SizedBox(height: MediaQuery.of(context).padding.bottom + 16.0);
  }
}