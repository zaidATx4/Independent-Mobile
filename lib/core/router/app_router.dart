import 'package:go_router/go_router.dart';
import 'package:independent/features/settings/presentation/settings_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/settings',
  routes: [
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    // Add other routes here
  ],
);
