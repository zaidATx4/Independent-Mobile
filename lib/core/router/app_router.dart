import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/auth_provider.dart';
import 'package:independent/features/settings/presentation/settings_screen.dart';
import 'package:independent/features/settings/presentation/screens/theme_screen.dart';
import 'package:independent/features/settings/presentation/screens/profile_edit_screen.dart';
import 'package:independent/features/settings/presentation/screens/payment_methods_screen.dart';
import 'package:independent/features/settings/presentation/screens/add_new_card_screen.dart'
    as settings;
import 'package:independent/features/settings/presentation/screens/card_details_screen.dart';
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
import 'package:independent/features/shared/checkout/presentation/pages/payment_method_screen.dart';
import 'package:independent/features/shared/checkout/presentation/pages/wallet_selection_screen.dart';
import 'package:independent/features/shared/checkout/presentation/pages/add_new_card_screen.dart'
    as checkout;
import 'package:independent/features/shared/checkout/presentation/pages/review_order_screen.dart';
import 'package:independent/features/shared/checkout/presentation/pages/payment_success_screen.dart';
import 'package:independent/features/shared/checkout/domain/entities/checkout_entities.dart';
import 'package:independent/features/language/presentation/language_selection_screen.dart';
import 'package:independent/features/language/presentation/initial_language_selection_screen.dart';
import 'package:independent/features/country/presentation/country_selection_screen.dart';
import 'package:independent/features/settings/presentation/screens/country_selection_screen.dart'
    as settings_country;
import 'package:independent/features/auth/presentation/welcome_screen.dart';
import 'package:independent/features/auth/presentation/sign_up_screen.dart';
import 'package:independent/features/auth/presentation/otp_verification_screen.dart';
// Wallet imports
import 'package:independent/features/wallet/presentation/pages/my_wallets_list_screen.dart';
import 'package:independent/features/wallet/presentation/pages/my_wallet_screen.dart';
import 'package:independent/features/wallet/presentation/pages/wallet_transactions_screen.dart';
import 'package:independent/features/wallet/presentation/pages/transaction_detail_screen.dart';
import 'package:independent/features/wallet/presentation/pages/add_money_screen.dart';
import 'package:independent/features/wallet/presentation/pages/add_money_confirmation_screen.dart';
import 'package:independent/features/wallet/presentation/pages/manage_wallet_screen.dart';
import 'package:independent/features/wallet/presentation/pages/add_wallet_screen.dart';
import 'package:independent/features/wallet/presentation/pages/wallet_payment_options_screen.dart';
import 'package:independent/features/settings/presentation/screens/order_history_screen.dart';
import 'package:independent/features/settings/presentation/screens/top_choices_screen.dart';
import 'package:independent/features/settings/presentation/screens/terms_and_conditions_screen.dart';
import 'package:independent/features/events/presentation/pages/events_screen.dart';
import 'package:independent/features/events/presentation/pages/single_event_screen.dart';
import 'package:independent/features/events/domain/entities/event_entity.dart';

// TESTING FLAG: Set to true to skip authorization flow during development
const bool BYPASS_AUTH_FOR_TESTING = true;

