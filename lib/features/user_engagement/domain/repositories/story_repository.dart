import '../entities/user_story_entity.dart';

abstract class StoryRepository {
  Future<List<UserStoryEntity>> getUserStories();
  Future<bool> markStoryAsViewed(String storyId);
  Future<bool> createStory(String mediaUrl, String? content);
  Future<bool> deleteStory(String storyId);
}