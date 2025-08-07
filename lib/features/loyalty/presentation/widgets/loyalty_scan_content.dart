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
              // Show redeemed rewards from the member's rewards list
              if (member != null && member.rewards.isNotEmpty)
                ...member.rewards.where((reward) => reward.isRedeemed).map(
                  (reward) => RewardItem(
                    title: reward.title,
                    expiryDate: reward.expiryDate,
                    foodImagePath: reward.foodImageUrl,
                    brandLogoPath: reward.brandLogoUrl,
                  ),
                )
              else
                // Show message when no redeemed rewards are available
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: const Center(
                    child: Text(
                      'No redeemed rewards yet.\nRedeem rewards from the Redeem tab to see them here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        height: 20 / 14,
                        color: Color(0x66FEFEFF), // rgba(254,254,255,0.4)
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}