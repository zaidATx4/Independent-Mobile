import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/brand_selection_provider.dart';
import '../widgets/brand_card.dart';
import '../widgets/brand_selection_header.dart';
import '../../../../core/theme/theme_service.dart';

/// Brand selection screen matching Figma design with light theme
class BrandSelectionScreen extends ConsumerStatefulWidget {
  const BrandSelectionScreen({super.key});

  @override
  ConsumerState<BrandSelectionScreen> createState() =>
      _BrandSelectionScreenState();
}

class _BrandSelectionScreenState extends ConsumerState<BrandSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(brandSelectionProvider);
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    // Responsive dimensions based on Figma design (393x852 base) - adjusted gaps
    final titleTopPadding = (screenHeight * 0.12).clamp(
      85.0,
      115.0,
    ); // Move Select brand title lower for larger gap from Place Order
    final brandsTopPadding = (screenHeight * 0.17).clamp(
      135.0,
      165.0,
    ); // Move cards lower to create gap from Select brand title
    final horizontalPadding = (screenWidth * 0.0407).clamp(12.0, 20.0); // 16px

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background image - extends to full screen including status bar
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgrounds/Select_Language.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          // Theme-aware overlay
          Positioned.fill(
            child: Container(
              color: context.getThemedColor(
                lightColor: Colors.white.withValues(alpha: 0.3),
                darkColor: Colors.black.withValues(alpha: 0.7),
              ),
            ),
          ),
          // Main content container
          Container(
            width: screenWidth,
            height: screenHeight,
            child: Stack(
              children: [
                // Header with SafeArea
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                      ), // Increase top padding
                      child: const BrandSelectionHeader(),
                    ),
                  ),
                ),

                // Select brand title - centered
                Positioned(
                  top:
                      titleTopPadding, // moved up to create more gap to the cards
                  left: horizontalPadding,
                  right: horizontalPadding,
                  child: Center(
                    child: Text(
                      'Select brand',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: (screenWidth * 0.0508).clamp(
                          18.0,
                          22.0,
                        ), // 20px
                        fontWeight: FontWeight.w600, // SemiBold
                        color: context.getThemedColor(
                          lightColor: const Color(0x99242424), // Dark text for light theme
                          darkColor: const Color(0xCCFEFEFF), // Light text for dark theme
                        ),
                        height: 1.5, // 30/20 = 1.5 line height
                      ),
                    ),
                  ),
                ),

                // Brand cards list - remove top positioning
                Positioned(
                  top: brandsTopPadding - 20, // Remove additional top padding
                  left: horizontalPadding,
                  right: horizontalPadding,
                  bottom: 120, // Leave space for bottom navigation
                  child: state.isLoading
                      ? _buildLoadingState()
                      : state.error != null
                      ? _buildErrorState(state.error!)
                      : _buildBrandsList(state.brands, screenWidth),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build loading state with shimmer effect
  Widget _buildLoadingState() {
    return Column(
      children: List.generate(
        5,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Container(
            width: double.infinity,
            height: 80, // Height matching brand card
            decoration: BoxDecoration(
              color: context.getThemedColor(
                lightColor: const Color(0xFFFEFEFF), // Light theme background
                darkColor: Colors.white.withValues(alpha: 0.25), // Dark theme glassmorphism
              ),
              borderRadius: BorderRadius.circular(106),
              border: Border.all(
                color: context.getThemedColor(
                  lightColor: const Color(0xFFD9D9D9), // Light theme border
                  darkColor: Colors.white.withValues(alpha: 0.45), // Dark theme border
                ),
                width: 1,
              ),
            ),
            child: Center(
              child: CircularProgressIndicator(
                color: context.getThemedColor(
                  lightColor: const Color(0xFF1A1A1A), // Dark indicator for light theme
                  darkColor: const Color(0xFFFEFEFF), // Light indicator for dark theme
                ),
                strokeWidth: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build error state
  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: context.getThemedColor(
              lightColor: const Color(0xFF1A1A1A),
              darkColor: const Color(0xFFFEFEFF),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: context.getThemedColor(
                lightColor: const Color(0xFF1A1A1A),
                darkColor: const Color(0xFFFEFEFF),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              color: context.getThemedColor(
                lightColor: const Color(0x99242424),
                darkColor: Colors.white.withValues(alpha: 0.75),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () =>
                ref.read(brandSelectionProvider.notifier).refresh(),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.getThemedColor(
                lightColor: const Color(0xFF1A1A1A),
                darkColor: const Color(0xFFFEFEFF),
              ),
              foregroundColor: context.getThemedColor(
                lightColor: const Color(0xFFFEFEFF),
                darkColor: const Color(0xFF1A1A1A),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Text(
              'Try Again',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build brands list
  Widget _buildBrandsList(List brands, double screenWidth) {
    if (brands.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              size: 48,
              color: context.getThemedColor(
                lightColor: const Color(0x80242424),
                darkColor: Colors.white.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No brands found',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: context.getThemedColor(
                  lightColor: const Color(0xFF1A1A1A),
                  darkColor: const Color(0xFFFEFEFF),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                color: context.getThemedColor(
                  lightColor: const Color(0x99242424),
                  darkColor: Colors.white.withValues(alpha: 0.75),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: brands.length,
      separatorBuilder: (context, index) => SizedBox(height: 8.0), // 8px gap
      itemBuilder: (context, index) {
        return BrandCard(
          brand: brands[index],
          onTap: () => _handleBrandTap(brands[index]),
        );
      },
    );
  }

  /// Handle brand tap - navigate to location selection
  void _handleBrandTap(dynamic brand) {
    
    // Select brand in provider
    ref.read(brandSelectionProvider.notifier).selectBrand(brand.id);

    // Navigate to location selection screen with brand data
    context.push(
      '/location-selection',
      extra: {
        'brandId': brand.id,
        'brandName': brand.name,
        'brandLogoPath': brand.logoUrl,
      },
    );
    
  }
}
