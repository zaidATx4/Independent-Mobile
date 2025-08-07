import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../widgets/loyalty_stats_card.dart';
import '../widgets/qr_code_section.dart';
import '../widgets/reward_item.dart';
import '../widgets/cart_badge_widget.dart';

class ScanScreen extends ConsumerWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Scan & Earn',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      height: 32 / 24,
                      color: Color(0xccfefeff), // rgba(254,254,255,0.8)
                    ),
                  ),
                  Row(
                    children: [
                      // Shopping cart button with badge
                      const CartBadgeWidget(),
                      const SizedBox(width: 4),
                      // Search button
                      GestureDetector(
                        onTap: () => context.push('/food-search'),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFBF1),
                            borderRadius: BorderRadius.circular(44),
                          ),
                          child: SvgPicture.asset(
                            'assets/images/icons/SVGs/Loyalty/Search_icon.svg',
                            width: 16,
                            height: 16,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFF242424),
                              BlendMode.srcIn,  
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    // Loyalty stats card
                    const LoyaltyStatsCard(
                      points: 2500,
                      membershipTier: 'Gold Member',
                      pointsNeeded: 5000,
                      nextTier: 'Platinum',
                    ),
                    const SizedBox(height: 24),
                    // QR Code section
                    const QrCodeSection(),
                    const SizedBox(height: 24), // Reduced gap to bring Redeemed Rewards up
                    // Redeemed Rewards section
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          // Section header
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            width: double.infinity,
                            child: const Text(
                              'Redeemed Rewards',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                height: 27 / 18,
                                color: Color(0xccfefeff), // rgba(254,254,255,0.8)
                              ),
                            ),
                          ),
                          // Reward items
                          const RewardItem(
                            title: 'Cheeseburger',
                            expiryDate: 'Expires on April 6, 2025',
                            foodImagePath: 'assets/images/Static/burger.png',
                            brandLogoPath: 'assets/images/logos/brands/Salt.png',
                            rewardId: 'cheeseburger_001',
                            isRedeemed: true,
                          ),
                          const RewardItem(
                            title: 'Chicken taco',
                            expiryDate: 'Expires on April 6, 2025',
                            foodImagePath: 'assets/images/Static/Chicken_taco.png',
                            brandLogoPath: 'assets/images/logos/brands/Somewhere.png',
                            rewardId: 'chicken_taco_001',
                            isRedeemed: true,
                          ),
                          const RewardItem(
                            title: 'Orange Juice',
                            expiryDate: 'Expires on April 6, 2025',
                            foodImagePath: 'assets/images/Static/greek_salad.png', // Placeholder until we have juice image
                            brandLogoPath: 'assets/images/logos/brands/Joe_and _juice.png',
                            rewardId: 'orange_juice_001',
                            isRedeemed: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 100), // Space for bottom navigation
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}