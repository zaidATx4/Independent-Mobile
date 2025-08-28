import '../../domain/entities/user_story_entity.dart';

class UserStoryModel extends UserStoryEntity {
  const UserStoryModel({
    required super.id,
    required super.userId,
    required super.userName,
    required super.userAvatar,
    required super.mediaUrl,
    super.thumbnailUrl,
    required super.isViewed,
    required super.createdAt,
    required super.expiresAt,
    super.content,
  });

  factory UserStoryModel.fromJson(Map<String, dynamic> json) {
    return UserStoryModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      userAvatar: json['userAvatar'] ?? '',
      mediaUrl: json['mediaUrl'] ?? '',
      thumbnailUrl: json['thumbnailUrl'],
      isViewed: json['isViewed'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      expiresAt: DateTime.parse(json['expiresAt'] ?? DateTime.now().add(const Duration(hours: 24)).toIso8601String()),
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'mediaUrl': mediaUrl,
      'thumbnailUrl': thumbnailUrl,
      'isViewed': isViewed,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
      'content': content,
    };
  }
}