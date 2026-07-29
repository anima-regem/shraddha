import 'dart:math' as math;

/// Flashcard self-assessment ratings (Anki-style).
enum Rating { again, hard, good, easy }

/// Immutable SRS scheduling state for a single card.
class SrsState {
  final double easeFactor;
  final int intervalDays;
  final int repetitions;
  final int lapses;
  final DateTime due;

  const SrsState({
    required this.easeFactor,
    required this.intervalDays,
    required this.repetitions,
    required this.lapses,
    required this.due,
  });

  factory SrsState.fresh(DateTime now) => SrsState(
        easeFactor: 2.5,
        intervalDays: 0,
        repetitions: 0,
        lapses: 0,
        due: now,
      );
}

/// SM-2 derived scheduler (simplified Anki flavour).
///
/// - `again`: card lapses, restarts learning, due immediately (same session).
/// - `hard`: small interval growth, ease penalty.
/// - `good`: standard SM-2 progression (1d, 6d, then interval * ease).
/// - `easy`: boosted interval and ease bonus.
SrsState schedule(SrsState state, Rating rating, DateTime now) {
  const minEase = 1.3;
  var ease = state.easeFactor;
  var reps = state.repetitions;
  var interval = state.intervalDays;
  var lapses = state.lapses;

  switch (rating) {
    case Rating.again:
      ease = math.max(minEase, ease - 0.20);
      reps = 0;
      lapses += 1;
      interval = 0;
      return SrsState(
        easeFactor: ease,
        intervalDays: interval,
        repetitions: reps,
        lapses: lapses,
        due: now,
      );
    case Rating.hard:
      ease = math.max(minEase, ease - 0.15);
      reps += 1;
      interval = interval <= 0 ? 1 : math.max(interval + 1, (interval * 1.2).ceil());
      break;
    case Rating.good:
      reps += 1;
      interval = switch (reps) {
        1 => 1,
        2 => 6,
        _ => (interval * ease).ceil(),
      };
      break;
    case Rating.easy:
      ease += 0.15;
      reps += 1;
      interval = switch (reps) {
        1 => 4,
        2 => 8,
        _ => (interval * ease * 1.3).ceil(),
      };
      break;
  }

  return SrsState(
    easeFactor: ease,
    intervalDays: interval,
    repetitions: reps,
    lapses: lapses,
    due: DateTime(now.year, now.month, now.day).add(Duration(days: interval)),
  );
}
