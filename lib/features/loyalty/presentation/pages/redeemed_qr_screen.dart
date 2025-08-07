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
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // 30% blur effect
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
                          padding: const EdgeInsets.all(16.0),
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
                                  // Show QR code modal or navigate to QR display
                                  _showQrCodeModal(context);
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
                        
                        // Home indicator
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Container(
                            width: 134,
                            height: 5,
                            decoration: BoxDecoration(
                              color: const Color(0xFF9C9C9D),
                              borderRadius: BorderRadius.circular(100),
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
          ],
        ),
      ),
    );
  }

  void _showQrCodeModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Color(0xFFFFFBF1),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF9C9C9D),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // QR Code section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // QR Code
                    Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 20,
                            spreadRadius: 0,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/images/Static/qr.png',
                          width: 240,
                          height: 240,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.qr_code,
                              size: 200,
                              color: Color(0xFF242424),
                            );
                          },
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Instructions
                    const Text(
                      'Show this QR code to staff',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        height: 30 / 20,
                        color: Color(0xFF242424),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    const Text(
                      'Present this QR code at the restaurant counter to redeem your reward',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        height: 21 / 14,
                        color: Color(0xFF9C9C9D),
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
    );
  }
}