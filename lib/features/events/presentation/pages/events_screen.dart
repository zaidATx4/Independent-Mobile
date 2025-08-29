import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/events_providers.dart';
import '../widgets/event_card.dart';

class EventsScreen extends ConsumerStatefulWidget {
  const EventsScreen({super.key});

  @override
  ConsumerState<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends ConsumerState<EventsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final eventsAsync = ref.watch(eventsNotifierProvider);

    return Scaffold(
      backgroundColor: isLight ? const Color(0xFFFFFCF5) : const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context, isLight),
            Expanded(
              child: _buildEventsContent(eventsAsync, isLight),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isLight) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isLight
                      ? const Color(0xFF242424)
                      : const Color(0xFFFEFEFF),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(44),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 16,
                color: isLight
                    ? const Color(0xFF242424)
                    : const Color(0xFFFEFEFF),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Events',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w700,
                fontSize: 24,
                height: 1.33,
                color: isLight
                    ? const Color(0xFF242424)
                    : const Color(0xFFFEFEFF),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsContent(AsyncValue eventsAsync, bool isLight) {
    return eventsAsync.when(
      data: (events) => _buildEventsList(events, isLight),
      loading: () => _buildLoadingState(isLight),
      error: (error, stackTrace) => _buildErrorState(error, isLight),
    );
  }

  Widget _buildEventsList(List events, bool isLight) {
    if (events.isEmpty) {
      return _buildEmptyState(isLight);
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(eventsNotifierProvider);
      },
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final event = events[index];
                  return EventCard(
                    event: event,
                    onTap: () => _handleEventTap(event),
                  );
                },
                childCount: events.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(bool isLight) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: isLight ? const Color(0xFF242424) : const Color(0xFFFEFEFF),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading events...',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: isLight
                  ? const Color(0xFF242424).withValues(alpha: 0.7)
                  : const Color(0xFFFEFEFF).withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object error, bool isLight) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: isLight
                  ? const Color(0xFF242424).withValues(alpha: 0.5)
                  : const Color(0xFFFEFEFF).withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load events',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: isLight
                    ? const Color(0xFF242424)
                    : const Color(0xFFFEFEFF),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your connection and try again',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: isLight
                    ? const Color(0xFF242424).withValues(alpha: 0.7)
                    : const Color(0xFFFEFEFF).withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isLight
                    ? const Color(0xFF242424)
                    : const Color(0xFFFEFEFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              onPressed: () {
                ref.invalidate(eventsNotifierProvider);
              },
              child: Text(
                'Try Again',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: isLight
                      ? const Color(0xFFFEFEFF)
                      : const Color(0xFF242424),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isLight) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_available,
              size: 64,
              color: isLight
                  ? const Color(0xFF242424).withValues(alpha: 0.5)
                  : const Color(0xFFFEFEFF).withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No events available',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: isLight
                    ? const Color(0xFF242424)
                    : const Color(0xFFFEFEFF),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check back later for upcoming events',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: isLight
                    ? const Color(0xFF242424).withValues(alpha: 0.7)
                    : const Color(0xFFFEFEFF).withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _handleEventTap(dynamic event) {
    context.push(
      '/events/${event.id}',
      extra: {'event': event},
    );
  }
}