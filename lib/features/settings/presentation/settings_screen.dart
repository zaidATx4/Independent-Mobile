import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    
    // Responsive banner height (minimum 160px, maximum 220px)
    final bannerHeight = (screenHeight * 0.25).clamp(160.0, 220.0);
    
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Column(
        children: [
          // Banner Section with Header and Profile
          Container(
            height: bannerHeight,
            width: screenWidth,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/illustrations/Settings_Banner_design_Dark.png'),
                fit: BoxFit.cover,
                opacity: 0.2,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Header with Profile title and close button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Profile',
                          style: TextStyle(
                            color: Color(0xFFFEFEFF),
                            fontSize: 24,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                    
                    const SizedBox(height: 24),
                    
                    // Profile Header
                    Expanded(
                      child: _buildProfileHeader(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Settings Menu Section
          Expanded(
            child: Container(
              width: screenWidth,
              decoration: const BoxDecoration(
                color: Color(0xFF1A1A1A),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 24.0),
                  child: Column(
                    children: [
                      _buildSettingsItem(
                        svgPath: 'assets/images/icons/SVGs/Settings/Payment_Method_Icon_Dark.svg',
                        title: 'Payment Methods',
                        subtitle: 'Add Cards, Delete Cards',
                        onTap: () => _handleNavigation(context, '/payment-methods'),
                      ),
                      _buildSettingsItem(
                        svgPath: 'assets/images/icons/SVGs/Settings/Theme_Icon_dark.svg',
                        title: 'Theme',
                        subtitle: 'Select theme',
                        onTap: () => _handleNavigation(context, '/theme'),
                      ),
                      _buildSettingsItem(
                        svgPath: 'assets/images/icons/SVGs/Settings/Language_Icon_dark.svg',
                        title: 'Language',
                        subtitle: 'Select Language',
                        onTap: () => _handleNavigation(context, '/language'),
                      ),
                      _buildSettingsItem(
                        svgPath: 'assets/images/icons/SVGs/Settings/Country_Icon_Dark.svg',
                        title: 'Country',
                        subtitle: 'Select Country',
                        onTap: () => _handleNavigation(context, '/country'),
                      ),
                      _buildSettingsItem(
                        svgPath: 'assets/images/icons/SVGs/Settings/Order_History_dark.svg',
                        title: 'Order History',
                        subtitle: 'Order details, Download Invoice',
                        onTap: () => _handleNavigation(context, '/order-history'),
                      ),
                      _buildSettingsItem(
                        svgPath: 'assets/images/icons/SVGs/Settings/Top_Choices_Dark.svg',
                        title: 'Top Choices',
                        subtitle: 'Favorite Dishes, Favorite Restaurants',
                        onTap: () => _handleNavigation(context, '/favorites'),
                      ),
                      _buildSettingsItem(
                        svgPath: 'assets/images/icons/SVGs/Settings/Terms_And_Conditions_dark.svg',
                        title: 'Terms & Conditions',
                        subtitle: 'Payment Policy, Loyalty & Rewards Terms',
                        onTap: () => _handleNavigation(context, '/terms'),
                      ),
                      _buildSettingsItem(
                        svgPath: 'assets/images/icons/SVGs/Settings/Log_Out_dark.svg',
                        title: 'Log out',
                        onTap: () => _handleLogout(context),
                      ),
                      // Extra padding at bottom to ensure no overlap
                      SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      children: [
        // Profile Image - Responsive size
        Container(
          width: 75,
          height: 75,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            image: const DecorationImage(
              image: AssetImage(
                'assets/images/illustrations/profile_Image.jpg',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 24),
        // Profile Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'John Smith',
                style: TextStyle(
                  color: Color(0xFFFEFEFF),
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                'independent@example.com',
                style: TextStyle(
                  color: const Color(0xFFFEFEFF).withValues(alpha: 0.8),
                  fontSize: 12,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.normal,
                  height: 1.5,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                '+971 50 123 4567',
                style: TextStyle(
                  color: const Color(0xFFFEFEFF).withValues(alpha: 0.8),
                  fontSize: 12,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.normal,
                  height: 1.5,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem({
    required String svgPath,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFF4D4E52), width: 1)),
        ),
        child: Row(
          children: [
            // SVG Icon
            SizedBox(
              width: 40,
              height: 40,
              child: SvgPicture.asset(
                svgPath,
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 16),
            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFFFEFEFF),
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF9C9C9D),
                        fontSize: 12,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.normal,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleNavigation(BuildContext context, String route) {
    context.push(route);
  }

  void _handleLogout(BuildContext context) {
    // TODO: Implement logout logic
    context.go('/welcome');
  }
}
