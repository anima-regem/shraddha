import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/haptics.dart';
import '../../core/theme.dart';
import '../../data/db/database.dart';
import '../../data/providers.dart';
import '../../ui/aurora_route.dart';
import '../../ui/glass_panel.dart';
import '../../ui/glass_sheet.dart';
import '../../widgets/animated_counter.dart';
import '../../widgets/goal_ring.dart';
import '../../widgets/streak_flame.dart';
import '../flashcards/deck_screen.dart';
import '../quiz/mock_setup_screen.dart';
import '../quiz/practice_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjects =
        ref.watch(subjectsProvider).valueOrNull ?? const <Subject>[];
    final todayCount = ref.watch(todayCountProvider).valueOrNull ?? 0;
    final goal = ref.watch(dailyGoalProvider);
    final streak = ref.watch(streakProvider);
    final dueCounts = ref.watch(dueCountsProvider).valueOrNull ?? const {};
    final totalDue = dueCounts.values.fold<int>(0, (sum, count) => sum + count);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _greeting(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: context.aurora.textSecondary,
                      ),
                    ),
                    Text(
                      'Shraddha',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ],
                ),
                GlassPanel(
                  radius: 18,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: StreakFlame(streak: streak.current, iconSize: 22),
                ),
              ],
            ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, end: 0),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: _DailyGoalCard(todayCount: todayCount, goal: goal)
                .animate()
                .fadeIn(delay: 100.ms, duration: 400.ms)
                .slideY(begin: 0.15, end: 0),
          ),
        ),
        if (totalDue > 0)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child:
                  _DueBanner(
                        totalDue: totalDue,
                        subjects: subjects,
                        dueCounts: dueCounts,
                      )
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 400.ms)
                      .slideY(begin: 0.15, end: 0),
            ),
          ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 26, 20, 12),
            child: Text(
              'Subjects',
              style: Theme.of(context).textTheme.headlineSmall,
            ).animate().fadeIn(delay: 250.ms),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 1.05,
            ),
            delegate: SliverChildBuilderDelegate((context, i) {
              final subject = subjects[i];
              return _SubjectCard(
                    subject: subject,
                    dueCount: dueCounts[subject.id] ?? 0,
                  )
                  .animate()
                  .fadeIn(delay: (280 + i * 70).ms, duration: 400.ms)
                  .slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic)
                  .scale(
                    begin: const Offset(0.94, 0.94),
                    end: const Offset(1, 1),
                  );
            }, childCount: subjects.length),
          ),
        ),
      ],
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning ☀️';
    if (hour < 17) return 'Good afternoon 🌤️';
    return 'Good evening 🌙';
  }
}

class _DailyGoalCard extends StatelessWidget {
  final int todayCount;
  final int goal;

  const _DailyGoalCard({required this.todayCount, required this.goal});

  @override
  Widget build(BuildContext context) {
    final progress = goal == 0 ? 0.0 : todayCount / goal;
    final complete = progress >= 1;
    final tint = complete ? AppColors.success : AppColors.primary;
    return GlassPanel(
      radius: 28,
      tint: tint,
      strong: true,
      padding: const EdgeInsets.all(20),
      glow: auroraGlow(tint, alpha: complete ? 0.4 : 0.22),
      child: Row(
        children: [
          GoalRing(
            progress: progress,
            size: 96,
            center: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedCounter(
                  value: todayCount,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text('/$goal', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  complete ? 'Goal crushed! 🎉' : 'Daily goal',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 6),
                Text(
                  complete
                      ? 'You reviewed $todayCount items today. Momentum is everything — keep the streak alive!'
                      : '${(goal - todayCount).clamp(0, goal)} more reviews to hit today\'s target.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DueBanner extends StatelessWidget {
  final int totalDue;
  final List<Subject> subjects;
  final Map<String, int> dueCounts;

  const _DueBanner({
    required this.totalDue,
    required this.subjects,
    required this.dueCounts,
  });

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      radius: 22,
      tint: AppColors.accent,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      onTap: () {
        Haptics.light();
        final sorted = subjects.toList()
          ..sort(
            (a, b) => (dueCounts[b.id] ?? 0).compareTo(dueCounts[a.id] ?? 0),
          );
        if (sorted.isNotEmpty) {
          Navigator.of(
            context,
          ).push(auroraRoute(DeckScreen(subject: sorted.first)));
        }
      },
      child: Row(
        children: [
          const Icon(Icons.style_rounded, color: AppColors.accent)
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .shake(hz: 0.5, rotation: 0.04, duration: 1200.ms),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$totalDue flashcards due for review',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppColors.accent),
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.accent),
        ],
      ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final Subject subject;
  final int dueCount;

  const _SubjectCard({required this.subject, required this.dueCount});

  @override
  Widget build(BuildContext context) {
    final color = hexColor(subject.colorHex);
    return GlassPanel(
      radius: 24,
      tint: color,
      padding: const EdgeInsets.all(16),
      onTap: () {
        Haptics.light();
        _showModeSheet(context, subject);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: color.withValues(alpha: 0.35)),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.30),
                      blurRadius: 14,
                      spreadRadius: -2,
                    ),
                  ],
                ),
                child: Icon(subjectIcon(subject.icon), color: color, size: 24),
              ),
              if (dueCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.accent],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: auroraGlow(AppColors.accent, alpha: 0.4),
                  ),
                  child: Text(
                    '$dueCount due',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          const Spacer(),
          Text(
            subject.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            '${(jsonDecode(subject.topicsJson) as List).length} topics',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

void _showModeSheet(BuildContext context, Subject subject) {
  final color = hexColor(subject.colorHex);
  showGlassSheet<void>(
    context: context,
    child: Builder(
      builder: (sheetContext) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(subjectIcon(subject.icon), color: color, size: 26),
              const SizedBox(width: 10),
              Text(
                subject.name,
                style: Theme.of(sheetContext).textTheme.headlineSmall,
              ),
            ],
          ),
          const SizedBox(height: 18),
          _ModeTile(
            icon: Icons.style_rounded,
            color: AppColors.accent,
            title: 'Flashcards',
            subtitle: 'Swipe, flip & rate — spaced repetition',
            onTap: () => _push(sheetContext, DeckScreen(subject: subject)),
          ),
          const SizedBox(height: 10),
          _ModeTile(
            icon: Icons.quiz_rounded,
            color: AppColors.primary,
            title: 'Practice MCQs',
            subtitle: 'Untimed drill with instant feedback',
            onTap: () => _push(sheetContext, PracticeScreen(subject: subject)),
          ),
          const SizedBox(height: 10),
          _ModeTile(
            icon: Icons.timer_rounded,
            color: AppColors.warning,
            title: 'Timed Mock',
            subtitle: 'Prelims style — negative marking',
            onTap: () => _push(sheetContext, MockSetupScreen(subject: subject)),
          ),
        ],
      ),
    ),
  );
}

void _push(BuildContext sheetContext, Widget screen) {
  Haptics.light();
  Navigator.of(sheetContext).pop();
  Navigator.of(sheetContext).push(auroraRoute(screen));
}

class _ModeTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ModeTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      radius: 18,
      tint: color,
      padding: const EdgeInsets.all(14),
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: color),
        ],
      ),
    );
  }
}
