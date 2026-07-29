import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/haptics.dart';
import '../../core/theme.dart';
import '../../data/db/database.dart';
import '../../data/providers.dart';
import '../../data/stats_logic.dart';
import '../../ui/aurora_route.dart';
import '../../ui/glass_panel.dart';
import '../../ui/glass_progress.dart';
import '../../ui/pressable.dart';
import '../../widgets/animated_counter.dart';
import '../quiz/mock_setup_screen.dart';
import 'heatmap.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final byDay = ref.watch(heatmapProvider);
    final streak = ref.watch(streakProvider);
    final subjects =
        ref.watch(subjectsProvider).valueOrNull ?? const <Subject>[];
    final accuracy = ref.watch(subjectAccuracyProvider).valueOrNull ?? const {};
    final weakTopics = ref.watch(weakTopicsProvider).valueOrNull ?? const [];
    final totalReviews = byDay.values.fold<int>(0, (a, b) => a + b);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
      children: [
        Text(
          'Progress',
          style: Theme.of(context).textTheme.headlineLarge,
        ).animate().fadeIn(duration: 300.ms),
        const SizedBox(height: 18),
        Row(
          children: [
            _MetricCard(
              icon: Icons.local_fire_department_rounded,
              color: AppColors.warning,
              value: streak.current,
              label: 'Current streak',
            ),
            const SizedBox(width: 10),
            _MetricCard(
              icon: Icons.military_tech_rounded,
              color: AppColors.accent,
              value: streak.longest,
              label: 'Longest streak',
            ),
            const SizedBox(width: 10),
            _MetricCard(
              icon: Icons.fact_check_rounded,
              color: AppColors.success,
              value: totalReviews,
              label: 'Total reviews',
            ),
          ],
        ).animate().fadeIn(delay: 80.ms).slideY(begin: 0.15, end: 0),
        const SizedBox(height: 22),
        _SectionCard(
          title: 'Activity',
          subtitle: 'Last 6 months',
          child: ActivityHeatmap(byDay: byDay),
        ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.12, end: 0),
        const SizedBox(height: 14),
        _SectionCard(
          title: 'This week',
          subtitle: 'Reviews per day',
          child: SizedBox(height: 160, child: _WeeklyBars(byDay: byDay)),
        ).animate().fadeIn(delay: 220.ms).slideY(begin: 0.12, end: 0),
        const SizedBox(height: 14),
        _SectionCard(
          title: 'Subject accuracy',
          subtitle: 'MCQ performance',
          child: subjects.isEmpty || accuracy.isEmpty
              ? const _EmptyHint(
                  text: 'Answer some MCQs to unlock subject analytics.',
                )
              : Column(
                  children: [
                    for (final subject in subjects)
                      if (accuracy.containsKey(subject.id))
                        _AccuracyRow(
                          subject: subject,
                          attempts: accuracy[subject.id]!.attempts,
                          correct: accuracy[subject.id]!.correct,
                        ),
                  ],
                ),
        ).animate().fadeIn(delay: 290.ms).slideY(begin: 0.12, end: 0),
        const SizedBox(height: 14),
        _SectionCard(
          title: 'Weak topics',
          subtitle: 'Lowest accuracy (min 3 attempts)',
          child: weakTopics.isEmpty
              ? const _EmptyHint(
                  text:
                      'Keep practising — weak areas show up here once you have enough attempts.',
                )
              : Column(
                  children: [
                    for (final topic in weakTopics)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.priority_high_rounded,
                              size: 18,
                              color: AppColors.error,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                topic.topic,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            Text(
                              '${topic.accuracy.toStringAsFixed(0)}% · ${topic.attempts} tries',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppColors.error),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
        ).animate().fadeIn(delay: 360.ms).slideY(begin: 0.12, end: 0),
        const SizedBox(height: 14),
        const _RecentMocks()
            .animate()
            .fadeIn(delay: 430.ms)
            .slideY(begin: 0.12, end: 0),
        const SizedBox(height: 18),
        _GrandMockButton(
          onTap: () {
            Haptics.light();
            Navigator.of(context).push(auroraRoute(const MockSetupScreen()));
          },
        ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2, end: 0),
      ],
    );
  }
}

