import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui' as ui;
import '../../domain/entities/food_item_entity.dart';
import '../../domain/entities/location_entity.dart';
import '../../../shared/cart/presentation/pages/cart_screen.dart';
import '../../../shared/cart/presentation/providers/cart_provider.dart';
import '../../../shared/cart/data/models/cart_models.dart';
import '../../../shared/checkout/presentation/providers/checkout_providers.dart';
import '../../../shared/checkout/domain/entities/checkout_entities.dart';
import '../providers/location_selection_provider.dart';
import '../../../shared/widgets/location_conflict_banner.dart';

/// Food detail screen matching Figma design with full-screen food image
/// Displays detailed food information with overlay content and location-aware add to cart functionality
class FoodDetailScreen extends ConsumerStatefulWidget {
  final FoodItemEntity foodItem;
  final String? brandLogoPath;
  final LocationEntity? selectedLocation;

  const FoodDetailScreen({
    super.key,
    required this.foodItem,
    this.brandLogoPath,
    this.selectedLocation,
  });

  @override
  ConsumerState<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends ConsumerState<FoodDetailScreen> {
  bool _isAddedToCart = false;
  bool _isLoading = false;

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
            decoration: const BoxDecoration(color: Color(0xFF242424)),
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
            colors: [Color.fromRGBO(0, 0, 0, 0.3), Colors.transparent],
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
            // Back button with rounded blurred background (matching cart button style)
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(44.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(
                        0x33000000,
                      ), // Reduced shadow - 20% opacity
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
                        color: const Color(
                          0x40FFFFFF,
                        ), // rgba(255,255,255,0.25)
                        borderRadius: BorderRadius.circular(44.0),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Color(
                            0xFFFEFEFF,
                          ), // Full white for better visibility
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Cart button with rounded blurred background and badge
            GestureDetector(
              onTap: () => _navigateToCartOrCheckout(context, ref),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(44.0),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0x33000000,
                          ), // Reduced shadow - 20% opacity
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
                            color: const Color(
                              0x40FFFFFF,
                            ), // rgba(255,255,255,0.25)
                            borderRadius: BorderRadius.circular(44.0),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/images/icons/SVGs/Loyalty/Cart_icon.svg',
                              width: 18.0,
                              height: 18.0,
                              colorFilter: const ColorFilter.mode(
                                Color(
                                  0xFFFEFEFF,
                                ), // Full white for better visibility
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Cart item count badge
                  Consumer(
                    builder: (context, ref, child) {
                      final cartItemCount = ref.watch(cartItemCountProvider);
                      if (cartItemCount == 0) return const SizedBox.shrink();

                      return Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4.0),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF3B30), // iOS red color
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16.0,
                            minHeight: 16.0,
                          ),
                          child: Text(
                            cartItemCount > 99
                                ? '99+'
                                : cartItemCount.toString(),
                            style: const TextStyle(
                              fontFamily: 'SF Pro Text',
                              fontSize: 10.0,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFFEFEFF),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  ),
                ],
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
          filter: ui.ImageFilter.blur(
            sigmaX: 30.0,
            sigmaY: 30.0,
          ), // 30% blur effect
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Theme-aware colors for button
    final buttonBackgroundColor = isDarkMode
        ? const Color(0xFFFFFBF1)
        : const Color(0xFF1A1A1A);
    final buttonTextColor = isDarkMode
        ? const Color(0xFF242424)
        : const Color(0xFFFEFEFF);
    final addedStateBorderColor = isDarkMode
        ? const Color(0xFFFEFEFF)
        : const Color(0xFF1A1A1A);
    final addedStateTextColor = isDarkMode
        ? const Color(0xFFFEFEFF)
        : const Color(0xFF1A1A1A);
    final loadingBackgroundColor = isDarkMode
        ? const Color(0xFFFFFBF1).withValues(alpha: 0.7)
        : const Color(0xFF1A1A1A).withValues(alpha: 0.7);
    final loadingIndicatorColor = isDarkMode
        ? const Color(0xFF242424)
        : const Color(0xFFFEFEFF);

    return Consumer(
      builder: (context, ref, child) {
        final cartState = ref.watch(cartProvider);
        final isInCart =
            cartState.cart?.containsItem(widget.foodItem.id) ?? false;

        return Positioned(
          bottom: MediaQuery.of(context).padding.bottom,
          left: 16.0,
          right: 16.0,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: isTablet ? 400.0 : double.infinity,
            ),
            child: _isLoading
                ? Container(
                    padding: EdgeInsets.symmetric(
                      vertical: isTablet ? 16.0 : 12.0,
                    ),
                    decoration: BoxDecoration(
                      color: loadingBackgroundColor,
                      borderRadius: BorderRadius.circular(44.0),
                    ),
                    child: Center(
                      child: SizedBox(
                        width: 20.0,
                        height: 20.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            loadingIndicatorColor,
                          ),
                        ),
                      ),
                    ),
                  )
                : (isInCart || _isAddedToCart)
                ? Container(
                    padding: EdgeInsets.symmetric(
                      vertical: isTablet ? 16.0 : 12.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(44.0),
                      border: Border.all(
                        color: addedStateBorderColor,
                        width: 1.0,
                      ),
                    ),
                    child: Text(
                      'Added to cart',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        height: 24.0 / 16.0,
                        letterSpacing: 0.0,
                        color: addedStateTextColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ElevatedButton(
                    onPressed: () => _handleAddToCart(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonBackgroundColor,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      surfaceTintColor: Colors.transparent,
                      padding: EdgeInsets.symmetric(
                        vertical: isTablet ? 16.0 : 12.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(44.0),
                      ),
                    ),
                    child: Text(
                      'Add to cart',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        height: 24.0 / 16.0,
                        letterSpacing: 0.0,
                        color: buttonTextColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
          ),
        );
      },
    );
  }

