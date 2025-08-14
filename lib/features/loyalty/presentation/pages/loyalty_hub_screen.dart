import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/loyalty_hub_progress_card.dart';
import '../widgets/loyalty_tab_control.dart';
import '../widgets/loyalty_rewards_section.dart';
import '../widgets/loyalty_history_content.dart';
import '../widgets/loyalty_scan_content.dart';
import '../providers/loyalty_hub_provider.dart';
import '../../../../core/theme/theme_service.dart';

class LoyaltyHubScreen extends ConsumerWidget {
  const LoyaltyHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loyaltyState = ref.watch(loyaltyHubProvider);
    final member = loyaltyState.member;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface, // Theme-aware background
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
                      color: context.getThemedColor(
                        lightColor: Colors.transparent, // No background for light theme
                        darkColor: const Color(0x40FFFFFF), // Light glass for dark theme
                      ),
                      borderRadius: BorderRadius.circular(44),
                      border: Border.all(
                        color: context.getThemedColor(
                          lightColor: const Color(0xFF242424), // Dark border for light theme
                          darkColor: Colors.transparent, // No border for dark theme
                        ),
                        width: 1,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(44),
                        onTap: () => context.pop(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            size: 16,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Title
                  Expanded(
                    child: Text(
                      'Loyalty hub',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700, // Bold
                        fontSize: 24,
                        height: 32 / 24, // lineHeight / fontSize
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                  // Close button
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: context.getThemedColor(
                        lightColor: const Color(0xFF242424), // Dark black for light theme
                        darkColor: const Color(0xFF2A2A2A), // Dark container for dark theme
                      ),
                      borderRadius: BorderRadius.circular(44),
                    ),
                    child: GestureDetector(
                      onTap: () => context.pop(),
                      child: Icon(
                        Icons.close,
                        size: 16,
                        color: context.getThemedColor(
                          lightColor: const Color(0xFFFEFEFF), // White icon for dark background in light theme
                          darkColor: const Color(0xFFFEFEFF), // Light for dark theme
                        ),
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
                                  Center(
                                    child: CircularProgressIndicator(
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  )
                                else
                                  Center(
                                    child: Text(
                                      'Failed to load loyalty data',
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
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
                                : Center(
                                    child: Text(
                                      'Tab content coming soon',
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
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