class _GrandMockButton extends StatelessWidget {
  final VoidCallback onTap;

  const _GrandMockButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [AppColors.warning, Color(0xFFC5A16B)],
          ),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
          boxShadow: auroraGlow(AppColors.warning, alpha: 0.45),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.emoji_events_rounded, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              'Take a Grand Mock (all subjects)',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final int value;
  final String label;

  const _MetricCard({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GlassPanel(
        radius: 20,
        tint: color,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
            AnimatedCounter(
              value: value,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: color),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      radius: 24,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _WeeklyBars extends StatelessWidget {
  final Map<DateTime, int> byDay;

  const _WeeklyBars({required this.byDay});

  @override
  Widget build(BuildContext context) {
    final tokens = context.aurora;
    final today = dateOnly(DateTime.now());
    final days = List.generate(7, (i) => today.subtract(Duration(days: 6 - i)));
    final counts = [for (final d in days) byDay[d] ?? 0];
    final maxCount = counts
        .fold<int>(0, (a, b) => a > b ? a : b)
        .clamp(1, 1 << 31);

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxCount * 1.2,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => tokens.surfaceSolid,
            getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                BarTooltipItem(
                  '${rod.toY.round()}',
                  TextStyle(
                    color: tokens.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final day = days[value.toInt()];
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    DateFormat('E').format(day).substring(0, 2),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              },
            ),
          ),
        ),
        barGroups: [
          for (var i = 0; i < 7; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: counts[i].toDouble(),
                  width: 18,
                  borderRadius: BorderRadius.circular(6),
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.accent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: maxCount * 1.2,
                    color: tokens.glassFill,
                  ),
                ),
              ],
            ),
        ],
      ),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
    );
  }
}

class _AccuracyRow extends StatelessWidget {
  final Subject subject;
  final int attempts;
  final int correct;

  const _AccuracyRow({
    required this.subject,
    required this.attempts,
    required this.correct,
  });

  @override
  Widget build(BuildContext context) {
    final pct = attempts == 0 ? 0.0 : correct / attempts;
    final color = hexColor(subject.colorHex);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(subjectIcon(subject.icon), size: 16, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  subject.name,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Text(
                '${(pct * 100).toStringAsFixed(0)}% · $attempts attempted',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 6),
          GlassProgressBar(
            value: pct,
            colors: [color, Color.lerp(color, AppColors.accent, 0.5)!],
          ),
        ],
      ),
    );
  }
}

class _RecentMocks extends ConsumerWidget {
  const _RecentMocks();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _SectionCard(
      title: 'Recent mocks',
      subtitle: 'Latest timed test results',
      child: FutureBuilder<List<QuizResult>>(
        future: ref.watch(contentRepositoryProvider).recentQuizResults(),
        builder: (context, snapshot) {
          final results = snapshot.data ?? const <QuizResult>[];
          if (results.isEmpty) {
            return const _EmptyHint(
              text: 'No mocks yet. Take one to see your score history.',
            );
          }
          return Column(
            children: [
              for (final result in results)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.warning.withValues(alpha: 0.3),
                          ),
                        ),
                        child: const Icon(
                          Icons.timer_rounded,
                          size: 18,
                          color: AppColors.warning,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${result.score.toStringAsFixed(result.score.truncateToDouble() == result.score ? 0 : 2)} / ${result.maxScore.toStringAsFixed(0)}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              '${result.correctCount}✓ ${result.wrongCount}✗ ${result.skippedCount} skipped · '
                              '${DateFormat('d MMM, h:mm a').format(result.timestamp)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        result.maxScore == 0
                            ? '0%'
                            : '${(result.score / result.maxScore * 100).clamp(0, 100).toStringAsFixed(0)}%',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: result.score / result.maxScore >= 0.5
                                  ? AppColors.success
                                  : AppColors.warning,
                            ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  final String text;

  const _EmptyHint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            size: 18,
            color: context.aurora.textSecondary.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}
