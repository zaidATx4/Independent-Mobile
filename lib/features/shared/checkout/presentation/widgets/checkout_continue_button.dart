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
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: enabled && !isLoading 
            ? const Color(0xFFFFFBF1) // indpt/sand - enabled
            : const Color(0xFFFFFBF1).withValues(alpha: 0.5), // disabled/loading
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
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF242424), // indpt/accent
                      ),
                    ),
                  )
                else if (text != null) ...[
                  // Simple text-only button
                  Flexible(
                    child: Text(
                      text!,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF242424), // indpt/accent
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
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF242424), // indpt/accent
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
                            colorFilter: const ColorFilter.mode(
                              Color(0xFF242424), // indpt/accent
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Separator
                  const SizedBox(width: 8),
                  const Text(
                    '|',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF242424), // indpt/accent
                      height: 24 / 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Button Text
                  Flexible(
                    child: Text(
                      buttonText!,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF242424), // indpt/accent
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