// Router provider with authentication logic
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: _getInitialLocation(authState),
    redirect: (context, state) => _handleRedirect(state, authState),
    routes: [
      // Language Selection (First screen)
      GoRoute(
        path: '/language-selection',
        builder: (context, state) => const InitialLanguageSelectionScreen(),
      ),
      GoRoute(
        path: '/language',
        builder: (context, state) => const LanguageSelectionScreen(),
      ),
      // Country Selection
      GoRoute(
        path: '/country-selection',
        builder: (context, state) => const CountrySelectionScreen(),
      ),
      GoRoute(
        path: '/country',
        builder: (context, state) =>
            const settings_country.CountrySelectionScreen(),
      ),
      // Authentication Routes
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/sign-up',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/otp-verification',
        builder: (context, state) {
          return const OtpVerificationScreen();
        },
      ),
      // Main App Routes (after authentication)
      GoRoute(
        path: '/',
        builder: (context, state) => const MainNavigationScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const MainNavigationScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/settings/theme',
        builder: (context, state) => const ThemeScreen(),
      ),
      GoRoute(
        path: '/settings/profile-edit',
        builder: (context, state) => const ProfileEditScreen(),
      ),
      GoRoute(
        path: '/payment-methods',
        builder: (context, state) => const PaymentMethodsScreen(),
      ),
      GoRoute(
        path: '/settings/add-new-card',
        builder: (context, state) => const settings.AddNewCardScreen(),
      ),
      GoRoute(
        path: '/settings/card-details/:cardId',
        builder: (context, state) {
          final cardId = state.pathParameters['cardId'] ?? 'unknown';
          return CardDetailsScreen(cardId: cardId);
        },
      ),
      GoRoute(
        path: '/loyalty-hub',
        builder: (context, state) => const LoyaltyHubScreen(),
      ),
      GoRoute(path: '/cart', builder: (context, state) => const CartScreen()),
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
          final brandId =
              state.uri.queryParameters['brandId'] ??
              extra?['brandId'] as String? ??
              '';
          final brandName =
              state.uri.queryParameters['brandName'] ??
              extra?['brandName'] as String?;
          final brandLogoPath =
              state.uri.queryParameters['brandLogoPath'] ??
              extra?['brandLogoPath'] as String?;

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
          final locationId =
              state.uri.queryParameters['locationId'] ??
              extra?['locationId'] as String? ??
              '';
          final brandId =
              state.uri.queryParameters['brandId'] ??
              extra?['brandId'] as String?;
          final brandLogoPath =
              state.uri.queryParameters['brandLogoPath'] ??
              extra?['brandLogoPath'] as String?;
          final selectedLocation =
              extra?['selectedLocation'] as LocationEntity?;

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
          final brandLogoUrl = extra?['brandLogoUrl'] as String?;

          // Extract location data from food ordering flow
          final foodLocation = extra?['foodLocation'] as PickupLocationEntity?;
          final orderingLocation =
              extra?['orderingLocation'] as LocationEntity?;

          // If we have ordering location but no foodLocation, convert it with proper brand logo
          PickupLocationEntity? finalFoodLocation = foodLocation;
          if (finalFoodLocation == null && orderingLocation != null) {
            finalFoodLocation = PickupDetailsScreen.convertLocationToPickupLocation(
              orderingLocation,
              brandLogoPath:
                  brandLogoUrl ??
                  'assets/images/logos/brands/Salt.png', // Use actual brand logo or fallback to Salt
            );
          }

          return PickupDetailsScreen(
            subtotal: subtotal,
            tax: tax,
            total: total,
            brandId: brandId,
            locationId: locationId,
            foodLocation: finalFoodLocation,
            orderingLocation: orderingLocation,
            brandLogoUrl: brandLogoUrl,
          );
        },
      ),
      // Payment method selection route
      GoRoute(
        path: '/checkout/payment-method',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final total = (extra?['total'] as num?)?.toDouble() ?? 0.0;
          final currency = extra?['currency'] as String? ?? 'SAR';

          return PaymentMethodScreen(total: total, currency: currency);
        },
      ),
      // Wallet selection route
      GoRoute(
        path: '/checkout/wallet-selection',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final total = (extra?['total'] as num?)?.toDouble() ?? 0.0;
          final currency = extra?['currency'] as String? ?? 'SAR';

          return WalletSelectionScreen(total: total, currency: currency);
        },
      ),
      // Add new card route
      GoRoute(
        path: '/checkout/add-new-card',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final total = (extra?['total'] as num?)?.toDouble() ?? 0.0;
          final currency = extra?['currency'] as String? ?? 'SAR';

          return checkout.AddNewCardScreen(total: total, currency: currency);
        },
      ),
      // Wallet Routes
      GoRoute(
        path: '/wallet',
        builder: (context, state) => const MyWalletsListScreen(),
      ),
      GoRoute(
        path: '/wallet/details/:walletId',
        builder: (context, state) {
          final walletId = state.pathParameters['walletId'] ?? 'unknown';
          return MyWalletScreen(walletId: walletId);
        },
      ),
      GoRoute(
        path: '/wallet/transactions',
        builder: (context, state) => const WalletTransactionsScreen(),
      ),
      GoRoute(
        path: '/wallet/transaction-details',
        builder: (context, state) {
          final transactionId = state.extra as String? ?? 'unknown';
          return TransactionDetailScreen(transactionId: transactionId);
        },
      ),
      GoRoute(
        path: '/wallet/add-money',
        builder: (context, state) => const AddMoneyScreen(),
      ),
      GoRoute(
        path: '/wallet/add-money/confirm',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final amount = extra?['amount'] as String? ?? '0';
          final paymentMethod = extra?['paymentMethod'] as String? ?? 'visa';

          return AddMoneyConfirmationScreen(
            amount: amount,
            paymentMethod: paymentMethod,
          );
        },
      ),
      GoRoute(
        path: '/wallet/manage',
        builder: (context, state) => const ManageWalletScreen(),
      ),
      GoRoute(
        path: '/wallet/add',
        builder: (context, state) => const AddWalletScreen(),
      ),
      GoRoute(
        path: '/wallets/add',
        builder: (context, state) => const AddWalletScreen(),
      ),
      GoRoute(
        path: '/wallet/payment-options',
        builder: (context, state) => const WalletPaymentOptionsScreen(),
      ),
      GoRoute(
        path: '/order-history',
        builder: (context, state) => const OrderHistoryScreen(),
      ),
      GoRoute(
        path: '/favorites',
        builder: (context, state) => const TopChoicesScreen(),
      ),
      GoRoute(
        path: '/terms',
        builder: (context, state) => const TermsAndConditionsScreen(),
      ),
      GoRoute(
        path: '/events',
        builder: (context, state) => const EventsScreen(),
      ),
      GoRoute(
        path: '/events/:eventId',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final event = extra?['event'] as EventEntity?;
          
          if (event == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pop();
            });
            return const SizedBox.shrink();
          }
          
          return SingleEventScreen(event: event);
        },
      ),
    ],
  );
});

