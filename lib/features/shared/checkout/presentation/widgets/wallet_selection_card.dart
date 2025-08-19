import 'package:flutter/material.dart';

import '../../domain/entities/checkout_entities.dart';

/// Wallet Selection Card Widget
/// Displays wallet information with radio button selection
/// Matches Figma design exactly for wallet payment selection
class WalletSelectionCard extends StatelessWidget {
  final WalletEntity wallet;
  final bool isSelected;
  final double transactionAmount;
  final VoidCallback onTap;

  const WalletSelectionCard({
    super.key,
    required this.wallet,
    required this.isSelected,
    required this.transactionAmount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool canUseWallet = wallet.canBeUsed && 
                             wallet.hasSufficientBalance(transactionAmount);
    
    return GestureDetector(
      onTap: canUseWallet ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xFF4D4E52), width: 1),
            bottom: BorderSide(color: Color(0xFF4D4E52), width: 1),
          ),
        ),
        child: Row(
          children: [
            // Wallet details (name and balance)
            Expanded(
              child: _buildWalletDetails(canUseWallet),
            ),
            
            // Radio button
            _buildRadioButton(canUseWallet),
          ],
        ),
      ),
    );
  }


  /// Build wallet details section with name and balance
  Widget _buildWalletDetails(bool canUseWallet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Wallet name - exact Figma typography
        Text(
          wallet.name,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: canUseWallet 
                ? const Color(0xCCFEFEFF) // 80% opacity white for enabled
                : const Color(0xFF6B6B6B), // Dimmed for disabled
            height: 21 / 14, // Line height from Figma
          ),
        ),
        
        const SizedBox(height: 2),
        
        // Balance display - exact Figma styling
        Text(
          'Balance: ${wallet.formattedBalance}',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: canUseWallet
                ? const Color(0xFF9C9C9D) // Secondary text color for enabled
                : const Color(0xFF6B6B6B), // Dimmed for disabled
            height: 18 / 12, // Line height from Figma
          ),
        ),
        
        // Show insufficient balance warning if needed
        if (!wallet.hasSufficientBalance(transactionAmount) && wallet.canBeUsed)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              'Insufficient balance',
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 11,
                fontWeight: FontWeight.normal,
                color: Color(0xFFFF6B6B), // Red color for warning
                height: 16 / 11,
              ),
            ),
          ),
          
        // Show wallet status if not active
        if (!wallet.isActive)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              'Wallet not available',
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 11,
                fontWeight: FontWeight.normal,
                color: Color(0xFFFF6B6B), // Red color for warning
                height: 16 / 11,
              ),
            ),
          ),
          
        // Show expiry warning if wallet is expired
        if (wallet.isExpired)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              'Wallet expired',
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 11,
                fontWeight: FontWeight.normal,
                color: Color(0xFFFF6B6B), // Red color for warning
                height: 16 / 11,
              ),
            ),
          ),
      ],
    );
  }

  /// Build radio button for wallet selection
  Widget _buildRadioButton(bool canUseWallet) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: canUseWallet
              ? (isSelected 
                  ? const Color(0xFFFEFEFF) // White border when selected and enabled
                  : const Color(0xFF4D4E52)) // Gray border when not selected but enabled
              : const Color(0xFF6B6B6B), // Dimmed border when disabled
          width: 2,
        ),
      ),
      child: (isSelected && canUseWallet)
          ? Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFEFEFF), // White dot when selected
                ),
              ),
            )
          : null,
    );
  }
}