import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_story_entity.dart';
import '../providers/feed_providers.dart';

class StoryItem extends ConsumerWidget {
  final UserStoryEntity story;
  final VoidCallback onTap;

  const StoryItem({
    super.key,
    required this.story,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewedStories = ref.watch(storyViewProvider);
    final isViewed = viewedStories.contains(story.id) || story.isViewed;

    return GestureDetector(
      onTap: () {
        if (!isViewed) {
          ref.read(storyViewProvider.notifier).markAsViewed(story.id);
        }
        onTap();
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isViewed
                    ? LinearGradient(
                        colors: [Colors.grey.shade300, Colors.grey.shade400],
                      )
                    : const LinearGradient(
                        colors: [Color(0xFFE91E63), Color(0xFFFF9800)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
              ),
              padding: const EdgeInsets.all(2),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: ClipOval(
                  child: Image.asset(
                    story.userAvatar,
                    width: 58,
                    height: 58,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 58,
                        height: 58,
                        color: Colors.grey.shade300,
                        child: Icon(
                          Icons.person,
                          color: Colors.grey.shade600,
                          size: 30,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: 64,
              child: Text(
                story.userName.split(' ').first,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).brightness == Brightness.light
                      ? const Color(0xFF1A1A1A)
                      : const Color(0xFFFEFEFF),
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}