/// Pure aggregation helpers for streaks, heatmap and daily stats.
/// Kept free of DB/Flutter imports so they are trivially unit-testable.
library;

DateTime dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

/// Buckets timestamps into day counts.
Map<DateTime, int> countByDay(Iterable<DateTime> timestamps) {
  final map = <DateTime, int>{};
  for (final t in timestamps) {
    final d = dateOnly(t.toLocal());
    map[d] = (map[d] ?? 0) + 1;
  }
  return map;
}

/// Current streak of consecutive active days ending today or yesterday.
/// A streak is still "alive" if today has no activity yet but yesterday did.
int currentStreak(Map<DateTime, int> byDay, DateTime today) {
  final t = dateOnly(today);
  var anchor = t;
  if ((byDay[t] ?? 0) == 0) {
    anchor = t.subtract(const Duration(days: 1));
    if ((byDay[anchor] ?? 0) == 0) return 0;
  }
  var streak = 0;
  var cursor = anchor;
  while ((byDay[cursor] ?? 0) > 0) {
    streak++;
    cursor = cursor.subtract(const Duration(days: 1));
  }
  return streak;
}

/// Longest run of consecutive active days.
int longestStreak(Map<DateTime, int> byDay) {
  final days = byDay.entries
      .where((e) => e.value > 0)
      .map((e) => e.key)
      .toList()
    ..sort();
  var best = 0;
  var run = 0;
  DateTime? prev;
  for (final d in days) {
    if (prev != null && d.difference(prev).inDays == 1) {
      run++;
    } else {
      run = 1;
    }
    if (run > best) best = run;
    prev = d;
  }
  return best;
}

/// Intensity level 0..4 for heatmap cell colouring.
int heatLevel(int count) {
  if (count <= 0) return 0;
  if (count < 5) return 1;
  if (count < 15) return 2;
  if (count < 30) return 3;
  return 4;
}
