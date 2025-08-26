import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/auth_colors.dart';

enum Language {
  english('English (UK)', 'assets/images/icons/Language_Icons/English.svg', 'en'),
  arabic('Arabic', 'assets/images/icons/Language_Icons/Arabic.svg', 'ar');

  const Language(this.displayName, this.iconPath, this.code);
  final String displayName;
  final String iconPath;
  final String code;
}

final initialSelectedLanguageProvider = StateProvider<Language>(
  (ref) => Language.english,
);

class InitialLanguageSelectionScreen extends ConsumerWidget {
  const InitialLanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLanguage = ref.watch(initialSelectedLanguageProvider);
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
                        // Title
                        const Text(
                          'Select language',
                          style: TextStyle(
                            color: AuthColors.textPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 24),

                        // Language list with exact specifications
                        Container(
                          width: 329,
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
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
                            // Navigate to country selection
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
    return GestureDetector(
      onTap: () {
        ref.read(initialSelectedLanguageProvider.notifier).state = language;
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
            
            // Language flag icon with exact specifications
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
                child: SvgPicture.asset(
                  language.iconPath,
                  width: 28,
                  height: 28,
                  fit: BoxFit.cover,
                  placeholderBuilder: (context) {
                    // Fallback icon if SVG fails to load
                    return Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade600,
                        borderRadius: BorderRadius.circular(48),
                      ),
                      child: Center(
                        child: Text(
                          language == Language.english ? 'EN' : 'عربي',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(width: 10), // gap: 10px

            // Language name
            Expanded(
              child: Text(
                language.displayName,
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