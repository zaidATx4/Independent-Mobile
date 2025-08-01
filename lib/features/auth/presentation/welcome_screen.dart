import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/auth_colors.dart';
import '../../../core/utils/validation_service.dart';
import '../../country/presentation/country_selection_screen.dart';

final phoneNumberProvider = StateProvider<String>((ref) => '');
final phoneErrorProvider = StateProvider<String?>((ref) => null);

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phoneNumber = ref.watch(phoneNumberProvider);
    final phoneError = ref.watch(phoneErrorProvider);
    final selectedCountry = ref.watch(selectedCountryProvider);
    final screenSize = MediaQuery.of(context).size;

    // Calculate responsive dimensions based on 393x808 reference
    final containerWidth = (screenSize.width * 361 / 393);
    final leftPosition = (screenSize.width * 16 / 393);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image with proper full-screen coverage
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgrounds/Select_Language.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                // Fallback gradient background
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.grey.shade800, Colors.grey.shade900],
                    ),
                  ),
                );
              },
            ),
          ),

          // Dark overlay for better visibility
          Container(color: Colors.black.withValues(alpha: 0.5)),

          // Welcome modal with blur effect - centered positioning
          Center(
            child: Container(
              width: containerWidth,
              margin: EdgeInsets.symmetric(horizontal: leftPosition),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 10.5,
                    sigmaY: 10.5,
                  ), // 70% blur effect
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 16,
                      right: 24,
                      bottom: 16,
                      left: 24,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Back button and title row
                        Row(
                          children: [
                            // Back button
                            GestureDetector(
                              onTap: () {
                                context.go('/country-selection');
                              },
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: AuthColors.textPrimary,
                                  size: 18,
                                ),
                              ),
                            ),
                            
                            const Expanded(
                              child: Text(
                                'Welcome',
                                style: TextStyle(
                                  color: AuthColors.textPrimary,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            
                            const SizedBox(width: 32), // Balance the back button
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Phone number input field with country code prefix
                        Container(
                          width: 313,
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(34),
                            border: Border.all(
                              color: const Color(0xCCFEFEFF), // #FEFEFFCC
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              // Country code prefix
                              Container(
                                padding: const EdgeInsets.only(left: 16, right: 8),
                                child: Text(
                                  selectedCountry.countryCode,
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    height: 1.5,
                                    color: AuthColors.textPrimary,
                                  ),
                                ),
                              ),
                              // Separator
                              Container(
                                width: 1,
                                height: 20,
                                color: const Color(0xCCFEFEFF),
                              ),
                              // Phone number input
                              Expanded(
                                child: TextField(
                                  onChanged: (value) {
                                    ref.read(phoneNumberProvider.notifier).state = value;
                                    // Clear error when user starts typing
                                    if (phoneError != null) {
                                      ref.read(phoneErrorProvider.notifier).state = null;
                                    }
                                  },
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    height: 1.5,
                                    color: AuthColors.textPrimary,
                                  ),
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    hintText: ValidationService.getSampleFormat(selectedCountry),
                                    hintStyle: const TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      height: 1.5,
                                      color: AuthColors.textSecondary,
                                    ),
                                    filled: false,
                                    fillColor: Colors.transparent,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    border: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    focusedErrorBorder: InputBorder.none,
                                    contentPadding: const EdgeInsets.only(
                                      top: 12,
                                      right: 16,
                                      bottom: 12,
                                      left: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Error message display
                        if (phoneError != null) ...[
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Text(
                              phoneError,
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 24),

                        // Send OTP button with validation
                        Container(
                          width: 313,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(44),
                            color: const Color(
                              0xFFFFFBF1,
                            ), // #FFFBF1 (--indpt-sand)
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              _handleSendOTP(context, ref, phoneNumber, selectedCountry);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.black,
                              shadowColor: Colors.transparent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(44),
                              ),
                              padding: const EdgeInsets.only(
                                top: 12,
                                right: 16,
                                bottom: 12,
                                left: 16,
                              ),
                            ),
                            child: Container(
                              width: 71,
                              height: 24,
                              alignment: Alignment.center,
                              child: const Text(
                                'Send OTP',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // "or, sign up with" section with exact specifications
                        SizedBox(
                          width: 313,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Divider with "or, sign up with" text
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 1,
                                      color: AuthColors.textSecondary,
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: Text(
                                      'or, sign up with',
                                      style: TextStyle(
                                        color: AuthColors.textSecondary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 1,
                                      color: AuthColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8), // gap: 8px
                              // Social login icons
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Google icon
                                  GestureDetector(
                                    onTap: () {
                                      _handleSocialLogin(context, 'Google');
                                    },
                                    child: Image.asset(
                                      'assets/images/icons/Google_Icon.png',
                                      width: 24,
                                      height: 24,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return const Icon(
                                              Icons.g_mobiledata,
                                              color: AuthColors.textPrimary,
                                              size: 24,
                                            );
                                          },
                                    ),
                                  ),

                                  const SizedBox(width: 16),

                                  // Facebook icon
                                  GestureDetector(
                                    onTap: () {
                                      _handleSocialLogin(context, 'Facebook');
                                    },
                                    child: Image.asset(
                                      'assets/images/icons/Facebook_Icon.png',
                                      width: 24,
                                      height: 24,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return const Icon(
                                              Icons.facebook,
                                              color: AuthColors.textPrimary,
                                              size: 24,
                                            );
                                          },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // "Don't have an account? Sign up" text
                        SizedBox(
                          width: 313,
                          child: GestureDetector(
                            onTap: () {
                              // Navigate to sign up screen
                              context.go('/sign-up');
                            },
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Don't have an account ? ",
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      height:
                                          1.5, // line-height: 18px / font-size: 12px = 1.5
                                      color: Color(
                                        0xCCFEFEFF,
                                      ), // #FEFEFFCC (--indpt-text-secondary)
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Sign up",
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      height:
                                          1.5, // line-height: 18px / font-size: 12px = 1.5
                                      color: Color(
                                        0xFFFEFEFF,
                                      ), // #FEFEFF (--indpt-text-primary)
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSocialLogin(BuildContext context, String provider) {
    // Handle social login logic here
    // For now, navigate to home screen
    context.go('/home');
  }

  void _handleSendOTP(BuildContext context, WidgetRef ref, String phoneNumber, Country selectedCountry) {
    // Validate phone number
    final error = ValidationService.validatePhoneNumber(phoneNumber, selectedCountry);
    
    if (error != null) {
      // Show error
      ref.read(phoneErrorProvider.notifier).state = error;
      return;
    }
    
    // Clear any existing error
    ref.read(phoneErrorProvider.notifier).state = null;
    
    // Navigate to OTP verification screen
    context.go('/otp-verification');
  }
}
