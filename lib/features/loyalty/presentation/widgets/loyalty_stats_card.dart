import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class LoyaltyStatsCard extends StatelessWidget {
  final int points;
  final String membershipTier;
  final int pointsNeeded;
  final String nextTier;

  const LoyaltyStatsCard({
    super.key,
    required this.points,
    required this.membershipTier,
    required this.pointsNeeded,
    required this.nextTier,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate progress (example: 2500 out of 7500 total needed)
    final double progress = points / (points + pointsNeeded);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 7),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.transparent,
      ),
      child: Column(
        children: [
          // Header with points and loyalty hub button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        points.toString(),
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          height: 32 / 24,
                          color: Color(0xFFFEFEFF),
                        ),
                      ),
                      const SizedBox(width: 4),
                      // Star icon
                      SvgPicture.asset(
                        'assets/images/icons/SVGs/Star_Icon_Home_dark.svg',
                        width: 20,
                        height: 20,
                      ),
                    ],
                  ),
                  Text(
                    membershipTier,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      height: 18 / 12,
                      color: Color(0xFFFEFEFF),
                    ),
                  ),
                ],
              ),
              // Loyalty hub button
              GestureDetector(
                onTap: () => context.push('/loyalty-hub'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBF1),
                    borderRadius: BorderRadius.circular(44),
                  ),
                  child: const Text(
                    'Loyalty hub',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      height: 21 / 14,
                      color: Color(0xFF242424),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Progress section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Need $pointsNeeded Loyalty points to upgrade to $nextTier',
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  height: 18 / 12,
                  color: Color(0xFFFEFEFF),
                ),
              ),
              const SizedBox(height: 8),
              // Progress bar
              Stack(
                children: [
                  // Background track (unfilled portion)
                  Container(
                    width: double.infinity,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4D4E52),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Filled portion (progress) - Using SVG for exact Figma rendering
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final progressWidth = constraints.maxWidth * progress;
                      const progressHeight = 4.0;
                      
                      return SizedBox(
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
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}