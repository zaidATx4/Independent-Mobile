import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';

class PaymentSuccessScreen extends ConsumerWidget {
  final String? orderNumber;
  final String? locationName;
  final String? locationAddress;
  final String? estimatedTime;
  
  const PaymentSuccessScreen({
    super.key,
    this.orderNumber,
    this.locationName,
    this.locationAddress,
    this.estimatedTime,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Static/Burger_Background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            // Header with back button in SafeArea
            SafeArea(
              child: _buildHeader(context),
            ),
            
            const Spacer(),
            
            // Glass blur overlay with success details - extends to bottom
            Expanded(
              flex: 0,
              child: _buildGlassmorphismOverlay(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Back button with glass effect
          InkWell(
            onTap: () => context.go('/home'),
            borderRadius: BorderRadius.circular(22),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Color(0xFFFEFEFF),
                    size: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassmorphismOverlay(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(40),
        topRight: Radius.circular(40),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            // Combined gradient: black 0.1 opacity + white 0.25 opacity
            color: const Color.fromRGBO(255, 255, 255, 0.25).withValues(alpha: 0.35),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            child: _buildSuccessContent(context),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessContent(BuildContext context) {
    return Column(
      children: [
        // Success title and message
        Column(
          children: [
            const Text(
              'Order Placed Successfully!',
              style: TextStyle(
                color: Color(0xFFFEFEFF),
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontFamily: 'Roboto',
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 16),
            
            const Text(
              'Thank you for your order! Your food is being prepared with love and care.',
              style: TextStyle(
                color: Color(0xCCFEFEFF),
                fontSize: 14,
                fontFamily: 'Roboto',
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 32),
          ],
        ),
        
        // Order details
        _buildOrderDetails(),
        
        const SizedBox(height: 32),
        
        // Back to Home button
        _buildBackToHomeButton(context),
      ],
    );
  }

  Widget _buildOrderDetails() {
    return Column(
      children: [
        // Pickup Location
        _buildDetailRow(
          icon: Icons.location_on_outlined,
          title: 'Pickup Location',
          subtitle: locationName ?? 'Mall of the Emirates',
          description: locationAddress ?? 'North Beach, Jumeirah 1, Dubai, UAE',
        ),
        
        const SizedBox(height: 16),
        
        // Pickup Time
        _buildDetailRow(
          icon: Icons.schedule_outlined,
          title: 'Pickup Time',
          subtitle: estimatedTime ?? '25-30 minutes',
          description: null,
        ),
      ],
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String subtitle,
    String? description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon with border
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0x40FEFEFF)),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Icon(
              icon,
              color: const Color(0xCCFEFEFF),
              size: 16,
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFFFEFEFF),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Roboto',
                  ),
                ),
                
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xCCFEFEFF),
                      fontSize: 14,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ],
                
                if (description != null && description.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Color(0xCCFEFEFF),
                      fontSize: 12,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackToHomeButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => GoRouter.of(context).go('/home'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFFBF1), // indpt/sand color
          foregroundColor: const Color(0xFF242424), // indpt/accent color
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(44),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Back to Home',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Roboto',
          ),
        ),
      ),
    );
  }

}