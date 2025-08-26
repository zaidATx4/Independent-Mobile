import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

enum TopChoicesTab { foods, restaurants }

class FoodItem {
  final String id;
  final String name;
  final String brandName;
  final String brandIcon;
  final String foodImage;
  final double price;

  const FoodItem({
    required this.id,
    required this.name,
    required this.brandName,
    required this.brandIcon,
    required this.foodImage,
    required this.price,
  });
}

class RestaurantItem {
  final String id;
  final String name;
  final String distance;
  final String brandIcon;
  final String restaurantImage;

  const RestaurantItem({
    required this.id,
    required this.name,
    required this.distance,
    required this.brandIcon,
    required this.restaurantImage,
  });
}

final selectedTopChoicesTabProvider = StateProvider<TopChoicesTab>(
  (ref) => TopChoicesTab.foods,
);

final favoriteFoodsProvider = StateProvider<List<FoodItem>>(
  (ref) => [
    const FoodItem(
      id: '1',
      name: 'Faluda ice cream',
      brandName: 'Salt',
      brandIcon: 'assets/images/logos/brands/Salt.png',
      foodImage: 'assets/images/Static/ice_cream.jpg',
      price: 5.0,
    ),
    const FoodItem(
      id: '2',
      name: 'Classic mojito',
      brandName: 'Somewhere',
      brandIcon: 'assets/images/logos/brands/Somewhere.png',
      foodImage: 'assets/images/Static/mojito.jpg',
      price: 5.0,
    ),
    const FoodItem(
      id: '3',
      name: 'Cheeseburger',
      brandName: 'Switch',
      brandIcon: 'assets/images/logos/brands/Switch.png',
      foodImage: 'assets/images/Static/burger.png',
      price: 5.0,
    ),
    const FoodItem(
      id: '4',
      name: 'Macaroni',
      brandName: 'Parkers',
      brandIcon: 'assets/images/logos/brands/Parkers.png',
      foodImage: 'assets/images/Static/rice.jpg',
      price: 5.0,
    ),
  ],
);

final favoriteRestaurantsProvider = StateProvider<List<RestaurantItem>>(
  (ref) => [
    const RestaurantItem(
      id: '1',
      name: 'Mall of the Emirates',
      distance: '4.1 Km away',
      brandIcon: 'assets/images/logos/brands/Salt.png',
      restaurantImage: 'assets/images/Static/Restaurant/Image-2.jpg',
    ),
    const RestaurantItem(
      id: '2',
      name: 'Dubai Mall',
      distance: '2.8 Km away',
      brandIcon: 'assets/images/logos/brands/Somewhere.png',
      restaurantImage: 'assets/images/Static/Restaurant/Mall_of_Emirates.jpg',
    ),
    const RestaurantItem(
      id: '3',
      name: 'JBR Beach',
      distance: '5.2 Km away',
      brandIcon: 'assets/images/logos/brands/Switch.png',
      restaurantImage: 'assets/images/Static/Restaurant/Image-3.jpg',
    ),
    const RestaurantItem(
      id: '4',
      name: 'Downtown Dubai',
      distance: '3.6 Km away',
      brandIcon: 'assets/images/logos/brands/Parkers.png',
      restaurantImage: 'assets/images/Static/Restaurant/Image-4.jpg',
    ),
  ],
);

class TopChoicesScreen extends ConsumerWidget {
  const TopChoicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(selectedTopChoicesTabProvider);
    final favoriteFoods = ref.watch(favoriteFoodsProvider);
    final favoriteRestaurants = ref.watch(favoriteRestaurantsProvider);
    final theme = Theme.of(context);
    final isLightTheme = theme.brightness == Brightness.light;

    return Scaffold(
      backgroundColor: isLightTheme
          ? const Color(0xFFFFFCF5)
          : const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context, isLightTheme),

            // Tab Selector
            _buildTabSelector(context, ref, selectedTab, isLightTheme),

            const SizedBox(height: 16),

