import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Light theme version of custom radio button widget
/// Uses dark colors for proper contrast on light backgrounds
class CustomRadioButtonLight extends StatelessWidget {
  final bool isSelected;

  const CustomRadioButtonLight({
    super.key,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: SvgPicture.asset(
        isSelected 
            ? 'assets/images/icons/SVGs/Settings/Radio_button _selected.svg'
            : 'assets/images/icons/SVGs/Settings/Radio_button _Unselected.svg',
        width: 24,
        height: 24,
        fit: BoxFit.contain,
        // Apply color filter for light theme - dark colors on light background
        colorFilter: ColorFilter.mode(
          isSelected ? const Color(0xFF1A1A1A) : const Color(0xFF878787),
          BlendMode.srcIn,
        ),
        placeholderBuilder: (BuildContext context) => Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? const Color(0xFF1A1A1A) : const Color(0xFF878787), // Dark colors for light theme
              width: 2,
            ),
          ),
          child: isSelected
              ? Center(
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1A1A1A), // Dark inner circle for contrast
                      shape: BoxShape.circle,
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}