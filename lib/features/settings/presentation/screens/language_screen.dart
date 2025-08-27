import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

final selectedLanguageProvider = StateProvider<String>((ref) => 'English');

class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLanguage = ref.watch(selectedLanguageProvider);
    final theme = Theme.of(context);
    final isLightTheme = theme.brightness == Brightness.light;

    return Scaffold(
      backgroundColor: isLightTheme ? const Color(0xFFFFFCF5) : const Color(0xFF1A1A1A),
      body: Stack(
        children: [
          // Main Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Language',
                        style: TextStyle(
                          color: isLightTheme 
                            ? const Color(0xCC1A1A1A)
                            : const Color(0xFFFEFEFF),
                          fontSize: 24,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Close Button
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isLightTheme
                              ? const Color(0xFF1A1A1A)
                              : const Color(0xFFFFFBF1),
                            borderRadius: BorderRadius.circular(44),
                          ),
                          child: Icon(
                            Icons.close,
                            color: isLightTheme
                              ? const Color(0xFFFEFEFF)
                              : const Color(0xFF242424),
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildLanguageOption(
                          context,
                          ref,
                          'English',
                          'English (US)',
                          'en',
                          selectedLanguage == 'English',
                          isLightTheme,
                        ),
                        const SizedBox(height: 12),
                        _buildLanguageOption(
                          context,
                          ref,
                          'Arabic',
                          'العربية',
                          'ar',
                          selectedLanguage == 'Arabic',
                          isLightTheme,
                        ),
                        const SizedBox(height: 12),
                        _buildLanguageOption(
                          context,
                          ref,
                          'French',
                          'Français',
                          'fr',
                          selectedLanguage == 'French',
                          isLightTheme,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    WidgetRef ref,
    String language,
    String nativeName,
    String code,
    bool isSelected,
    bool isLightTheme,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isLightTheme
          ? Colors.grey.withValues(alpha: 0.1)
          : Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isLightTheme
            ? const Color(0xFFD9D9D9)
            : Colors.white.withValues(alpha: 0.2)
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            ref.read(selectedLanguageProvider.notifier).state = language;
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isLightTheme
                      ? const Color(0xFF1A1A1A)
                      : Colors.black,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Text(
                    code.toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFFFEFEFF),
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        language,
                        style: TextStyle(
                          color: isLightTheme
                            ? const Color(0xFF1A1A1A)
                            : const Color(0xFFFEFEFF),
                          fontSize: 14,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        nativeName,
                        style: TextStyle(
                          color: isLightTheme
                            ? const Color(0xFF1A1A1A).withValues(alpha: 0.8)
                            : const Color(0xFFFEFEFF).withValues(alpha: 0.8),
                          fontSize: 12,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
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
        ),
      ),
    );
  }
}
