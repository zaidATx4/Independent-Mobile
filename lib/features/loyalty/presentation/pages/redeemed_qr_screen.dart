import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RedeemedQrScreen extends StatelessWidget {
  final String? rewardTitle;
  final String? rewardId;
  final String? qrData;
  final String? brandLogoPath;

  const RedeemedQrScreen({
    super.key,
    this.rewardTitle,
    this.rewardId,
    this.qrData,
    this.brandLogoPath,
  });

  @override
  Widget build(BuildContext context) {
    // Debug: Print the received parameters
    print('DEBUG: Received brandLogoPath: $brandLogoPath');
    print('DEBUG: Received rewardTitle: $rewardTitle');
    
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Static/Burger_Background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Status bar and back button
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: ClipOval(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                color: Color(0x40FFFFFF), // Glass morphism effect
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios_new,
                                color: Color(0xFFFEFEFF),
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Bottom reward card
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
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
                            Color(0x40FFFFFF), // rgba(255, 255, 255, 0.25) glass fill
                            Color(0x40FFFFFF),
                          ],
                        ),
                      ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Reward details section
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 40.0),
                          child: Row(
                            children: [
                              // Brand logo
                              Container(
                                width: 64,
                                height: 64,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(16)),
                                  color: Colors.white, // White background for brand logo
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: brandLogoPath != null && brandLogoPath!.isNotEmpty
                                      ? Image.asset(
                                          brandLogoPath!,
                                          width: 64,
                                          height: 64,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            print('DEBUG: Image loading error for $brandLogoPath: $error');
                                            // Try to load Salt.png as fallback
                                            return Image.asset(
                                              'assets/images/logos/brands/Salt.png',
                                              width: 64,
                                              height: 64,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error2, stackTrace2) {
                                                print('DEBUG: Fallback image also failed: $error2');
                                                return Container(
                                                  width: 64,
                                                  height: 64,
                                                  color: const Color(0xFFF5F5F5),
                                                  child: const Icon(
                                                    Icons.restaurant,
                                                    color: Color(0xFF242424),
                                                    size: 32,
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        )
                                      : Container(
                                          width: 64,
                                          height: 64,
                                          color: const Color(0xFFF5F5F5),
                                          child: const Icon(
                                            Icons.help,
                                            color: Color(0xFF242424),
                                            size: 32,
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              
                              // Reward information
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      rewardTitle ?? 'Free Cheeseburger',
                                      style: const TextStyle(
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
                                        height: 30 / 20,
                                        color: Color(0xFFFFFFFF),
                                      ),
                                    ),
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
                              
                              // QR Code button
                              GestureDetector(
                                onTap: () {
                                  _showQrCodeBanner(context);
                                },
                                child: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFFBF1),
                                    borderRadius: BorderRadius.circular(44),
                                  ),
                                  child: const Icon(
                                    Icons.qr_code,
                                    color: Color(0xFF000000),
                                    size: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQrCodeBanner(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.55, // 55% of screen
        width: double.infinity,
        child: ClipRect(
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
                      Color(0x40FFFFFF), // rgba(255, 255, 255, 0.25) glass fill
                      Color(0x40FFFFFF),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    // Top section with reward info
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                      child: Row(
                        children: [
                          // Brand logo
                          Container(
                            width: 64,
                            height: 64,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(16)),
                              color: Colors.white,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: brandLogoPath != null && brandLogoPath!.isNotEmpty
                                  ? Image.asset(
                                      brandLogoPath!,
                                      width: 64,
                                      height: 64,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/images/logos/brands/Salt.png',
                                          width: 64,
                                          height: 64,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error2, stackTrace2) {
                                            return Container(
                                              width: 64,
                                              height: 64,
                                              color: const Color(0xFFF5F5F5),
                                              child: const Icon(
                                                Icons.restaurant,
                                                color: Color(0xFF242424),
                                                size: 32,
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    )
                                  : Container(
                                      width: 64,
                                      height: 64,
                                      color: const Color(0xFFF5F5F5),
                                      child: const Icon(
                                        Icons.help,
                                        color: Color(0xFF242424),
                                        size: 32,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          
                          // Reward information
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  rewardTitle ?? 'Free Cheeseburger',
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                    height: 30 / 20,
                                    color: Color(0xFFFFFFFF),
                                  ),
                                ),
                                const Text(
                                  'Valid until March 31, 2025',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    height: 18 / 12,
                                    color: Color(0xCCFEFEFF), // rgba(254,254,255,0.8)
                                  ),
                                ),
                                const Text(
                                  'Valid at all "Salt" branches',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    height: 18 / 12,
                                    color: Color(0xCCFEFEFF), // rgba(254,254,255,0.8)
                                  ),
                                ),
                                const Text(
                                  'Expires in 7 days.',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    height: 18 / 12,
                                    color: Color(0xCCFEFEFF), // rgba(254,254,255,0.8)
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // QR Code button (now just visual)
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFBF1), // indpt/sand
                              borderRadius: BorderRadius.circular(44),
                            ),
                            child: const Icon(
                              Icons.qr_code,
                              color: Color(0xFF000000),
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // QR Code and alternatives section
                    Expanded(
                      child: Container(
                        width: 361,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // QR Code container
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFFBF1), // indpt/sand
                              ),
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: Image.asset(
                                  'assets/images/Static/qr.png',
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.qr_code,
                                      size: 120,
                                      color: Color(0xFF242424),
                                    );
                                  },
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 12),
                            
                            // Instructions text
                            const Text(
                              'Show this QR code at the counter to redeem your reward instantly.',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                height: 21 / 14,
                                color: Color(0xCCFEFEFF), // rgba(254,254,255,0.8)
                              ),
                              textAlign: TextAlign.center,
                            ),
                            
                            const SizedBox(height: 12),
                            
                            // "Or" divider
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: const Color(0x40FFFFFF), // rgba(255,255,255,0.25)
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Text(
                                    'Or',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      height: 18 / 12,
                                      color: Color(0x40FFFFFF), // rgba(255,255,255,0.25)
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: const Color(0x40FFFFFF), // rgba(255,255,255,0.25)
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 12),
                            
                            // Alternative code section
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFF7BF10), // Indpt/Loyalty
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'ALPHA-12345',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24,
                                  height: 32 / 24,
                                  color: Color(0xFFFEFEFF), // indpt/text primary
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 12),
                            
                            // Alternative code instructions
                            const Text(
                              'Provide this code to the staff if scanning is unavailable.',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                height: 21 / 14,
                                color: Color(0xCCFEFEFF), // rgba(254,254,255,0.8)
                              ),
                              textAlign: TextAlign.center,
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
    );
  }
}