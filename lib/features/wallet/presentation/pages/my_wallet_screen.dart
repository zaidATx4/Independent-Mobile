import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

/// NOTE: Screen redesigned to match new wallet detail design (single centered card
/// with large balance, reset info, QR code, code fallback, info rows, and bottom
/// action bar). Old sectioned layout removed.

/// Individual wallet details screen - shows specific wallet details
/// Displays wallet balance, QR code, and transaction history for a specific wallet
/// Light theme version matching Figma design specifications
class MyWalletScreen extends ConsumerStatefulWidget {
  final String walletId;

  const MyWalletScreen({super.key, required this.walletId});

  @override
  ConsumerState<MyWalletScreen> createState() => _MyWalletScreenState();
}

class _MyWalletScreenState extends ConsumerState<MyWalletScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCF5), // dark/neutral (light theme background)
      body: Column(
        children: [
          SafeArea(bottom: false, child: _buildHeader(context)),
          Expanded(
            child: SingleChildScrollView(
              // No horizontal padding so card can be full-bleed
              child: Column(
                children: [
                  _buildCenteredWalletCard(context),
                  const SizedBox(height: 140),
                ],
              ),
            ),
          ),
          _buildBottomActions(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          _circleButton(
            onTap: () => context.pop(),
            border: true,
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 16,
              color: Color(0xCC1A1A1A), // dark/text secondary (light theme)
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Team Lunch', // TODO: make dynamic
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xCC1A1A1A), // dark/text secondary (light theme)
                height: 32 / 24,
              ),
            ),
          ),
          _circleButton(
            onTap: () => context.push('/wallet/manage'),
            fill: const Color(0xFF1A1A1A), // dark/sand (light theme)
            child: const Icon(
              Icons.settings,
              size: 20,
              color: Color(0xFFFEFEFF), // dark/accent (light theme)
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleButton({
    required VoidCallback onTap,
    required Widget child,
    bool border = false,
    Color? fill,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: fill ?? Colors.transparent,
        border: border
            ? Border.all(color: const Color(0xCC1A1A1A), width: 1) // dark/text secondary (light theme)
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Center(child: child),
        ),
      ),
    );
  }

  Widget _buildCenteredWalletCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
      decoration: BoxDecoration(
        color: const Color(0x0C1A1A1A), // Light theme card background - subtle dark overlay
        borderRadius: BorderRadius.circular(56),
      ),
      child: Column(
        children: [
          // Balance
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                '5,050', // TODO: dynamic
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A), // dark/text primary (light theme)
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 6),
              SvgPicture.asset(
                'assets/images/icons/Payment_Methods/SAR.svg',
                width: 20,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF1A1A1A), // dark/text primary (light theme)
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Next reset on May 1, 2025', // TODO dynamic reset date
            style: TextStyle(fontSize: 14, color: Color(0xCC1A1A1A)), // dark/text secondary (light theme)
          ),
          const SizedBox(height: 40),
          // QR code container (reduced size) PNG placeholder
          Container(
            width: 220,
            height: 220,
            decoration: const BoxDecoration(color: Color(0xFFFFFCF5)), // Same as background for light theme
            alignment: Alignment.center,
            child: Image.asset(
              'assets/images/Static/qr.png',
              width: 180,
              height: 180,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Scan this code at the counter to pay with your wallet.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Color(0xCC1A1A1A)), // dark/text secondary (light theme)
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: Container(height: 1, color: const Color(0x33878787)), // light theme divider
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Or',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1A1A1A), // dark/text primary (light theme)
                  ),
                ),
              ),
              Expanded(
                child: Container(height: 1, color: const Color(0x33878787)), // light theme divider
              ),
            ],
          ),
          const SizedBox(height: 28),
          // Code fallback box
          GestureDetector(
            onTap: () {}, // TODO: copy code
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFFFC940), width: 1), // Keep accent color
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'ALPHA-12345', // TODO dynamic code
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  color: Color(0xFF1A1A1A), // dark/text primary (light theme)
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Provide this code to the staff if scanning is unavailable.',
            textAlign: TextAlign.center,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.visible,
            style: TextStyle(fontSize: 14, color: Color(0xCC1A1A1A)), // dark/text secondary (light theme)
          ),
          const SizedBox(height: 48),
          _infoRow('Total Amount', '10,000'),
          const SizedBox(height: 24),
          _infoRow('Reset Schedule', 'Every 1st of the Month'),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1A1A), // dark/text primary (light theme)
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A), // dark/text primary (light theme)
              ),
            ),
            const SizedBox(width: 4),
            SvgPicture.asset(
              'assets/images/icons/Payment_Methods/SAR.svg',
              width: 12,
              height: 14,
              colorFilter: const ColorFilter.mode(
                Color(0xFF1A1A1A), // dark/text primary (light theme)
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        24,
        12,
        24,
        8 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F5), // Light theme bottom bar background
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(48),
          topRight: Radius.circular(48),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF1A1A1A), // dark/text primary (light theme)
                side: const BorderSide(color: Color(0xFF1A1A1A), width: 1), // dark/text primary border
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                padding: const EdgeInsets.symmetric(vertical: 18),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () => context.push('/wallet/transactions'),
              child: const Text('Transactions'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A1A1A), // dark/sand (light theme)
                foregroundColor: const Color(0xFFFEFEFF), // dark/accent (light theme)
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                padding: const EdgeInsets.symmetric(vertical: 18),
                elevation: 0,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              onPressed: () {}, // TODO: reset logic
              child: const Text('Reset now'),
            ),
          ),
        ],
      ),
    );
  }
}
