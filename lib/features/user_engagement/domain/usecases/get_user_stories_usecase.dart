import '../entities/user_story_entity.dart';
import '../repositories/story_repository.dart';

class GetUserStoriesUseCase {
  final StoryRepository _repository;

  GetUserStoriesUseCase(this._repository);

  Future<List<UserStoryEntity>> call() async {
    return await _repository.getUserStories();
  }
}