import '../entities/event_entity.dart';
import '../repositories/event_repository.dart';

class GetEventsUsecase {
  final EventRepository repository;

  const GetEventsUsecase(this.repository);

  Future<List<EventEntity>> call() async {
    return await repository.getEvents();
  }
}