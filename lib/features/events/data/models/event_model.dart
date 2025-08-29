import '../../domain/entities/event_entity.dart';

class EventModel extends EventEntity {
  const EventModel({
    required super.id,
    required super.title,
    required super.description,
    required super.location,
    required super.dateTime,
    required super.imageUrl,
    required super.organizerName,
    required super.organizerLogo,
    required super.category,
    super.isBookmarked,
    super.attendeeCount,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      dateTime: DateTime.parse(json['dateTime'] ?? DateTime.now().toIso8601String()),
      imageUrl: json['imageUrl'] ?? '',
      organizerName: json['organizerName'] ?? '',
      organizerLogo: json['organizerLogo'] ?? '',
      category: json['category'] ?? '',
      isBookmarked: json['isBookmarked'] ?? false,
      attendeeCount: json['attendeeCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'dateTime': dateTime.toIso8601String(),
      'imageUrl': imageUrl,
      'organizerName': organizerName,
      'organizerLogo': organizerLogo,
      'category': category,
      'isBookmarked': isBookmarked,
      'attendeeCount': attendeeCount,
    };
  }

  factory EventModel.fromEntity(EventEntity entity) {
    return EventModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      location: entity.location,
      dateTime: entity.dateTime,
      imageUrl: entity.imageUrl,
      organizerName: entity.organizerName,
      organizerLogo: entity.organizerLogo,
      category: entity.category,
      isBookmarked: entity.isBookmarked,
      attendeeCount: entity.attendeeCount,
    );
  }

  @override
  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    String? location,
    DateTime? dateTime,
    String? imageUrl,
    String? organizerName,
    String? organizerLogo,
    String? category,
    bool? isBookmarked,
    int? attendeeCount,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      dateTime: dateTime ?? this.dateTime,
      imageUrl: imageUrl ?? this.imageUrl,
      organizerName: organizerName ?? this.organizerName,
      organizerLogo: organizerLogo ?? this.organizerLogo,
      category: category ?? this.category,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      attendeeCount: attendeeCount ?? this.attendeeCount,
    );
  }
}