// Helper functions for authentication logic
String _getInitialLocation(AuthState authState) {
  // TESTING: Skip auth flow when bypass flag is enabled
  if (BYPASS_AUTH_FOR_TESTING) {
    return '/home';
  }

  if (!authState.hasCompletedOnboarding) {
    return '/language-selection';
  }
  if (!authState.isAuthenticated) {
    return '/welcome';
  }
  return '/home';
}

String? _handleRedirect(GoRouterState state, AuthState authState) {
  final currentLocation = state.matchedLocation;

  // TESTING: Skip all auth redirects when bypass flag is enabled
  if (BYPASS_AUTH_FOR_TESTING) {
    return null; // Allow access to all routes
  }

  // Onboarding flow routes - accessible without authentication
  const onboardingRoutes = [
    '/language-selection',
    '/country-selection',
    '/welcome',
    '/sign-up',
    '/otp-verification',
  ];

  // Settings routes - accessible when authenticated
  const settingsRoutes = [
    '/country', // Settings country selection
    '/language', // Settings language selection
  ];

  // If user hasn't completed onboarding and trying to access protected routes
  if (!authState.hasCompletedOnboarding &&
      !onboardingRoutes.contains(currentLocation) &&
      !settingsRoutes.contains(currentLocation)) {
    return '/language-selection';
  }

  // If user completed onboarding but not authenticated and trying to access protected routes
  if (authState.hasCompletedOnboarding && !authState.isAuthenticated) {
    if (!onboardingRoutes.contains(currentLocation) &&
        !settingsRoutes.contains(currentLocation)) {
      return '/welcome';
    }
  }

  // Settings routes require authentication
  if (settingsRoutes.contains(currentLocation) && !authState.isAuthenticated) {
    return '/welcome';
  }

  // If authenticated and trying to access onboarding routes, redirect to home
  if (authState.isAuthenticated && onboardingRoutes.contains(currentLocation)) {
    return '/home';
  }

  return null; // No redirect needed
}

