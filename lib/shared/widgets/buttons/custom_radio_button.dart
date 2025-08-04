import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomRadioButton extends StatelessWidget {
  final bool isSelected;

  const CustomRadioButton({
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
        placeholderBuilder: (BuildContext context) => Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? const Color(0xFFFEFEFF) : const Color(0xFF4D4E52),
              width: 2,
            ),
          ),
          child: isSelected
              ? Center(
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFEFEFF),
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