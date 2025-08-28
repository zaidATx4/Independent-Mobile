import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../domain/entities/post_entity.dart';
import '../providers/feed_providers.dart';
import '../pages/single_user_posts_screen.dart';
import '../pages/create_post_screen.dart';

class FullScreenPostCard extends ConsumerWidget {
  final PostEntity post;

  const FullScreenPostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final bottomNavHeight = 80.0; // Approximate bottom nav height
    
    final postInteractions = ref.watch(postInteractionProvider);
    final currentPost = postInteractions[post.id] ?? post;

    return SizedBox(
      height: screenHeight - bottomNavHeight,
      width: screenWidth,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image - Full Screen
          _buildBackgroundImage(context, currentPost),
          
          // Dark Gradient Overlay for better text visibility
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.3),
                  Colors.black.withValues(alpha: 0.7),
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
            ),
          ),


          // Right Side Action Buttons
          Positioned(
            right: 16,
            bottom: 160, // Position from bottom like in Figma
            child: _buildActionButtons(context, ref, currentPost),
          ),

          // Bottom Content Section
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: _buildBottomContent(context, currentPost),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage(BuildContext context, PostEntity post) {
    return post.mediaUrl != null
        ? Image.asset(
            post.mediaUrl!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey.shade800,
                child: const Center(
                  child: Icon(
                    Icons.image_not_supported,
                    color: Colors.white,
                    size: 64,
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
                size: 64,
              ),
            ),
          );
  }


  Widget _buildActionButtons(BuildContext context, WidgetRef ref, PostEntity post) {
    return Column(
      children: [
        // Add/Follow Button (+ button)
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreatePostScreen(),
              ),
            );
          },
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFFFBF1), // #FFFBF1 from design system
            ),
            child: const Icon(
              Icons.add,
              color: Color(0xFF242424), // #242424 from design system
              size: 16,
            ),
          ),
        ),
        const SizedBox(height: 24),
        
        // Profile Avatar
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
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1),
            ),
            child: ClipOval(
              child: Image.asset(
                post.userAvatar,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade400,
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 16,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Like Button with Count Below
        Column(
          children: [
            GestureDetector(
              onTap: () {
                ref.read(postInteractionProvider.notifier)
                    .toggleLike(post.id, post.isLiked);
              },
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                ),
                child: SvgPicture.asset(
                  post.isLiked 
                      ? 'assets/images/icons/SVGs/heart_like_icon_filled.svg'
                      : 'assets/images/icons/SVGs/heart_like_icon.svg',
                  width: 24,
                  height: 24,
                  colorFilter: post.isLiked 
                      ? null
                      : const ColorFilter.mode(
                          Color(0xFFFEFEFF),
                          BlendMode.srcIn,
                        ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatCount(post.likesCount),
              style: const TextStyle(
                color: Color(0xCCFEFEFF), // #FEFEFFCC from design system
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: 'Roboto',
              ),
            ),
          ],
        ),
      ],
    );
  }


  Widget _buildBottomContent(BuildContext context, PostEntity post) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Hashtags first (as shown in Figma)
        if (post.hashtags.isNotEmpty)
          Text(
            post.hashtags.map((tag) => '#$tag').join(' '),
            style: const TextStyle(
              color: Color(0xFFFEFEFF), // #FEFEFF from design system
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Roboto',
              height: 1.5, // 24/16 = 1.5 line height
            ),
          ),
        
        // Post Content
        if (post.content.isNotEmpty) ...[ 
          const SizedBox(height: 4),
          Text(
            post.content,
            style: const TextStyle(
              color: Color(0xFFFEFEFF), // #FEFEFF from design system
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Roboto',
              height: 1.5, // 24/16 = 1.5 line height
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

}