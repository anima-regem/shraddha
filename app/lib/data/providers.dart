import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'db/database.dart';
import 'repository.dart';
import 'stats_logic.dart';
import 'sync_service.dart';

/// Overridden in main() with the real instance.
final sharedPrefsProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('Overridden in main'),
);

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final contentRepositoryProvider = Provider<ContentRepository>(
  (ref) => ContentRepository(ref.watch(databaseProvider)),
);

final syncServiceProvider = Provider<SyncService>(
  (ref) => SyncService(
    repository: ref.watch(contentRepositoryProvider),
    prefs: ref.watch(sharedPrefsProvider),
  ),
);

// ------------------------------------------------------------------ content

final subjectsProvider = StreamProvider<List<Subject>>(
  (ref) => ref.watch(contentRepositoryProvider).watchSubjects(),
);

final dueCountsProvider = FutureProvider<Map<String, int>>(
  (ref) {
    // Re-computes whenever any review happens today.
    ref.watch(todayCountProvider);
    return ref.watch(contentRepositoryProvider).dueCounts();
  },
);

// ----------------------------------------------------------------- tracking

final todayCountProvider = StreamProvider<int>(
  (ref) => ref.watch(contentRepositoryProvider).watchTodayCount(),
);

/// Review logs for the last 370 days, streaming so heatmap/streaks update live.
final recentLogsProvider = StreamProvider<List<ReviewLog>>((ref) {
  final since = dateOnly(DateTime.now()).subtract(const Duration(days: 370));
  return ref.watch(contentRepositoryProvider).watchLogsSince(since);
});

final heatmapProvider = Provider<Map<DateTime, int>>((ref) {
  final logs = ref.watch(recentLogsProvider).valueOrNull ?? const [];
  return countByDay(logs.map((l) => l.timestamp));
});

final streakProvider = Provider<({int current, int longest})>((ref) {
  final byDay = ref.watch(heatmapProvider);
  return (
    current: currentStreak(byDay, DateTime.now()),
    longest: longestStreak(byDay),
  );
});

final subjectAccuracyProvider =
    FutureProvider<Map<String, ({int attempts, int correct})>>((ref) {
  ref.watch(recentLogsProvider);
  return ref.watch(contentRepositoryProvider).subjectAccuracy();
});

final weakTopicsProvider = FutureProvider<
    List<({String subjectId, String topic, int attempts, double accuracy})>>(
  (ref) {
    ref.watch(recentLogsProvider);
    return ref.watch(contentRepositoryProvider).weakTopics();
  },
);

// ----------------------------------------------------------------- settings

const defaultDailyGoal = 20;

final dailyGoalProvider =
    StateNotifierProvider<DailyGoalNotifier, int>((ref) {
  return DailyGoalNotifier(ref.watch(sharedPrefsProvider));
});

class DailyGoalNotifier extends StateNotifier<int> {
  static const _key = 'daily_goal';
  final SharedPreferences prefs;

  DailyGoalNotifier(this.prefs) : super(prefs.getInt(_key) ?? defaultDailyGoal);

  void set(int goal) {
    state = goal;
    prefs.setInt(_key, goal);
  }
}

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, bool>((ref) {
  return ThemeModeNotifier(ref.watch(sharedPrefsProvider));
});

/// true = dark mode (default), false = light.
class ThemeModeNotifier extends StateNotifier<bool> {
  static const _key = 'dark_mode';
  final SharedPreferences prefs;

  ThemeModeNotifier(this.prefs) : super(prefs.getBool(_key) ?? true);

  void toggle() {
    state = !state;
    prefs.setBool(_key, state);
  }
}
