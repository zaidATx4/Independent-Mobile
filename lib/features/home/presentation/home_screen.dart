import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/theme_extensions.dart';

// Providers
final selectedTabProvider = StateProvider<int>((ref) => 0);
final userNameProvider = StateProvider<String>((ref) => 'John Doe');
final userLoyaltyPointsProvider = StateProvider<int>((ref) => 2500);
final userMembershipProvider = StateProvider<String>((ref) => 'Gold Member');
final loyaltyProgressProvider = StateProvider<double>(
  (ref) => 0.5,
); // 2500/5000

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName = ref.watch(userNameProvider);
    final loyaltyPoints = ref.watch(userLoyaltyPointsProvider);
    final membershipStatus = ref.watch(userMembershipProvider);
    final loyaltyProgress = ref.watch(loyaltyProgressProvider);

    final screenHeight = MediaQuery.of(context).size.height;
    final safeAreaTop = MediaQuery.of(context).padding.top;
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;

    // Get screen width for responsive design
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive bottom navigation height
    final bottomNavHeight = (screenHeight * 0.1).clamp(70.0, 100.0);

    // Calculate available height for content
    final availableHeight =
        screenHeight - safeAreaTop - safeAreaBottom - bottomNavHeight;

    // Responsive spacing based on screen height
    final headerSpacing = (availableHeight * 0.02).clamp(16.0, 28.0);
    final cardSpacing = (availableHeight * 0.015).clamp(12.0, 24.0);

    // Responsive padding and sizes
    final horizontalPadding = (screenWidth * 0.04).clamp(12.0, 20.0);
    final headerFontSize = (screenWidth * 0.06).clamp(20.0, 28.0);
    // final iconSize = (screenWidth * 0.06).clamp(20.0, 28.0); // Unused

    // Get theme colors
    final theme = Theme.of(context);
    final customColors = context.customColors;
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          // Background - SAME for both light and dark theme (Figma specification)
          Image.asset(
            'assets/images/backgrounds/Select_Language.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            color: isDarkMode 
                ? Colors.black.withValues(alpha: 0.7)  // Dark theme overlay
                : Colors.black.withValues(alpha: 0.7), // Light theme - SAME overlay
          ),
          // Main Content
          SafeArea(
            child: Column(
              children: [
                // Header with Welcome and Settings - Aligned with profile card
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    horizontalPadding,
                    horizontalPadding,
                    0.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'Welcome to Independent',
                          style: AppTypography.headlineMedium.copyWith(
                            color: const Color(0xFFFEFEFF), // #fefeff for both themes
                            fontSize: headerFontSize,
                            fontFamily: 'Roboto',
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.push('/settings'),
                        child: Container(
                          padding: const EdgeInsets.all(6), // Figma: 6px padding
                          decoration: BoxDecoration(
                            color: Colors.transparent, // Transparent background for both themes
                            border: Border.all(
                              color: const Color(0xFFFEFEFF), // #fefeff border for both themes
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(23), // Figma: 23px radius
                          ),
                          child: SizedBox(
                            width: 24, // Figma: 24px icon size
                            height: 24,
                            child: Stack(
                              children: [
                                // Base settings icon
                                Positioned(
                                  top: 2.56,
                                  left: 1.99,
                                  right: 2,
                                  bottom: 2.56,
                                  child: Icon(
                                    Icons.settings,
                                    color: const Color(0xFFFEFEFF), // #fefeff for both themes
                                    size: 19, // Adjusted size for proper fit
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: headerSpacing),

                // User Profile Card
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: _buildUserProfileCard(
                    userName: userName,
                    loyaltyPoints: loyaltyPoints,
                    membershipStatus: membershipStatus,
                    loyaltyProgress: loyaltyProgress,
                    availableHeight: availableHeight,
                    theme: theme,
                    customColors: customColors,
                    isDarkMode: isDarkMode,
                  ),
                ),

                SizedBox(height: cardSpacing),

                // Features Grid - Responsive height
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    child: _buildFeaturesGrid(
                      context,
                      availableHeight,
                      screenWidth,
                      theme,
                      customColors,
                      isDarkMode,
                    ),
                  ),
                ),

                SizedBox(height: cardSpacing),

                // Bottom Navigation Bar - Part of main column
                _buildBottomNavigationBar(ref, context, theme, isDarkMode),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfileCard({
    required String userName,
    required int loyaltyPoints,
    required String membershipStatus,
    required double loyaltyProgress,
    required double availableHeight,
    required ThemeData theme,
    required CustomColors customColors,
    required bool isDarkMode,
  }) {
    // Responsive padding and sizes
    final cardPadding = (availableHeight * 0.025).clamp(16.0, 20.0);
    final profileImageSize = (availableHeight * 0.06).clamp(44.0, 52.0);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withValues(alpha: 0.2)
              : theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
        // Light theme gets a subtle shadow, dark theme uses glass morphism
        boxShadow: isDarkMode
            ? null
            : [
                BoxShadow(
                  color: theme.colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: isDarkMode
            ? BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 14.7, sigmaY: 14.7),
                child: Container(
                  padding: EdgeInsets.all(cardPadding),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: _buildProfileCardContent(
                    userName: userName,
                    loyaltyPoints: loyaltyPoints,
                    membershipStatus: membershipStatus,
                    loyaltyProgress: loyaltyProgress,
                    availableHeight: availableHeight,
                    cardPadding: cardPadding,
                    profileImageSize: profileImageSize,
                    theme: theme,
                    customColors: customColors,
                    isDarkMode: isDarkMode,
                  ),
                ),
              )
            : Container(
                padding: EdgeInsets.all(cardPadding),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _buildProfileCardContent(
                  userName: userName,
                  loyaltyPoints: loyaltyPoints,
                  membershipStatus: membershipStatus,
                  loyaltyProgress: loyaltyProgress,
                  availableHeight: availableHeight,
                  cardPadding: cardPadding,
                  profileImageSize: profileImageSize,
                  theme: theme,
                  customColors: customColors,
                  isDarkMode: isDarkMode,
                ),
              ),
      ),
    );
  }

  Widget _buildProfileCardContent({
    required String userName,
    required int loyaltyPoints,
    required String membershipStatus,
    required double loyaltyProgress,
    required double availableHeight,
    required double cardPadding,
    required double profileImageSize,
    required ThemeData theme,
    required CustomColors customColors,
    required bool isDarkMode,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // User Info
            Row(
              children: [
                Container(
                  width: profileImageSize,
                  height: profileImageSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/illustrations/profile_Image.jpg',
                      ),
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                ),
                SizedBox(width: cardPadding * 0.6),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome',
                      style: AppTypography.bodySmall.copyWith(
                        color: isDarkMode 
                            ? const Color(0xFFFEFEFF) // Dark theme - Figma specification
                            : const Color(0xFF1A1A1A), // Light theme - dark/text primary (CORRECTED)
                        fontSize: (availableHeight * 0.014).clamp(10.0, 12.0),
                        fontFamily: 'Roboto',
                      ),
                    ),
                    Text(
                      userName,
                      style: AppTypography.titleMedium.copyWith(
                        color: isDarkMode 
                            ? const Color(0xFFFEFEFF) // Dark theme - Figma specification
                            : const Color(0xFF1A1A1A), // Light theme - dark/text primary
                        fontSize: (availableHeight * 0.016).clamp(12.0, 14.0),
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Points and Membership
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Text(
                      loyaltyPoints.toString(),
                      style: AppTypography.headlineSmall.copyWith(
                        color: isDarkMode 
                            ? const Color(0xFFFEFEFF) // Dark theme - Figma specification
                            : const Color(0xFF1A1A1A), // Light theme - dark/text primary
                        fontSize: (availableHeight * 0.025).clamp(18.0, 22.0),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    SizedBox(width: (availableHeight * 0.005).clamp(3.0, 5.0)),
                    SvgPicture.asset(
                      'assets/images/icons/SVGs/Star_Icon_Home_dark.svg',
                      width: (availableHeight * 0.022).clamp(16.0, 20.0),
                      height: (availableHeight * 0.022).clamp(16.0, 20.0),
                      colorFilter: isDarkMode 
                          ? null // Use original SVG colors for dark mode
                          : const ColorFilter.mode(
                              Color(0xFF1A1A1A), // rgba(26, 26, 26, 1) for light mode
                              BlendMode.srcIn,
                            ),
                    ),
                  ],
                ),
                Text(
                  membershipStatus,
                  style: AppTypography.labelMedium.copyWith(
                    color: isDarkMode 
                        ? const Color(0xFFFEFEFF) // Dark theme - Figma specification
                        : const Color(0xFF1A1A1A), // Light theme - dark/text primary
                    fontSize: (availableHeight * 0.014).clamp(10.0, 12.0),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Roboto',
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: (availableHeight * 0.015).clamp(10.0, 14.0)),
        // Progress Bar
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Need 5000 Loyalty points to upgrade to Platinum',
              style: AppTypography.bodySmall.copyWith(
                color: isDarkMode 
                    ? const Color(0xFFFEFEFF) // Dark theme - Figma specification
                    : const Color(0xFF1A1A1A), // Light theme - dark/text primary
                fontSize: (availableHeight * 0.012).clamp(9.0, 11.0),
                fontFamily: 'Roboto',
              ),
            ),
            SizedBox(height: (availableHeight * 0.007).clamp(5.0, 8.0)),
            Stack(
              children: [
                // Background track (unfilled portion)
                Container(
                  height: (availableHeight * 0.004).clamp(2.0, 4.0),
                  decoration: BoxDecoration(
                    color: isDarkMode 
                        ? const Color(0xFF4D4E52) // Dark theme - Exact Figma specification
                        : const Color(0xFFD9D9D9), // Light theme - rgba(217, 217, 217, 1)
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Filled portion (progress) - Using SVG for exact Figma rendering
                LayoutBuilder(
                  builder: (context, constraints) {
                    final progressWidth = constraints.maxWidth * loyaltyProgress;
                    final progressHeight = (availableHeight * 0.004).clamp(2.0, 4.0);
                    
                    return isDarkMode 
                        ? SizedBox(
                            width: progressWidth,
                            height: progressHeight,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: SvgPicture.asset(
                                'assets/images/icons/SVGs/Progress_Fill_Home_dark.svg',
                                width: progressWidth,
                                height: progressHeight,
                                fit: BoxFit.fill, // Stretch to fill the progress area
                              ),
                            ),
                          )
                        : Container(
                            width: progressWidth,
                            height: progressHeight,
                            decoration: BoxDecoration(
                              color: const Color(0xCC1A1A1A), // rgba(26, 26, 26, 0.8) - Light theme fill
                              borderRadius: BorderRadius.circular(2),
                            ),
                          );
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeaturesGrid(
    BuildContext context,
    double availableHeight,
    double screenWidth,
    ThemeData theme,
    CustomColors customColors,
    bool isDarkMode,
  ) {
    final features = [
      {
        'title': 'Food Delivery',
        'subtitle': 'Order your favorites for pickup',
        'icon': 'assets/images/illustrations/bruger.png',
        'route': '/food-delivery',
      },
      {
        'title': 'Reservations',
        'subtitle': 'Book your table in seconds',
        'icon': 'assets/images/illustrations/reservation.png',
        'route': '/reservations',
      },
      {
        'title': 'Loyalty Hub',
        'subtitle': 'Track, earn & redeem rewards',
        'icon': 'assets/images/illustrations/crown.png',
        'route': '/loyalty',
      },
      {
        'title': 'Gift Card',
        'subtitle': 'Send joy in a few taps',
        'icon': 'assets/images/illustrations/gift_box.png',
        'route': '/gift-cards',
      },
      {
        'title': 'Wallet',
        'subtitle': 'Share your foodie moments',
        'icon': 'assets/images/illustrations/wallet.png',
        'route': '/wallet',
      },
      {
        'title': 'Feed',
        'subtitle': 'Share your foodie moments',
        'icon': 'assets/images/illustrations/Feed.png',
        'route': '/feed',
      },
      {
        'title': 'Locations',
        'subtitle': 'Order your favorites for pickup',
        'icon': 'assets/images/illustrations/Location.png',
        'route': '/locations',
      },
      {
        'title': 'Events',
        'subtitle': 'Share your foodie moments',
        'icon': 'assets/images/illustrations/Event_icon.png',
        'route': '/events',
      },
    ];

    // Calculate responsive spacing
    final cardSpacing = (availableHeight * 0.02).clamp(8.0, 16.0);
    final horizontalSpacing = (screenWidth * 0.025).clamp(10.0, 16.0);

    return Column(
      children: [
        for (int i = 0; i < features.length; i += 2)
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: cardSpacing * 0.5),
              child: Row(
                children: [
                  Expanded(
                    child: _buildFeatureCard(
                      title: features[i]['title'] as String,
                      subtitle: features[i]['subtitle'] as String,
                      iconPath: features[i]['icon'] as String,
                      availableHeight: availableHeight,
                      screenWidth: screenWidth,
                      theme: theme,
                      customColors: customColors,
                      isDarkMode: isDarkMode,
                      onTap: () => _navigateToFeature(
                        context,
                        features[i]['route'] as String,
                      ),
                    ),
                  ),
                  SizedBox(width: horizontalSpacing),
                  if (i + 1 < features.length)
                    Expanded(
                      child: _buildFeatureCard(
                        title: features[i + 1]['title'] as String,
                        subtitle: features[i + 1]['subtitle'] as String,
                        iconPath: features[i + 1]['icon'] as String,
                        availableHeight: availableHeight,
                        screenWidth: screenWidth,
                        theme: theme,
                        customColors: customColors,
                        isDarkMode: isDarkMode,
                        onTap: () => _navigateToFeature(
                          context,
                          features[i + 1]['route'] as String,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String subtitle,
    required String iconPath,
    required double availableHeight,
    required double screenWidth,
    required ThemeData theme,
    required CustomColors customColors,
    required bool isDarkMode,
    required VoidCallback onTap,
  }) {
    // Responsive sizing - based on both screen dimensions
    final cardPadding = (screenWidth * 0.025).clamp(8.0, 14.0);
    final iconSize = (screenWidth * 0.08).clamp(32.0, 48.0);
    final titleFontSize = (screenWidth * 0.04).clamp(14.0, 18.0);
    final subtitleFontSize = (screenWidth * 0.032).clamp(12.0, 14.0);
    final spacingBetween = (screenWidth * 0.02).clamp(4.0, 8.0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDarkMode
                ? Colors.white.withValues(alpha: 0.2)
                : theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
          // Light theme gets a subtle shadow, dark theme uses glass morphism
          boxShadow: isDarkMode
              ? null
              : [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: isDarkMode
              ? BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 14.7, sigmaY: 14.7),
                  child: Container(
                    padding: EdgeInsets.all(cardPadding),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: _buildFeatureCardContent(
                      title: title,
                      subtitle: subtitle,
                      iconPath: iconPath,
                      cardPadding: cardPadding,
                      iconSize: iconSize,
                      titleFontSize: titleFontSize,
                      subtitleFontSize: subtitleFontSize,
                      spacingBetween: spacingBetween,
                      theme: theme,
                      isDarkMode: isDarkMode,
                    ),
                  ),
                )
              : Container(
                  padding: EdgeInsets.all(cardPadding),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: _buildFeatureCardContent(
                    title: title,
                    subtitle: subtitle,
                    iconPath: iconPath,
                    cardPadding: cardPadding,
                    iconSize: iconSize,
                    titleFontSize: titleFontSize,
                    subtitleFontSize: subtitleFontSize,
                    spacingBetween: spacingBetween,
                    theme: theme,
                    isDarkMode: isDarkMode,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildFeatureCardContent({
    required String title,
    required String subtitle,
    required String iconPath,
    required double cardPadding,
    required double iconSize,
    required double titleFontSize,
    required double subtitleFontSize,
    required double spacingBetween,
    required ThemeData theme,
    required bool isDarkMode,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: iconSize,
            height: iconSize * 0.7, // Maintain aspect ratio
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(iconPath),
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: spacingBetween),
          Text(
            title,
            style: AppTypography.titleMedium.copyWith(
              color: isDarkMode 
                  ? const Color(0xFFFEFEFF) // Dark theme - white
                  : const Color(0xFF1A1A1A), // Light theme - dark/text primary
              fontSize: titleFontSize,
              fontWeight: FontWeight.w600,
              fontFamily: 'Roboto',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: spacingBetween * 0.5),
          Text(
            subtitle,
            style: AppTypography.bodySmall.copyWith(
              color: isDarkMode 
                  ? const Color(0xFFFEFEFF) // Dark theme - white
                  : const Color(0xCC1A1A1A), // Light theme - rgba(26,26,26,0.8)
              fontSize: subtitleFontSize,
              fontFamily: 'Roboto',
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(
    WidgetRef ref,
    BuildContext context,
    ThemeData theme,
    bool isDarkMode,
  ) {
    final selectedTab = ref.watch(selectedTabProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive padding and sizing
    final horizontalPadding = (screenWidth * 0.04).clamp(12.0, 20.0);
    final verticalPadding = (screenHeight * 0.015).clamp(10.0, 16.0);
    final iconSize = 24.0; // Fixed 24px as per Figma
    final fontSize = 10.0; // Fixed 10px as per Figma

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode
            ? const Color(0xFF242424) // Dark theme color (ORIGINAL)
            : const Color(0xFFFEFEFF), // Light theme: #fefeff (Figma)
        border: Border(
          top: BorderSide(
            color: isDarkMode
                ? const Color(0xFF4D4E52) // Dark theme border (ORIGINAL)
                : const Color(0xFFD9D9D9), // Light theme: #d9d9d9 (Figma)
            width: 1,
          ),
        ),
        // Light theme gets a subtle shadow
        boxShadow: isDarkMode
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Navigation items row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(
                  svgPath: 'assets/images/icons/SVGs/Home_Icon_Light.svg',
                  label: 'Home',
                  isSelected: selectedTab == 0,
                  iconSize: iconSize,
                  fontSize: fontSize,
                  theme: theme,
                  isDarkMode: isDarkMode,
                  onTap: () => ref.read(selectedTabProvider.notifier).state = 0,
                ),
                _buildNavItem(
                  svgPath: 'assets/images/icons/SVGs/QR_Icon_light.svg',
                  label: 'Scan',
                  isSelected: selectedTab == 1,
                  iconSize: iconSize,
                  fontSize: fontSize,
                  theme: theme,
                  isDarkMode: isDarkMode,
                  onTap: () => ref.read(selectedTabProvider.notifier).state = 1,
                ),
                _buildNavItem(
                  svgPath: 'assets/images/icons/SVGs/Order_Icon_light.svg',
                  label: 'Order',
                  isSelected: selectedTab == 2,
                  iconSize: iconSize,
                  fontSize: fontSize,
                  theme: theme,
                  isDarkMode: isDarkMode,
                  onTap: () => ref.read(selectedTabProvider.notifier).state = 2,
                ),
                _buildNavItem(
                  svgPath: 'assets/images/icons/SVGs/Restaurant_Icon_light.svg',
                  label: 'Reserve',
                  isSelected: selectedTab == 3,
                  iconSize: iconSize,
                  fontSize: fontSize,
                  theme: theme,
                  isDarkMode: isDarkMode,
                  onTap: () => ref.read(selectedTabProvider.notifier).state = 3,
                ),
                _buildNavItem(
                  svgPath: 'assets/images/icons/SVGs/Feed_Icon_light.svg',
                  label: 'Feed',
                  isSelected: selectedTab == 4,
                  iconSize: iconSize,
                  fontSize: fontSize,
                  theme: theme,
                  isDarkMode: isDarkMode,
                  onTap: () => ref.read(selectedTabProvider.notifier).state = 4,
                ),
                _buildNavItem(
                  svgPath: 'assets/images/icons/SVGs/Location_Icon_light.svg',
                  label: 'Location',
                  isSelected: selectedTab == 5,
                  iconSize: iconSize,
                  fontSize: fontSize,
                  theme: theme,
                  isDarkMode: isDarkMode,
                  onTap: () => ref.read(selectedTabProvider.notifier).state = 5,
                ),
              ],
            ),
            // Removed home indicator notch
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String svgPath,
    required String label,
    required bool isSelected,
    required double iconSize,
    required double fontSize,
    required ThemeData theme,
    required bool isDarkMode,
    required VoidCallback onTap,
  }) {
    // Theme-responsive colors (ORIGINAL dark mode + Figma light mode)
    final unselectedColor = isDarkMode
        ? const Color(0xFF9C9C9D) // Dark theme tertiary (ORIGINAL)
        : const Color(0xFF878787); // Light theme: #878787 (Figma)

    final selectedColor = isDarkMode
        ? const Color(0xFFFFFBF1) // Dark theme sand (ORIGINAL)
        : const Color(0xFF1A1A1A); // Light theme: #1a1a1a (Figma)

    final selectedBackground = isDarkMode
        ? const Color(0xFF1A1A1A) // Dark background for selected (ORIGINAL)
        : const Color(0xFFFFFCF5); // Light theme: #fffcf5 (Figma)

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? (iconSize * 0.5) : (iconSize * 0.33),
          vertical: (iconSize * 0.33),
        ),
        decoration: isSelected
            ? BoxDecoration(
                color: selectedBackground,
                borderRadius: BorderRadius.circular(isDarkMode ? (iconSize * 0.83) : 38), // Original for dark, Figma for light
              )
            : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              svgPath,
              width: iconSize,
              height: iconSize,
              colorFilter: ColorFilter.mode(
                isSelected ? selectedColor : unselectedColor,
                BlendMode.srcIn,
              ),
            ),
            if (isSelected) ...[
              SizedBox(width: iconSize * 0.25),
              Text(
                label,
                style: AppTypography.labelMedium.copyWith(
                  color: isDarkMode
                      ? selectedColor // Dark mode: original color
                      : selectedColor, // Light mode: same as icon (Figma)
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _navigateToFeature(BuildContext context, String route) {
    context.push(route);
  }
}
