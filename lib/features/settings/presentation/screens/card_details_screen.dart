import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CardDetailsScreen extends ConsumerWidget {
  final String cardId;

  const CardDetailsScreen({super.key, required this.cardId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isLightTheme = theme.brightness == Brightness.light;

    // Get card data based on cardId
    final cardData = _getCardData(cardId);

    return Scaffold(
      backgroundColor: isLightTheme
          ? const Color(0xFFFFFCF5)
          : const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context, isLightTheme),

            // Card Display
            Expanded(
              child: Align(
                alignment: const Alignment(0, -0.3), // Move up from center (-1 is top, 0 is center, 1 is bottom)
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: _buildCardWithPNG(cardData, isLightTheme),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isLightTheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isLightTheme
                      ? const Color(0xFF1A1A1A)
                      : const Color(0xFFFEFEFF),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(44),
              ),
              child: Icon(
                Icons.arrow_back,
                color: isLightTheme
                    ? const Color(0xFF1A1A1A)
                    : const Color(0xFFFEFEFF),
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Title
          Expanded(
            child: Text(
              'Card Details',
              style: TextStyle(
                color: isLightTheme
                    ? const Color(0xCC1A1A1A)
                    : const Color(0xCCFEFEFF),
                fontSize: 24,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                height: 32 / 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardWithPNG(CardData cardData, bool isLightTheme) {
    return Container(
      width: double.infinity,
      height: 220,
      child: Stack(
        children: [
          // Background PNG Image
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                cardData.backgroundImage,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Debug: Print error details
                  print('Error loading image: ${cardData.backgroundImage}');
                  print('Error: $error');

                  // Fallback if image not found
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color:
                          Colors.red, // Make it obvious when fallback is used
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error, color: Colors.white, size: 32),
                          SizedBox(height: 8),
                          Text(
                            'Image not found',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          Text(
                            cardData.backgroundImage,
                            style: TextStyle(color: Colors.white, fontSize: 10),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Card Number - positioned below chip area, left aligned
          Positioned(
            left: 24,
            top: 100, // Below chip area
            child: Text(
              cardData.maskedNumber,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                letterSpacing: 2,
                shadows: [
                  Shadow(
                    offset: Offset(0, 1),
                    blurRadius: 2,
                    color: Colors.black45,
                  ),
                ],
              ),
            ),
          ),

          // Bottom row with Card Holder and Expiry
          Positioned(
            left: 24,
            right: 24,
            bottom: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Card Holder section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   'CARD HOLDER',
                    //   style: TextStyle(
                    //     color: Colors.white.withOpacity(0.8),
                    //     fontSize: 10,
                    //     fontFamily: 'Roboto',
                    //     fontWeight: FontWeight.normal,
                    //     letterSpacing: 1,
                    //     shadows: const [
                    //       Shadow(
                    //         offset: Offset(0, 1),
                    //         blurRadius: 2,
                    //         color: Colors.black45,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    const SizedBox(height: 4),
                    Text(
                      cardData.cardHolderName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 2,
                            color: Colors.black45,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Expiry section - positioned to align with PNG label
                Container(
                  margin: const EdgeInsets.only(
                    right: 30,
                  ), // Adjust left alignment
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   'EXPIRES',
                      //   style: TextStyle(
                      //     color: Colors.white.withOpacity(0.8),
                      //     fontSize: 10,
                      //     fontFamily: 'Roboto',
                      //     fontWeight: FontWeight.normal,
                      //     letterSpacing: 1,
                      //     shadows: const [
                      //       Shadow(
                      //         offset: Offset(0, 1),
                      //         blurRadius: 2,
                      //         color: Colors.black45,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      const SizedBox(height: 4),
                      Text(
                        cardData.expiryDate,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 1),
                              blurRadius: 2,
                              color: Colors.black45,
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
        ],
      ),
    );
  }

  CardData _getCardData(String cardId) {
    // Mock data - in production this would come from a provider/repository
    switch (cardId) {
      case 'pm_visa_2345':
        return CardData(
          cardType: 'visa',
          maskedNumber: '**** **** **** 2345',
          expiryDate: '02/30',
          cardHolderName: 'JOHN DOE',
          backgroundImage:
              'assets/images/illustrations/Payement_Card_designs/Visa_1.png',
        );
      case 'pm_visa_1343':
        return CardData(
          cardType: 'visa',
          maskedNumber: '**** **** **** 1343',
          expiryDate: '03/29',
          cardHolderName: 'JOHN DOE',
          backgroundImage:
              'assets/images/illustrations/Payement_Card_designs/Visa_2.png',
        );
      case 'pm_mc_2345':
        return CardData(
          cardType: 'mastercard',
          maskedNumber: '**** **** **** 2345',
          expiryDate: '02/30',
          cardHolderName: 'JOHN DOE',
          backgroundImage:
              'assets/images/illustrations/Payement_Card_designs/Master_1.png',
        );
      case 'pm_mc_1343':
        return CardData(
          cardType: 'mastercard',
          maskedNumber: '**** **** **** 1343',
          expiryDate: '03/29',
          cardHolderName: 'JOHN DOE',
          backgroundImage:
              'assets/images/illustrations/Payement_Card_designs/Master_2.png',
        );
      default:
        return CardData(
          cardType: 'visa',
          maskedNumber: '**** **** **** 0000',
          expiryDate: '00/00',
          cardHolderName: 'UNKNOWN',
          backgroundImage:
              'assets/images/illustrations/Payement_Card_designs/Visa_1.png',
        );
    }
  }
}

class CardData {
  final String cardType;
  final String maskedNumber;
  final String expiryDate;
  final String cardHolderName;
  final String backgroundImage;

  const CardData({
    required this.cardType,
    required this.maskedNumber,
    required this.expiryDate,
    required this.cardHolderName,
    required this.backgroundImage,
  });
}
