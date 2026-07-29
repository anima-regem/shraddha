import 'package:flutter_test/flutter_test.dart';
import 'package:shraddha/data/srs.dart';

void main() {
  final now = DateTime(2026, 7, 29, 10);

  group('SM-2 scheduler', () {
    test('fresh card rated good gets 1 day interval', () {
      final next = schedule(SrsState.fresh(now), Rating.good, now);
      expect(next.repetitions, 1);
      expect(next.intervalDays, 1);
      expect(next.due, DateTime(2026, 7, 30));
    });

    test('second good review jumps to 6 days', () {
      var state = schedule(SrsState.fresh(now), Rating.good, now);
      state = schedule(state, Rating.good, now.add(const Duration(days: 1)));
      expect(state.repetitions, 2);
      expect(state.intervalDays, 6);
    });

    test('third good review multiplies by ease factor', () {
      var state = schedule(SrsState.fresh(now), Rating.good, now);
      state = schedule(state, Rating.good, now);
      state = schedule(state, Rating.good, now);
      expect(state.intervalDays, (6 * 2.5).ceil());
    });

    test('again resets repetitions, adds lapse, keeps card due today', () {
      var state = schedule(SrsState.fresh(now), Rating.good, now);
      state = schedule(state, Rating.good, now);
      state = schedule(state, Rating.again, now);
      expect(state.repetitions, 0);
      expect(state.lapses, 1);
      expect(state.intervalDays, 0);
      expect(state.due, now);
      expect(state.easeFactor, closeTo(2.3, 0.001));
    });

    test('ease factor never drops below 1.3', () {
      var state = SrsState.fresh(now);
      for (var i = 0; i < 20; i++) {
        state = schedule(state, Rating.again, now);
      }
      expect(state.easeFactor, 1.3);
    });

    test('easy grows faster than good and boosts ease', () {
      final good = schedule(SrsState.fresh(now), Rating.good, now);
      final easy = schedule(SrsState.fresh(now), Rating.easy, now);
      expect(easy.intervalDays, greaterThan(good.intervalDays));
      expect(easy.easeFactor, greaterThan(good.easeFactor));
    });

    test('hard always advances interval by at least one day', () {
      var state = schedule(SrsState.fresh(now), Rating.hard, now);
      expect(state.intervalDays, 1);
      final before = state.intervalDays;
      state = schedule(state, Rating.hard, now);
      expect(state.intervalDays, greaterThan(before));
    });
  });
}
