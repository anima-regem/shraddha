import 'dart:convert';
import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/haptics.dart';
import '../../core/theme.dart';
import '../../data/db/database.dart';
import '../../data/providers.dart';
import '../../ui/aurora_scaffold.dart';
import '../../ui/glass_button.dart';
import '../../ui/glass_chip.dart';
import '../../ui/glass_panel.dart';
import '../../ui/glass_progress.dart';
import '../../ui/pressable.dart';

class PracticeScreen extends ConsumerStatefulWidget {
  final Subject subject;

  const PracticeScreen({super.key, required this.subject});

  @override
  ConsumerState<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends ConsumerState<PracticeScreen> {
  List<Mcq>? _questions;
  int _index = 0;
  int? _selected;
  int _correct = 0;
  late final ConfettiController _confetti =
      ConfettiController(duration: const Duration(seconds: 2));

  bool get _answered => _selected != null;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final all = await ref
        .read(contentRepositoryProvider)
        .mcqsForSubject(widget.subject.id);
    all.shuffle();
    if (mounted) setState(() => _questions = all.take(10).toList());
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  void _select(int option) {
    if (_answered) return;
    final question = _questions![_index];
    final correct = option == question.answerIndex;
    correct ? Haptics.success() : Haptics.error();
    if (correct) _correct++;
    ref
        .read(contentRepositoryProvider)
        .logMcqAnswer(question: question, correct: correct);
    setState(() => _selected = option);
  }

  void _next() {
    Haptics.tap();
    if (_index + 1 >= _questions!.length) {
      setState(() => _index++);
      if (_correct / _questions!.length >= 0.7) {
        Haptics.celebrate();
        _confetti.play();
      }
    } else {
      setState(() {
        _index++;
        _selected = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final questions = _questions;
    final accent = hexColor(widget.subject.colorHex);

    return AuroraScaffold(
      title: 'Practice',
      headerTrailing: questions != null && _index < questions.length
          ? GlassChip(
              label: '${_index + 1} / ${questions.length}', color: accent)
          : null,
      body: questions == null
          ? const Center(child: AuroraSpinner())
          : questions.isEmpty
              ? Center(
                  child: Text('No questions available yet.',
                      style: Theme.of(context).textTheme.bodyLarge))
              : _index >= questions.length
                  ? _PracticeSummary(
                      confetti: _confetti,
                      correct: _correct,
                      total: questions.length,
                      onRetry: () {
                        setState(() {
                          _questions = null;
                          _index = 0;
                          _selected = null;
                          _correct = 0;
                        });
                        _load();
                      },
                    )
                  : _buildQuestion(questions[_index], accent),
    );
  }

  Widget _buildQuestion(Mcq question, Color accent) {
    final options = (jsonDecode(question.optionsJson) as List).cast<String>();

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: Column(
              key: ValueKey(question.id),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GlassChip(label: question.topic, color: accent),
                    const SizedBox(width: 8),
                    GlassChip(
                      label: question.difficulty.toUpperCase(),
                      color: switch (question.difficulty) {
                        'easy' => AppColors.success,
                        'hard' => AppColors.error,
                        _ => AppColors.warning,
                      },
                    ),
                  ],
                ).animate().fadeIn(duration: 300.ms),
                const SizedBox(height: 16),
                Text(
                  question.question,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(height: 1.4),
                ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0),
                const SizedBox(height: 24),
                for (var i = 0; i < options.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _OptionTile(
                      index: i,
                      text: options[i],
                      state: _optionState(i, question.answerIndex),
                      onTap: () => _select(i),
                    )
                        .animate()
                        .fadeIn(delay: (80 * i).ms, duration: 300.ms)
                        .slideX(begin: 0.06, end: 0),
                  ),
                if (_answered) ...[
                  const SizedBox(height: 8),
                  _ExplanationCard(text: question.explanation)
                      .animate()
                      .fadeIn(duration: 350.ms)
                      .slideY(begin: 0.25, end: 0, curve: Curves.easeOutCubic),
                ],
              ],
            ),
          ),
        ),
        if (_answered)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
            child: GlassButton(
              expand: true,
              onPressed: _next,
              icon: _index + 1 >= (_questions?.length ?? 0)
                  ? Icons.flag_rounded
                  : Icons.arrow_forward_rounded,
              label: _index + 1 >= (_questions?.length ?? 0)
                  ? 'Finish'
                  : 'Next question',
            ).animate().fadeIn(duration: 250.ms).slideY(begin: 0.4, end: 0),
          ),
      ],
    );
  }

  _OptionState _optionState(int option, int answerIndex) {
    if (!_answered) return _OptionState.idle;
    if (option == answerIndex) return _OptionState.correct;
    if (option == _selected) return _OptionState.wrong;
    return _OptionState.dimmed;
  }
}

