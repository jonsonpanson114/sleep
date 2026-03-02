import 'package:go_router/go_router.dart';
import '../domain/entities/routine_task.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/routine/evening_routine_screen.dart';
import '../presentation/screens/routine/morning_routine_screen.dart';
import '../presentation/screens/settings/settings_screen.dart';
import '../presentation/screens/edit_routine/edit_routine_screen.dart';
import '../presentation/screens/history/history_screen.dart';
import '../presentation/screens/insights/insights_screen.dart';
import '../presentation/screens/badges/badges_screen.dart';
import '../presentation/screens/weekly_report/weekly_report_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/routine/evening',
        builder: (context, state) => const EveningRoutineScreen(),
      ),
      GoRoute(
        path: '/routine/morning',
        builder: (context, state) => const MorningRoutineScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/routine/:type/edit',
        builder: (context, state) {
          final type = state.pathParameters['type'] == 'morning' ? RoutineType.morning : RoutineType.evening;
          return EditRoutineScreen(type: type);
        },
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: '/insights',
        builder: (context, state) => const InsightsScreen(),
      ),
      GoRoute(
        path: '/badges',
        builder: (context, state) => const BadgesScreen(),
      ),
      GoRoute(
        path: '/report',
        builder: (context, state) => const WeeklyReportScreen(),
      ),
    ],
  );
}
