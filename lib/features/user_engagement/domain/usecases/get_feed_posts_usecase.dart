import '../entities/post_entity.dart';
import '../repositories/post_repository.dart';

class GetFeedPostsUseCase {
  final PostRepository _repository;

  GetFeedPostsUseCase(this._repository);

  Future<List<PostEntity>> call({int page = 1, int limit = 20}) async {
    return await _repository.getFeedPosts(page: page, limit: limit);
  }
}