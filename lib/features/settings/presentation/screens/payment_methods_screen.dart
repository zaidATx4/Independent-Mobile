import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PaymentMethodsScreen extends ConsumerWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Stack(
        children: [
          // Main Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Payment Methods',
                        style: TextStyle(
                          color: Color(0xFFFEFEFF),
                          fontSize: 24,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Close Button
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFBF1),
                            borderRadius: BorderRadius.circular(44),
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Color(0xFF242424),
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Add Card Button
                        _buildAddCardButton(),
                        const SizedBox(height: 24),

                        // Saved Cards
                        const Text(
                          'Saved Cards',
                          style: TextStyle(
                            color: Color(0xFFFEFEFF),
                            fontSize: 18,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Card List
                        _buildSavedCard(
                          cardType: 'Visa',
                          lastFourDigits: '4567',
                          expiryDate: '12/25',
                        ),
                        const SizedBox(height: 12),
                        _buildSavedCard(
                          cardType: 'Mastercard',
                          lastFourDigits: '8901',
                          expiryDate: '09/24',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddCardButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // TODO: Implement add card functionality
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Color(0xFFFEFEFF),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Add New Card',
                  style: TextStyle(
                    color: Color(0xFFFEFEFF),
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSavedCard({
    required String cardType,
    required String lastFourDigits,
    required String expiryDate,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // TODO: Implement card management
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Icon(
                    cardType == 'Visa' ? Icons.credit_card : Icons.credit_card,
                    color: const Color(0xFFFEFEFF),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$cardType ending in $lastFourDigits',
                        style: const TextStyle(
                          color: Color(0xFFFEFEFF),
                          fontSize: 14,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Expires $expiryDate',
                        style: TextStyle(
                          color: const Color(0xFFFEFEFF).withValues(alpha: 0.8),
                          fontSize: 12,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.more_vert, color: Color(0xFFFEFEFF), size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
