import 'package:flutter/material.dart';

class CheckoutRadioOption extends StatelessWidget {
  final bool isSelected;
  final String title;
  final String description;
  final VoidCallback? onTap;
  final Widget? additionalContent;

  const CheckoutRadioOption({
    super.key,
    required this.isSelected,
    required this.title,
    required this.description,
    this.onTap,
    this.additionalContent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF4D4E52), // Figma stroke color
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF4D4E52).withValues(alpha: 0.3) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Custom Radio Button
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected 
                          ? const Color(0xFFFEFEFF) 
                          : const Color(0xFF4D4E52),
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFFEFEFF), // indpt/text primary
                            ),
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFFEFEFF), // indpt/text primary
                          height: 24 / 16, // lineHeight / fontSize
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Description
                      Text(
                        description,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF9C9C9D), // indpt/text tertiary
                          height: 21 / 14, // lineHeight / fontSize
                        ),
                      ),
                      // Additional Content (like date picker)
                      if (additionalContent != null) ...[
                        const SizedBox(height: 16),
                        additionalContent!,
                      ],
                    ],
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