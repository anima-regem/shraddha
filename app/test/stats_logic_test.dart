import 'package:flutter_test/flutter_test.dart';
import 'package:shraddha/data/stats_logic.dart';

void main() {
  final today = DateTime(2026, 7, 29);

  Map<DateTime, int> activityOn(List<DateTime> days) =>
      {for (final d in days) d: 5};

  group('countByDay', () {
    test('buckets multiple timestamps into the same day', () {
      final counts = countByDay([
        DateTime(2026, 7, 29, 9, 30),
        DateTime(2026, 7, 29, 22, 15),
        DateTime(2026, 7, 28, 5),
      ]);
      expect(counts[DateTime(2026, 7, 29)], 2);
      expect(counts[DateTime(2026, 7, 28)], 1);
    });
  });

  group('currentStreak', () {
    test('zero when no activity', () {
      expect(currentStreak({}, today), 0);
    });

    test('counts consecutive days ending today', () {
      final byDay = activityOn([
        today,
        today.subtract(const Duration(days: 1)),
        today.subtract(const Duration(days: 2)),
      ]);
      expect(currentStreak(byDay, today), 3);
    });

    test('streak alive if today idle but yesterday active', () {
      final byDay = activityOn([
        today.subtract(const Duration(days: 1)),
        today.subtract(const Duration(days: 2)),
      ]);
      expect(currentStreak(byDay, today), 2);
    });

    test('streak broken by a gap', () {
      final byDay = activityOn([
        today,
        today.subtract(const Duration(days: 2)),
        today.subtract(const Duration(days: 3)),
      ]);
      expect(currentStreak(byDay, today), 1);
    });
  });

  group('longestStreak', () {
    test('finds the longest historical run', () {
      final byDay = activityOn([
        // 2-day run
        DateTime(2026, 7, 1),
        DateTime(2026, 7, 2),
        // 4-day run
        DateTime(2026, 7, 10),
        DateTime(2026, 7, 11),
        DateTime(2026, 7, 12),
        DateTime(2026, 7, 13),
        // singleton
        DateTime(2026, 7, 20),
      ]);
      expect(longestStreak(byDay), 4);
    });

    test('empty map yields zero', () {
      expect(longestStreak({}), 0);
    });
  });

  group('heatLevel', () {
    test('maps counts to intensity buckets', () {
      expect(heatLevel(0), 0);
      expect(heatLevel(1), 1);
      expect(heatLevel(5), 2);
      expect(heatLevel(15), 3);
      expect(heatLevel(40), 4);
    });
  });
}
