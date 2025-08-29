import '../repositories/event_repository.dart';

class BookmarkEventUsecase {
  final EventRepository repository;

  const BookmarkEventUsecase(this.repository);

  Future<bool> call(String eventId, bool bookmark) async {
    if (bookmark) {
      return await repository.bookmarkEvent(eventId);
    } else {
      return await repository.removeBookmark(eventId);
    }
  }
}