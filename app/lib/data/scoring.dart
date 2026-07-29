/// UPSC Prelims style scoring: +2 for correct, -1/3 of marks (2/3) for wrong,
/// 0 for unattempted.
class MockScore {
  final int total;
  final int correct;
  final int wrong;
  final int skipped;
  final double marksPerQuestion;

  const MockScore({
    required this.total,
    required this.correct,
    required this.wrong,
    required this.skipped,
    this.marksPerQuestion = 2.0,
  }) : assert(correct + wrong + skipped == total);

  double get penaltyPerWrong => marksPerQuestion / 3;

  double get score {
    final raw = correct * marksPerQuestion - wrong * penaltyPerWrong;
    return double.parse(raw.toStringAsFixed(2));
  }

  double get maxScore => total * marksPerQuestion;

  double get percentage => maxScore == 0 ? 0 : (score / maxScore * 100).clamp(0, 100);

  double get accuracy {
    final attempted = correct + wrong;
    return attempted == 0 ? 0 : correct / attempted * 100;
  }
}
