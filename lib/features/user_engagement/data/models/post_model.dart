import '../../domain/entities/post_entity.dart';

class PostModel extends PostEntity {
  const PostModel({
    required super.id,
    required super.userId,
    required super.userName,
    required super.userAvatar,
    required super.type,
    required super.content,
    super.mediaUrl,
    super.thumbnailUrl,
    required super.likesCount,
    required super.commentsCount,
    required super.sharesCount,
    required super.isLiked,
    required super.isBookmarked,
    required super.createdAt,
    required super.hashtags,
    super.locationTag,
    required super.isPromoted,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      userAvatar: json['userAvatar'] ?? '',
      type: PostType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => PostType.image,
      ),
      content: json['content'] ?? '',
      mediaUrl: json['mediaUrl'],
      thumbnailUrl: json['thumbnailUrl'],
      likesCount: json['likesCount'] ?? 0,
      commentsCount: json['commentsCount'] ?? 0,
      sharesCount: json['sharesCount'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      isBookmarked: json['isBookmarked'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      hashtags: List<String>.from(json['hashtags'] ?? []),
      locationTag: json['locationTag'],
      isPromoted: json['isPromoted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'type': type.name,
      'content': content,
      'mediaUrl': mediaUrl,
      'thumbnailUrl': thumbnailUrl,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'sharesCount': sharesCount,
      'isLiked': isLiked,
      'isBookmarked': isBookmarked,
      'createdAt': createdAt.toIso8601String(),
      'hashtags': hashtags,
      'locationTag': locationTag,
      'isPromoted': isPromoted,
    };
  }

  PostModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userAvatar,
    PostType? type,
    String? content,
    String? mediaUrl,
    String? thumbnailUrl,
    int? likesCount,
    int? commentsCount,
    int? sharesCount,
    bool? isLiked,
    bool? isBookmarked,
    DateTime? createdAt,
    List<String>? hashtags,
    String? locationTag,
    bool? isPromoted,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      type: type ?? this.type,
      content: content ?? this.content,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      sharesCount: sharesCount ?? this.sharesCount,
      isLiked: isLiked ?? this.isLiked,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      createdAt: createdAt ?? this.createdAt,
      hashtags: hashtags ?? this.hashtags,
      locationTag: locationTag ?? this.locationTag,
      isPromoted: isPromoted ?? this.isPromoted,
    );
  }
}