            // Content
            Expanded(
              child: selectedTab == TopChoicesTab.foods
                  ? _buildFoodsGrid(favoriteFoods, isLightTheme)
                  : _buildRestaurantsGrid(favoriteRestaurants, isLightTheme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isLightTheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isLightTheme
                      ? const Color(0xFF1A1A1A)
                      : const Color(0xFFFEFEFF),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(44),
              ),
              child: Icon(
                Icons.arrow_back,
                color: isLightTheme
                    ? const Color(0xFF1A1A1A)
                    : const Color(0xFFFEFEFF),
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Title
          Expanded(
            child: Text(
              'Top Choices',
              style: TextStyle(
                color: isLightTheme
                    ? const Color(0xCC1A1A1A)
                    : const Color(0xCCFEFEFF),
                fontSize: 24,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                height: 32 / 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSelector(
    BuildContext context,
    WidgetRef ref,
    TopChoicesTab selectedTab,
    bool isLightTheme,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: Border.all(
          color: isLightTheme
              ? const Color(0xFF9C9C9D)
              : const Color(0xFF9C9C9D),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Foods Tab
          Expanded(
            child: GestureDetector(
              onTap: () =>
                  ref.read(selectedTopChoicesTabProvider.notifier).state =
                      TopChoicesTab.foods,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: selectedTab == TopChoicesTab.foods
                      ? const Color(0xFFFFFBF1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  'Foods',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selectedTab == TopChoicesTab.foods
                        ? const Color(0xFF242424)
                        : const Color(0xFF9C9C9D),
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    height: 21 / 14,
                  ),
                ),
              ),
            ),
          ),

          // Restaurants Tab
          Expanded(
            child: GestureDetector(
              onTap: () =>
                  ref.read(selectedTopChoicesTabProvider.notifier).state =
                      TopChoicesTab.restaurants,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: selectedTab == TopChoicesTab.restaurants
                      ? const Color(0xFFFFFBF1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  'Restaurants',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selectedTab == TopChoicesTab.restaurants
                        ? const Color(0xFF242424)
                        : const Color(0xFF9C9C9D),
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    height: 21 / 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodsGrid(List<FoodItem> foods, bool isLightTheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 170 / 334,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: foods.length,
        itemBuilder: (context, index) {
          final food = foods[index];
          return _buildFoodCard(food, isLightTheme);
        },
      ),
    );
  }

  Widget _buildRestaurantsGrid(
    List<RestaurantItem> restaurants,
    bool isLightTheme,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 170 / 334,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          final restaurant = restaurants[index];
          return _buildRestaurantCard(restaurant, isLightTheme);
        },
      ),
    );
  }

  Widget _buildFoodCard(FoodItem food, bool isLightTheme) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        image: DecorationImage(
          image: AssetImage(food.foodImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Bottom section with glass effect and blur
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(40)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0x1A000000), // rgba(0,0,0,0.1)
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(
                        0x40FFFFFF,
                      ), // rgba(255,255,255,0.25) - 25% white glass fill
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        // Brand icon
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            image: DecorationImage(
                              image: AssetImage(food.brandIcon),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Food details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                food.name,
                                style: const TextStyle(
                                  color: Color(0xFFFEFEFF),
                                  fontSize: 12,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.normal,
                                  height: 18 / 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),

                              Row(
                                children: [
                                  Text(
                                    food.price.toString(),
                                    style: const TextStyle(
                                      color: Color(0xFFFEFEFF),
                                      fontSize: 12,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w600,
                                      height: 18 / 12,
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  SizedBox(
                                    width: 10,
                                    height: 11.429,
                                    child: SvgPicture.asset(
                                      'assets/images/icons/SVGs/Loyalty/SAR.svg',
                                      width: 10,
                                      height: 11.429,
                                      colorFilter: const ColorFilter.mode(
                                        Color(0xFFFEFEFF),
                                        BlendMode.srcIn,
                                      ),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Add button
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFBF1),
                            borderRadius: BorderRadius.circular(44),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Color(0xFF242424),
                            size: 16,
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
    );
  }

  Widget _buildRestaurantCard(RestaurantItem restaurant, bool isLightTheme) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        image: DecorationImage(
          image: AssetImage(restaurant.restaurantImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Bottom section with glass effect and blur
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(40)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0x1A000000), // rgba(0,0,0,0.1)
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(
                        0x40FFFFFF,
                      ), // rgba(255,255,255,0.25) - 25% white glass fill
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        // Brand icon
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            image: DecorationImage(
                              image: AssetImage(restaurant.brandIcon),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Restaurant details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                restaurant.name,
                                style: const TextStyle(
                                  color: Color(0xFFFEFEFF),
                                  fontSize: 12,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.normal,
                                  height: 18 / 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),

                              Text(
                                restaurant.distance,
                                style: const TextStyle(
                                  color: Color(0xCCFEFEFF),
                                  fontSize: 12,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w600,
                                  height: 18 / 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
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
    );
  }
}
