import '../../domain/entities/event_entity.dart';
import '../../domain/repositories/event_repository.dart';
import '../models/event_model.dart';

class EventRepositoryImpl implements EventRepository {
  final List<String> _bookmarkedEventIds = [];

  final List<EventModel> _mockEvents = [
    EventModel(
      id: '1',
      title: 'Flavor Fest',
      description: 'Join us for an amazing culinary experience with local and international flavors.',
      location: 'Salt Marsa Al Arab',
      dateTime: DateTime(2024, 5, 29, 18, 0),
      imageUrl: 'assets/images/Static/Events/Event1.jpg',
      organizerName: 'SALT',
      organizerLogo: 'assets/images/icons/SVGs/salt_logo.svg',
      category: 'Food & Drink',
      attendeeCount: 250,
    ),
    EventModel(
      id: '2', 
      title: 'Flavor Fest',
      description: 'Experience the best food festival in the city with amazing dishes and entertainment.',
      location: 'Salt Marsa Al Arab',
      dateTime: DateTime(2024, 5, 29, 19, 0),
      imageUrl: 'assets/images/Static/Events/Event2.jpg',
      organizerName: 'SALT',
      organizerLogo: 'assets/images/icons/SVGs/salt_logo.svg',
      category: 'Food & Drink',
      attendeeCount: 180,
    ),
    EventModel(
      id: '3',
      title: 'Flavor Fest',
      description: 'A spectacular outdoor food festival with live music and great atmosphere.',
      location: 'Salt Marsa Al Arab',
      dateTime: DateTime(2024, 5, 29, 20, 0),
      imageUrl: 'assets/images/Static/Events/Event3.jpg',
      organizerName: 'PARKERS',
      organizerLogo: 'assets/images/icons/SVGs/parkers_logo.svg',
      category: 'Food & Drink',
      attendeeCount: 320,
    ),
    EventModel(
      id: '4',
      title: 'Night Market Special',
      description: 'Late night food market with special dishes and unique flavors.',
      location: 'Salt Marsa Al Arab',
      dateTime: DateTime(2024, 6, 15, 21, 0),
      imageUrl: 'assets/images/Static/Events/Event4.jpg',
      organizerName: 'Night Market',
      organizerLogo: 'assets/images/icons/SVGs/salt_logo.svg',
      category: 'Food & Drink',
      attendeeCount: 150,
    ),
  ];

  @override
  Future<List<EventEntity>> getEvents() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockEvents.map((model) => model.copyWith(
      isBookmarked: _bookmarkedEventIds.contains(model.id),
    )).toList();
  }

  @override
  Future<List<EventEntity>> getEventsByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockEvents
        .where((event) => event.category.toLowerCase() == category.toLowerCase())
        .map((model) => model.copyWith(
          isBookmarked: _bookmarkedEventIds.contains(model.id),
        ))
        .toList();
  }

  @override
  Future<EventEntity?> getEventById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      final model = _mockEvents.firstWhere((event) => event.id == id);
      return model.copyWith(
        isBookmarked: _bookmarkedEventIds.contains(model.id),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<EventEntity>> searchEvents(String query) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final lowercaseQuery = query.toLowerCase();
    return _mockEvents
        .where((event) =>
            event.title.toLowerCase().contains(lowercaseQuery) ||
            event.description.toLowerCase().contains(lowercaseQuery) ||
            event.location.toLowerCase().contains(lowercaseQuery) ||
            event.organizerName.toLowerCase().contains(lowercaseQuery))
        .map((model) => model.copyWith(
          isBookmarked: _bookmarkedEventIds.contains(model.id),
        ))
        .toList();
  }

  @override
  Future<List<EventEntity>> getBookmarkedEvents() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockEvents
        .where((event) => _bookmarkedEventIds.contains(event.id))
        .map((model) => model.copyWith(isBookmarked: true))
        .toList();
  }

  @override
  Future<bool> bookmarkEvent(String eventId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (!_bookmarkedEventIds.contains(eventId)) {
      _bookmarkedEventIds.add(eventId);
    }
    return true;
  }

  @override
  Future<bool> removeBookmark(String eventId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _bookmarkedEventIds.remove(eventId);
    return true;
  }
}