import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/loyalty_hub_progress_card.dart';
import '../widgets/loyalty_tab_control.dart';
import '../widgets/loyalty_rewards_section.dart';
import '../widgets/loyalty_history_content.dart';
import '../widgets/loyalty_scan_content.dart';
import '../providers/loyalty_hub_provider.dart';

class LoyaltyHubScreen extends ConsumerWidget {
  const LoyaltyHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loyaltyState = ref.watch(loyaltyHubProvider);
    final member = loyaltyState.member;
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A), // indpt/neutral
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button, title, and close button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  // Back button with blur effect
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0x40FFFFFF), // rgba(255,255,255,0.25) - indpt/glass-fill
                      borderRadius: BorderRadius.circular(44),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(44),
                        onTap: () => context.pop(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            size: 16,
                            color: Color(0xFFFEFEFF), // indpt/text primary
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Title
                  const Expanded(
                    child: Text(
                      'Loyalty hub',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700, // Bold
                        fontSize: 24,
                        height: 32 / 24, // lineHeight / fontSize
                        color: Color(0xCCFEFEFF), // #FEFEFFCC 80% opacity
                      ),
                    ),
                  ),
                  // Search button
                  Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.only(right: 8),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(44),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(44),
                        onTap: () {
                          print('Search icon tapped!'); // Debug log
                          context.push('/food-search');
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(44),
                          ),
                          child: const Icon(
                            Icons.search,
                            size: 24,
                            color: Color(0xFFFEFEFF), // indpt/text primary
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Close button
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBF1), // indpt/sand
                      borderRadius: BorderRadius.circular(44),
                    ),
                    child: GestureDetector(
                      onTap: () => context.pop(),
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Color(0xFF242424), // indpt/accent
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content area
            Expanded(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  // Tab control
                  LoyaltyTabControl(
                    selectedTab: loyaltyState.selectedTab,
                    onTabSelected: (tab) => ref.read(loyaltyHubProvider.notifier).selectTab(tab),
                  ),
                  const SizedBox(height: 24),
                  // Tab-specific content
                  Expanded(
                    child: loyaltyState.selectedTab == 'Discover'
                        ? SingleChildScrollView(
                            child: Column(
                              children: [
                                // Progress card - only show in Discover tab
                                if (member != null)
                                  LoyaltyHubProgressCard(
                                    points: member.points,
                                    membershipTier: member.tier,
                                    pointsNeeded: member.pointsToNextTier,
                                    nextTier: member.nextTier,
                                  )
                                else if (loyaltyState.isLoading)
                                  const Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFFFFFBF1),
                                    ),
                                  )
                                else
                                  const Center(
                                    child: Text(
                                      'Failed to load loyalty data',
                                      style: TextStyle(
                                        color: Color(0xCCFEFEFF),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 16),
                                // Rewards section
                                const LoyaltyRewardsSection(),
                                const SizedBox(height: 100), // Space for bottom navigation
                              ],
                            ),
                          )
                        : loyaltyState.selectedTab == 'History'
                            ? const LoyaltyHistoryContent()
                            : loyaltyState.selectedTab == 'Scan'
                                ? const SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        LoyaltyScanContent(),
                                        SizedBox(height: 100), // Space for bottom navigation
                                      ],
                                    ),
                                  )
                                : const Center(
                                    child: Text(
                                      'Tab content coming soon',
                                      style: TextStyle(
                                        color: Color(0xFF9C9C9D),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}