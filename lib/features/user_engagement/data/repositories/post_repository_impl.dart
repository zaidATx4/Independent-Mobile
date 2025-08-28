import '../../domain/entities/comment_entity.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/post_repository.dart';
import '../models/post_model.dart';

class PostRepositoryImpl implements PostRepository {
  // Mock data - in production this would come from API/database
  final List<PostModel> _mockPosts = [
    PostModel(
      id: '1',
      userId: 'user_john',
      userName: 'John Smith',
      userAvatar: 'assets/images/Static/Profile_images/1.jpg',
      type: PostType.image,
      content: 'Amazing brunch experience at this cozy café! ☕✨ The presentation and taste were absolutely perfect.',
      mediaUrl: 'assets/images/Static/Restaurant_Foods/Pink_Cake1.jpg',
      thumbnailUrl: 'assets/images/Static/Restaurant_Foods/Pink_Cake1.jpg',
      likesCount: 1245,
      commentsCount: 23,
      sharesCount: 8,
      isLiked: true,
      isBookmarked: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      hashtags: ['Brunch', 'Coffee', 'Perfect'],
      locationTag: 'Cozy Corner Café - Marina',
      isPromoted: false,
    ),
    PostModel(
      id: '2',
      userId: 'user_john',
      userName: 'John Smith',
      userAvatar: 'assets/images/Static/Profile_images/1.jpg',
      type: PostType.image,
      content: 'Incredible pasta night! 🍝 This place knows how to make authentic Italian cuisine.',
      mediaUrl: 'assets/images/Static/Restaurant_Foods/Red_Cake.jpg',
      thumbnailUrl: 'assets/images/Static/Restaurant_Foods/Red_Cake.jpg',
      likesCount: 987,
      commentsCount: 19,
      sharesCount: 12,
      isLiked: false,
      isBookmarked: true,
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      hashtags: ['Pasta', 'Italian', 'Dinner'],
      locationTag: 'Bella Vista Restaurant - JBR',
      isPromoted: false,
    ),
    PostModel(
      id: '3',
      userId: 'user_john',
      userName: 'John Smith',
      userAvatar: 'assets/images/Static/Profile_images/1.jpg',
      type: PostType.image,
      content: 'Decadent chocolate dessert that melted my heart! 🍫💕 Pure indulgence.',
      mediaUrl: 'assets/images/Static/Restaurant_Foods/Matilda_Cake1.jpg',
      thumbnailUrl: 'assets/images/Static/Restaurant_Foods/Matilda_Cake1.jpg',
      likesCount: 1567,
      commentsCount: 34,
      sharesCount: 15,
      isLiked: true,
      isBookmarked: true,
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      hashtags: ['Chocolate', 'Dessert', 'Sweet'],
      locationTag: 'Sweet Dreams Patisserie - Mall',
      isPromoted: false,
    ),
    PostModel(
      id: '4',
      userId: 'user_john',
      userName: 'John Smith',
      userAvatar: 'assets/images/Static/Profile_images/1.jpg',
      type: PostType.image,
      content: 'Fresh sushi experience! 🍣 The quality and presentation exceeded my expectations.',
      mediaUrl: 'assets/images/Static/Restaurant_Foods/Pink_Cake1.jpg',
      thumbnailUrl: 'assets/images/Static/Restaurant_Foods/Pink_Cake1.jpg',
      likesCount: 823,
      commentsCount: 16,
      sharesCount: 7,
      isLiked: false,
      isBookmarked: false,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      hashtags: ['Sushi', 'Fresh', 'Japanese'],
      locationTag: 'Sakura Sushi - Business Bay',
      isPromoted: false,
    ),
    PostModel(
      id: '5',
      userId: 'user_john',
      userName: 'John Smith',
      userAvatar: 'assets/images/Static/Profile_images/1.jpg',
      type: PostType.image,
      content: 'Grilled perfection! 🥩 This steakhouse really knows their craft.',
      mediaUrl: 'assets/images/Static/Restaurant_Foods/Red_Cake.jpg',
      thumbnailUrl: 'assets/images/Static/Restaurant_Foods/Red_Cake.jpg',
      likesCount: 1134,
      commentsCount: 28,
      sharesCount: 11,
      isLiked: true,
      isBookmarked: false,
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 8)),
      hashtags: ['Steak', 'Grilled', 'Premium'],
      locationTag: 'Prime Cuts - Downtown',
      isPromoted: false,
    ),
    PostModel(
      id: '6',
      userId: 'user_john',
      userName: 'John Smith',
      userAvatar: 'assets/images/Static/Profile_images/1.jpg',
      type: PostType.image,
      content: 'Artisanal pizza with the perfect crust! 🍕 Every bite was heavenly.',
      mediaUrl: 'assets/images/Static/Restaurant_Foods/Matilda_Cake1.jpg',
      thumbnailUrl: 'assets/images/Static/Restaurant_Foods/Matilda_Cake1.jpg',
      likesCount: 756,
      commentsCount: 12,
      sharesCount: 9,
      isLiked: false,
      isBookmarked: true,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      hashtags: ['Pizza', 'Artisanal', 'Perfect'],
      locationTag: 'Wood Fire Kitchen - Marina',
      isPromoted: false,
    ),
    PostModel(
      id: '7',
      userId: 'user_john',
      userName: 'John Smith',
      userAvatar: 'assets/images/Static/Profile_images/1.jpg',
      type: PostType.image,
      content: 'Tropical smoothie bowl paradise! 🥥🥭 Healthy and incredibly delicious.',
      mediaUrl: 'assets/images/Static/Restaurant_Foods/Pink_Cake1.jpg',
      thumbnailUrl: 'assets/images/Static/Restaurant_Foods/Pink_Cake1.jpg',
      likesCount: 645,
      commentsCount: 18,
      sharesCount: 6,
      isLiked: true,
      isBookmarked: false,
      createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 12)),
      hashtags: ['Smoothie', 'Healthy', 'Tropical'],
      locationTag: 'Green Paradise - JBR Beach',
      isPromoted: false,
    ),
    PostModel(
      id: '8',
      userId: 'user_john',
      userName: 'John Smith',
      userAvatar: 'assets/images/Static/Profile_images/1.jpg',
      type: PostType.image,
      content: 'Gourmet burger experience! 🍔 The flavors were incredibly balanced.',
      mediaUrl: 'assets/images/Static/Restaurant_Foods/Red_Cake.jpg',
      thumbnailUrl: 'assets/images/Static/Restaurant_Foods/Red_Cake.jpg',
      likesCount: 892,
      commentsCount: 21,
      sharesCount: 13,
      isLiked: false,
      isBookmarked: true,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      hashtags: ['Burger', 'Gourmet', 'Balanced'],
      locationTag: 'Burger Lab - City Walk',
      isPromoted: false,
    ),
    PostModel(
      id: '9',
      userId: 'user_john',
      userName: 'John Smith',
      userAvatar: 'assets/images/Static/Profile_images/1.jpg',
      type: PostType.image,
      content: 'Exquisite fine dining experience! ✨🍽️ Every detail was perfect.',
      mediaUrl: 'assets/images/Static/Restaurant_Foods/Matilda_Cake1.jpg',
      thumbnailUrl: 'assets/images/Static/Restaurant_Foods/Matilda_Cake1.jpg',
      likesCount: 1456,
      commentsCount: 39,
      sharesCount: 22,
      isLiked: true,
      isBookmarked: true,
      createdAt: DateTime.now().subtract(const Duration(days: 3, hours: 18)),
      hashtags: ['FineDining', 'Exquisite', 'Perfect'],
      locationTag: 'Le Gourmet - Burj Al Arab',
      isPromoted: false,
    ),
    PostModel(
      id: '10',
      userId: 'user_2',
      userName: 'Sarah Johnson',
      userAvatar: 'assets/images/Static/Profile_images/2.jpg',
      type: PostType.image,
      content:
          'Perfect weekend vibes at Somewhere! 🍹☀️ Their dessert is absolutely refreshing and the ambiance is perfect for relaxing with friends.',
      mediaUrl: 'assets/images/Static/Restaurant_Foods/Pink_Cake1.jpg',
      thumbnailUrl: 'assets/images/Static/Restaurant_Foods/Pink_Cake1.jpg',
      likesCount: 892,
      commentsCount: 15,
      sharesCount: 5,
      isLiked: true,
      isBookmarked: true,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      hashtags: ['Somewhere', 'Dessert', 'Weekend', 'Relax'],
      locationTag: 'Somewhere Café - JBR',
      isPromoted: false,
    ),
    PostModel(
      id: '11',
      userId: 'user_3',
      userName: 'Mohammad Hassan',
      userAvatar: 'assets/images/Static/Profile_images/3.jpg',
      type: PostType.promotion,
      content:
          '🎉 SPECIAL OFFER! Get 25% off on all cakes this week at Switch! Don\'t miss out on our signature chocolate cake. Valid until Sunday!',
      mediaUrl: 'assets/images/Static/Restaurant_Foods/Red_Cake.jpg',
      thumbnailUrl: 'assets/images/Static/Restaurant_Foods/Red_Cake.jpg',
      likesCount: 2156,
      commentsCount: 42,
      sharesCount: 18,
      isLiked: false,
      isBookmarked: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
      hashtags: ['Switch', 'Offer', 'Cake', 'Discount'],
      locationTag: 'Switch Restaurant - Mall of Emirates',
      isPromoted: true,
    ),
    PostModel(
      id: '12',
      userId: 'user_4',
      userName: 'Fatima Al-Zahra',
      userAvatar: 'assets/images/Static/Profile_images/1.jpg',
      type: PostType.image,
      content:
          'Comfort dessert at its finest! 🧁 Parkers always delivers the most delicious and sweet treats. Perfect for a cozy evening.',
      mediaUrl: 'assets/images/Static/Restaurant_Foods/Matilda_Cake1.jpg',
      thumbnailUrl: 'assets/images/Static/Restaurant_Foods/Matilda_Cake1.jpg',
      likesCount: 675,
      commentsCount: 8,
      sharesCount: 3,
      isLiked: false,
      isBookmarked: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      hashtags: ['Parkers', 'ComfortFood', 'Dessert'],
      locationTag: 'Parkers Restaurant - Downtown',
      isPromoted: false,
    ),
  ];

  @override
  Future<List<PostEntity>> getFeedPosts({int page = 1, int limit = 20}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;

    if (startIndex >= _mockPosts.length) {
      return [];
    }

    final posts = _mockPosts.sublist(
      startIndex,
      endIndex > _mockPosts.length ? _mockPosts.length : endIndex,
    );

    return posts;
  }

  @override
  Future<PostEntity?> getPostById(String postId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      return _mockPosts.firstWhere((post) => post.id == postId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> likePost(String postId) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final postIndex = _mockPosts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      final post = _mockPosts[postIndex];
      _mockPosts[postIndex] = post.copyWith(
        isLiked: true,
        likesCount: post.likesCount + 1,
      );
      return true;
    }
    return false;
  }

  @override
  Future<bool> unlikePost(String postId) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final postIndex = _mockPosts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      final post = _mockPosts[postIndex];
      _mockPosts[postIndex] = post.copyWith(
        isLiked: false,
        likesCount: post.likesCount > 0 ? post.likesCount - 1 : 0,
      );
      return true;
    }
    return false;
  }

  @override
  Future<bool> bookmarkPost(String postId) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final postIndex = _mockPosts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      final post = _mockPosts[postIndex];
      _mockPosts[postIndex] = post.copyWith(isBookmarked: true);
      return true;
    }
    return false;
  }

  @override
  Future<bool> unbookmarkPost(String postId) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final postIndex = _mockPosts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      final post = _mockPosts[postIndex];
      _mockPosts[postIndex] = post.copyWith(isBookmarked: false);
      return true;
    }
    return false;
  }

  @override
  Future<bool> sharePost(String postId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final postIndex = _mockPosts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      final post = _mockPosts[postIndex];
      _mockPosts[postIndex] = post.copyWith(sharesCount: post.sharesCount + 1);
      return true;
    }
    return false;
  }

  @override
  Future<List<CommentEntity>> getPostComments(
    String postId, {
    int page = 1,
    int limit = 10,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));

    // Mock comments data
    return [
      CommentEntity(
        id: 'comment_1',
        postId: postId,
        userId: 'user_5',
        userName: 'Omar Khalil',
        userAvatar: 'assets/images/Static/Profile_images/2.jpg',
        content: 'Looks absolutely delicious! 😍',
        likesCount: 12,
        isLiked: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      CommentEntity(
        id: 'comment_2',
        postId: postId,
        userId: 'user_6',
        userName: 'Layla Mansour',
        userAvatar: 'assets/images/Static/Profile_images/3.jpg',
        content: 'I need to try this place! Thanks for sharing 🙏',
        likesCount: 8,
        isLiked: true,
        createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
      ),
    ];
  }

  @override
  Future<bool> addComment(String postId, String content) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final postIndex = _mockPosts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      final post = _mockPosts[postIndex];
      _mockPosts[postIndex] = post.copyWith(
        commentsCount: post.commentsCount + 1,
      );
      return true;
    }
    return false;
  }

  @override
  Future<bool> likeComment(String commentId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true; // Mock success
  }

  @override
  Future<bool> unlikeComment(String commentId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true; // Mock success
  }

  // Additional method to get posts by user ID
  @override
  Future<List<PostEntity>> getPostsByUserId(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Filter posts by userId - in production this would be done by API
    final userPosts = _mockPosts.where((post) => post.userId == userId).toList();
    
    // Sort by creation date (newest first)
    userPosts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    return userPosts;
  }

  @override
  Future<PostEntity?> createPost({
    required String content,
    String? mediaUrl,
    List<String>? hashtags,
    String? locationTag,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    
    try {
      // Generate new post ID
      final postId = (_mockPosts.length + 1).toString();
      
      // Create new post - In production, this would be the current user
      final newPost = PostModel(
        id: postId,
        userId: 'user_john', // Mock current user
        userName: 'John Smith',
        userAvatar: 'assets/images/Static/Profile_images/1.jpg',
        type: mediaUrl != null ? PostType.image : PostType.announcement,
        content: content,
        mediaUrl: mediaUrl,
        thumbnailUrl: mediaUrl,
        likesCount: 0,
        commentsCount: 0,
        sharesCount: 0,
        isLiked: false,
        isBookmarked: false,
        createdAt: DateTime.now(),
        hashtags: hashtags ?? [],
        locationTag: locationTag,
        isPromoted: false,
      );
      
      // Add to the beginning of the list (newest first)
      _mockPosts.insert(0, newPost);
      
      return newPost;
    } catch (e) {
      return null;
    }
  }
}
