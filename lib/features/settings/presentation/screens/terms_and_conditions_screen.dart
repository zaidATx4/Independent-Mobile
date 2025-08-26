import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TermsSection {
  final String title;
  final String? description;
  final List<String>? bulletPoints;
  final bool isExpanded;

  const TermsSection({
    required this.title,
    this.description,
    this.bulletPoints,
    this.isExpanded = false,
  });

  TermsSection copyWith({
    String? title,
    String? description,
    List<String>? bulletPoints,
    bool? isExpanded,
  }) {
    return TermsSection(
      title: title ?? this.title,
      description: description ?? this.description,
      bulletPoints: bulletPoints ?? this.bulletPoints,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}

final termsSectionsProvider = StateNotifierProvider<TermsSectionsNotifier, List<TermsSection>>((ref) {
  return TermsSectionsNotifier();
});

class TermsSectionsNotifier extends StateNotifier<List<TermsSection>> {
  TermsSectionsNotifier() : super([
    const TermsSection(
      title: 'Terms and Conditions',
      description: 'Welcome to Independent ! By using our app, you agree to these terms and conditions. Please read them carefully. If you do not agree, kindly refrain from using our services.',
      isExpanded: true,
    ),
    const TermsSection(
      title: 'Account Registration & Security',
      bulletPoints: [
        'Users must provide accurate and complete information during registration.',
        'You are responsible for maintaining the security of your account.',
        'Any unauthorized use of your account must be reported immediately.',
      ],
      isExpanded: false,
    ),
    const TermsSection(
      title: 'Loyalty Program Terms',
      isExpanded: false,
    ),
    const TermsSection(
      title: 'Gift Cards & Redemption',
      isExpanded: false,
    ),
    const TermsSection(
      title: 'Ordering & Pickup Policy',
      isExpanded: false,
    ),
    const TermsSection(
      title: 'Reservations & Cancellation',
      isExpanded: false,
    ),
    const TermsSection(
      title: 'Referral & Rewards System',
      isExpanded: false,
    ),
    const TermsSection(
      title: 'Privacy Policy & Data Collection',
      isExpanded: false,
    ),
    const TermsSection(
      title: 'Prohibited Activities',
      isExpanded: false,
    ),
  ]);

  void toggleSection(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index) state[i].copyWith(isExpanded: !state[i].isExpanded) else state[i],
    ];
  }
}

class TermsAndConditionsScreen extends ConsumerWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final termsSections = ref.watch(termsSectionsProvider);
    final theme = Theme.of(context);
    final isLightTheme = theme.brightness == Brightness.light;

    return Scaffold(
      backgroundColor: isLightTheme ? const Color(0xFFFFFCF5) : const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context, isLightTheme),
            
            const SizedBox(height: 24),
            
            // Terms Content
            Expanded(
              child: _buildTermsContent(ref, termsSections, isLightTheme),
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
              'Terms and Conditions',
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

  Widget _buildTermsContent(WidgetRef ref, List<TermsSection> sections, bool isLightTheme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          children: sections.asMap().entries.map((entry) {
            final index = entry.key;
            final section = entry.value;
            return _buildTermsSection(ref, section, index, isLightTheme);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTermsSection(WidgetRef ref, TermsSection section, int index, bool isLightTheme) {
    final isFirst = index == 0;
    final isLast = index == 8; // Last section index

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isLightTheme 
              ? const Color(0xFFD9D9D9)
              : const Color(0xFF4D4E52),
            width: 1,
          ),
        ),
        borderRadius: isFirst 
          ? const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            )
          : isLast
            ? const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              )
            : null,
      ),
      child: Column(
        children: [
          // Section Header
          GestureDetector(
            onTap: () => ref.read(termsSectionsProvider.notifier).toggleSection(index),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  // Section Title
                  Expanded(
                    child: Text(
                      section.title,
                      style: TextStyle(
                        color: isLightTheme 
                          ? const Color(0xFF1A1A1A)
                          : const Color(0xFFFEFEFF),
                        fontSize: 14,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.normal,
                        height: 21 / 14,
                      ),
                    ),
                  ),
                  
                  // Expand/Collapse Icon
                  Icon(
                    section.isExpanded ? Icons.remove : Icons.add,
                    color: isLightTheme 
                      ? const Color(0xFF1A1A1A)
                      : const Color(0xFFFEFEFF),
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
          
          // Section Content
          if (section.isExpanded) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  if (section.description != null)
                    Text(
                      section.description!,
                      style: TextStyle(
                        color: isLightTheme 
                          ? const Color(0xCC1A1A1A)
                          : const Color(0xCCFEFEFF),
                        fontSize: 12,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.normal,
                        height: 18 / 12,
                      ),
                    ),
                  
                  // Bullet Points
                  if (section.bulletPoints != null) ...[
                    const SizedBox(height: 8),
                    ...section.bulletPoints!.map((point) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 6, right: 8),
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: isLightTheme 
                                ? const Color(0xCC1A1A1A)
                                : const Color(0xCCFEFEFF),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              point,
                              style: TextStyle(
                                color: isLightTheme 
                                  ? const Color(0xCC1A1A1A)
                                  : const Color(0xCCFEFEFF),
                                fontSize: 12,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.normal,
                                height: 18 / 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )).toList(),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}