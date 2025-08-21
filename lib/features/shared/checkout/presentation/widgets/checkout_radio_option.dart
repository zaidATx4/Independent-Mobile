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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Theme-aware colors based on Figma design
    final borderColor = isDarkMode ? const Color(0xFF4D4E52) : const Color(0xFFD9D9D9); // #d9d9d9 from Figma
    final primaryTextColor = isDarkMode ? const Color(0xFFFEFEFF) : const Color(0xFF1A1A1A); // #1a1a1a from Figma
    final tertiaryTextColor = isDarkMode ? const Color(0xFF9C9C9D) : const Color(0xFF878787); // #878787 from Figma
    final selectedBackgroundColor = isDarkMode 
        ? const Color(0xFF4D4E52).withValues(alpha: 0.3) 
        : const Color(0xFFD9D9D9).withValues(alpha: 0.2); // Light selection state
    
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor, // Theme-aware border
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: isSelected ? selectedBackgroundColor : Colors.transparent,
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
                          ? primaryTextColor 
                          : borderColor, // Theme-aware radio border
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: primaryTextColor, // Theme-aware radio dot
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
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: primaryTextColor, // Theme-aware title text
                          height: 24 / 16, // lineHeight / fontSize
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Description
                      Text(
                        description,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: tertiaryTextColor, // Theme-aware description text
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