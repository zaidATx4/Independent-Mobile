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
  final bool isFirstItem;

  const WalletSelectionCard({
    super.key,
    required this.wallet,
    required this.isSelected,
    required this.transactionAmount,
    required this.onTap,
    this.isFirstItem = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool canUseWallet = wallet.canBeUsed && 
                             wallet.hasSufficientBalance(transactionAmount);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: canUseWallet ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            top: isFirstItem ? BorderSide(
              color: isDarkMode ? const Color(0xFF4D4E52) : const Color(0xFFD9D9D9), 
              width: 1
            ) : BorderSide.none,
            bottom: BorderSide(
              color: isDarkMode ? const Color(0xFF4D4E52) : const Color(0xFFD9D9D9), 
              width: 1
            ),
          ),
        ),
        child: Row(
          children: [
            // Wallet details (name and balance)
            Expanded(
              child: _buildWalletDetails(canUseWallet, isDarkMode),
            ),
            
            // Radio button
            _buildRadioButton(canUseWallet, isDarkMode),
          ],
        ),
      ),
    );
  }


  /// Build wallet details section with name and balance
  Widget _buildWalletDetails(bool canUseWallet, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Wallet name - theme-aware typography
        Text(
          wallet.name,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: canUseWallet 
                ? (isDarkMode ? const Color(0xCCFEFEFF) : const Color(0xFF1A1A1A)) // Theme-aware enabled color
                : const Color(0xFF6B6B6B), // Dimmed for disabled (same for both themes)
            height: 21 / 14, // Line height from Figma
          ),
        ),
        
        const SizedBox(height: 2),
        
        // Balance display - theme-aware styling
        Text(
          'Balance: ${wallet.formattedBalance}',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: canUseWallet
                ? (isDarkMode ? const Color(0xFF9C9C9D) : const Color(0xFF878787)) // Theme-aware secondary color
                : const Color(0xFF6B6B6B), // Dimmed for disabled (same for both themes)
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
  Widget _buildRadioButton(bool canUseWallet, bool isDarkMode) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: canUseWallet
              ? (isSelected 
                  ? (isDarkMode ? const Color(0xFFFEFEFF) : const Color(0xFF1A1A1A)) // Theme-aware selected border
                  : (isDarkMode ? const Color(0xFF4D4E52) : const Color(0xFFD9D9D9))) // Theme-aware unselected border
              : const Color(0xFF6B6B6B), // Dimmed border when disabled (same for both themes)
          width: 2,
        ),
      ),
      child: (isSelected && canUseWallet)
          ? Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDarkMode ? const Color(0xFFFEFEFF) : const Color(0xFF1A1A1A), // Theme-aware selected dot
                ),
              ),
            )
          : null,
    );
  }
}