import 'dart:convert';
import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/haptics.dart';
import '../../core/theme.dart';
import '../../data/db/database.dart';
import '../../data/scoring.dart';
import '../../ui/aurora_scaffold.dart';
import '../../ui/glass_button.dart';
import '../../ui/glass_expander.dart';
import '../../ui/glass_panel.dart';
import '../../widgets/animated_counter.dart';
import '../../widgets/goal_ring.dart';

class ResultScreen extends StatefulWidget {
  final String subjectName;
  final MockScore score;
  final List<Mcq> questions;
  final Map<int, int> answers;
  final int durationSeconds;
  final bool autoSubmitted;

  const ResultScreen({
    super.key,
    required this.subjectName,
    required this.score,
    required this.questions,
    required this.answers,
    required this.durationSeconds,
    this.autoSubmitted = false,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late final ConfettiController _confetti =
      ConfettiController(duration: const Duration(seconds: 3));

  @override
  void initState() {
    super.initState();
    if (widget.score.percentage >= 50) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Haptics.celebrate();
        _confetti.play();
      });
    }
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final score = widget.score;
    return AuroraScaffold(
      title: 'Result · ${widget.subjectName}',
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              if (widget.autoSubmitted)
                GlassPanel(
                  radius: 16,
                  tint: AppColors.warning,
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(Icons.timer_off_rounded,
                          color: AppColors.warning, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text("Time's up — auto-submitted.",
                            style: Theme.of(context).textTheme.bodyMedium),
                      ),
                    ],
                  ),
                ).animate().fadeIn(),
              Center(
                child: GoalRing(
                  progress: score.maxScore == 0
                      ? 0
                      : (score.score / score.maxScore).clamp(0.0, 1.0),
                  size: 160,
                  center: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedCounter(
                        value: score.score,
                        duration: const Duration(milliseconds: 1400),
                        format: (v) => v.toStringAsFixed(
                            v.truncateToDouble() == v ? 0 : 2),
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      Text('of ${score.maxScore.toStringAsFixed(0)}',
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              ).animate().scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1, 1),
                    duration: 600.ms,
                    curve: Curves.easeOutBack,
                  ),
              const SizedBox(height: 18),
              Center(
                child: Text(
                  _verdict(score),
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 400.ms),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  _StatCard(
                    label: 'Correct',
                    value: '${score.correct}',
                    color: AppColors.success,
                    icon: Icons.check_circle_rounded,
                  ),
                  const SizedBox(width: 10),
                  _StatCard(
                    label: 'Wrong',
                    value: '${score.wrong}',
                    color: AppColors.error,
                    icon: Icons.cancel_rounded,
                  ),
                  const SizedBox(width: 10),
                  _StatCard(
                    label: 'Skipped',
                    value: '${score.skipped}',
                    color: AppColors.warning,
                    icon: Icons.remove_circle_rounded,
                  ),
                ],
              ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2, end: 0),
              const SizedBox(height: 12),
              Row(
                children: [
                  _StatCard(
                    label: 'Accuracy',
                    value: '${score.accuracy.toStringAsFixed(0)}%',
                    color: AppColors.primarySoft,
                    icon: Icons.gps_fixed_rounded,
                  ),
                  const SizedBox(width: 10),
                  _StatCard(
                    label: 'Time',
                    value: _formatTime(widget.durationSeconds),
                    color: AppColors.accent,
                    icon: Icons.schedule_rounded,
                  ),
                  const SizedBox(width: 10),
                  _StatCard(
                    label: 'Penalty',
                    value:
                        '−${(score.wrong * score.penaltyPerWrong).toStringAsFixed(2)}',
                    color: AppColors.error,
                    icon: Icons.trending_down_rounded,
                  ),
                ],
              ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, end: 0),
              const SizedBox(height: 28),
              Text('Review answers',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              for (var i = 0; i < widget.questions.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _ReviewTile(
                    index: i,
                    question: widget.questions[i],
                    chosen: widget.answers[i],
                  ).animate().fadeIn(delay: (650 + i * 40).ms),
                ),
              const SizedBox(height: 10),
              GlassButton(
                expand: true,
                icon: Icons.home_rounded,
                label: 'Back to home',
                onPressed: () =>
                    Navigator.of(context).popUntil((r) => r.isFirst),
              ),
            ],
          ),
          ConfettiWidget(
            confettiController: _confetti,
            blastDirection: math.pi / 2,
            blastDirectionality: BlastDirectionality.explosive,
            emissionFrequency: 0.05,
            numberOfParticles: 28,
            maxBlastForce: 24,
            minBlastForce: 8,
            gravity: 0.22,
            colors: const [
              AppColors.primary,
              AppColors.accent,
              AppColors.success,
              AppColors.warning,
            ],
          ),
        ],
      ),
    );
  }

  String _verdict(MockScore score) {
    final pct = score.percentage;
    if (pct >= 75) return 'Outstanding! Interview-board material 🏆';
    if (pct >= 55) return 'Strong performance — above the typical cutoff 🎯';
    if (pct >= 35) return 'Getting there. Sharpen the weak topics 💪';
    return 'Keep at it — every attempt teaches something 📚';
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return m > 0 ? '${m}m ${s}s' : '${s}s';
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GlassPanel(
        radius: 18,
        tint: color,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(value,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: color)),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final int index;
  final Mcq question;
  final int? chosen;

  const _ReviewTile({
    required this.index,
    required this.question,
    required this.chosen,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.aurora;
    final options = (jsonDecode(question.optionsJson) as List).cast<String>();
    final correct = chosen == question.answerIndex;
    final skipped = chosen == null;
    final color = skipped
        ? AppColors.warning
        : correct
            ? AppColors.success
            : AppColors.error;

    return GlassExpander(
      leading: Icon(
        skipped
            ? Icons.remove_circle_rounded
            : correct
                ? Icons.check_circle_rounded
                : Icons.cancel_rounded,
        color: color,
      ),
      title: 'Q${index + 1} · ${question.topic}',
      subtitle: question.question,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question.question,
              style:
                  Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.4)),
          const SizedBox(height: 10),
          for (var i = 0; i < options.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    i == question.answerIndex
                        ? Icons.check_rounded
                        : i == chosen
                            ? Icons.close_rounded
                            : Icons.circle_outlined,
                    size: 16,
                    color: i == question.answerIndex
                        ? AppColors.success
                        : i == chosen
                            ? AppColors.error
                            : tokens.textSecondary.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      options[i],
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: i == question.answerIndex
                                ? AppColors.success
                                : i == chosen
                                    ? AppColors.error
                                    : null,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          if (question.explanation.isNotEmpty) ...[
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary
                    .withValues(alpha: tokens.isDark ? 0.10 : 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.25)),
              ),
              child: Text(
                question.explanation,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(height: 1.45),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
