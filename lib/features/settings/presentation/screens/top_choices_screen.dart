import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TopChoicesScreen extends ConsumerWidget {
  const TopChoicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
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
                    'Top Choices',
                    style: TextStyle(
                      color: Color(0xFFFEFEFF),
                      fontSize: 24,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
            // TODO: Implement favorites UI
          ],
        ),
      ),
    );
  }
}
