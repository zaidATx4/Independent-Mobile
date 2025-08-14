import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/theme_service.dart';

class RewardDetailScreen extends StatelessWidget {
  final String title;
  final String expiryDate;
  final String foodImagePath;
  final String brandLogoPath;
  final int pointsCost;

  const RewardDetailScreen({
    super.key,
    required this.title,
    required this.expiryDate,
    required this.foodImagePath,
    required this.brandLogoPath,
    this.pointsCost = 500,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image - use burger image as placeholder
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/Static/Burger_Background.jpg',
                ), // Correct path
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Status bar area
          Container(
            height: MediaQuery.of(context).padding.top + 44,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x40000000), Colors.transparent],
              ),
            ),
          ),

          // Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0x40FFFFFF), // rgba(255, 255, 255, 0.25)
                  borderRadius: BorderRadius.circular(44),
                ),
                child: const Center(
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: Color(0xFFFEFEFF),
                    size: 16,
                  ),
                ),
              ),
            ),
          ),

          // Bottom section with reward details
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(),
              child: ClipRRect(
                borderRadius: BorderRadius.zero,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x1A000000), // rgba(0, 0, 0, 0.1) overlay
                          Color(0x1A000000),
                        ],
                      ),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(
                              0x40FFFFFF,
                            ), // rgba(255, 255, 255, 0.25) glass fill
                            Color(0x40FFFFFF),
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Reward info section
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Brand logo
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.white,
                                    image: DecorationImage(
                                      image: AssetImage(brandLogoPath),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),

                                // Reward details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title,
                                        style: const TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight:
                                              FontWeight.w600, // SemiBold
                                          fontSize: 20,
                                          height:
                                              30 / 20, // lineHeight / fontSize
                                          color: Color(
                                            0xFFFFFFFF,
                                          ), // indpt/BG/Accent
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      const Text(
                                        'Valid until March 31, 2025',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight:
                                              FontWeight.w400, // Regular
                                          fontSize: 12,
                                          height:
                                              18 / 12, // lineHeight / fontSize
                                          color: Color(
                                            0xCCFEFEFF,
                                          ), // indpt/text secondary
                                        ),
                                      ),
                                      const Text(
                                        'Valid at all "Salt" branches',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight:
                                              FontWeight.w400, // Regular
                                          fontSize: 12,
                                          height:
                                              18 / 12, // lineHeight / fontSize
                                          color: Color(
                                            0xCCFEFEFF,
                                          ), // indpt/text secondary
                                        ),
                                      ),
                                      const Text(
                                        'Expires in 7 days.',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight:
                                              FontWeight.w400, // Regular
                                          fontSize: 12,
                                          height:
                                              18 / 12, // lineHeight / fontSize
                                          color: Color(
                                            0xCCFEFEFF,
                                          ), // indpt/text secondary
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Redeem button
                            GestureDetector(
                              onTap: () {
                                // Navigate to redemption confirmation screen first
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        RedemptionConfirmationScreen(
                                          title: title,
                                          brandLogoPath: brandLogoPath,
                                        ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 361,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: context.getThemedColor(
                                    lightColor: Color(
                                      0xFF242424,
                                    ), // Dark background for light theme
                                    darkColor: Color(
                                      0xFFFFFBF1,
                                    ), // Sand background for dark theme
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    37,
                                  ), // Half-circle ends
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '$pointsCost',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w500, // Medium
                                        fontSize: 16,
                                        height:
                                            24 / 16, // lineHeight / fontSize
                                        color: context.getThemedColor(
                                          lightColor: Color(
                                            0xFFFEFEFF,
                                          ), // White text for light theme
                                          darkColor: Color(
                                            0xFF1A1A1A,
                                          ), // Dark text for dark theme
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    // Use custom SVG star icon with yellow color
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: SvgPicture.asset(
                                        'assets/images/icons/SVGs/Star_Icon_Home_dark.svg',
                                        width: 20,
                                        height: 20,
                                        colorFilter: const ColorFilter.mode(
                                          Color(
                                            0xFFF7BF10,
                                          ), // Yellow star color #F7BF10
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '| Redeem now',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w500, // Medium
                                        fontSize: 16,
                                        height:
                                            24 / 16, // lineHeight / fontSize
                                        color: context.getThemedColor(
                                          lightColor: Color(
                                            0xFFFEFEFF,
                                          ), // White text for light theme
                                          darkColor: Color(
                                            0xFF1A1A1A,
                                          ), // Dark text for dark theme
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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

class RedemptionConfirmationScreen extends StatelessWidget {
  final String title;
  final String brandLogoPath;

  const RedemptionConfirmationScreen({
    super.key,
    required this.title,
    required this.brandLogoPath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image - use burger image as placeholder
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/Static/Burger_Background.jpg',
                ), // Correct path
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Status bar area
          Container(
            height: MediaQuery.of(context).padding.top + 44,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x40000000), Colors.transparent],
              ),
            ),
          ),

          // Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0x40FFFFFF), // rgba(255, 255, 255, 0.25)
                  borderRadius: BorderRadius.circular(44),
                ),
                child: const Center(
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: Color(0xFFFEFEFF),
                    size: 16,
                  ),
                ),
              ),
            ),
          ),

          // Bottom section with redemption confirmation
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(),
              child: ClipRRect(
                borderRadius: BorderRadius.zero,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x1A000000), // rgba(0, 0, 0, 0.1) overlay
                          Color(0x1A000000),
                        ],
                      ),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(
                              0x40FFFFFF,
                            ), // rgba(255, 255, 255, 0.25) glass fill
                            Color(0x40FFFFFF),
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Header with brand info
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.white,
                                    image: DecorationImage(
                                      image: AssetImage(brandLogoPath),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title,
                                        style: const TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                          height: 30 / 20,
                                          color: Color(0xFFFFFFFF),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      const Text(
                                        'Valid until March 31, 2025',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          height: 18 / 12,
                                          color: Color(0xCCFEFEFF),
                                        ),
                                      ),
                                      const Text(
                                        'Valid at all "Salt" branches',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          height: 18 / 12,
                                          color: Color(0xCCFEFEFF),
                                        ),
                                      ),
                                      const Text(
                                        'Expires in 7 days.',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          height: 18 / 12,
                                          color: Color(0xCCFEFEFF),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // QR Code button - now visible immediately
                                GestureDetector(
                                  onTap: () {
                                    // Navigate to QR screen
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            RedemptionQRScreen(
                                              title: title,
                                              brandLogoPath: brandLogoPath,
                                            ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: context.getThemedColor(
                                        lightColor: Color(
                                          0xFF000000,
                                        ), // Dark background for light theme
                                        darkColor: Color(
                                          0xFFFFFBF1,
                                        ), // Sand background for dark theme
                                      ),
                                      borderRadius: BorderRadius.circular(44),
                                    ),
                                    child: Icon(
                                      Icons.qr_code,
                                      color: context.getThemedColor(
                                        lightColor: Color(
                                          0xFFFFFFFF,
                                        ), // White icon for light theme
                                        darkColor: Color(
                                          0xFF000000,
                                        ), // Black icon for dark theme
                                      ),
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Instruction text
                          ],
                        ),
                      ),
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

class RedemptionQRScreen extends StatelessWidget {
  final String title;
  final String brandLogoPath;

  const RedemptionQRScreen({
    super.key,
    required this.title,
    required this.brandLogoPath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image - use burger image as placeholder
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/Static/Burger_Background.jpg',
                ), // Correct path
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Status bar area
          Container(
            height: MediaQuery.of(context).padding.top + 44,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x40000000), Colors.transparent],
              ),
            ),
          ),

          // Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0x40FFFFFF), // rgba(255, 255, 255, 0.25)
                  borderRadius: BorderRadius.circular(44),
                ),
                child: const Center(
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: Color(0xFFFEFEFF),
                    size: 16,
                  ),
                ),
              ),
            ),
          ),

          // Bottom section with QR code
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(),
              child: ClipRRect(
                borderRadius: BorderRadius.zero,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x1A000000), // rgba(0, 0, 0, 0.1) overlay
                          Color(0x1A000000),
                        ],
                      ),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(
                              0x40FFFFFF,
                            ), // rgba(255, 255, 255, 0.25) glass fill
                            Color(0x40FFFFFF),
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Header with brand info - align logo with title
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.white,
                                    image: DecorationImage(
                                      image: AssetImage(brandLogoPath),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title,
                                        style: const TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                          height: 30 / 20,
                                          color: Color(0xFFFFFFFF),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      const Text(
                                        'Valid until March 31, 2025',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          height: 18 / 12,
                                          color: Color(0xCCFEFEFF),
                                        ),
                                      ),
                                      const Text(
                                        'Valid at all "Salt" branches',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          height: 18 / 12,
                                          color: Color(0xCCFEFEFF),
                                        ),
                                      ),
                                      const Text(
                                        'Expires in 7 days.',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          height: 18 / 12,
                                          color: Color(0xCCFEFEFF),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // QR Code
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFFFFFBF1,
                                ), // Using cream/sand color to match design
                                borderRadius: BorderRadius.circular(
                                  12,
                                ), // Add some border radius for QR container
                              ),
                              child: Container(
                                width: 200,
                                height: 200,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: Image.asset(
                                  'assets/images/Static/qr.png',
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.qr_code,
                                      size: 150,
                                      color: Color(0xFF242424),
                                    );
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            const Text(
                              'Show this QR code at the counter to redeem your reward instantly.',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                height: 21 / 14,
                                color: Color(0xCCFEFEFF),
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 24),

                            // "Or" divider
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: const Color(0x40FFFFFF),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: Text(
                                    'Or',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      height: 18 / 12,
                                      color: Color(0x80FFFFFF),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: const Color(0x40FFFFFF),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Alternative code section
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                                vertical: 12.0,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFF7BF10),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'ALPHA-12345',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                  height: 30 / 20,
                                  color: Color(0xFFFEFEFF),
                                  letterSpacing: 2.0,
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Alternative code instructions
                            const Text(
                              'Provide this code to the staff if scanning is unavailable.',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                height: 21 / 14,
                                color: Color(0xCCFEFEFF),
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 20),

                            // Home indicator
                          ],
                        ),
                      ),
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
