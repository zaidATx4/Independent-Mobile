import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/event_repository_impl.dart';
import '../../domain/entities/event_entity.dart';
import '../../domain/repositories/event_repository.dart';
import '../../domain/usecases/bookmark_event_usecase.dart';
import '../../domain/usecases/get_events_usecase.dart';
import '../../domain/usecases/search_events_usecase.dart';

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return EventRepositoryImpl();
});

final getEventsUsecaseProvider = Provider<GetEventsUsecase>((ref) {
  return GetEventsUsecase(ref.watch(eventRepositoryProvider));
});

final searchEventsUsecaseProvider = Provider<SearchEventsUsecase>((ref) {
  return SearchEventsUsecase(ref.watch(eventRepositoryProvider));
});

final bookmarkEventUsecaseProvider = Provider<BookmarkEventUsecase>((ref) {
  return BookmarkEventUsecase(ref.watch(eventRepositoryProvider));
});

final eventsProvider = FutureProvider<List<EventEntity>>((ref) async {
  final usecase = ref.watch(getEventsUsecaseProvider);
  return await usecase.call();
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredEventsProvider = FutureProvider<List<EventEntity>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  final usecase = ref.watch(searchEventsUsecaseProvider);
  return await usecase.call(query);
});

final bookmarkedEventsProvider = FutureProvider<List<EventEntity>>((ref) async {
  final repository = ref.watch(eventRepositoryProvider);
  return await repository.getBookmarkedEvents();
});

class EventsNotifier extends StateNotifier<AsyncValue<List<EventEntity>>> {
  final EventRepository _repository;
  final BookmarkEventUsecase _bookmarkUsecase;

  EventsNotifier(this._repository, this._bookmarkUsecase) 
      : super(const AsyncValue.loading()) {
    loadEvents();
  }

  Future<void> loadEvents() async {
    state = const AsyncValue.loading();
    try {
      final events = await _repository.getEvents();
      state = AsyncValue.data(events);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> toggleBookmark(String eventId) async {
    final currentState = state;
    if (currentState is AsyncData<List<EventEntity>>) {
      final events = currentState.value;
      final eventIndex = events.indexWhere((e) => e.id == eventId);
      
      if (eventIndex != -1) {
        final event = events[eventIndex];
        final newBookmarkStatus = !event.isBookmarked;
        
        final updatedEvents = [...events];
        updatedEvents[eventIndex] = event.copyWith(isBookmarked: newBookmarkStatus);
        state = AsyncValue.data(updatedEvents);
        
        try {
          await _bookmarkUsecase.call(eventId, newBookmarkStatus);
        } catch (error) {
          state = AsyncValue.data(events);
        }
      }
    }
  }

  Future<void> refreshEvents() async {
    await loadEvents();
  }
}

final eventsNotifierProvider = StateNotifierProvider<EventsNotifier, AsyncValue<List<EventEntity>>>((ref) {
  final repository = ref.watch(eventRepositoryProvider);
  final bookmarkUsecase = ref.watch(bookmarkEventUsecaseProvider);
  return EventsNotifier(repository, bookmarkUsecase);
});