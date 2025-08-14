import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui' as ui;
import '../../domain/entities/food_item_entity.dart';
import '../../../shared/cart/presentation/pages/cart_screen.dart';

/// Food detail screen matching Figma design with full-screen food image
/// Displays detailed food information with overlay content and add to cart functionality
class FoodDetailScreen extends StatefulWidget {
  final FoodItemEntity foodItem;
  final String? brandLogoPath;

  const FoodDetailScreen({
    super.key,
    required this.foodItem,
    this.brandLogoPath,
  });

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  bool _isAddedToCart = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full-screen food image background
          _buildFoodImageBackground(),
          
          // Status bar overlay
          _buildStatusBar(context),
          
          // Top navigation with back and cart buttons
          _buildTopNavigation(context),
          
          // Bottom content overlay with food details
          _buildBottomContentOverlay(context),
          
          // Add to cart button (outside blur effect)
          _buildFloatingAddToCartButton(context),
        ],
      ),
    );
  }

  /// Build full-screen food image background (no blur)
  Widget _buildFoodImageBackground() {
    return Positioned.fill(
      child: Image.asset(
        widget.foodItem.imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            decoration: const BoxDecoration(
              color: Color(0xFF242424),
            ),
            child: const Center(
              child: Icon(
                Icons.restaurant,
                color: Color(0xFF9C9C9D),
                size: 80.0,
              ),
            ),
          );
        },
      ),
    );
  }

  /// Build status bar overlay
  Widget _buildStatusBar(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: MediaQuery.of(context).padding.top + 44,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(0, 0, 0, 0.3),
              Colors.transparent,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '9:41',
                  style: TextStyle(
                    fontFamily: 'SF Pro Text',
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFFEFEFF),
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build top navigation with back and cart buttons
  Widget _buildTopNavigation(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 20,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Back button with rounded blurred background
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(44.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x33000000), // Reduced shadow - 20% opacity
                      blurRadius: 8.0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(44.0),
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                    child: Container(
                      width: 48.0,
                      height: 48.0,
                      decoration: BoxDecoration(
                        color: const Color(0x40FFFFFF), // rgba(255,255,255,0.25)
                        borderRadius: BorderRadius.circular(44.0),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Color(0xFFFEFEFF),
                        size: 16.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            // Cart button with rounded blurred background
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CartScreen(),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(44.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x33000000), // Reduced shadow - 20% opacity
                      blurRadius: 8.0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(44.0),
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                    child: Container(
                      width: 48.0,
                      height: 48.0,
                      decoration: BoxDecoration(
                        color: const Color(0x40FFFFFF), // rgba(255,255,255,0.25)
                        borderRadius: BorderRadius.circular(44.0),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/images/icons/SVGs/Loyalty/Cart_icon.svg',
                          width: 18.0,
                          height: 18.0,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFFFEFEFF), // Full white for better visibility
                            BlendMode.srcIn,
                          ),
                        ),
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

  /// Build bottom content overlay with food details
  Widget _buildBottomContentOverlay(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipRRect(
        borderRadius: BorderRadius.zero,
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0), // 30% blur effect
          child: Container(
            constraints: BoxConstraints(
              maxWidth: isTablet ? 500.0 : screenWidth,
              minHeight: screenHeight * 0.2,
              maxHeight: screenHeight * 0.4,
            ),
            decoration: BoxDecoration(
              // Combined gradients: black 0.1 opacity + glass-fill white 0.25 opacity
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(0, 0, 0, 0.1), // rgba(0, 0, 0, 0.1)
                  Color.fromRGBO(0, 0, 0, 0.1), // rgba(0, 0, 0, 0.1)
                ],
              ),
              borderRadius: BorderRadius.zero,
            ),
            child: Container(
              decoration: const BoxDecoration(
                // Glass-fill overlay: rgba(255, 255, 255, 0.25)
                color: Color.fromRGBO(255, 255, 255, 0.25), // indpt/glass-fill
                borderRadius: BorderRadius.zero,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Food details section
                  _buildFoodDetailsSection(context),
                  
                  // Bottom safe area padding (no home indicator overlay)
                  SizedBox(height: MediaQuery.of(context).padding.bottom),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build food details section with brand icon, name, description, and price
  Widget _buildFoodDetailsSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    
    return Container(
      padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand icon
          _buildBrandIcon(context),
          
          SizedBox(width: isTablet ? 12.0 : 8.0),
          
          // Food name and description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.foodItem.name,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: isTablet ? 24.0 : 20.0,
                    fontWeight: FontWeight.w600, // SemiBold
                    color: const Color(0xFFFFFFFF),
                    height: 1.5, // 30px line height / 20px font size
                  ),
                  maxLines: isTablet ? 3 : 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: isTablet ? 6.0 : 4.0),
                Text(
                  widget.foodItem.description,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: isTablet ? 14.0 : 12.0,
                    fontWeight: FontWeight.w400, // Regular
                    color: const Color(0xCCFEFEFF), // rgba(254, 254, 255, 0.8)
                    height: 1.5, // 18px line height / 12px font size
                  ),
                  maxLines: isTablet ? 4 : 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          SizedBox(width: isTablet ? 12.0 : 8.0),
          
          // Price section
          _buildPriceSection(context),
        ],
      ),
    );
  }

  /// Build brand icon
  Widget _buildBrandIcon(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final iconSize = isTablet ? 80.0 : 64.0;
    
    return Container(
      width: iconSize,
      height: iconSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: const Color(0xFF242424),
      ),
      child: widget.brandLogoPath != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.asset(
                widget.brandLogoPath!,
                width: iconSize,
                height: iconSize,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildDefaultBrandIcon(context);
                },
              ),
            )
          : _buildDefaultBrandIcon(context),
    );
  }

  /// Build default brand icon when no logo is available
  Widget _buildDefaultBrandIcon(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final iconSize = isTablet ? 80.0 : 64.0;
    
    return Container(
      width: iconSize,
      height: iconSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: const Color(0xFF242424),
      ),
      child: Icon(
        Icons.restaurant,
        color: const Color(0xFF9C9C9D),
        size: isTablet ? 40.0 : 32.0,
      ),
    );
  }

  /// Build price section with SAR icon and amount
  Widget _buildPriceSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '${widget.foodItem.price.toInt()}',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: isTablet ? 28.0 : 24.0,
            fontWeight: FontWeight.w700, // Bold
            color: const Color(0xFFFEFEFF),
            height: 1.33, // 32px line height / 24px font size
          ),
        ),
        SizedBox(width: isTablet ? 4.0 : 2.0),
        SvgPicture.asset(
          'assets/images/icons/SVGs/Loyalty/SAR.svg',
          width: isTablet ? 16.0 : 14.0,
          height: isTablet ? 18.0 : 16.0,
          colorFilter: const ColorFilter.mode(
            Color(0xFFFEFEFF),
            BlendMode.srcIn,
          ),
        ),
      ],
    );
  }

  /// Build floating add to cart button (outside blur effect)
  Widget _buildFloatingAddToCartButton(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    
    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom + 16.0,
      left: 16.0,
      right: 16.0,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: isTablet ? 400.0 : double.infinity,
        ),
        child: _isAddedToCart
            ? Container(
                padding: EdgeInsets.symmetric(vertical: isTablet ? 16.0 : 12.0),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(44.0),
                  border: Border.all(color: const Color(0xFFFEFEFF), width: 1.0),
                ),
                child: Text(
                  'Added to cart',
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    height: 24.0 / 16.0,
                    letterSpacing: 0.0,
                    color: Color(0xFFFEFEFF),
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            : ElevatedButton(
                onPressed: () => _handleAddToCart(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFFBF1),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(vertical: isTablet ? 16.0 : 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(44.0),
                  ),
                ),
                child: const Text(
                  'Add to cart',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    height: 24.0 / 16.0,
                    letterSpacing: 0.0,
                    color: Color(0xFF242424),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
      ),
    );
  }

  /// Build home indicator
  Widget _buildHomeIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 120.0, vertical: 8.0),
      child: Container(
        width: 134.0,
        height: 5.0,
        decoration: BoxDecoration(
          color: const Color(0xFF9C9C9D), // indpt/text tertiary
          borderRadius: BorderRadius.circular(100.0),
        ),
      ),
    );
  }

  /// Handle add to cart action
  void _handleAddToCart(BuildContext context) {
    setState(() {
      _isAddedToCart = true;
    });
    // Removed snackbar notification as requested
  }

  /// Example: Navigate to checkout with food's location data
  /// This shows how to pass location from food ordering to checkout
  /*
  void _navigateToCheckout(BuildContext context, LocationEntity selectedLocation) {
    context.push(
      '/checkout/pickup-details',
      extra: {
        'subtotal': 29.99,
        'tax': 4.50,
        'total': 34.49,
        'brandId': widget.foodItem.brandId,
        'locationId': selectedLocation.id,
        'orderingLocation': selectedLocation, // Pass the food's location
        // Alternative: convert to PickupLocationEntity first
        // 'foodLocation': PickupDetailsScreen.convertLocationToPickupLocation(
        //   selectedLocation,
        //   brandLogoPath: widget.brandLogoPath,
        // ),
      },
    );
  }
  */
}