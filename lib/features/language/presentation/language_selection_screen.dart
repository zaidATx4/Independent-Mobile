import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

enum Language {
  english('English (UK)', 'assets/images/icons/Language_Icons/English.svg', 'en'),
  arabic('Arabic', 'assets/images/icons/Language_Icons/Arabic.svg', 'ar');

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
    final theme = Theme.of(context);
    final isLightTheme = theme.brightness == Brightness.light;

    return Scaffold(
      backgroundColor: isLightTheme ? const Color(0xFFFFFCF5) : const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context, isLightTheme),
            
            // Language Options
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      'Select language',
                      style: TextStyle(
                        color: isLightTheme 
                          ? const Color(0xCC1A1A1A)
                          : const Color(0xCCFEFEFF),
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.normal,
                        height: 24 / 16,
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Language List
                    _buildLanguageOption(
                      context,
                      ref,
                      Language.english,
                      selectedLanguage == Language.english,
                      isLightTheme,
                    ),
                    _buildLanguageOption(
                      context,
                      ref,
                      Language.arabic,
                      selectedLanguage == Language.arabic,
                      isLightTheme,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isLightTheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isLightTheme 
                    ? const Color(0xFF1A1A1A)
                    : const Color(0xFFFEFEFF),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(44),
              ),
              child: Icon(
                Icons.arrow_back,
                color: isLightTheme 
                  ? const Color(0xFF1A1A1A)
                  : const Color(0xFFFEFEFF),
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Title
          Expanded(
            child: Text(
              'Language',
              style: TextStyle(
                color: isLightTheme 
                  ? const Color(0xCC1A1A1A)
                  : const Color(0xCCFEFEFF),
                fontSize: 24,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                height: 32 / 24,
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
    bool isLightTheme,
  ) {
    return GestureDetector(
      onTap: () {
        ref.read(selectedLanguageProvider.notifier).state = language;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isLightTheme 
                ? const Color(0xFFD9D9D9)
                : const Color(0xFF4D4E52),
              width: 1,
            ),
            bottom: BorderSide(
              color: isLightTheme 
                ? const Color(0xFFD9D9D9)
                : const Color(0xFF4D4E52),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            // Language flag/icon - circular with zoomed SVG
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isLightTheme 
                  ? const Color(0xFFFEFEFF)
                  : const Color(0xFF000000),
                shape: BoxShape.circle, // Make it circular
              ),
              child: Center(
                child: SvgPicture.asset(
                  language.iconPath,
                  width: 32, // Increased size for better visibility
                  height: 32, // Increased size for better visibility
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          language == Language.english ? 'UK' : 'عربي',
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
            
            const SizedBox(width: 16),
            
            // Language name
            Expanded(
              child: Text(
                language.displayName,
                style: TextStyle(
                  color: isLightTheme 
                    ? const Color(0xCC1A1A1A)
                    : const Color(0xCCFEFEFF),
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.normal,
                  height: 24 / 16,
                ),
              ),
            ),
            
            // SVG Radio button matching theme screen
            SvgPicture.asset(
              isSelected
                  ? 'assets/images/icons/SVGs/Settings/Radio_button _selected.svg'
                  : 'assets/images/icons/SVGs/Settings/Radio_button _Unselected.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                isSelected
                    ? (isLightTheme ? const Color(0xFF1A1A1A) : const Color(0xFFFFFBF1))
                    : const Color(0xFF9C9C9D),
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}