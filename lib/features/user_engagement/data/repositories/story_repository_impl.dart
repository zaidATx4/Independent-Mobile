import '../../domain/entities/user_story_entity.dart';
import '../../domain/repositories/story_repository.dart';
import '../models/story_model.dart';

class StoryRepositoryImpl implements StoryRepository {
  // Mock data - in production this would come from API/database
  final List<UserStoryModel> _mockStories = [
    UserStoryModel(
      id: 'story_1',
      userId: 'user_1',
      userName: 'Ahmed Al-Rashid',
      userAvatar: 'assets/images/avatars/user_1.jpg',
      mediaUrl: 'assets/images/stories/story_1.jpg',
      thumbnailUrl: 'assets/images/stories/story_1_thumb.jpg',
      isViewed: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      expiresAt: DateTime.now().add(const Duration(hours: 22)),
      content: 'Great dinner at Salt!',
    ),
    UserStoryModel(
      id: 'story_2',
      userId: 'user_2',
      userName: 'Sarah Johnson',
      userAvatar: 'assets/images/avatars/user_2.jpg',
      mediaUrl: 'assets/images/stories/story_2.jpg',
      thumbnailUrl: 'assets/images/stories/story_2_thumb.jpg',
      isViewed: true,
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      expiresAt: DateTime.now().add(const Duration(hours: 20)),
      content: 'Weekend vibes',
    ),
    UserStoryModel(
      id: 'story_3',
      userId: 'user_3',
      userName: 'Mohammad Hassan',
      userAvatar: 'assets/images/avatars/user_3.jpg',
      mediaUrl: 'assets/images/stories/story_3.jpg',
      thumbnailUrl: 'assets/images/stories/story_3_thumb.jpg',
      isViewed: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      expiresAt: DateTime.now().add(const Duration(hours: 18)),
      content: 'New burger special!',
    ),
  ];

  @override
  Future<List<UserStoryEntity>> getUserStories() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));
    
    // Filter out expired stories
    final now = DateTime.now();
    final activeStories = _mockStories.where((story) => story.expiresAt.isAfter(now)).toList();
    
    // Sort by creation date (newest first)
    activeStories.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    return activeStories;
  }

  @override
  Future<bool> markStoryAsViewed(String storyId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    final storyIndex = _mockStories.indexWhere((story) => story.id == storyId);
    if (storyIndex != -1) {
      _mockStories[storyIndex] = UserStoryModel(
        id: _mockStories[storyIndex].id,
        userId: _mockStories[storyIndex].userId,
        userName: _mockStories[storyIndex].userName,
        userAvatar: _mockStories[storyIndex].userAvatar,
        mediaUrl: _mockStories[storyIndex].mediaUrl,
        thumbnailUrl: _mockStories[storyIndex].thumbnailUrl,
        isViewed: true,
        createdAt: _mockStories[storyIndex].createdAt,
        expiresAt: _mockStories[storyIndex].expiresAt,
        content: _mockStories[storyIndex].content,
      );
      return true;
    }
    return false;
  }

  @override
  Future<bool> createStory(String mediaUrl, String? content) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    final newStory = UserStoryModel(
      id: 'story_${DateTime.now().millisecondsSinceEpoch}',
      userId: 'current_user',
      userName: 'You',
      userAvatar: 'assets/images/avatars/current_user.jpg',
      mediaUrl: mediaUrl,
      thumbnailUrl: mediaUrl,
      isViewed: false,
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(hours: 24)),
      content: content,
    );
    
    _mockStories.insert(0, newStory);
    return true;
  }

  @override
  Future<bool> deleteStory(String storyId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final storyIndex = _mockStories.indexWhere((story) => story.id == storyId);
    if (storyIndex != -1) {
      _mockStories.removeAt(storyIndex);
      return true;
    }
    return false;
  }
}