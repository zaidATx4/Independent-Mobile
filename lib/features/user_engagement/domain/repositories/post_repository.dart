import '../entities/post_entity.dart';
import '../entities/comment_entity.dart';

abstract class PostRepository {
  Future<List<PostEntity>> getFeedPosts({int page = 1, int limit = 20});
  Future<PostEntity?> getPostById(String postId);
  Future<List<PostEntity>> getPostsByUserId(String userId);
  Future<PostEntity?> createPost({
    required String content,
    String? mediaUrl,
    List<String>? hashtags,
    String? locationTag,
  });
  Future<bool> likePost(String postId);
  Future<bool> unlikePost(String postId);
  Future<bool> bookmarkPost(String postId);
  Future<bool> unbookmarkPost(String postId);
  Future<bool> sharePost(String postId);
  Future<List<CommentEntity>> getPostComments(String postId, {int page = 1, int limit = 10});
  Future<bool> addComment(String postId, String content);
  Future<bool> likeComment(String commentId);
  Future<bool> unlikeComment(String commentId);
}