// Backward compatibility - keep the old appRouter for now
final GoRouter appRouter = GoRouter(
  initialLocation: BYPASS_AUTH_FOR_TESTING ? '/home' : '/language-selection',
  routes: [
    // Language Selection (First screen)
    GoRoute(
      path: '/language-selection',
      builder: (context, state) => const InitialLanguageSelectionScreen(),
    ),
    GoRoute(
      path: '/language',
      builder: (context, state) => const LanguageSelectionScreen(),
    ),
    // Country Selection
    GoRoute(
      path: '/country-selection',
      builder: (context, state) => const CountrySelectionScreen(),
    ),
    GoRoute(
      path: '/country',
      builder: (context, state) =>
          const settings_country.CountrySelectionScreen(),
    ),
    // Authentication Routes
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/sign-up',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/otp-verification',
      builder: (context, state) {
        return const OtpVerificationScreen();
      },
    ),
    // Main App Routes (after authentication)
    GoRoute(
      path: '/',
      builder: (context, state) => const MainNavigationScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const MainNavigationScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/settings/theme',
      builder: (context, state) => const ThemeScreen(),
    ),
    GoRoute(
      path: '/settings/profile-edit',
      builder: (context, state) => const ProfileEditScreen(),
    ),
    GoRoute(
      path: '/payment-methods',
      builder: (context, state) => const PaymentMethodsScreen(),
    ),
    GoRoute(
      path: '/settings/add-new-card',
      builder: (context, state) => const settings.AddNewCardScreen(),
    ),
    GoRoute(
      path: '/settings/card-details/:cardId',
      builder: (context, state) {
        final cardId = state.pathParameters['cardId'] ?? 'unknown';
        return CardDetailsScreen(cardId: cardId);
      },
    ),
    GoRoute(
      path: '/loyalty-hub',
      builder: (context, state) => const LoyaltyHubScreen(),
    ),
    GoRoute(path: '/cart', builder: (context, state) => const CartScreen()),
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
        final brandId =
            state.uri.queryParameters['brandId'] ??
            extra?['brandId'] as String? ??
            '';
        final brandName =
            state.uri.queryParameters['brandName'] ??
            extra?['brandName'] as String?;
        final brandLogoPath =
            state.uri.queryParameters['brandLogoPath'] ??
            extra?['brandLogoPath'] as String?;

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
        final locationId =
            state.uri.queryParameters['locationId'] ??
            extra?['locationId'] as String? ??
            '';
        final brandId =
            state.uri.queryParameters['brandId'] ??
            extra?['brandId'] as String?;
        final brandLogoPath =
            state.uri.queryParameters['brandLogoPath'] ??
            extra?['brandLogoPath'] as String?;
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
        final brandLogoUrl = extra?['brandLogoUrl'] as String?;

        // Extract location data from food ordering flow
        final foodLocation = extra?['foodLocation'] as PickupLocationEntity?;
        final orderingLocation = extra?['orderingLocation'] as LocationEntity?;

        // If we have ordering location but no foodLocation, convert it with proper brand logo
        PickupLocationEntity? finalFoodLocation = foodLocation;
        if (finalFoodLocation == null && orderingLocation != null) {
          finalFoodLocation = PickupDetailsScreen.convertLocationToPickupLocation(
            orderingLocation,
            brandLogoPath:
                brandLogoUrl ??
                'assets/images/logos/brands/Salt.png', // Use actual brand logo or fallback to Salt
          );
        }

        return PickupDetailsScreen(
          subtotal: subtotal,
          tax: tax,
          total: total,
          brandId: brandId,
          locationId: locationId,
          foodLocation: finalFoodLocation,
          orderingLocation: orderingLocation,
          brandLogoUrl: brandLogoUrl,
        );
      },
    ),
    // Payment method selection route
    GoRoute(
      path: '/checkout/payment-method',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final total = (extra?['total'] as num?)?.toDouble() ?? 0.0;
        final currency = extra?['currency'] as String? ?? 'SAR';

        return PaymentMethodScreen(total: total, currency: currency);
      },
    ),
    // Payment method selection
    GoRoute(
      path: '/checkout/payment-method',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final total = (extra?['total'] as num?)?.toDouble() ?? 0.0;
        final currency = extra?['currency'] as String? ?? 'SAR';

        return PaymentMethodScreen(total: total, currency: currency);
      },
    ),
    // Wallet selection route
    GoRoute(
      path: '/checkout/wallet-selection',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final total = (extra?['total'] as num?)?.toDouble() ?? 0.0;
        final currency = extra?['currency'] as String? ?? 'SAR';

        return WalletSelectionScreen(total: total, currency: currency);
      },
    ),
    // Add new card route
    GoRoute(
      path: '/checkout/add-new-card',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final total = (extra?['total'] as num?)?.toDouble() ?? 0.0;
        final currency = extra?['currency'] as String? ?? 'SAR';

        return checkout.AddNewCardScreen(total: total, currency: currency);
      },
    ),
    // Review order route (final checkout step)
    GoRoute(
      path: '/checkout/review-order',
      builder: (context, state) => const ReviewOrderScreen(),
    ),
    // Payment success route
    GoRoute(
      path: '/checkout/success',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return PaymentSuccessScreen(
          orderNumber: extra?['orderNumber'] as String?,
          locationName: extra?['locationName'] as String?,
          locationAddress: extra?['locationAddress'] as String?,
          estimatedTime: extra?['estimatedTime'] as String?,
        );
      },
    ),
    // Wallet Routes
    GoRoute(
      path: '/wallet',
      builder: (context, state) => const MyWalletsListScreen(),
    ),
    GoRoute(
      path: '/wallet/details/:walletId',
      builder: (context, state) {
        final walletId = state.pathParameters['walletId'] ?? 'unknown';
        return MyWalletScreen(walletId: walletId);
      },
    ),
    GoRoute(
      path: '/wallet/transactions',
      builder: (context, state) => const WalletTransactionsScreen(),
    ),
    GoRoute(
      path: '/wallet/transaction-details',
      builder: (context, state) {
        final transactionId = state.extra as String? ?? 'unknown';
        return TransactionDetailScreen(transactionId: transactionId);
      },
    ),
    GoRoute(
      path: '/wallet/add-money',
      builder: (context, state) => const AddMoneyScreen(),
    ),
    GoRoute(
      path: '/wallet/add-money/confirm',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final amount = extra?['amount'] as String? ?? '0';
        final paymentMethod = extra?['paymentMethod'] as String? ?? 'visa';

        return AddMoneyConfirmationScreen(
          amount: amount,
          paymentMethod: paymentMethod,
        );
      },
    ),
    GoRoute(
      path: '/wallet/manage',
      builder: (context, state) => const ManageWalletScreen(),
    ),
    GoRoute(
      path: '/wallet/add',
      builder: (context, state) => const AddWalletScreen(),
    ),
    GoRoute(
      path: '/wallets/add',
      builder: (context, state) => const AddWalletScreen(),
    ),
    GoRoute(
      path: '/wallet/payment-options',
      builder: (context, state) => const WalletPaymentOptionsScreen(),
    ),
    GoRoute(
      path: '/order-history',
      builder: (context, state) => const OrderHistoryScreen(),
    ),
    GoRoute(
      path: '/favorites',
      builder: (context, state) => const TopChoicesScreen(),
    ),
    GoRoute(
      path: '/terms',
      builder: (context, state) => const TermsAndConditionsScreen(),
    ),
    GoRoute(
      path: '/events',
      builder: (context, state) => const EventsScreen(),
    ),
    GoRoute(
      path: '/events/:eventId',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final event = extra?['event'] as EventEntity?;
        
        if (event == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pop();
          });
          return const SizedBox.shrink();
        }
        
        return SingleEventScreen(event: event);
      },
    ),
    // Add other routes here
  ],
);
