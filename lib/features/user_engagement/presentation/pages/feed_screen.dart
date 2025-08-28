import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/feed_providers.dart';
import '../widgets/full_screen_post_card.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postsAsync = ref.watch(feedPostsProvider);

    return Scaffold(
      backgroundColor: Colors.black, // Always black background for full screen posts
      body: postsAsync.when(
        data: (posts) {
          if (posts.isEmpty) {
            return _buildEmptyState();
          }

          return PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical, // Vertical scrolling like TikTok
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return FullScreenPostCard(post: post);
            },
          );
        },
        loading: () => _buildLoadingState(),
        error: (error, stack) => _buildErrorState(),
      ),
    );
  }


  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.feed_outlined,
            size: 64,
            color: Colors.white,
          ),
          SizedBox(height: 16),
          Text(
            'No posts yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontFamily: 'Roboto',
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Follow some friends to see their posts in your feed',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
              fontFamily: 'Roboto',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }

  Widget _buildErrorState() {
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
          const Text(
            'Failed to load posts',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontFamily: 'Roboto',
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Please check your connection and try again',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
              fontFamily: 'Roboto',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.invalidate(feedPostsProvider);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}