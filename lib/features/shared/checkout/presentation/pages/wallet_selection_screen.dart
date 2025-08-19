import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../domain/entities/checkout_entities.dart';
import '../providers/checkout_providers.dart';
import '../widgets/wallet_selection_card.dart';

/// Wallet Payment Selection Screen
/// Matches Figma design exactly with pixel-perfect implementation
class WalletSelectionScreen extends ConsumerStatefulWidget {
  final double total;
  final String currency;

  const WalletSelectionScreen({
    super.key,
    required this.total,
    this.currency = 'SAR',
  });

  @override
  ConsumerState<WalletSelectionScreen> createState() => _WalletSelectionScreenState();
}

class _WalletSelectionScreenState extends ConsumerState<WalletSelectionScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize wallet selection when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeWallets();
    });
  }

  void _initializeWallets() {
    // Mock user ID for development - in production this would come from auth
    const userId = 'user_123';
    ref.read(walletSelectionProvider(widget.total).notifier).initializeWallets(userId);
  }

  @override
  Widget build(BuildContext context) {
    final wallets = ref.watch(availableWalletsProvider(widget.total));
    final selectedWallet = ref.watch(selectedWalletProvider(widget.total));
    final isLoading = ref.watch(walletSelectionLoadingProvider(widget.total));
    final error = ref.watch(walletSelectionErrorProvider(widget.total));
    final canProceed = ref.watch(canProceedWithWalletProvider(widget.total));

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A), // Dark theme background
      body: Column(
        children: [
          // Header with back button and title
          SafeArea(
            child: _buildHeader(context),
          ),
          
          // "To Pay" amount display
          _buildPaymentAmount(),
          
          // Wallet list or loading/error state
          Expanded(
            child: _buildWalletContent(
              wallets: wallets,
              selectedWallet: selectedWallet,
              isLoading: isLoading,
              error: error,
            ),
          ),
          
          // Bottom continue button
          _buildContinueButton(
            context: context,
            canProceed: canProceed,
            selectedWallet: selectedWallet,
          ),
        ],
      ),
    );
  }

  /// Build header with back arrow and "Choose Your Wallet" title
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Back button - exact Figma specifications
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFFEFEFF)),
                borderRadius: BorderRadius.circular(44),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Color(0xFFFEFEFF),
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Title - exact Figma typography
          const Expanded(
            child: Text(
              'Choose Your Wallet',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xCCFEFEFF), // 80% opacity white
                height: 32 / 24, // Line height from Figma
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build "To Pay: 10 ﷼" amount display
  Widget _buildPaymentAmount() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'To Pay: ',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFEFEFF), // Full opacity white
              height: 32 / 24,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            widget.total.toInt().toString(),
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFEFEFF),
              height: 32 / 24,
            ),
          ),
          const SizedBox(width: 4),
          // SAR currency symbol
          SvgPicture.asset(
            'assets/images/icons/Payment_Methods/SAR.svg',
            width: 14,
            height: 16,
            colorFilter: const ColorFilter.mode(
              Color(0xFFFEFEFF),
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }

  /// Build wallet content - list, loading, or error state
  Widget _buildWalletContent({
    required List<WalletEntity> wallets,
    required WalletEntity? selectedWallet,
    required bool isLoading,
    required String? error,
  }) {
    if (isLoading && wallets.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFFFEFEFF),
        ),
      );
    }

    if (error != null && wallets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Color(0xFFFEFEFF),
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              error,
              style: const TextStyle(
                color: Color(0xFFFEFEFF),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _initializeWallets,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFFBF1),
                foregroundColor: const Color(0xFF242424),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (wallets.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              color: Color(0xFFFEFEFF),
              size: 48,
            ),
            SizedBox(height: 16),
            Text(
              'No wallets available',
              style: TextStyle(
                color: Color(0xFFFEFEFF),
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        itemCount: wallets.length,
        itemBuilder: (context, index) {
          final wallet = wallets[index];
          final isSelected = selectedWallet?.id == wallet.id;
          
          return WalletSelectionCard(
            wallet: wallet,
            isSelected: isSelected,
            transactionAmount: widget.total,
            onTap: () => _onWalletTap(wallet),
          );
        },
      ),
    );
  }

  /// Build bottom continue button with amount and "Review Order"
  Widget _buildContinueButton({
    required BuildContext context,
    required bool canProceed,
    required WalletEntity? selectedWallet,
  }) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).padding.bottom + 8),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: canProceed ? () => _onContinuePressed(context) : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: canProceed 
                ? const Color(0xFFFFFBF1) // Active button color
                : const Color(0xFF4D4E52), // Disabled button color
            foregroundColor: canProceed 
                ? const Color(0xFF242424) // Active text color
                : const Color(0xFF9C9C9D), // Disabled text color
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(44),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Amount
              Text(
                widget.total.toInt().toString(),
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 24 / 16,
                ),
              ),
              const SizedBox(width: 4),
              // SAR symbol
              SvgPicture.asset(
                'assets/images/icons/Payment_Methods/SAR.svg',
                width: 11,
                height: 12,
                colorFilter: ColorFilter.mode(
                  canProceed 
                      ? const Color(0xFF242424) 
                      : const Color(0xFF9C9C9D),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              // Separator
              const Text(
                '|',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 24 / 16,
                ),
              ),
              const SizedBox(width: 8),
              // "Review Order" text
              const Text(
                'Review Order',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 24 / 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Handle wallet selection tap with security validation
  void _onWalletTap(WalletEntity wallet) {
    // Security validation before allowing selection
    if (!wallet.canBeUsed) {
      _showErrorMessage(context, 'This wallet is not available for transactions');
      return;
    }

    if (!wallet.hasSufficientBalance(widget.total)) {
      _showErrorMessage(context, 'Insufficient balance in this wallet');
      return;
    }

    if (wallet.isExpired) {
      _showErrorMessage(context, 'This wallet has expired');
      return;
    }

    // Additional security checks
    if (wallet.requiresBiometric) {
      // In production, this would trigger biometric authentication
    }

    // Proceed with wallet selection
    ref.read(walletSelectionProvider(widget.total).notifier).selectWallet(wallet);
  }

  /// Show error message to user
  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFFF6B6B), // Red color for errors
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Handle continue button press
  void _onContinuePressed(BuildContext context) {
    final selectedWallet = ref.read(selectedWalletProvider(widget.total));
    
    if (selectedWallet == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a wallet'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Update checkout state with selected wallet payment method
      ref.read(checkoutProvider.notifier).selectWalletPayment(selectedWallet);

      // Navigate to order review screen with wallet payment method
      context.push('/checkout/review-order');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Navigation error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}