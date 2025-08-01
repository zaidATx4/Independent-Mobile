import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/auth_colors.dart';

enum Country {
  uae('United Arab Emirates', 'assets/images/icons/UAE_Flag_Icon.png', 'ae', '+971'),
  saudi('Saudi Arabia', 'assets/images/icons/Saudi_Flag_Icon.png', 'sa', '+966'),
  qatar('Qatar', 'assets/images/icons/Qatar_Flag_Icon.png', 'qa', '+974'),
  uk('United Kingdom', 'assets/images/icons/UK_Flag_Icon.png', 'uk', '+44');

  const Country(this.displayName, this.iconPath, this.code, this.countryCode);
  final String displayName;
  final String iconPath;
  final String code;
  final String countryCode;
}

final selectedCountryProvider = StateProvider<Country>(
  (ref) => Country.uae,
);

class CountrySelectionScreen extends ConsumerWidget {
  const CountrySelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

          // Country selection modal with blur effect - centered positioning
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
                  filter: ImageFilter.blur(sigmaX: 10.5, sigmaY: 10.5), // 70% blur effect
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
                              context.go('/language');
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
                          
                          // Title
                          const Text(
                            'Select country',
                            style: TextStyle(
                              color: AuthColors.textPrimary,
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Country list with exact specifications
                      Container(
                        width: 329,
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Column(
                          children: [
                            // UAE country option (first item, show top border)
                            _buildCountryOption(
                              context,
                              ref,
                              Country.uae,
                              selectedCountry == Country.uae,
                              showTopBorder: true,
                            ),

                            // Saudi Arabia country option (no top border to avoid overlap)
                            _buildCountryOption(
                              context,
                              ref,
                              Country.saudi,
                              selectedCountry == Country.saudi,
                              showTopBorder: false,
                            ),

                            // Qatar country option (no top border to avoid overlap)
                            _buildCountryOption(
                              context,
                              ref,
                              Country.qatar,
                              selectedCountry == Country.qatar,
                              showTopBorder: false,
                            ),

                            // UK country option (no top border to avoid overlap)
                            _buildCountryOption(
                              context,
                              ref,
                              Country.uk,
                              selectedCountry == Country.uk,
                              showTopBorder: false,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Continue button
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to welcome screen
                          context.go('/welcome');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
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

  Widget _buildCountryOption(
    BuildContext context,
    WidgetRef ref,
    Country country,
    bool isSelected,
    {bool showTopBorder = true}
  ) {
    return GestureDetector(
      onTap: () {
        ref.read(selectedCountryProvider.notifier).state = country;
      },
      child: Container(
        width: 329,
        height: 48,
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border(
            top: showTopBorder ? BorderSide(
              color: Color(0xCCFEFEFF), // #FEFEFFCC
              width: 1,
            ) : BorderSide.none,
            bottom: BorderSide(
              color: Color(0xCCFEFEFF), // #FEFEFFCC
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16), // gap: 16px
            
            // Country flag icon with exact specifications
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: Color(0xFF1A1A1A), // #1A1A1A
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(48), // Slightly smaller for border
                child: Image.asset(
                  country.iconPath,
                  width: 28,
                  height: 28,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback icon if image fails to load
                    return Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade600,
                        borderRadius: BorderRadius.circular(48),
                      ),
                      child: const Icon(
                        Icons.flag,
                        color: Colors.white,
                        size: 16,
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(width: 10), // gap: 10px

            // Country name
            Expanded(
              child: Text(
                country.displayName,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  height: 1.5,
                  color: AuthColors.textPrimary,
                ),
                textAlign: TextAlign.left,
              ),
            ),

            // Radio button with thick white dot
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AuthColors.textPrimary, width: 2),
                color: Colors.transparent,
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AuthColors.textPrimary,
                        ),
                      ),
                    )
                  : null,
            ),

            const SizedBox(width: 16), // gap: 16px
          ],
        ),
      ),
    );
  }
}