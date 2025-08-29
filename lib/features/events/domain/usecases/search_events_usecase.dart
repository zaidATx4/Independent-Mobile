import '../entities/event_entity.dart';
import '../repositories/event_repository.dart';

class SearchEventsUsecase {
  final EventRepository repository;

  const SearchEventsUsecase(this.repository);

  Future<List<EventEntity>> call(String query) async {
    if (query.trim().isEmpty) {
      return await repository.getEvents();
    }
    return await repository.searchEvents(query);
  }
}