  /// Handle add to cart action with location validation
  Future<void> _handleAddToCart(BuildContext context) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Get the location for this food item
      LocationEntity? itemLocation = widget.selectedLocation;

      // If no location provided, try to get it from the selected location provider
      itemLocation ??= ref.read(selectedLocationProvider);

      // If still no location, show error
      if (itemLocation == null) {
        if (mounted) {
          _showLocationRequiredDialog(context);
        }
        return;
      }

      final brandName = _getBrandNameFromId(widget.foodItem.brandId);
      final brandLogoUrl = _getBrandLogoFromId(widget.foodItem.brandId);

      // Create cart item with location information
      final cartItem = CartItem(
        id: widget.foodItem.id,
        name: widget.foodItem.name,
        description: widget.foodItem.description,
        price: widget.foodItem.price,
        currency: widget.foodItem.currency,
        imageUrl: widget.foodItem.imagePath,
        brandName: brandName,
        brandLogoUrl: brandLogoUrl,
        quantity: 1,
        locationId: itemLocation.id,
        locationName: itemLocation.name,
      );

      // Try to add with location check
      final cartNotifier = ref.read(cartProvider.notifier);
      final success = await cartNotifier.addItemWithLocationCheck(cartItem);

      if (success) {
        setState(() {
          _isAddedToCart = true;
        });
        if (mounted) {
          _showSuccessMessage(context);
        }
      } else {
        // Location conflict - show dialog
        final currentCart = ref.read(cartProvider).cart;
        if (mounted && currentCart != null && currentCart.isNotEmpty) {
          _showLocationConflictBanner(
            context,
            currentCart.currentLocationName ?? 'Unknown',
            itemLocation.name,
            cartItem,
          );
        }
      }
    } catch (e) {
      if (mounted && e is LocationConflictException) {
        _showLocationConflictBanner(
          context,
          e.currentLocationName,
          e.conflictingLocationName,
          CartItem(
            id: widget.foodItem.id,
            name: widget.foodItem.name,
            description: widget.foodItem.description,
            price: widget.foodItem.price,
            currency: widget.foodItem.currency,
            imageUrl: widget.foodItem.imagePath,
            brandName: _getBrandNameFromId(widget.foodItem.brandId),
            brandLogoUrl: _getBrandLogoFromId(widget.foodItem.brandId),
            quantity: 1,
            locationId: widget.selectedLocation?.id ?? '',
            locationName: widget.selectedLocation?.name ?? '',
          ),
        );
      } else if (mounted) {
        _showErrorDialog(context, e.toString());
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Show location required dialog
  void _showLocationRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1C1C1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: const Text(
            'Location Required',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              color: Color(0xFFFEFEFF),
            ),
          ),
          content: const Text(
            'Please select a location to add items to your cart.',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              color: Color(0xCCFEFEFF),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'OK',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFFFFBF1),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Show location conflict banner from bottom
  void _showLocationConflictBanner(
    BuildContext context,
    String currentLocationName,
    String newLocationName,
    CartItem newItem,
  ) {
    LocationConflictBanner.show(
      context: context,
      currentLocationName: currentLocationName,
      newLocationName: newLocationName,
      onClearCart: () async {
        Navigator.of(context).pop(); // Close the banner
        await _clearCartAndAddItem(newItem);
      },
      onCancel: () {
        Navigator.of(context).pop(); // Close the banner
      },
    );
  }

  /// Clear cart and add new item
  Future<void> _clearCartAndAddItem(CartItem newItem) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final cartNotifier = ref.read(cartProvider.notifier);
      await cartNotifier.addItemWithLocationCheck(
        newItem,
        clearCartOnConflict: true,
      );

      setState(() {
        _isAddedToCart = true;
      });
      if (mounted) {
        _showSuccessMessage(context);
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(context, e.toString());
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Show success message
  void _showSuccessMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${widget.foodItem.name} added to cart',
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            color: Color(0xFFFEFEFF),
          ),
        ),
        backgroundColor: const Color(0xFF34C759),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    );
  }

  /// Show error dialog
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1C1C1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: const Text(
            'Error',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              color: Color(0xFFFEFEFF),
            ),
          ),
          content: Text(
            message,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              color: Color(0xCCFEFEFF),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'OK',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFFFFBF1),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Show error snackbar
  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: Color(0xFFFEFEFF),
          ),
        ),
        backgroundColor: const Color(0xFFDC2626),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        margin: const EdgeInsets.all(16.0),
      ),
    );
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

  /// Get brand name from brand ID
  String _getBrandNameFromId(String brandId) {
    // First try to use the passed brandLogoPath to infer brand name
    if (widget.brandLogoPath != null && widget.brandLogoPath!.isNotEmpty) {
      final logoPath = widget.brandLogoPath!.toLowerCase();
      if (logoPath.contains('salt')) {
        return 'Salt';
      } else if (logoPath.contains('switch')) {
        return 'Switch';
      } else if (logoPath.contains('somewhere')) {
        return 'Somewhere';
      } else if (logoPath.contains('joe') || logoPath.contains('juice')) {
        return 'Joe & Juice';
      } else if (logoPath.contains('parkers')) {
        return 'Parkers';
      }
    }

    // Fallback to ID-based mapping with corrected brand names
    final brandName = switch (brandId) {
      '1' => 'Salt',
      '2' => 'Switch',
      '3' => 'Somewhere',
      '4' => 'Joe & Juice',
      '5' => 'Parkers',
      _ => 'Salt', // Default fallback
    };

    return brandName;
  }

  /// Get brand logo URL from brand ID
  String _getBrandLogoFromId(String brandId) {
    // First prefer the passed brandLogoPath if available
    if (widget.brandLogoPath != null && widget.brandLogoPath!.isNotEmpty) {
      return widget.brandLogoPath!;
    }

    // Fallback to ID-based mapping with corrected logo paths
    final logoPath = switch (brandId) {
      '1' => 'assets/images/logos/brands/Salt.png',
      '2' => 'assets/images/logos/brands/Switch.png',
      '3' => 'assets/images/logos/brands/Somewhere.png',
      '4' => 'assets/images/logos/brands/Joe_and _juice.png',
      '5' => 'assets/images/logos/brands/Parkers.png',
      _ => 'assets/images/logos/brands/Salt.png', // Default fallback
    };

    return logoPath;
  }
  
  /// Navigate to cart or directly to checkout based on cart state
  void _navigateToCartOrCheckout(BuildContext context, WidgetRef ref) {
    // Always navigate directly to cart screen
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const CartScreen()),
    );
  }
  
  /// Initiate secure checkout flow
  Future<void> _initiateSecureCheckout(BuildContext context, WidgetRef ref) async {
    try {
      final cartState = ref.read(cartProvider);
      final cart = cartState.cart;
      
      if (cart == null || cart.isEmpty) {
        _showError(context, 'Your cart is empty');
        return;
      }
      
      // Get or create user ID (in production, from auth service)
      // const userId = 'user_demo_123'; // Placeholder - unused for now
      
      // Initialize secure checkout flow
      final checkoutNotifier = ref.read(checkoutProvider.notifier);
      
      // Convert LocationEntity to PickupLocationEntity if available
      PickupLocationEntity? foodLocation;
      if (widget.selectedLocation != null) {
        foodLocation = PickupLocationEntity(
          id: widget.selectedLocation!.id,
          name: widget.selectedLocation!.name,
          address: widget.selectedLocation!.address,
          brandLogoPath: widget.brandLogoPath ?? '',
          latitude: widget.selectedLocation!.latitude,
          longitude: widget.selectedLocation!.longitude,
          isActive: widget.selectedLocation!.isOpen && widget.selectedLocation!.acceptsPickup,
        );
      }
      
      await checkoutNotifier.initializeCheckout(
        subtotal: cart.subtotal,
        tax: cart.tax, 
        total: cart.total,
        foodLocation: foodLocation,
      );
      
      // Navigate to pickup details screen
      if (context.mounted) {
        context.push('/checkout/pickup-details', extra: {
          'total': cart.total,
          'currency': 'SAR',
          'fromSecureFlow': true,
        });
      }
      
    } catch (e) {
      if (context.mounted) {
        _showError(context, 'Failed to start checkout: ${e.toString()}');
      }
    }
  }
}
