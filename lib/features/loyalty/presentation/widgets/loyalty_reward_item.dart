import 'package:flutter/material.dart';
import '../pages/reward_detail_screen.dart';

class LoyaltyRewardItem extends StatefulWidget {
  final String title;
  final String expiryDate;
  final String foodImagePath;
  final String brandLogoPath;

  const LoyaltyRewardItem({
    super.key,
    required this.title,
    required this.expiryDate,
    required this.foodImagePath,
    required this.brandLogoPath,
  });

  @override
  State<LoyaltyRewardItem> createState() => _LoyaltyRewardItemState();
}

class _LoyaltyRewardItemState extends State<LoyaltyRewardItem> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RewardDetailScreen(
              title: widget.title,
              expiryDate: widget.expiryDate,
              foodImagePath: widget.foodImagePath,
              brandLogoPath: widget.brandLogoPath,
            ),
          ),
        );
      },
      child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFF4D4E52), width: 1.0), // indpt/stroke
          bottom: BorderSide(color: Color(0xFF4D4E52), width: 1.0), // indpt/stroke
        ),
      ),
      child: Row(
        children: [
          // Food Image (64x64)
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: AssetImage(widget.foodImagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Title and Expiry
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500, // Medium
                    fontSize: 14,
                    height: 21 / 14, // lineHeight / fontSize
                    color: Color(0xFFFEFEFF), // indpt/text primary
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.expiryDate,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400, // Regular
                    fontSize: 12,
                    height: 18 / 12, // lineHeight / fontSize
                    color: Color(0xFF9C9C9D), // indpt/text tertiary
                  ),
                ),
              ],
            ),
          ),
          // Brand Logo (48x48 circular)
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white, // White background for brand logos
              image: DecorationImage(
                image: AssetImage(widget.brandLogoPath),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}

