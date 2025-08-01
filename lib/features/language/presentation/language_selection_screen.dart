import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/auth_colors.dart';

enum Language {
  english('English (UK)', 'assets/images/icons/English_Logo.png', 'en'),
  arabic('Arabic', 'assets/images/icons/Arabic_Logo.png', 'ar');

  const Language(this.displayName, this.iconPath, this.code);
  final String displayName;
  final String iconPath;
  final String code;
}

final selectedLanguageProvider = StateProvider<Language>(
  (ref) => Language.english,
);

class LanguageSelectionScreen extends ConsumerWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLanguage = ref.watch(selectedLanguageProvider);
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

          // Language selection modal with blur effect - centered positioning
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
                        // Title
                        const Text(
                          'Select language',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            height:
                                1.5, // line-height: 27px / font-size: 18px = 1.5
                            color: AuthColors.textPrimary,
                          ),
                          textAlign: TextAlign.start,
                        ),

                        const SizedBox(height: 24),

                        // Language list with responsive specifications
                        Container(
                          width: (screenSize.width * 329 / 393),
                          padding: EdgeInsets.symmetric(
                            vertical: screenSize.height * 8 / 808,
                          ),
                          child: Column(
                            children: [
                              // English language option (first item, show top border)
                              _buildLanguageOption(
                                context,
                                ref,
                                Language.english,
                                selectedLanguage == Language.english,
                                showTopBorder: true,
                              ),

                              // Arabic language option (no top border to avoid overlap)
                              _buildLanguageOption(
                                context,
                                ref,
                                Language.arabic,
                                selectedLanguage == Language.arabic,
                                showTopBorder: false,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Continue button
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to country selection screen with slide animation
                            context.go('/country-selection');
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

  Widget _buildLanguageOption(
    BuildContext context,
    WidgetRef ref,
    Language language,
    bool isSelected,
    {bool showTopBorder = true}
  ) {
    final screenSize = MediaQuery.of(context).size;
    final containerWidth = (screenSize.width * 329 / 393);
    final containerHeight = (screenSize.height * 56 / 808);
    
    return GestureDetector(
      onTap: () {
        ref.read(selectedLanguageProvider.notifier).state = language;
      },
      child: Container(
        width: containerWidth,
        height: containerHeight,
        padding: EdgeInsets.symmetric(
          vertical: screenSize.height * 12 / 808,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border(
            top: showTopBorder ? BorderSide(
              color: Color(0xCCFEFEFF), // #FEFEFFCC (--indpt-text-secondary)
              width: 1,
            ) : BorderSide.none,
            bottom: BorderSide(
              color: Color(0xCCFEFEFF), // #FEFEFFCC (--indpt-text-secondary)
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            SizedBox(width: screenSize.width * 16 / 393), // responsive gap
            // Custom language icon with black circle and text - larger size
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  _getLanguageInitials(language),
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    fontSize: screenSize.width * 14 / 393,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            SizedBox(width: screenSize.width * 12 / 393), // responsive gap
            // Language name with responsive specifications
            Expanded(
              child: Text(
                language.displayName,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: screenSize.width * 16 / 393,
                  height: 1.5,
                  color: AuthColors.textPrimary,
                ),
                textAlign: TextAlign.left,
              ),
            ),

            // Radio button with perfect circle
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AuthColors.textPrimary, 
                  width: 2,
                ),
                color: Colors.transparent,
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AuthColors.textPrimary,
                        ),
                      ),
                    )
                  : null,
            ),

            SizedBox(width: screenSize.width * 16 / 393), // responsive gap
          ],
        ),
      ),
    );
  }

  String _getLanguageInitials(Language language) {
    switch (language) {
      case Language.english:
        return 'UK';
      case Language.arabic:
        return 'عربي';
    }
  }
}
