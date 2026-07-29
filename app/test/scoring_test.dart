import 'package:flutter_test/flutter_test.dart';
import 'package:shraddha/data/scoring.dart';

void main() {
  group('UPSC mock scoring', () {
    test('perfect score', () {
      const score = MockScore(total: 10, correct: 10, wrong: 0, skipped: 0);
      expect(score.score, 20.0);
      expect(score.maxScore, 20.0);
      expect(score.percentage, 100.0);
      expect(score.accuracy, 100.0);
    });

    test('negative marking is one third of question marks', () {
      const score = MockScore(total: 10, correct: 5, wrong: 3, skipped: 2);
      // 5*2 - 3*(2/3) = 10 - 2 = 8
      expect(score.score, 8.0);
      expect(score.penaltyPerWrong, closeTo(2 / 3, 1e-9));
    });

    test('all wrong clamps percentage to zero, not negative', () {
      const score = MockScore(total: 6, correct: 0, wrong: 6, skipped: 0);
      expect(score.score, -4.0);
      expect(score.percentage, 0.0);
    });

    test('skipped questions carry no penalty', () {
      const attempted = MockScore(total: 4, correct: 2, wrong: 2, skipped: 0);
      const cautious = MockScore(total: 4, correct: 2, wrong: 0, skipped: 2);
      expect(cautious.score, greaterThan(attempted.score));
    });

    test('accuracy counts attempted questions only', () {
      const score = MockScore(total: 10, correct: 4, wrong: 4, skipped: 2);
      expect(score.accuracy, 50.0);
    });
  });
}
