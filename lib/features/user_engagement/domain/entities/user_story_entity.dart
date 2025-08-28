import 'package:equatable/equatable.dart';

class UserStoryEntity extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String mediaUrl;
  final String? thumbnailUrl;
  final bool isViewed;
  final DateTime createdAt;
  final DateTime expiresAt;
  final String? content;

  const UserStoryEntity({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.mediaUrl,
    this.thumbnailUrl,
    required this.isViewed,
    required this.createdAt,
    required this.expiresAt,
    this.content,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        userName,
        userAvatar,
        mediaUrl,
        thumbnailUrl,
        isViewed,
        createdAt,
        expiresAt,
        content,
      ];
}