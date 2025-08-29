class EventEntity {
  final String id;
  final String title;
  final String description;
  final String location;
  final DateTime dateTime;
  final String imageUrl;
  final String organizerName;
  final String organizerLogo;
  final String category;
  final bool isBookmarked;
  final int attendeeCount;

  const EventEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.dateTime,
    required this.imageUrl,
    required this.organizerName,
    required this.organizerLogo,
    required this.category,
    this.isBookmarked = false,
    this.attendeeCount = 0,
  });

  EventEntity copyWith({
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
    return EventEntity(
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EventEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}