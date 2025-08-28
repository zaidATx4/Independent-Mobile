import '../repositories/post_repository.dart';

class InteractWithPostUseCase {
  final PostRepository _repository;

  InteractWithPostUseCase(this._repository);

  Future<bool> likePost(String postId) async {
    return await _repository.likePost(postId);
  }

  Future<bool> unlikePost(String postId) async {
    return await _repository.unlikePost(postId);
  }

  Future<bool> bookmarkPost(String postId) async {
    return await _repository.bookmarkPost(postId);
  }

  Future<bool> unbookmarkPost(String postId) async {
    return await _repository.unbookmarkPost(postId);
  }

  Future<bool> sharePost(String postId) async {
    return await _repository.sharePost(postId);
  }
}