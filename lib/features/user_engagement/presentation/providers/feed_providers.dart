import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/post_repository_impl.dart';
import '../../data/repositories/story_repository_impl.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/entities/user_story_entity.dart';
import '../../domain/repositories/post_repository.dart';
import '../../domain/repositories/story_repository.dart';
import '../../domain/usecases/get_feed_posts_usecase.dart';
import '../../domain/usecases/get_user_stories_usecase.dart';
import '../../domain/usecases/interact_with_post_usecase.dart';

// Repository Providers
final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepositoryImpl();
});

final storyRepositoryProvider = Provider<StoryRepository>((ref) {
  return StoryRepositoryImpl();
});

// Use Case Providers
final getFeedPostsUseCaseProvider = Provider<GetFeedPostsUseCase>((ref) {
  return GetFeedPostsUseCase(ref.watch(postRepositoryProvider));
});

final getUserStoriesUseCaseProvider = Provider<GetUserStoriesUseCase>((ref) {
  return GetUserStoriesUseCase(ref.watch(storyRepositoryProvider));
});

final interactWithPostUseCaseProvider = Provider<InteractWithPostUseCase>((ref) {
  return InteractWithPostUseCase(ref.watch(postRepositoryProvider));
});

// State Providers
final feedPostsProvider = FutureProvider<List<PostEntity>>((ref) async {
  final useCase = ref.watch(getFeedPostsUseCaseProvider);
  return await useCase();
});

// User Posts Provider
final userPostsProvider = FutureProvider.family<List<PostEntity>, String>((ref, userId) async {
  final repository = ref.watch(postRepositoryProvider);
  return await repository.getPostsByUserId(userId);
});

final userStoriesProvider = FutureProvider<List<UserStoryEntity>>((ref) async {
  final useCase = ref.watch(getUserStoriesUseCaseProvider);
  return await useCase();
});

// Loading State Provider
final feedLoadingProvider = StateProvider<bool>((ref) => false);

// Error State Provider
final feedErrorProvider = StateProvider<String?>((ref) => null);

// Post Interaction Providers
class PostInteractionNotifier extends StateNotifier<Map<String, PostEntity>> {
  final InteractWithPostUseCase _interactUseCase;
  final PostRepository _postRepository;

  PostInteractionNotifier(this._interactUseCase, this._postRepository) : super({});

  Future<void> toggleLike(String postId, bool currentLikeStatus) async {
    try {
      final success = currentLikeStatus 
          ? await _interactUseCase.unlikePost(postId)
          : await _interactUseCase.likePost(postId);
      
      if (success) {
        // Refresh the post data
        final updatedPost = await _postRepository.getPostById(postId);
        if (updatedPost != null) {
          state = {...state, postId: updatedPost};
        }
      }
    } catch (e) {
      // Handle error - could emit error state
    }
  }

  Future<void> toggleBookmark(String postId, bool currentBookmarkStatus) async {
    try {
      final success = currentBookmarkStatus
          ? await _interactUseCase.unbookmarkPost(postId)
          : await _interactUseCase.bookmarkPost(postId);
      
      if (success) {
        final updatedPost = await _postRepository.getPostById(postId);
        if (updatedPost != null) {
          state = {...state, postId: updatedPost};
        }
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> sharePost(String postId) async {
    try {
      await _interactUseCase.sharePost(postId);
      final updatedPost = await _postRepository.getPostById(postId);
      if (updatedPost != null) {
        state = {...state, postId: updatedPost};
      }
    } catch (e) {
      // Handle error
    }
  }
}

final postInteractionProvider = StateNotifierProvider<PostInteractionNotifier, Map<String, PostEntity>>((ref) {
  return PostInteractionNotifier(
    ref.watch(interactWithPostUseCaseProvider),
    ref.watch(postRepositoryProvider),
  );
});

// Story View Provider
class StoryViewNotifier extends StateNotifier<Set<String>> {
  final StoryRepository _storyRepository;

  StoryViewNotifier(this._storyRepository) : super({});

  Future<void> markAsViewed(String storyId) async {
    try {
      final success = await _storyRepository.markStoryAsViewed(storyId);
      if (success) {
        state = {...state, storyId};
      }
    } catch (e) {
      // Handle error
    }
  }
}

final storyViewProvider = StateNotifierProvider<StoryViewNotifier, Set<String>>((ref) {
  return StoryViewNotifier(ref.watch(storyRepositoryProvider));
});