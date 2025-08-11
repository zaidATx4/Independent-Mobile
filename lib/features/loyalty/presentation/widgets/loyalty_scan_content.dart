import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'qr_code_section.dart';
import 'reward_item.dart';
import '../providers/loyalty_hub_provider.dart';

class LoyaltyScanContent extends ConsumerWidget {
  const LoyaltyScanContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loyaltyState = ref.watch(loyaltyHubProvider);
    final member = loyaltyState.member;
    
    return Column(
      children: [
        // QR Code section
        const QrCodeSection(),
        const SizedBox(height: 24), // Reduced gap to bring Redeemed Rewards up
        // Available Rewards section - for scanning to redeem
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
                    color: Color(0xCCFEFEFF), // rgba(254,254,255,0.8)
                  ),
                ),
              ),
              // Show redeemed rewards with same flow as scan and earn screen
              if (member != null && member.rewards.isNotEmpty)
                ...member.rewards.where((reward) => reward.isRedeemed).map(
                  (reward) => RewardItem(
                    title: reward.title,
                    expiryDate: reward.expiryDate,
                    foodImagePath: reward.foodImageUrl,
                    brandLogoPath: reward.brandLogoUrl,
                    rewardId: reward.title.toLowerCase().replaceAll(' ', '_'),
                    isRedeemed: true, // Mark as redeemed to enable QR navigation
                  ),
                )
              else
                // Show static redeemed rewards like scan and earn screen
                ...[
                  const RewardItem(
                    title: 'Cheeseburger',
                    expiryDate: 'Expires on April 6, 2025',
                    foodImagePath: 'assets/images/Static/burger.png',
                    brandLogoPath: 'assets/images/logos/brands/Salt.png',
                    rewardId: 'cheeseburger_001',
                    isRedeemed: true, // Enable QR navigation flow
                  ),
                  const RewardItem(
                    title: 'Chicken taco',
                    expiryDate: 'Expires on April 6, 2025',
                    foodImagePath: 'assets/images/Static/Chicken_taco.png',
                    brandLogoPath: 'assets/images/logos/brands/Somewhere.png',
                    rewardId: 'chicken_taco_001',
                    isRedeemed: true, // Enable QR navigation flow
                  ),
                  const RewardItem(
                    title: 'Orange Juice',
                    expiryDate: 'Expires on April 6, 2025',
                    foodImagePath: 'assets/images/Static/greek_salad.png', // Placeholder until we have juice image
                    brandLogoPath: 'assets/images/logos/brands/Joe_and _juice.png',
                    rewardId: 'orange_juice_001',
                    isRedeemed: true, // Enable QR navigation flow
                  ),
                ],
            ],
          ),
        ),
      ],
    );
  }
}