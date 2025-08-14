import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QrCodeSection extends StatelessWidget {
  const QrCodeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth * 0.6).clamp(223.0, 300.0); // Responsive width
    final qrSize = (cardWidth * 0.65).clamp(158.0, 190.0); // Responsive QR size
    final circleSize = (cardWidth * 0.15).clamp(30.0, 40.0); // Responsive circle size
    final circleOffset = circleSize / 2; // Half the circle extends outside
    
    return Container(
      margin: const EdgeInsets.only(top: 2), // Reduced gap from redeem rewards
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Main ticket card with border
          Container(
            width: cardWidth,
            decoration: BoxDecoration(
              border: Border.all(
                color: isDark 
                    ? Colors.transparent // no border for dark theme
                    : const Color(0xFF878787), // dark border for light theme: 1px solid var(--dark-text-tertiary, #878787)
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top section with QR code
                Container(
                  width: cardWidth,
                  padding: EdgeInsets.all(cardWidth * 0.07), // Responsive padding
                  decoration: BoxDecoration(
                    color: isDark 
                        ? const Color(0xFFFFFBF1) // cream for dark theme (matches Figma)
                        : const Color(0xFFFEFEFF), // white for light theme
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        width: qrSize,
                        height: qrSize,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _buildQrCode(),
                      ),
                    ),
                  ),
                ),
                // Middle separator with visible line and cutouts
                Container(
                  width: cardWidth,
                  height: 16, // Increased height to accommodate moved line
                  decoration: BoxDecoration(
                    color: isDark 
                        ? const Color(0xFFFFFBF1) // cream for dark theme
                        : const Color(0xFFFEFEFF), // white for light theme
                  ),
                  child: Stack(
                    children: [
                      // Visible separation line through middle connecting half-circles
                      Positioned(
                        left: 0, // Start from edge to touch left circle
                        right: 0, // End at edge to touch right circle
                        top: 6 + (circleSize * 0.15), // Move line down to match circle center
                        child: Container(
                          width: double.infinity,
                          height: 1.0, // Thin line
                          color: isDark 
                              ? Colors.transparent // no line for dark theme
                              : const Color(0xFF878787), // dark border line for light theme
                        ),
                      ),
                    ],
                  ),
                ),
                // Bottom section with text and earn button
                Container(
                  width: cardWidth,
                  padding: EdgeInsets.all(cardWidth * 0.07), // Responsive padding
                  decoration: BoxDecoration(
                    color: isDark 
                        ? const Color(0xFFFFFBF1) // cream for dark theme
                        : const Color(0xFFFEFEFF), // white for light theme
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Scan this QR at the counter to earn points.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          fontSize: (cardWidth * 0.063).clamp(12.0, 16.0), // Responsive font size
                          height: 1.5,
                          color: isDark 
                              ? const Color(0xFF4D4E52) // dark gray for dark theme
                              : const Color(0xCC1A1A1A), // semi-transparent dark for light theme
                        ),
                      ),
                      SizedBox(height: cardWidth * 0.07), // Responsive spacing
                      // Earn points button
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: cardWidth * 0.07,
                          vertical: cardWidth * 0.035,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(33),
                          border: Border.all(
                            color: const Color(0xFFF7BF10),
                            width: 2.0, // Increased for better visibility
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Earn 1',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                                fontSize: (cardWidth * 0.08).clamp(16.0, 20.0), // Responsive font size
                                height: 1.5,
                                color: isDark 
                                    ? const Color(0xFF4D4E52) // dark gray for dark theme
                                    : const Color(0xCC1A1A1A), // semi-transparent dark for light theme
                              ),
                            ),
                            SizedBox(width: cardWidth * 0.018), // Responsive spacing
                            // Star icon for earning
                            SvgPicture.asset(
                              'assets/images/icons/SVGs/Star_Icon_Home_dark.svg',
                              width: (cardWidth * 0.09).clamp(18.0, 24.0), // Responsive icon size
                              height: (cardWidth * 0.09).clamp(18.0, 24.0),
                              colorFilter: const ColorFilter.mode(
                                Color(0xFFF7BF10), // Golden star color
                                BlendMode.srcIn,
                              ),
                            ),
                            Text(
                              ' per \$1',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                                fontSize: (cardWidth * 0.08).clamp(16.0, 20.0), // Responsive font size
                                height: 1.5,
                                color: isDark 
                                    ? const Color(0xFF4D4E52) // dark gray for dark theme
                                    : const Color(0xCC1A1A1A), // semi-transparent dark for light theme
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Left semicircle cutout - positioned with 55% above, 45% below separation line
          Positioned(
            left: -circleOffset,
            top: (cardWidth * 0.07) + qrSize + (cardWidth * 0.07) + 4 + (circleSize * 0.15), // Move twice as much down: circles mostly below separator
            child: Container(
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark 
                    ? const Color(0xFF1A1A1A) // dark background shows through for dark theme
                    : const Color(0xFFFFFCF5), // light background shows through for light theme
                border: isDark 
                    ? null // no border for dark theme
                    : Border.all(
                        color: const Color(0xFF878787), // dark border for light theme
                        width: 1.0,
                      ),
              ),
            ),
          ),
          // Right semicircle cutout - positioned with 55% above, 45% below separation line
          Positioned(
            right: -circleOffset,
            top: (cardWidth * 0.07) + qrSize + (cardWidth * 0.07) + 4 + (circleSize * 0.15), // Move twice as much down: circles mostly below separator
            child: Container(
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark 
                    ? const Color(0xFF1A1A1A) // dark background shows through for dark theme
                    : const Color(0xFFFFFCF5), // light background shows through for light theme
                border: isDark 
                    ? null // no border for dark theme
                    : Border.all(
                        color: const Color(0xFF878787), // dark border for light theme
                        width: 1.0,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrCode() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Image.asset(
          'assets/images/Static/qr.png',
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          fit: BoxFit.contain,
        );
      },
    );
  }
}

