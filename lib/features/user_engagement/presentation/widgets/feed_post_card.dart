import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../domain/entities/post_entity.dart';
import '../providers/feed_providers.dart';
import '../pages/single_user_posts_screen.dart';

class FeedPostCard extends ConsumerWidget {
  final PostEntity post;

  const FeedPostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isLightTheme = theme.brightness == Brightness.light;
    final postInteractions = ref.watch(postInteractionProvider);
    
    // Use updated post data if available, otherwise use original
    final currentPost = postInteractions[post.id] ?? post;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isLightTheme ? Colors.white : const Color(0xFF242424),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isLightTheme ? 0.1 : 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, currentPost, isLightTheme),
          if (currentPost.content.isNotEmpty) 
            _buildContent(context, currentPost, isLightTheme),
          if (currentPost.mediaUrl != null) 
            _buildMedia(context, currentPost),
          _buildActions(context, ref, currentPost, isLightTheme),
          _buildEngagementStats(context, currentPost, isLightTheme),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, PostEntity post, bool isLightTheme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // User Avatar
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SingleUserPostsScreen(
                    userId: 'user_john', // Using hardcoded userId for demo
                    userName: post.userName,
                    userAvatar: post.userAvatar,
                  ),
                ),
              );
            },
            child: CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(post.userAvatar),
              onBackgroundImageError: (_, __) {},
              child: post.userAvatar.isEmpty
                  ? Icon(Icons.person, color: Colors.grey.shade600)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      post.userName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: isLightTheme ? const Color(0xFF1A1A1A) : const Color(0xFFFEFEFF),
                      ),
                    ),
                    if (post.isPromoted) ...[
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE91E63),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'PROMOTED',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      _formatTime(post.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: isLightTheme ? const Color(0xFF878787) : const Color(0xFF9C9C9D),
                      ),
                    ),
                    if (post.locationTag != null) ...[
                      const SizedBox(width: 4),
                      Icon(
                        Icons.location_on,
                        size: 12,
                        color: isLightTheme ? const Color(0xFF878787) : const Color(0xFF9C9C9D),
                      ),
                      const SizedBox(width: 2),
                      Flexible(
                        child: Text(
                          post.locationTag!,
                          style: TextStyle(
                            fontSize: 12,
                            color: isLightTheme ? const Color(0xFF878787) : const Color(0xFF9C9C9D),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          
          // More Options
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: isLightTheme ? const Color(0xFF878787) : const Color(0xFF9C9C9D),
            ),
            onPressed: () {
              // Show options menu
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, PostEntity post, bool isLightTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        post.content,
        style: TextStyle(
          fontSize: 14,
          height: 1.4,
          color: isLightTheme ? const Color(0xFF1A1A1A) : const Color(0xFFFEFEFF),
        ),
      ),
    );
  }

  Widget _buildMedia(BuildContext context, PostEntity post) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      width: double.infinity,
      height: 250,
      child: ClipRRect(
        child: Image.asset(
          post.mediaUrl!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey.shade300,
              child: Center(
                child: Icon(
                  Icons.image_not_supported,
                  color: Colors.grey.shade600,
                  size: 40,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context, WidgetRef ref, PostEntity post, bool isLightTheme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Like Button
          GestureDetector(
            onTap: () {
              ref.read(postInteractionProvider.notifier)
                  .toggleLike(post.id, post.isLiked);
            },
            child: Row(
              children: [
                SvgPicture.asset(
                  post.isLiked 
                      ? 'assets/images/icons/SVGs/heart_like_icon_filled.svg'
                      : 'assets/images/icons/SVGs/heart_like_icon.svg',
                  width: 20,
                  height: 20,
                  colorFilter: post.isLiked 
                      ? null
                      : ColorFilter.mode(
                          isLightTheme ? const Color(0xFF878787) : const Color(0xFF9C9C9D),
                          BlendMode.srcIn,
                        ),
                ),
                const SizedBox(width: 4),
                Text(
                  post.likesCount.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    color: isLightTheme ? const Color(0xFF878787) : const Color(0xFF9C9C9D),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          
          // Comment Button
          GestureDetector(
            onTap: () {
              // Navigate to comments screen
            },
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/images/icons/SVGs/comment.svg',
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(
                    isLightTheme ? const Color(0xFF878787) : const Color(0xFF9C9C9D),
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  post.commentsCount.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    color: isLightTheme ? const Color(0xFF878787) : const Color(0xFF9C9C9D),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          
          // Share Button
          GestureDetector(
            onTap: () {
              ref.read(postInteractionProvider.notifier).sharePost(post.id);
            },
            child: Row(
              children: [
                Icon(
                  Icons.share_outlined,
                  color: isLightTheme ? const Color(0xFF878787) : const Color(0xFF9C9C9D),
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  post.sharesCount.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    color: isLightTheme ? const Color(0xFF878787) : const Color(0xFF9C9C9D),
                  ),
                ),
              ],
            ),
          ),
          
          const Spacer(),
          
          // Bookmark Button
          GestureDetector(
            onTap: () {
              ref.read(postInteractionProvider.notifier)
                  .toggleBookmark(post.id, post.isBookmarked);
            },
            child: Icon(
              post.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: post.isBookmarked 
                  ? const Color(0xFFE91E63)
                  : (isLightTheme ? const Color(0xFF878787) : const Color(0xFF9C9C9D)),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEngagementStats(BuildContext context, PostEntity post, bool isLightTheme) {
    if (post.hashtags.isEmpty) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        children: post.hashtags.map((tag) => Text(
          '#$tag',
          style: TextStyle(
            fontSize: 12,
            color: const Color(0xFF1976D2),
            fontWeight: FontWeight.w500,
          ),
        )).toList(),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }
}