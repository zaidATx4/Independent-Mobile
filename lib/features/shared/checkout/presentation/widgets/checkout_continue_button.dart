import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CheckoutContinueButton extends StatelessWidget {
  final String? price;
  final String currency;
  final String? buttonText;
  final String? text; // Alternative: single text for the button
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;

  const CheckoutContinueButton({
    super.key,
    this.price,
    this.currency = 'SAR',
    this.buttonText,
    this.text, // For simple text-only buttons
    this.onPressed,
    this.isLoading = false,
    this.enabled = true,
  }) : assert(
         (price != null && buttonText != null) || text != null,
         'Either provide price+buttonText or text parameter',
       );

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Theme-aware button background: #1A1A1A for light theme, #FFFBF1 for dark theme
    final buttonColor = isDarkMode ? const Color(0xFFFFFBF1) : const Color(0xFF1A1A1A);
    // Theme-aware text color: light text on dark button in light theme, dark text on light button in dark theme
    final textColor = isDarkMode ? const Color(0xFF242424) : const Color(0xFFFEFEFF);
    
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: enabled && !isLoading 
            ? buttonColor
            : buttonColor.withValues(alpha: 0.5), // disabled/loading
        borderRadius: BorderRadius.circular(44),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled && !isLoading ? onPressed : null,
          borderRadius: BorderRadius.circular(44),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        textColor, // Theme-aware color
                      ),
                    ),
                  )
                else if (text != null) ...[
                  // Simple text-only button
                  Flexible(
                    child: Text(
                      text!,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: textColor, // Theme-aware color
                        height: 24 / 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ]
                else ...[
                  // Price Section
                  Flexible(
                    flex: 0,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          price!,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: textColor, // Theme-aware color
                            height: 24 / 16,
                          ),
                        ),
                        const SizedBox(width: 4),
                        // SAR Currency Icon
                        SizedBox(
                          width: 11,
                          height: 12,
                          child: SvgPicture.asset(
                            'assets/images/icons/SVGs/Loyalty/SAR.svg',
                            colorFilter: ColorFilter.mode(
                              textColor, // Theme-aware color
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Separator
                  const SizedBox(width: 8),
                  Text(
                    '|',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: textColor, // Theme-aware color
                      height: 24 / 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Button Text
                  Flexible(
                    child: Text(
                      buttonText!,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: textColor, // Theme-aware color
                        height: 24 / 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CheckoutContinueButtonSkeleton extends StatelessWidget {
  const CheckoutContinueButtonSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFF4D4E52).withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(44),
      ),
      child: const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              Color(0xFF9C9C9D),
            ),
          ),
        ),
      ),
    );
  }
}