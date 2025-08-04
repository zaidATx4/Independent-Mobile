import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/auth_colors.dart';
import '../../../core/utils/validation_service.dart';

final otpProvider = StateProvider<String>((ref) => '');
final phoneNumberDisplayProvider = StateProvider<String>((ref) => '');
final otpErrorProvider = StateProvider<String?>((ref) => null);

class OtpVerificationScreen extends ConsumerWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otp = ref.watch(otpProvider);
    final otpError = ref.watch(otpErrorProvider);
    final screenSize = MediaQuery.of(context).size;

    // Get phone number from URL parameters
    final uri = GoRouterState.of(context).uri;
    final phoneFromUrl = uri.queryParameters['phone'] ?? '';
    
    // Update phone number provider if we have data from URL
    if (phoneFromUrl.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(phoneNumberDisplayProvider.notifier).state = phoneFromUrl;
      });
    }
    
    final phoneNumber = ref.watch(phoneNumberDisplayProvider);

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

          // OTP verification modal with blur effect - centered positioning
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
                            
                            const SizedBox(width: 16),
                            
                            // OTP Verification heading
                            const Text(
                              'OTP Verification',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                height: 1.5,
                                color: AuthColors.textPrimary,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Note with phone number and change link
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // OTP sent message
                            Text(
                              'OTP has been sent to ${phoneNumber.isNotEmpty ? phoneNumber : '+971 - 1234567'}',
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                height: 1.5, // line-height: 18px / font-size: 12px = 1.5
                                color: AuthColors.textSecondary,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            
                            const SizedBox(width: 4),
                            
                            // Change link with exact specifications
                            GestureDetector(
                              onTap: () {
                                // Navigate back to welcome screen to change number
                                context.go('/welcome');
                              },
                              child: Container(
                                width: 50,
                                height: 18,
                                alignment: Alignment.center,
                                child: const Text(
                                  'Change',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    height: 1.5, // line-height: 18px / font-size: 12px = 1.5
                                    color: AuthColors.textPrimary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // 6 OTP input boxes
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(6, (index) {
                            return Container(
                              width: 40,
                              height: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Color(0xCCFEFEFF), // #FEFEFFCC
                                  width: 1,
                                ),
                                color: Colors.transparent, // Transparent background
                              ),
                              child: TextField(
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    // Move to next field
                                    if (index < 5) {
                                      FocusScope.of(context).nextFocus();
                                    }
                                  }
                                  // Update OTP string
                                  String currentOtp = ref.read(otpProvider);
                                  List<String> otpDigits = currentOtp.padRight(6).split('');
                                  otpDigits[index] = value;
                                  ref.read(otpProvider.notifier).state = otpDigits.join('').trim();
                                  
                                  // Clear error when user starts typing
                                  if (otpError != null) {
                                    ref.read(otpErrorProvider.notifier).state = null;
                                  }
                                },
                                style: const TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: AuthColors.textPrimary,
                                ),
                                decoration: const InputDecoration(
                                  counterText: '',
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  fillColor: Colors.transparent,
                                  filled: false,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            );
                          }),
                        ),

                        // OTP error message
                        if (otpError != null) ...[
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Text(
                              otpError,
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

                        // Resend OTP button
                        GestureDetector(
                          onTap: () {
                            // Handle resend OTP logic
                            _handleResendOtp(context);
                          },
                          child: const Text(
                            'Resend OTP',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              height: 1.5, // line-height: 18px / font-size: 12px = 1.5
                              color: AuthColors.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Continue button with exact specifications (matching Send OTP button)
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
                              _handleContinue(context, ref, otp);
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
                                'Continue',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
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

  void _handleResendOtp(BuildContext context) {
    // Handle resend OTP logic here
    // For now, show a simple message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('OTP resent successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleContinue(BuildContext context, WidgetRef ref, String otp) {
    // Validate OTP
    final error = ValidationService.validateOTP(otp);
    
    if (error != null) {
      // Show error
      ref.read(otpErrorProvider.notifier).state = error;
      return;
    }
    
    // Clear any existing error
    ref.read(otpErrorProvider.notifier).state = null;
    
    // Navigate to home screen
    context.go('/home');
  }
}