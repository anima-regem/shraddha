import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/haptics.dart';
import '../../core/theme.dart';
import '../../data/db/database.dart';
import '../../data/providers.dart';
import '../../data/scoring.dart';
import '../../ui/aurora_route.dart';
import '../../ui/aurora_scaffold.dart';
import '../../ui/glass_button.dart';
import '../../ui/glass_dialog.dart';
import '../../ui/glass_panel.dart';
import '../../ui/glass_progress.dart';
import '../../ui/pressable.dart';
import 'result_screen.dart';

class MockScreen extends ConsumerStatefulWidget {
  final Subject? subject;
  final int questionCount;
  final int totalSeconds;

  const MockScreen({
    super.key,
    required this.subject,
    required this.questionCount,
    required this.totalSeconds,
  });

  @override
  ConsumerState<MockScreen> createState() => _MockScreenState();
}

class _MockScreenState extends ConsumerState<MockScreen> {
  List<Mcq>? _questions;
  final Map<int, int> _answers = {};
  int _index = 0;
  late int _remaining = widget.totalSeconds;
  Timer? _timer;
  bool _submitted = false;
  late final PageController _pageController = PageController();
  late final DateTime _startedAt = DateTime.now();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final all = await ref
        .read(contentRepositoryProvider)
        .mcqsForSubject(widget.subject?.id);
    all.shuffle();
    if (!mounted) return;
    setState(() => _questions = all.take(widget.questionCount).toList());
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _remaining--);
      if (_remaining == 30) Haptics.error();
      if (_remaining <= 0) _submit(auto: true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _submit({bool auto = false}) async {
    if (_submitted || _questions == null) return;
    _submitted = true;
    _timer?.cancel();

    final questions = _questions!;
    var correct = 0;
    var wrong = 0;
    final repo = ref.read(contentRepositoryProvider);
    for (var i = 0; i < questions.length; i++) {
      final answer = _answers[i];
      if (answer == null) continue;
      final isCorrect = answer == questions[i].answerIndex;
      isCorrect ? correct++ : wrong++;
      await repo.logMcqAnswer(question: questions[i], correct: isCorrect);
    }
    final skipped = questions.length - correct - wrong;
    final score = MockScore(
      total: questions.length,
      correct: correct,
      wrong: wrong,
      skipped: skipped,
    );
    final duration = DateTime.now().difference(_startedAt).inSeconds;

    await repo.saveQuizResult(QuizResultsCompanion(
      subjectId: Value(widget.subject?.id),
      mode: const Value('mock'),
      total: Value(score.total),
      correctCount: Value(score.correct),
      wrongCount: Value(score.wrong),
      skippedCount: Value(score.skipped),
      score: Value(score.score),
      maxScore: Value(score.maxScore),
      durationSeconds: Value(duration),
      timestamp: Value(DateTime.now()),
    ));

    if (!mounted) return;
    Navigator.of(context).pushReplacement(auroraRoute(
      ResultScreen(
        subjectName: widget.subject?.name ?? 'All subjects',
        score: score,
        questions: questions,
        answers: Map.of(_answers),
        durationSeconds: duration,
        autoSubmitted: auto,
      ),
    ));
  }

  void _confirmSubmit() {
    Haptics.light();
    final unanswered = widget.questionCount - _answers.length;
    showGlassDialog<void>(
      context: context,
      title: 'Submit mock?',
      message: unanswered > 0
          ? '$unanswered question${unanswered == 1 ? '' : 's'} unanswered. Unanswered questions carry no penalty.'
          : 'All questions answered. Ready to see your score?',
      actions: [
        Builder(
          builder: (dialogContext) => GlassButton(
            label: 'Keep going',
            variant: GlassButtonVariant.glass,
            expand: true,
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
        ),
        Builder(
          builder: (dialogContext) => GlassButton(
            label: 'Submit',
            expand: true,
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _submit();
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final questions = _questions;
    final urgent = _remaining <= widget.totalSeconds * 0.15;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmExit();
      },
      child: AuroraScaffold(
        title: widget.subject?.name ?? 'Grand Mock',
        onBack: _confirmExit,
        headerTrailing: _TimerPill(remaining: _remaining, urgent: urgent),
        resizeToAvoidBottomInset: false,
        body: questions == null
            ? const Center(child: AuroraSpinner())
            : PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _index = i),
                itemCount: questions.length,
                itemBuilder: (context, i) => _MockQuestion(
                  question: questions[i],
                  number: i + 1,
                  total: questions.length,
                  selected: _answers[i],
                  onSelect: (option) {
                    Haptics.tap();
                    setState(() {
                      if (_answers[i] == option) {
                        _answers.remove(i); // tap again to clear
                      } else {
                        _answers[i] = option;
                      }
                    });
                  },
                ),
              ),
        bottomBar: questions == null
            ? null
            : _PaletteBar(
                count: questions.length,
                current: _index,
                answers: _answers,
                onJump: (i) {
                  Haptics.tap();
                  _pageController.animateToPage(
                    i,
                    duration: const Duration(milliseconds: 320),
                    curve: Curves.easeOutCubic,
                  );
                },
                onSubmit: _confirmSubmit,
              ),
      ),
    );
  }

  void _confirmExit() {
    showGlassDialog<void>(
      context: context,
      title: 'Abandon mock?',
      message: 'Your progress in this mock will be lost.',
      actions: [
        Builder(
          builder: (dialogContext) => GlassButton(
            label: 'Stay',
            variant: GlassButtonVariant.glass,
            expand: true,
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
        ),
        Builder(
          builder: (dialogContext) => GlassButton(
            label: 'Exit',
            variant: GlassButtonVariant.danger,
            expand: true,
            onPressed: () {
              Navigator.of(dialogContext).pop();
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }
}

class _TimerPill extends StatelessWidget {
  final int remaining;
  final bool urgent;

  const _TimerPill({required this.remaining, required this.urgent});

  String _format(int seconds) {
    final clamped = seconds.clamp(0, 24 * 3600);
    final m = (clamped ~/ 60).toString().padLeft(2, '0');
    final s = (clamped % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.aurora;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Color.alphaBlend(
          (urgent ? AppColors.error : AppColors.primary)
              .withValues(alpha: 0.14),
          tokens.glassFill,
        ),
        border: Border.all(
          color: (urgent ? AppColors.error : AppColors.primary)
              .withValues(alpha: 0.4),
        ),
        boxShadow: urgent ? auroraGlow(AppColors.error, alpha: 0.4) : null,
      ),
      child: Row(
        children: [
          Icon(
            Icons.timer_rounded,
            size: 18,
            color: urgent ? AppColors.error : AppColors.primarySoft,
          )
              .animate(
                target: urgent ? 1 : 0,
                onPlay: (c) {
                  if (urgent) c.repeat(reverse: true);
                },
              )
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.2, 1.2),
                duration: 400.ms,
              ),
          const SizedBox(width: 6),
          Text(
            _format(remaining),
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontFeatures: const [FontFeature.tabularFigures()],
              color: urgent ? AppColors.error : tokens.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _MockQuestion extends StatelessWidget {
  final Mcq question;
  final int number;
  final int total;
  final int? selected;
  final ValueChanged<int> onSelect;

  const _MockQuestion({
    required this.question,
    required this.number,
    required this.total,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final options = (jsonDecode(question.optionsJson) as List).cast<String>();
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Question $number of $total',
              style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 10),
          Text(
            question.question,
            style:
                Theme.of(context).textTheme.titleLarge?.copyWith(height: 1.4),
          ),
          const SizedBox(height: 22),
          for (var i = 0; i < options.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _SelectTile(
                index: i,
                text: options[i],
                selected: selected == i,
                onTap: () => onSelect(i),
              ),
            ),
        ],
      ),
    );
  }
}

class _SelectTile extends StatelessWidget {
  final int index;
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _SelectTile({
    required this.index,
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.aurora;
    return Pressable(
      onTap: onTap,
      pressedScale: 0.98,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: selected
              ? Color.alphaBlend(
                  AppColors.primary.withValues(alpha: 0.16), tokens.glassFill)
              : tokens.glassFill,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? AppColors.primary : tokens.strokeBottom,
            width: selected ? 1.5 : 1.2,
          ),
          boxShadow:
              selected ? auroraGlow(AppColors.primary, alpha: 0.3) : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? AppColors.primary : Colors.transparent,
                  border: Border.all(
                    color: selected
                        ? AppColors.primary
                        : tokens.textSecondary.withValues(alpha: 0.5),
                  ),
                ),
                child: Text(
                  String.fromCharCode(65 + index),
                  style: TextStyle(
                    color: selected ? Colors.white : tokens.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  text,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(height: 1.35),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaletteBar extends StatelessWidget {
  final int count;
  final int current;
  final Map<int, int> answers;
  final ValueChanged<int> onJump;
  final VoidCallback onSubmit;

  const _PaletteBar({
    required this.count,
    required this.current,
    required this.answers,
    required this.onJump,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.aurora;
    return GlassPanel(
      blur: true,
      strong: true,
      radius: 26,
      margin: const EdgeInsets.fromLTRB(12, 6, 12, 10),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      glow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: tokens.isDark ? 0.35 : 0.10),
          blurRadius: 24,
          offset: const Offset(0, 10),
        ),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              itemCount: count,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final answered = answers.containsKey(i);
                final isCurrent = i == current;
                return Pressable(
                  onTap: () => onJump(i),
                  pressedScale: 0.9,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: answered
                          ? AppColors.success.withValues(alpha: 0.2)
                          : tokens.glassFill,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isCurrent
                            ? AppColors.primary
                            : answered
                                ? AppColors.success
                                : tokens.strokeBottom,
                        width: isCurrent ? 2 : 1.2,
                      ),
                      boxShadow: isCurrent
                          ? auroraGlow(AppColors.primary, alpha: 0.3)
                          : null,
                    ),
                    child: Text(
                      '${i + 1}',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: answered
                            ? AppColors.success
                            : tokens.textPrimary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${answers.length} / $count answered',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              GlassButton(
                label: 'Submit',
                icon: Icons.flag_rounded,
                onPressed: onSubmit,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
