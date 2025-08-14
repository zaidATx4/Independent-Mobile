import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RewardItem extends StatelessWidget {
  final String title;
  final String expiryDate;
  final String foodImagePath;
  final String brandLogoPath;
  final String? rewardId;
  final bool isRedeemed;
  final VoidCallback? onTap;

  const RewardItem({
    super.key,
    required this.title,
    required this.expiryDate,
    required this.foodImagePath,
    required this.brandLogoPath,
    this.rewardId,
    this.isRedeemed = false,
    this.onTap,
  });

  void _handleTap(BuildContext context) {
    if (onTap != null) {
      onTap!();
    } else if (isRedeemed) {
      // Debug: Print what we're sending
      // DEBUG: Navigating with brandLogoPath
      // DEBUG: Navigating with title
      
      // Navigate to redeemed QR screen
      context.push('/redeemed-qr', extra: {
        'rewardTitle': title,
        'rewardId': rewardId,
        'qrData': 'reward_${rewardId ?? DateTime.now().millisecondsSinceEpoch}',
        'brandLogoPath': brandLogoPath,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: () => _handleTap(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isDark 
                  ? const Color(0xFF4D4E52) // dark gray for dark theme
                  : const Color(0xFFD9D9D9), // light gray for light theme
              width: 1.0,
            ),
            bottom: BorderSide(
              color: isDark 
                  ? const Color(0xFF4D4E52) // dark gray for dark theme
                  : const Color(0xFFD9D9D9), // light gray for light theme
              width: 1.0,
            ),
          ),
        ),
        child: Row(
        children: [
          // Food Image
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: AssetImage(foodImagePath),
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
                  title,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    height: 21 / 14,
                    color: isDark 
                        ? const Color(0xFFFEFEFF) // white text for dark theme
                        : const Color(0xFF1A1A1A), // dark text for light theme
                  ),
                ),
                Text(
                  expiryDate,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    height: 18 / 12,
                    color: isDark 
                        ? const Color(0xFF9C9C9D) // gray text for dark theme
                        : const Color(0xFF878787), // medium gray text for light theme
                  ),
                ),
              ],
            ),
          ),
          // Brand Logo
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white, // White background for brand logos
              image: DecorationImage(
                image: AssetImage(brandLogoPath),
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