enum _OptionState { idle, correct, wrong, dimmed }

class _OptionTile extends StatelessWidget {
  final int index;
  final String text;
  final _OptionState state;
  final VoidCallback onTap;

  const _OptionTile({
    required this.index,
    required this.text,
    required this.state,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.aurora;
    final (Color bg, Color border, Color fg, List<BoxShadow>? glow) =
        switch (state) {
      _OptionState.idle => (
          tokens.glassFill,
          tokens.strokeBottom,
          tokens.textPrimary,
          null,
        ),
      _OptionState.correct => (
          Color.alphaBlend(
              AppColors.success.withValues(alpha: 0.18), tokens.glassFill),
          AppColors.success,
          AppColors.success,
          auroraGlow(AppColors.success, alpha: 0.35),
        ),
      _OptionState.wrong => (
          Color.alphaBlend(
              AppColors.error.withValues(alpha: 0.18), tokens.glassFill),
          AppColors.error,
          AppColors.error,
          auroraGlow(AppColors.error, alpha: 0.35),
        ),
      _OptionState.dimmed => (
          tokens.glassFill.withValues(alpha: 0.03),
          tokens.strokeBottom.withValues(alpha: 0.05),
          tokens.textSecondary.withValues(alpha: 0.6),
          null,
        ),
    };

    Widget tile = Pressable(
      onTap: onTap,
      pressedScale: 0.98,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: border, width: 1.3),
          boxShadow: glow,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: state == _OptionState.correct
                      ? AppColors.success
                      : state == _OptionState.wrong
                          ? AppColors.error
                          : Colors.transparent,
                  border: Border.all(color: border, width: 1.3),
                ),
                child: state == _OptionState.correct
                    ? const Icon(Icons.check_rounded,
                        size: 18, color: Colors.white)
                    : state == _OptionState.wrong
                        ? const Icon(Icons.close_rounded,
                            size: 18, color: Colors.white)
                        : Text(
                            String.fromCharCode(65 + index),
                            style: TextStyle(
                              color: fg,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
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
                      ?.copyWith(color: fg, height: 1.35),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (state == _OptionState.wrong) {
      tile = tile.animate().shake(hz: 5, offset: const Offset(4, 0));
    }
    if (state == _OptionState.correct) {
      tile = tile.animate().scale(
            begin: const Offset(1, 1),
            end: const Offset(1.02, 1.02),
            duration: 180.ms,
            curve: Curves.easeOut,
          );
    }
    return tile;
  }
}

class _ExplanationCard extends StatelessWidget {
  final String text;

  const _ExplanationCard({required this.text});

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) return const SizedBox.shrink();
    return GlassPanel(
      radius: 18,
      tint: AppColors.primary,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb_rounded,
                  color: AppColors.warning, size: 18),
              const SizedBox(width: 6),
              Text('Explanation',
                  style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style:
                Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.45),
          ),
        ],
      ),
    );
  }
}

class _PracticeSummary extends StatelessWidget {
  final ConfettiController confetti;
  final int correct;
  final int total;
  final VoidCallback onRetry;

  const _PracticeSummary({
    required this.confetti,
    required this.correct,
    required this.total,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final pct = total == 0 ? 0.0 : correct / total * 100;
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                pct >= 70
                    ? '🎯'
                    : pct >= 40
                        ? '💪'
                        : '📚',
                style: const TextStyle(fontSize: 64),
              ).animate().scale(
                    begin: const Offset(0, 0),
                    end: const Offset(1, 1),
                    duration: 500.ms,
                    curve: Curves.elasticOut,
                  ),
              const SizedBox(height: 12),
              Text('$correct / $total correct',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  pct >= 70
                      ? 'Excellent recall — keep it up!'
                      : pct >= 40
                          ? 'Solid effort. Review the explanations and retry.'
                          : 'Tough set! Revisit the flashcards for this subject.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: context.aurora.textSecondary),
                ),
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GlassButton(
                    label: 'Done',
                    variant: GlassButtonVariant.glass,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 12),
                  GlassButton(
                    label: 'New set',
                    icon: Icons.refresh_rounded,
                    onPressed: onRetry,
                  ),
                ],
              ),
            ],
          ),
        ),
        ConfettiWidget(
          confettiController: confetti,
          blastDirection: math.pi / 2,
          blastDirectionality: BlastDirectionality.explosive,
          emissionFrequency: 0.06,
          numberOfParticles: 24,
          maxBlastForce: 22,
          minBlastForce: 8,
          gravity: 0.25,
          colors: const [
            AppColors.primary,
            AppColors.accent,
            AppColors.success,
            AppColors.warning,
          ],
        ),
      ],
    );
  }
}
