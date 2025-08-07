import 'package:flutter/material.dart';
import '../../data/models/loyalty_member.dart';

class LoyaltyTransactionItem extends StatelessWidget {
  final LoyaltyTransaction transaction;

  const LoyaltyTransactionItem({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
      constraints: const BoxConstraints(minHeight: 55),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFF4D4E52), width: 1), // indpt/stroke
          bottom: BorderSide(color: Color(0xFF4D4E52), width: 1), // indpt/stroke
        ),
      ),
      child: Row(
        children: [
          // Transaction status circle with icon
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _getTransactionColor(transaction.type),
              borderRadius: BorderRadius.circular(44), // Fully circular
            ),
            child: Icon(
              _getTransactionIcon(transaction.type),
              color: const Color(0xFFFEFEFF), // White icon
              size: 16,
            ),
          ),
          const SizedBox(width: 16),
          // Transaction details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Points row
                Row(
                  children: [
                    Text(
                      '${transaction.points > 0 ? '+' : ''}${transaction.points} Points ',
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500, // Medium
                        fontSize: 14,
                        height: 21 / 14, // lineHeight / fontSize
                        color: Color(0xFFFEFEFF), // indpt/text primary
                      ),
                    ),
                  ],
                ),
                // Description
                Text(
                  transaction.description,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400, // Regular
                    fontSize: 12,
                    height: 18 / 12, // lineHeight / fontSize
                    color: Color(0xFF9C9C9D), // indpt/text tertiary
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Date
          Text(
            transaction.date,
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
    );
  }

  IconData _getTransactionIcon(String type) {
    switch (type.toLowerCase()) {
      case 'earned':
        return Icons.keyboard_arrow_up; // Up arrow for earned points
      case 'redeemed':
        return Icons.keyboard_arrow_down; // Down arrow for redeemed points
      case 'expired':
        return Icons.schedule; // Clock for expired points
      default:
        return Icons.keyboard_arrow_up;
    }
  }

  Color _getTransactionColor(String type) {
    switch (type.toLowerCase()) {
      case 'earned':
        return const Color(0xFF2BE519); // indpt/Success/500 for earned points
      case 'redeemed':
        return const Color(0xFFFF2323); // indpt/Error/500 for redeemed points
      case 'expired':
        return const Color(0xFF9C9C9D); // indpt/text tertiary for expired points
      default:
        return const Color(0xFF2BE519); // Default to success color
    }
  }
}