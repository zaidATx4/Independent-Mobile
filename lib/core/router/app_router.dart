import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:independent/features/settings/presentation/settings_screen.dart';
import 'package:independent/features/home/presentation/main_navigation_screen.dart';
import 'package:independent/features/loyalty/presentation/pages/loyalty_hub_screen.dart';
import 'package:independent/features/shared/cart/presentation/pages/cart_screen.dart';
import 'package:independent/features/shared/food/presentation/pages/food_search_screen.dart';
import 'package:independent/features/food_ordering/presentation/pages/brand_selection_screen.dart';
import 'package:independent/features/food_ordering/presentation/pages/location_selection_screen.dart';
import 'package:independent/features/food_ordering/presentation/pages/food_menu_screen.dart';
import 'package:independent/features/food_ordering/presentation/pages/food_detail_screen.dart';
import 'package:independent/features/food_ordering/domain/entities/location_entity.dart';
import 'package:independent/features/food_ordering/domain/entities/food_item_entity.dart';
import 'package:independent/features/loyalty/presentation/pages/redeemed_qr_screen.dart';
import 'package:independent/features/shared/checkout/presentation/pages/pickup_details_screen.dart';
import 'package:independent/features/shared/checkout/domain/entities/checkout_entities.dart';
import 'package:independent/features/settings/presentation/screens/theme_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainNavigationScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/theme',
      builder: (context, state) => const ThemeScreen(),
    ),
    GoRoute(
      path: '/loyalty-hub',
      builder: (context, state) => const LoyaltyHubScreen(),
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => const CartScreen(),
    ),
    GoRoute(
      path: '/food-search',
      builder: (context, state) => const FoodSearchScreen(),
    ),
    GoRoute(
      path: '/brand-selection',
      builder: (context, state) => const BrandSelectionScreen(),
    ),
    GoRoute(
      path: '/location-selection',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final brandId = state.uri.queryParameters['brandId'] ?? extra?['brandId'] as String? ?? '';
        final brandName = state.uri.queryParameters['brandName'] ?? extra?['brandName'] as String?;
        final brandLogoPath = state.uri.queryParameters['brandLogoPath'] ?? extra?['brandLogoPath'] as String?;
        
        return LocationSelectionScreen(
          brandId: brandId,
          brandName: brandName,
          brandLogoPath: brandLogoPath,
        );
      },
    ),
    GoRoute(
      path: '/food-menu',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final locationId = state.uri.queryParameters['locationId'] ?? extra?['locationId'] as String? ?? '';
        final brandId = state.uri.queryParameters['brandId'] ?? extra?['brandId'] as String?;
        final brandLogoPath = state.uri.queryParameters['brandLogoPath'] ?? extra?['brandLogoPath'] as String?;
        final selectedLocation = extra?['selectedLocation'] as LocationEntity?;
        
        return FoodMenuScreen(
          locationId: locationId,
          brandId: brandId,
          selectedLocation: selectedLocation,
          brandLogoPath: brandLogoPath,
        );
      },
    ),
    GoRoute(
      path: '/food-detail',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final foodItem = extra?['foodItem'] as FoodItemEntity?;
        final brandLogoPath = extra?['brandLogoPath'] as String?;
        
        if (foodItem == null) {
          // Handle missing food item by navigating back
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pop();
          });
          return const SizedBox.shrink();
        }
        
        return FoodDetailScreen(
          foodItem: foodItem,
          brandLogoPath: brandLogoPath,
        );
      },
    ),
    GoRoute(
      path: '/redeemed-qr',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return RedeemedQrScreen(
          rewardTitle: extra?['rewardTitle'] as String?,
          rewardId: extra?['rewardId'] as String?,
          qrData: extra?['qrData'] as String?,
          brandLogoPath: extra?['brandLogoPath'] as String?,
        );
      },
    ),
    // Checkout routes
    GoRoute(
      path: '/checkout/pickup-details',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final subtotal = (extra?['subtotal'] as num?)?.toDouble() ?? 0.0;
        final tax = (extra?['tax'] as num?)?.toDouble() ?? 0.0;
        final total = (extra?['total'] as num?)?.toDouble() ?? 0.0;
        final brandId = extra?['brandId'] as String?;
        final locationId = extra?['locationId'] as String?;
        
        // Extract location data from food ordering flow
        final foodLocation = extra?['foodLocation'] as PickupLocationEntity?;
        final orderingLocation = extra?['orderingLocation'] as LocationEntity?;
        
        return PickupDetailsScreen(
          subtotal: subtotal,
          tax: tax,
          total: total,
          brandId: brandId,
          locationId: locationId,
          foodLocation: foodLocation,
          orderingLocation: orderingLocation,
        );
      },
    ),
    // Add other routes here
  ],
);
