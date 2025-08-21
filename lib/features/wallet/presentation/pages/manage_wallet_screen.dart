import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Wallet management screen
/// Provides access to wallet settings, security options, and account management
class ManageWalletScreen extends ConsumerStatefulWidget {
  const ManageWalletScreen({super.key});

  @override
  ConsumerState<ManageWalletScreen> createState() => _ManageWalletScreenState();
}

class _ManageWalletScreenState extends ConsumerState<ManageWalletScreen> {
  bool notificationsEnabled = true;
  bool autoTopUpEnabled = false;
  bool biometricEnabled = true;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A), // indpt/neutral
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    
                    // Account section
                    _buildAccountSection(),
                    
                    const SizedBox(height: 32),
                    
                    // Security section
                    _buildSecuritySection(),
                    
                    const SizedBox(height: 32),
                    
                    // Preferences section
                    _buildPreferencesSection(),
                    
                    const SizedBox(height: 32),
                    
                    // Support section
                    _buildSupportSection(),
                    
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Back button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFFEFEFF), // indpt/text primary
                width: 1,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => context.pop(),
                borderRadius: BorderRadius.circular(20),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Color(0xFFFEFEFF), // indpt/text primary
                  size: 16,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Title
          const Expanded(
            child: Text(
              'Manage Wallet',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 24,
                fontWeight: FontWeight.w700, // Bold
                color: Color(0xFFFEFEFF), // indpt/text primary
                height: 32 / 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Account',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            fontWeight: FontWeight.w500, // Medium
            color: Color(0xFFFEFEFF), // indpt/text primary
            height: 24 / 16,
          ),
        ),
        
        const SizedBox(height: 16),
        
        Column(
          children: [
            _buildMenuOption(
              title: 'Payment Methods',
              subtitle: 'Manage your cards and payment options',
              icon: Icons.payment,
              onTap: () => context.push('/wallet/payment-methods'),
            ),
            
            const SizedBox(height: 12),
            
            _buildMenuOption(
              title: 'Auto Top-up',
              subtitle: 'Automatically add money when balance is low',
              icon: Icons.refresh,
              trailing: Switch(
                value: autoTopUpEnabled,
                onChanged: (value) {
                  setState(() {
                    autoTopUpEnabled = value;
                  });
                },
                activeColor: const Color(0xFFFFFBF1), // indpt/sand
                activeTrackColor: const Color(0xFFFFFBF1).withValues(alpha: 0.3),
                inactiveThumbColor: const Color(0xFF9C9C9D), // indpt/text tertiary
                inactiveTrackColor: const Color(0xFF4D4E52), // indpt/stroke
              ),
            ),
            
            const SizedBox(height: 12),
            
            _buildMenuOption(
              title: 'Transaction Limits',
              subtitle: 'Set daily and monthly spending limits',
              icon: Icons.account_balance_wallet,
              onTap: () => context.push('/wallet/limits'),
            ),
            
            const SizedBox(height: 12),
            
            _buildMenuOption(
              title: 'Currency Settings',
              subtitle: 'Saudi Riyal (SAR)',
              icon: Icons.currency_exchange,
              onTap: () => context.push('/wallet/currency'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSecuritySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Security',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            fontWeight: FontWeight.w500, // Medium
            color: Color(0xFFFEFEFF), // indpt/text primary
            height: 24 / 16,
          ),
        ),
        
        const SizedBox(height: 16),
        
        Column(
          children: [
            _buildMenuOption(
              title: 'Biometric Authentication',
              subtitle: 'Use fingerprint or face ID for payments',
              icon: Icons.fingerprint,
              trailing: Switch(
                value: biometricEnabled,
                onChanged: (value) {
                  setState(() {
                    biometricEnabled = value;
                  });
                },
                activeColor: const Color(0xFFFFFBF1), // indpt/sand
                activeTrackColor: const Color(0xFFFFFBF1).withValues(alpha: 0.3),
                inactiveThumbColor: const Color(0xFF9C9C9D), // indpt/text tertiary
                inactiveTrackColor: const Color(0xFF4D4E52), // indpt/stroke
              ),
            ),
            
            const SizedBox(height: 12),
            
            _buildMenuOption(
              title: 'PIN Management',
              subtitle: 'Change your wallet PIN',
              icon: Icons.lock,
              onTap: () => context.push('/wallet/pin'),
            ),
            
            const SizedBox(height: 12),
            
            _buildMenuOption(
              title: 'Two-Factor Authentication',
              subtitle: 'Add extra security to your account',
              icon: Icons.security,
              onTap: () => context.push('/wallet/2fa'),
            ),
            
            const SizedBox(height: 12),
            
            _buildMenuOption(
              title: 'Freeze Wallet',
              subtitle: 'Temporarily disable all transactions',
              icon: Icons.block,
              onTap: () => _showFreezeWalletDialog(),
              isDestructive: true,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPreferencesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Preferences',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            fontWeight: FontWeight.w500, // Medium
            color: Color(0xFFFEFEFF), // indpt/text primary
            height: 24 / 16,
          ),
        ),
        
        const SizedBox(height: 16),
        
        Column(
          children: [
            _buildMenuOption(
              title: 'Notifications',
              subtitle: 'Transaction alerts and promotional offers',
              icon: Icons.notifications,
              trailing: Switch(
                value: notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    notificationsEnabled = value;
                  });
                },
                activeColor: const Color(0xFFFFFBF1), // indpt/sand
                activeTrackColor: const Color(0xFFFFFBF1).withValues(alpha: 0.3),
                inactiveThumbColor: const Color(0xFF9C9C9D), // indpt/text tertiary
                inactiveTrackColor: const Color(0xFF4D4E52), // indpt/stroke
              ),
            ),
            
            const SizedBox(height: 12),
            
            _buildMenuOption(
              title: 'Receipt Settings',
              subtitle: 'Choose how you receive transaction receipts',
              icon: Icons.receipt,
              onTap: () => context.push('/wallet/receipts'),
            ),
            
            const SizedBox(height: 12),
            
            _buildMenuOption(
              title: 'Privacy Settings',
              subtitle: 'Control what information is shared',
              icon: Icons.privacy_tip,
              onTap: () => context.push('/wallet/privacy'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Support',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            fontWeight: FontWeight.w500, // Medium
            color: Color(0xFFFEFEFF), // indpt/text primary
            height: 24 / 16,
          ),
        ),
        
        const SizedBox(height: 16),
        
        Column(
          children: [
            _buildMenuOption(
              title: 'Help Center',
              subtitle: 'Find answers to common questions',
              icon: Icons.help,
              onTap: () => context.push('/wallet/help'),
            ),
            
            const SizedBox(height: 12),
            
            _buildMenuOption(
              title: 'Contact Support',
              subtitle: 'Get help from our support team',
              icon: Icons.support_agent,
              onTap: () => context.push('/wallet/support'),
            ),
            
            const SizedBox(height: 12),
            
            _buildMenuOption(
              title: 'Terms & Conditions',
              subtitle: 'Review wallet terms and policies',
              icon: Icons.description,
              onTap: () => context.push('/wallet/terms'),
            ),
            
            const SizedBox(height: 12),
            
            _buildMenuOption(
              title: 'Close Wallet',
              subtitle: 'Permanently close your wallet account',
              icon: Icons.close,
              onTap: () => _showCloseWalletDialog(),
              isDestructive: true,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMenuOption({
    required String title,
    required String subtitle,
    required IconData icon,
    VoidCallback? onTap,
    Widget? trailing,
    bool isDestructive = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFF2A2A2A),
        border: Border.all(
          color: const Color(0xFF4D4E52), // indpt/stroke
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDestructive 
                        ? const Color(0xFFFF2323).withValues(alpha: 0.1) // Error with opacity
                        : const Color(0xFF4D4E52).withValues(alpha: 0.3),
                  ),
                  child: Icon(
                    icon,
                    color: isDestructive 
                        ? const Color(0xFFFF2323) // indpt/Error/500
                        : const Color(0xFFFEFEFF), // indpt/text primary
                    size: 20,
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Title and subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w500, // Medium
                          color: isDestructive 
                              ? const Color(0xFFFF2323) // indpt/Error/500
                              : const Color(0xFFFEFEFF), // indpt/text primary
                          height: 21 / 14,
                        ),
                      ),
                      
                      const SizedBox(height: 2),
                      
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF9C9C9D), // indpt/text tertiary
                          height: 18 / 12,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Trailing widget (switch or arrow)
                if (trailing != null) 
                  trailing
                else if (onTap != null)
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFF9C9C9D), // indpt/text tertiary
                    size: 12,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFreezeWalletDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Freeze Wallet',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFFFEFEFF), // indpt/text primary
          ),
        ),
        content: const Text(
          'Are you sure you want to freeze your wallet? This will temporarily disable all transactions until you unfreeze it.',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xCCFEFEFF), // indpt/text secondary
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF9C9C9D), // indpt/text tertiary
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Implement freeze wallet functionality
            },
            child: const Text(
              'Freeze',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFFFF2323), // indpt/Error/500
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCloseWalletDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Close Wallet',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFFFF2323), // indpt/Error/500
          ),
        ),
        content: const Text(
          'This action is permanent and cannot be undone. Your wallet balance will be transferred to your bank account within 3-5 business days.',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xCCFEFEFF), // indpt/text secondary
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF9C9C9D), // indpt/text tertiary
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Implement close wallet functionality
            },
            child: const Text(
              'Close Wallet',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFFFF2323), // indpt/Error/500
              ),
            ),
          ),
        ],
      ),
    );
  }
}