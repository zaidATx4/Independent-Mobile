import '../entities/event_entity.dart';

abstract class EventRepository {
  Future<List<EventEntity>> getEvents();
  Future<List<EventEntity>> getEventsByCategory(String category);
  Future<EventEntity?> getEventById(String id);
  Future<List<EventEntity>> searchEvents(String query);
  Future<List<EventEntity>> getBookmarkedEvents();
  Future<bool> bookmarkEvent(String eventId);
  Future<bool> removeBookmark(String eventId);
}