import 'package:flutter/material.dart';

class CheckoutDatePicker extends StatelessWidget {
  final String placeholder;
  final DateTime? selectedDate;
  final VoidCallback? onTap;
  final bool enabled;

  const CheckoutDatePicker({
    super.key,
    this.placeholder = 'Date Picker',
    this.selectedDate,
    this.onTap,
    this.enabled = true,
  });

  String get displayText {
    if (selectedDate != null) {
      return '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year} at ${selectedDate!.hour}:${selectedDate!.minute.toString().padLeft(2, '0')}';
    }
    return placeholder;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Theme-aware colors based on Figma design
    final borderColor = isDarkMode ? const Color(0xFF4D4E52) : const Color(0xFF1A1A1A).withValues(alpha: 0.64); // #1a1a1acc from Figma
    final primaryTextColor = isDarkMode ? const Color(0xFFFEFEFF) : const Color(0xFF1A1A1A);
    final tertiaryTextColor = isDarkMode ? const Color(0xFF9C9C9D) : const Color(0xFF878787);
    final iconColor = isDarkMode ? const Color(0xFFFEFEFF).withValues(alpha: 0.8) : const Color(0xFF1A1A1A).withValues(alpha: 0.8);
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor, // Theme-aware border from Figma
          width: 1,
        ),
        borderRadius: BorderRadius.circular(34),
      ),
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(34),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Text
                Expanded(
                  child: Text(
                    displayText,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: selectedDate != null 
                          ? primaryTextColor 
                          : tertiaryTextColor, // Theme-aware text colors
                      height: 24 / 16, // lineHeight / fontSize
                    ),
                  ),
                ),
                // Calendar Icon
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Stack(
                    children: [
                      // Calendar base
                      Positioned(
                        left: 3,
                        top: 2,
                        right: 3,
                        bottom: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: iconColor,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      // Top hooks (calendar rings)
                      Positioned(
                        left: 8,
                        top: 2,
                        child: Container(
                          width: 2,
                          height: 6,
                          decoration: BoxDecoration(
                            color: iconColor,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 8,
                        top: 2,
                        child: Container(
                          width: 2,
                          height: 6,
                          decoration: BoxDecoration(
                            color: iconColor,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ),
                      // Top line (calendar header)
                      Positioned(
                        left: 5,
                        top: 9,
                        right: 5,
                        child: Container(
                          height: 1,
                          color: const Color(0xFFFEFEFF).withValues(alpha: 0.8),
                        ),
                      ),
                      // Date squares
                      Positioned(
                        left: 6,
                        top: 13,
                        child: Container(
                          width: 3,
                          height: 3,
                          decoration: BoxDecoration(
                            color: iconColor,
                            borderRadius: BorderRadius.circular(0.5),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 10.5,
                        top: 13,
                        child: Container(
                          width: 3,
                          height: 3,
                          decoration: BoxDecoration(
                            color: iconColor,
                            borderRadius: BorderRadius.circular(0.5),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 10.5,
                        top: 13,
                        child: Container(
                          width: 3,
                          height: 3,
                          decoration: BoxDecoration(
                            color: iconColor,
                            borderRadius: BorderRadius.circular(0.5),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 6,
                        top: 13,
                        child: Container(
                          width: 3,
                          height: 3,
                          decoration: BoxDecoration(
                            color: iconColor,
                            borderRadius: BorderRadius.circular(0.5),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 6,
                        top: 17,
                        child: Container(
                          width: 3,
                          height: 3,
                          decoration: BoxDecoration(
                            color: iconColor,
                            borderRadius: BorderRadius.circular(0.5),
                          ),
                        ),
                      ),
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

class CheckoutTimePicker extends StatelessWidget {
  final String placeholder;
  final TimeOfDay? selectedTime;
  final VoidCallback? onTap;
  final bool enabled;

  const CheckoutTimePicker({
    super.key,
    this.placeholder = 'Select Time',
    this.selectedTime,
    this.onTap,
    this.enabled = true,
  });

  String get displayText {
    if (selectedTime != null) {
      final hour = selectedTime!.hourOfPeriod;
      final minute = selectedTime!.minute.toString().padLeft(2, '0');
      final period = selectedTime!.period == DayPeriod.am ? 'AM' : 'PM';
      return '$hour:$minute $period';
    }
    return placeholder;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Theme-aware colors based on Figma design
    final borderColor = isDarkMode ? const Color(0xFF4D4E52) : const Color(0xFF1A1A1A).withValues(alpha: 0.64);
    final primaryTextColor = isDarkMode ? const Color(0xFFFEFEFF) : const Color(0xFF1A1A1A);
    final tertiaryTextColor = isDarkMode ? const Color(0xFF9C9C9D) : const Color(0xFF878787);
    final iconColor = isDarkMode ? const Color(0xFFFEFEFF) : const Color(0xFF1A1A1A).withValues(alpha: 0.8);
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(34),
      ),
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(34),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    displayText,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: selectedTime != null 
                          ? primaryTextColor 
                          : tertiaryTextColor,
                      height: 24 / 16,
                    ),
                  ),
                ),
                Icon(
                  Icons.access_time,
                  color: iconColor,
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