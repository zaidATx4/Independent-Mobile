import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';
import '../../domain/entities/wallet_entities.dart';

/// Wallet Card Widget - Displays individual wallet information
/// Light theme implementation matching Figma design specifications
class WalletCard extends StatelessWidget {
  final WalletEntity wallet;
  final VoidCallback onTap;

  const WalletCard({
    super.key,
    required this.wallet,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive card dimensions maintaining Figma aspect ratio (360:179)
        final cardWidth = constraints.maxWidth;
        final cardHeight = cardWidth * (179 / 360);
        
        return Container(
          width: cardWidth,
          height: cardHeight,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(40), // Exact Figma border radius
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  image: DecorationImage(
                    image: AssetImage(wallet.backgroundImageUrl ?? 'assets/images/illustrations/Wallet_1.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.all(8), // Small thick border around the wallet card bg
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32), // Slightly smaller radius for inner blur
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15), // Glass morphism effect
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          color: const Color(0x40FFFFFF), // indpt/glass-fill (25% white opacity)
                          border: Border.all(
                            color: const Color(0x1AFEFEFF), // Subtle border
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Wallet name - centered
                          Text(
                            wallet.displayName ?? wallet.currency,
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              fontWeight: FontWeight.w400, // Regular (matches Figma Indpt/Text 2)
                              color: Color(0xFFFEFEFF), // White text on glass overlay
                              height: 21 / 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Balance section - centered
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Balance amount
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    wallet.formattedBalance,
                                    style: const TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700, // Bold (matches Figma Indpt/Title 1)
                                      color: Color(0xFFFEFEFF), // White text on glass overlay
                                      height: 32 / 24,
                                    ),
                                  ),
                                  
                                  const SizedBox(width: 2), // Reduced spacing to match Figma
                                  
                                  SvgPicture.asset(
                                    'assets/images/icons/Payment_Methods/SAR.svg',
                                    width: 16,
                                    height: 17.92, // Exact height from Figma
                                    colorFilter: const ColorFilter.mode(
                                      Color(0xFFFEFEFF), // White text on glass overlay
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 4),
                              
                              // Reset date info
                              if (wallet.resetDate != null)
                                Text(
                                  wallet.resetDateDisplay,
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400, // Regular (matches Figma Indpt/Text 3)
                                    color: Color(0xFFFEFEFF), // White text on glass overlay
                                    height: 18 / 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                            ],
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
        );
      },
    );
  }
}