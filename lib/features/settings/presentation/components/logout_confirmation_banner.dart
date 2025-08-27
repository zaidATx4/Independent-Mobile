import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogoutConfirmationBanner extends ConsumerWidget {
  final VoidCallback onConfirmLogout;
  final VoidCallback onCancel;
  final String title;
  final String message;

  const LogoutConfirmationBanner({
    super.key,
    required this.onConfirmLogout,
    required this.onCancel,
    this.title = '',
    this.message = 'Are you sure want to log out?',
  });

  /// Convenience helper to present the banner from the bottom with proper styling
  static Future<T?> show<T>({
    required BuildContext context,
    required VoidCallback onConfirmLogout,
    required VoidCallback onCancel,
    String title = '',
    String message = 'Are you sure want to log out?',
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      isScrollControlled: true,
      builder: (ctx) => LogoutConfirmationBanner(
        onConfirmLogout: onConfirmLogout,
        onCancel: onCancel,
        title: title,
        message: message,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Banner design is fixed dark style per spec

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Home indicator
          Container(
            height: 21,
            width: double.infinity,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                width: 55,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFF888888),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),

          // Title section - only show if title is not empty
          if (title.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFF4D4E52), width: 1),
                ),
              ),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFFFEFEFF),
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  height: 24 / 16,
                ),
              ),
            ),

          // Content section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Text(
              message,
              style: TextStyle(
                color: const Color(0xFFFEFEFF),
                fontSize: 16,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.normal,
                height: 24 / 16,
              ),
            ),
          ),

          // Buttons section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFF4D4E52), width: 1),
              ),
            ),
            child: Row(
              children: [
                // Cancel button
                Expanded(
                  child: GestureDetector(
                    onTap: onCancel,
                    child: Container(
                      margin: const EdgeInsets.only(left: 4, right: 2),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFFEFEFF),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(44),
                      ),
                      child: Text(
                        'Cancel',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFFFEFEFF),
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          height: 24 / 16,
                        ),
                      ),
                    ),
                  ),
                ),

                // Log out button
                Expanded(
                  child: GestureDetector(
                    onTap: onConfirmLogout,
                    child: Container(
                      margin: const EdgeInsets.only(left: 2, right: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBF1),
                        borderRadius: BorderRadius.circular(44),
                      ),
                      child: Text(
                        'Log out',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF242424),
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          height: 24 / 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom padding
          SizedBox(height: 8 + MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
