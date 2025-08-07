import 'package:go_router/go_router.dart';
import 'package:independent/features/settings/presentation/settings_screen.dart';
import 'package:independent/features/home/presentation/main_navigation_screen.dart';
import 'package:independent/features/loyalty/presentation/pages/loyalty_hub_screen.dart';
import 'package:independent/features/loyalty/presentation/pages/cart_screen.dart';
import 'package:independent/features/loyalty/presentation/pages/food_search_screen.dart';
import 'package:independent/features/loyalty/presentation/pages/redeemed_qr_screen.dart';

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
    // Add other routes here
  ],
);
