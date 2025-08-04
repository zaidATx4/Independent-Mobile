import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final selectedLanguageProvider = StateProvider<String>((ref) => 'English');

class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLanguage = ref.watch(selectedLanguageProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
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
                      const Text(
                        'Language',
                        style: TextStyle(
                          color: Color(0xFFFEFEFF),
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
                        ),
                        const SizedBox(height: 12),
                        _buildLanguageOption(
                          context,
                          ref,
                          'Arabic',
                          'العربية',
                          'ar',
                          selectedLanguage == 'Arabic',
                        ),
                        const SizedBox(height: 12),
                        _buildLanguageOption(
                          context,
                          ref,
                          'French',
                          'Français',
                          'fr',
                          selectedLanguage == 'French',
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
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
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
                    color: Colors.black,
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
                        style: const TextStyle(
                          color: Color(0xFFFEFEFF),
                          fontSize: 14,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        nativeName,
                        style: TextStyle(
                          color: const Color(0xFFFEFEFF).withValues(alpha: 0.8),
                          fontSize: 12,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check_circle,
                    color: Color(0xFFFFFBF1),
                    size: 24,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
