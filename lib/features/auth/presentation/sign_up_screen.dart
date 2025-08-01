import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/auth_colors.dart';
import '../../../core/utils/validation_service.dart';
import '../../country/presentation/country_selection_screen.dart';

final usernameProvider = StateProvider<String>((ref) => '');
final emailProvider = StateProvider<String>((ref) => '');
final mobileNumberProvider = StateProvider<String>((ref) => '');

// Error providers
final usernameErrorProvider = StateProvider<String?>((ref) => null);
final emailErrorProvider = StateProvider<String?>((ref) => null);
final mobileErrorProvider = StateProvider<String?>((ref) => null);

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final username = ref.watch(usernameProvider);
    final email = ref.watch(emailProvider);
    final mobileNumber = ref.watch(mobileNumberProvider);
    final selectedCountry = ref.watch(selectedCountryProvider);
    
    final usernameError = ref.watch(usernameErrorProvider);
    final emailError = ref.watch(emailErrorProvider);
    final mobileError = ref.watch(mobileErrorProvider);
    
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

          // Sign up modal with blur effect - centered positioning
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
                      borderRadius: BorderRadius.circular(40),
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
                                context.go('/welcome');
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
                                'Sign up',
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

                        // Username input field
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
                          child: TextField(
                            onChanged: (value) {
                              ref.read(usernameProvider.notifier).state = value;
                              // Clear error when user starts typing
                              if (usernameError != null) {
                                ref.read(usernameErrorProvider.notifier).state = null;
                              }
                            },
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              height: 1.5,
                              color: AuthColors.textPrimary,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Username',
                              hintStyle: TextStyle(
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
                              contentPadding: EdgeInsets.only(
                                top: 12,
                                right: 16,
                                bottom: 12,
                                left: 16,
                              ),
                            ),
                          ),
                        ),

                        // Username error message
                        if (usernameError != null) ...[
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Text(
                              usernameError,
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 16),

                        // Email input field
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
                          child: TextField(
                            onChanged: (value) {
                              ref.read(emailProvider.notifier).state = value;
                              // Clear error when user starts typing
                              if (emailError != null) {
                                ref.read(emailErrorProvider.notifier).state = null;
                              }
                            },
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              height: 1.5,
                              color: AuthColors.textPrimary,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Email',
                              hintStyle: TextStyle(
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
                              contentPadding: EdgeInsets.only(
                                top: 12,
                                right: 16,
                                bottom: 12,
                                left: 16,
                              ),
                            ),
                          ),
                        ),

                        // Email error message
                        if (emailError != null) ...[
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Text(
                              emailError,
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 16),

                        // Mobile number input field
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
                          child: TextField(
                            onChanged: (value) {
                              ref.read(mobileNumberProvider.notifier).state = value;
                              // Clear error when user starts typing
                              if (mobileError != null) {
                                ref.read(mobileErrorProvider.notifier).state = null;
                              }
                            },
                            keyboardType: TextInputType.phone,
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              height: 1.5,
                              color: AuthColors.textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: '${selectedCountry.countryCode} ${ValidationService.getSampleFormat(selectedCountry)}',
                              hintStyle: TextStyle(
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
                              contentPadding: EdgeInsets.only(
                                top: 12,
                                right: 16,
                                bottom: 12,
                                left: 16,
                              ),
                            ),
                          ),
                        ),

                        // Mobile number error message
                        if (mobileError != null) ...[
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Text(
                              mobileError,
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
                              _handleSendOTP(context, ref, username, email, mobileNumber, selectedCountry);
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

                        // "or, Sign up with" section with exact specifications
                        SizedBox(
                          width: 313,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Divider with "or, Sign up with" text
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
                                      'or, Sign up with',
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
                                      _handleSocialSignUp(context, 'Google');
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
                                      _handleSocialSignUp(context, 'Facebook');
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

                        // "Already have an account? Sign in" text
                        SizedBox(
                          width: 313,
                          child: GestureDetector(
                            onTap: () {
                              // Navigate back to welcome screen
                              context.go('/welcome');
                            },
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Already have an account ? ",
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      height: 1.5,
                                      color: Color(
                                        0xCCFEFEFF,
                                      ), // #FEFEFFCC (--indpt-text-secondary)
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Sign in",
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      height: 1.5,
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

  void _handleSendOTP(BuildContext context, WidgetRef ref, String username, String email, String mobileNumber, Country selectedCountry) {
    // Clear all existing errors
    ref.read(usernameErrorProvider.notifier).state = null;
    ref.read(emailErrorProvider.notifier).state = null;
    ref.read(mobileErrorProvider.notifier).state = null;
    
    // Validate all fields
    bool hasErrors = false;
    
    final usernameError = ValidationService.validateUsername(username);
    if (usernameError != null) {
      ref.read(usernameErrorProvider.notifier).state = usernameError;
      hasErrors = true;
    }
    
    final emailError = ValidationService.validateEmail(email);
    if (emailError != null) {
      ref.read(emailErrorProvider.notifier).state = emailError;
      hasErrors = true;
    }
    
    final mobileError = ValidationService.validatePhoneNumber(mobileNumber, selectedCountry);
    if (mobileError != null) {
      ref.read(mobileErrorProvider.notifier).state = mobileError;
      hasErrors = true;
    }
    
    // If no errors, navigate to OTP verification
    if (!hasErrors) {
      context.go('/otp-verification');
    }
  }

  void _handleSocialSignUp(BuildContext context, String provider) {
    // Handle social sign up logic here
    // For now, navigate to home screen
    context.go('/home');
  }
}