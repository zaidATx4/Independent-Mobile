import 'dart:ui';
import 'package:flutter/material.dart';

/// Food categories screen matching Figma design
/// Shows all available food categories with images and glass morphism effects
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
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A), // indpt/neutral background
      body: Column(
        children: [
          // Status bar spacer
          Container(
            height: MediaQuery.of(context).padding.top,
            color: const Color(0xFF1A1A1A),
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
    return Container(
      width: double.infinity,
      color: const Color(0xFF1A1A1A),
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
                  color: const Color(0xFFFEFEFF), // indpt/text primary
                  width: 1.0,
                ),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Color(0xFFFEFEFF), // indpt/text primary
                size: 14.0,
              ),
            ),
          ),

          const SizedBox(width: 16.0), // gap-4

          // Categories title
          const Expanded(
            child: Text(
              'Categories',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 24.0,
                fontWeight: FontWeight.w700, // Bold
                color: Color(0xCCFEFEFF), // rgba(254,254,255,0.8)
                height: 1.33, // line-height: 32px / 24px
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
        childAspectRatio: 171 / 144, // Width / Height from Figma analysis
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
    return GestureDetector(
      onTap: () => _handleCategorySelection(context, categoryFilter),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0), // 30px blur
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color(0x40FFFFFF), // #FFFFFF40 glass-fill
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(
                color: const Color(0x1AFFFFFF), // Subtle white border
                width: 1.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category image
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12.0), // Add padding to make images smaller
                    child: Align(
                      alignment: Alignment.centerLeft, // Left align the image
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.contain, // Change to contain to prevent cropping
                        errorBuilder: (context, error, stackTrace) {
                          print('Failed to load image: $imagePath');
                          print('Error: $error');
                          return Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1A1A),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.restaurant_menu,
                                    color: Color(0xFFFEFEFF),
                                    size: 32.0,
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    'Image not found',
                                    style: const TextStyle(
                                      color: Color(0xFFFEFEFF),
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
                  ),
                ),

                const SizedBox(height: 12.0),

                // Category title
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFFEFEFF), // indpt/text-primary
                    height: 1.5,
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