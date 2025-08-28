import 'package:equatable/equatable.dart';

class CommentEntity extends Equatable {
  final String id;
  final String postId;
  final String userId;
  final String userName;
  final String userAvatar;
  final String content;
  final int likesCount;
  final bool isLiked;
  final DateTime createdAt;
  final String? parentCommentId; // For reply comments

  const CommentEntity({
    required this.id,
    required this.postId,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.content,
    required this.likesCount,
    required this.isLiked,
    required this.createdAt,
    this.parentCommentId,
  });

  @override
  List<Object?> get props => [
        id,
        postId,
        userId,
        userName,
        userAvatar,
        content,
        likesCount,
        isLiked,
        createdAt,
        parentCommentId,
      ];
}