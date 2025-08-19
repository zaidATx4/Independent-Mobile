import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../domain/entities/checkout_entities.dart';

class PaymentMethodCard extends StatelessWidget {
  final PaymentMethodEntity paymentMethod;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodCard({
    super.key,
    required this.paymentMethod,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1), // Small margin for separator effect
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.zero,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFF4D4E52), width: 1), // indpt/stroke
                bottom: BorderSide(color: Color(0xFF4D4E52), width: 1), // indpt/stroke
              ),
            ),
            child: Row(
              children: [
                // Payment method icon - significantly enlarged for maximum visibility
                Container(
                  width: 56,
                  height: 56,
                  padding: const EdgeInsets.all(2),
                  child: _buildIcon(),
                ),
                
                const SizedBox(width: 16),
                
                // Payment method details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        paymentMethod.displayName,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w400, // Regular
                          color: Color(0xCCFEFEFF), // indpt/text secondary
                          height: 21 / 14, // lineHeight / fontSize
                        ),
                      ),
                      if (description.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          description,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 12,
                            fontWeight: FontWeight.w400, // Regular
                            color: Color(0xFF9C9C9D), // indpt/text tertiary
                            height: 18 / 12, // lineHeight / fontSize
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Radio button
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected 
                          ? const Color(0xFFFEFEFF) 
                          : const Color(0xFF4D4E52),
                      width: 2,
                    ),
                  ),
                  child: isSelected 
                      ? Center(
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFFEFEFF), // indpt/text primary
                            ),
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    // Handle different payment method types
    switch (paymentMethod.type) {
      case PaymentMethodType.card:
        if (paymentMethod.cardBrand?.toLowerCase() == 'visa') {
          return SvgPicture.asset(
            'assets/images/icons/Payment_Methods/Visa.svg',
            width: 52,
            height: 52,
          );
        } else if (paymentMethod.cardBrand?.toLowerCase() == 'mastercard') {
          return SvgPicture.asset(
            'assets/images/icons/Payment_Methods/Mastercard.svg',
            width: 52,
            height: 52,
          );
        } else if (paymentMethod.id == 'add_new') {
          return SvgPicture.asset(
            'assets/images/icons/Payment_Methods/Add_Card.svg',
            width: 52,
            height: 52,
            // Removed colorFilter to preserve original SVG colors
          );
        }
        break;
      
      case PaymentMethodType.applePay:
        return SvgPicture.asset(
          'assets/images/icons/Payment_Methods/Apple_Pay.svg',
          width: 52,
          height: 52,
        );
        
      case PaymentMethodType.googlePay:
        return SvgPicture.asset(
          'assets/images/icons/Payment_Methods/Google_Pay.svg',
          width: 52,
          height: 52,
        );
        
      case PaymentMethodType.cash:
        return SvgPicture.asset(
          'assets/images/icons/Payment_Methods/Cash.svg',
          width: 52,
          height: 52,
          // Removed colorFilter to preserve original SVG colors
        );
        
      case PaymentMethodType.wallet:
        return SvgPicture.asset(
          'assets/images/icons/Payment_Methods/Wallet.svg',
          width: 52,
          height: 52,
          // Removed colorFilter to preserve original SVG colors
        );
    }

    // Fallback to a generic icon
    return const Icon(
      Icons.payment,
      color: Color(0xCCFEFEFF), // indpt/text secondary
      size: 52,
    );
  }
}