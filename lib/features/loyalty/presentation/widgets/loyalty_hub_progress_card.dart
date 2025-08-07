import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoyaltyHubProgressCard extends StatelessWidget {
  final int points;
  final String membershipTier;
  final int pointsNeeded;
  final String nextTier;

  const LoyaltyHubProgressCard({
    super.key,
    required this.points,
    required this.membershipTier,
    required this.pointsNeeded,
    required this.nextTier,
  });

  @override
  Widget build(BuildContext context) {
    // For now, set progress to 60% filled and 40% unfilled
    final double progress = 0.6;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const RadialGradient(
          center: Alignment.center,
          radius: 1.0,
          colors: [
            Color(0xFFFFF9A3), // Light golden yellow at center
            Color(0xFFF6E082), // Medium golden yellow
            Color(0xFFEDC760), // Darker golden yellow at edges
          ],
          stops: [0.0, 0.6, 1.0],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          color: Color(0x33FFFFFF), // #FFFFFF33 - 20% transparent white overlay
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with points and star icons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Points and membership info
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        points.toStringAsFixed(0).replaceAllMapped(
                          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                          (Match m) => '${m[1]},',
                        ),
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          fontSize: 32,
                          height: 48 / 32,
                          color: Color(0xFF1E1E1E),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Small star icon next to points
                      SvgPicture.asset(
                        'assets/images/icons/SVGs/Star_Icon_Home_dark.svg',
                        width: 32,
                        height: 32,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF1E1E1E),
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    membershipTier,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      height: 27 / 18,
                      color: Color(0xFF4E4E4E),
                    ),
                  ),
                ],
              ),
              // Large star icon on the right
              SvgPicture.asset(
                'assets/images/icons/SVGs/Star_Icon_Home_dark.svg',
                width: 55,
                height: 55,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF1E1E1E),
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress description
          Text(
            'Need $pointsNeeded Loyalty points to upgrade to $nextTier',
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              fontSize: 12,
              height: 18 / 12,
              color: Color(0xFF4E4E4E),
            ),
          ),
          const SizedBox(height: 8),
          // Progress bar
          Container(
            height: 4,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0x29787880), // Figma spec: var(--Fills-Secondary, #78788029) - unfilled part
              borderRadius: BorderRadius.circular(100),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E), // var(--Indpt-Text-Primary, #1E1E1E) - filled part
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Progress labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Gold',
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  height: 18 / 12,
                  color: Color(0xFF4E4E4E),
                ),
              ),
              Text(
                nextTier,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  height: 18 / 12,
                  color: Color(0xFF4E4E4E),
                ),
              ),
            ],
          ),
        ],
        ),
      ),
    );
  }
}