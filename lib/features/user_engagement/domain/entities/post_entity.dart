import 'package:equatable/equatable.dart';

enum PostType { image, video, promotion, announcement }

class PostEntity extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final PostType type;
  final String content;
  final String? mediaUrl;
  final String? thumbnailUrl;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final bool isLiked;
  final bool isBookmarked;
  final DateTime createdAt;
  final List<String> hashtags;
  final String? locationTag;
  final bool isPromoted;

  const PostEntity({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.type,
    required this.content,
    this.mediaUrl,
    this.thumbnailUrl,
    required this.likesCount,
    required this.commentsCount,
    required this.sharesCount,
    required this.isLiked,
    required this.isBookmarked,
    required this.createdAt,
    required this.hashtags,
    this.locationTag,
    required this.isPromoted,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        userName,
        userAvatar,
        type,
        content,
        mediaUrl,
        thumbnailUrl,
        likesCount,
        commentsCount,
        sharesCount,
        isLiked,
        isBookmarked,
        createdAt,
        hashtags,
        locationTag,
        isPromoted,
      ];
}