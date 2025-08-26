import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

enum Country {
  uae('United Arab Emirates', 'assets/images/icons/Country_Icons/UAE_Icon.svg', 'ae', '+971'),
  saudi('Saudi Arabia', 'assets/images/icons/Country_Icons/Saudi_Icon.svg', 'sa', '+966'),
  qatar('Qatar', 'assets/images/icons/Country_Icons/Qatar_Icon.svg', 'qa', '+974'),
  uk('United Kingdom', 'assets/images/icons/Country_Icons/UK_Icon.svg', 'uk', '+44');

  const Country(this.displayName, this.iconPath, this.code, this.countryCode);
  final String displayName;
  final String iconPath;
  final String code;
  final String countryCode;
}

final settingsSelectedCountryProvider = StateProvider<Country>(
  (ref) => Country.uae,
);

class CountrySelectionScreen extends ConsumerWidget {
  const CountrySelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCountry = ref.watch(settingsSelectedCountryProvider);
    final theme = Theme.of(context);
    final isLightTheme = theme.brightness == Brightness.light;

    return Scaffold(
      backgroundColor: isLightTheme ? const Color(0xFFFFFCF5) : const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context, isLightTheme),
            
            // Country Options
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      'Select country',
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
                    
                    // Country List
                    _buildCountryOption(
                      context,
                      ref,
                      Country.uae,
                      selectedCountry == Country.uae,
                      isLightTheme,
                    ),
                    _buildCountryOption(
                      context,
                      ref,
                      Country.saudi,
                      selectedCountry == Country.saudi,
                      isLightTheme,
                    ),
                    _buildCountryOption(
                      context,
                      ref,
                      Country.qatar,
                      selectedCountry == Country.qatar,
                      isLightTheme,
                    ),
                    _buildCountryOption(
                      context,
                      ref,
                      Country.uk,
                      selectedCountry == Country.uk,
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
              'Country',
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

  Widget _buildCountryOption(
    BuildContext context,
    WidgetRef ref,
    Country country,
    bool isSelected,
    bool isLightTheme,
  ) {
    return GestureDetector(
      onTap: () {
        ref.read(settingsSelectedCountryProvider.notifier).state = country;
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
            // Country flag icon - clean display like onboarding screen
            Container(
              width: 40,
              height: 40,
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: SvgPicture.asset(
                country.iconPath,
                width: 40,
                height: 40,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.flag,
                    color: Colors.red,
                    size: 40,
                  );
                },
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Country name
            Expanded(
              child: Text(
                country.displayName,
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
            
            // Radio button
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? (isLightTheme 
                            ? const Color(0xFF1A1A1A)
                            : const Color(0xFFFEFEFF))
                      : (isLightTheme 
                            ? const Color(0xFF878787)
                            : const Color(0xFF9C9C9D)),
                  width: 2,
                ),
                color: Colors.transparent,
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isLightTheme 
                            ? const Color(0xFF1A1A1A)
                            : const Color(0xFFFEFEFF),
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}