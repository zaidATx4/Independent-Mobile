import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/post_entity.dart';
import '../providers/feed_providers.dart';
import '../widgets/full_screen_post_card.dart';

class SingleUserPostsScreen extends ConsumerStatefulWidget {
  final String userId;
  final String userName;
  final String userAvatar;

  const SingleUserPostsScreen({
    super.key,
    required this.userId,
    required this.userName,
    required this.userAvatar,
  });

  @override
  ConsumerState<SingleUserPostsScreen> createState() => _SingleUserPostsScreenState();
}

class _SingleUserPostsScreenState extends ConsumerState<SingleUserPostsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLightTheme = theme.brightness == Brightness.light;

    return Scaffold(
      backgroundColor: isLightTheme ? const Color(0xFFFFFBF1) : const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context, isLightTheme),
            _buildUserProfile(context, isLightTheme),
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  final userPostsAsync = ref.watch(userPostsProvider(widget.userId));
                  
                  return userPostsAsync.when(
                    data: (userPosts) {
                      if (userPosts.isEmpty) {
                        return _buildEmptyState(isLightTheme);
                      }
                      
                      return _buildPostsGrid(userPosts, isLightTheme);
                    },
                    loading: () => _buildLoadingState(isLightTheme),
                    error: (error, stack) => _buildErrorState(isLightTheme),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isLightTheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isLightTheme ? const Color(0xFF1A1A1A) : const Color(0xFFFEFEFF),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(44),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 16,
                color: isLightTheme ? const Color(0xFF1A1A1A) : const Color(0xFFFEFEFF),
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildUserProfile(BuildContext context, bool isLightTheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          // Profile Avatar
          Container(
            width: 75,
            height: 75,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: ClipOval(
              child: Image.asset(
                widget.userAvatar,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade400,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.grey.shade600,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // User Name
          Text(
            widget.userName,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              fontSize: 16,
              height: 1.5, // 24/16 = 1.5
              color: isLightTheme ? const Color(0xFF1A1A1A) : const Color(0xFFFEFEFF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostsGrid(List<PostEntity> posts, bool isLightTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        padding: const EdgeInsets.only(bottom: 16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 9 / 16, // Match Figma aspect ratio
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return _buildPostThumbnail(post, index, isLightTheme);
        },
      ),
    );
  }

  Widget _buildPostThumbnail(PostEntity post, int index, bool isLightTheme) {
    return GestureDetector(
      onTap: () {
        // Navigate to full screen post view starting from this index
        final allUserPosts = ref.read(userPostsProvider(widget.userId)).asData?.value ?? [];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => _FullScreenPostsView(
              posts: allUserPosts,
              initialIndex: index,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xFF363636),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: post.mediaUrl != null
              ? Image.asset(
                  post.mediaUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFF363636),
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    );
                  },
                )
              : Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.blue.shade800,
                        Colors.purple.shade800,
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.restaurant_menu,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isLightTheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 64,
            color: isLightTheme ? const Color(0xFF878787) : const Color(0xFF9C9C9D),
          ),
          const SizedBox(height: 16),
          Text(
            'No posts yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isLightTheme ? const Color(0xFF1A1A1A) : const Color(0xFFFEFEFF),
              fontFamily: 'Roboto',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This user hasn\'t shared any posts yet',
            style: TextStyle(
              fontSize: 14,
              color: isLightTheme ? const Color(0xFF878787) : const Color(0xFF9C9C9D),
              fontFamily: 'Roboto',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(bool isLightTheme) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          isLightTheme ? const Color(0xFF1A1A1A) : const Color(0xFFFEFEFF),
        ),
      ),
    );
  }

  Widget _buildErrorState(bool isLightTheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load posts',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isLightTheme ? const Color(0xFF1A1A1A) : const Color(0xFFFEFEFF),
              fontFamily: 'Roboto',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please check your connection and try again',
            style: TextStyle(
              fontSize: 14,
              color: isLightTheme ? const Color(0xFF878787) : const Color(0xFF9C9C9D),
              fontFamily: 'Roboto',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.invalidate(userPostsProvider(widget.userId));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isLightTheme ? const Color(0xFF1A1A1A) : const Color(0xFFFEFEFF),
              foregroundColor: isLightTheme ? const Color(0xFFFEFEFF) : const Color(0xFF1A1A1A),
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}

// Helper widget for full screen post viewing from grid
class _FullScreenPostsView extends ConsumerStatefulWidget {
  final List<PostEntity> posts;
  final int initialIndex;

  const _FullScreenPostsView({
    required this.posts,
    required this.initialIndex,
  });

  @override
  ConsumerState<_FullScreenPostsView> createState() => _FullScreenPostsViewState();
}

class _FullScreenPostsViewState extends ConsumerState<_FullScreenPostsView> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: widget.posts.length,
        itemBuilder: (context, index) {
          return FullScreenPostCard(post: widget.posts[index]);
        },
      ),
    );
  }
}