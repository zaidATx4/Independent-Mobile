import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/food_menu_provider.dart';
import '../widgets/food_menu_header.dart';
import '../widgets/category_section_header.dart';
import '../widgets/food_filter_chips.dart';
import '../widgets/food_item_card.dart';
import '../../domain/entities/food_item_entity.dart';
import '../../domain/entities/location_entity.dart';
import '../../../shared/cart/presentation/pages/cart_screen.dart';
import '../../../shared/food/presentation/pages/food_search_screen.dart';
import 'food_categories_screen.dart';

/// Food menu screen matching Figma design with dark theme
/// Displays food items from a selected restaurant location
class FoodMenuScreen extends ConsumerStatefulWidget {
  final String locationId;
  final String? brandId;
  final LocationEntity? selectedLocation;
  final String? brandLogoPath;

  const FoodMenuScreen({
    super.key,
    required this.locationId,
    this.brandId,
    this.selectedLocation,
    this.brandLogoPath,
  });

  @override
  ConsumerState<FoodMenuScreen> createState() => _FoodMenuScreenState();
}

class _FoodMenuScreenState extends ConsumerState<FoodMenuScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize data loading after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final params = createFoodMenuParams(
        locationId: widget.locationId,
        brandId: widget.brandId,
      );
      ref.read(foodMenuProvider(params).notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final menuParams = createFoodMenuParams(
      locationId: widget.locationId,
      brandId: widget.brandId,
    );
    final state = ref.watch(foodMenuProvider(menuParams));

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A), // indpt/neutral background
      body: Stack(
        children: [
          // Main content
          Column(
            children: [
              // Status bar spacer
              Container(
                height: MediaQuery.of(context).padding.top,
                color: const Color(0xFF1A1A1A),
              ),

              // Header with back button, title, and action buttons
              FoodMenuHeader(
                onBackPressed: () => Navigator.of(context).pop(),
                onCartPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CartScreen(),
                    ),
                  );
                },
                onSearchPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const FoodSearchScreen(),
                    ),
                  );
                },
              ),

              // Location info section - always show with fallback data
              LocationInfoWidget(
                brandLogoPath: widget.brandLogoPath,
                locationName:
                    widget.selectedLocation?.name ?? 'Selected Location',
                locationAddress:
                    widget.selectedLocation?.address ?? 'Location Address',
              ),

              // Category section header - shows selected category
              CategorySectionHeader(
                categoryName: state.selectedCategory,
                itemCount: state.filteredFoodItems.length,
                locationId: widget.locationId,
                brandId: widget.brandId,
                brandLogoPath: widget.brandLogoPath,
                onFilterPressed: () => _handleCategoriesNavigation(context, menuParams),
              ),

              // Category filter chips - show all available categories
              FoodFilterChips(
                categories: state.categories,
                selectedCategory: state.selectedCategory,
                onCategorySelected: (category) {
                  ref
                      .read(foodMenuProvider(menuParams).notifier)
                      .selectCategory(category);
                },
              ),

              // Food items content (no loading/error branches)
              Expanded(child: _buildFoodItemsContent(state, menuParams)),
            ],
          ),
        ],
      ),
    );
  }

  /// Build food items content based on current state
  Widget _buildFoodItemsContent(
    FoodMenuState state,
    FoodMenuParams menuParams,
  ) {
    return _buildFoodItemsGrid(state.filteredFoodItems);
  }

  // Loading/error/empty states removed per request to always render items

  /// Build food items grid matching Figma layout
  Widget _buildFoodItemsGrid(List<FoodItemEntity> foodItems) {
    return Container(
      color: const Color(0xFF1A1A1A),
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 172 / 245, // Width / Height from Figma
          crossAxisSpacing: 8.0, // Gap between columns
          mainAxisSpacing: 16.0, // Gap between rows
        ),
        itemCount: foodItems.length,
        itemBuilder: (context, index) {
          final foodItem = foodItems[index];
          return FoodItemCard(
            foodItem: foodItem,
            isCompact: index % 2 == 1, // Alternate compact sizing
            onTap: () => _handleFoodItemTap(foodItem),
            onAddPressed: () => _handleAddToCart(foodItem),
          );
        },
      ),
    );
  }

  /// Handle food item tap - navigate to food detail screen
  void _handleFoodItemTap(FoodItemEntity foodItem) {
    context.push('/food-detail', extra: {
      'foodItem': foodItem,
      'brandLogoPath': widget.brandLogoPath,
    });
  }

  /// Handle add to cart action
  void _handleAddToCart(FoodItemEntity foodItem) {
    // TODO: Add item to cart
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ${foodItem.name} to cart'),
        backgroundColor: const Color(0xFF242424),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: const EdgeInsets.all(16.0),
        action: SnackBarAction(
          label: 'View Cart',
          textColor: const Color(0xFFFFFBF1),
          onPressed: () {
            // TODO: Navigate to cart screen
          },
        ),
      ),
    );
  }

  /// Handle navigation to categories screen and process result
  Future<void> _handleCategoriesNavigation(
    BuildContext context,
    FoodMenuParams menuParams,
  ) async {
    final selectedCategory = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (context) => FoodCategoriesScreen(
          locationId: widget.locationId,
          brandId: widget.brandId,
          brandLogoPath: widget.brandLogoPath,
        ),
      ),
    );

    if (selectedCategory != null && mounted) {
      // Update the food menu provider with the selected category
      ref
          .read(foodMenuProvider(menuParams).notifier)
          .selectCategory(selectedCategory);
    }
  }
}
