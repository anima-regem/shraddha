import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/haptics.dart';
import '../../core/theme.dart';
import '../../data/db/database.dart';
import '../../data/providers.dart';
import '../../data/srs.dart';
import '../../ui/aurora_scaffold.dart';
import '../../ui/glass_button.dart';
import '../../ui/glass_chip.dart';
import '../../ui/glass_panel.dart';
import '../../ui/glass_progress.dart';
import '../../ui/pressable.dart';
import 'flash_card.dart';

class DeckScreen extends ConsumerStatefulWidget {
  final Subject subject;

  const DeckScreen({super.key, required this.subject});

  @override
  ConsumerState<DeckScreen> createState() => _DeckScreenState();
}

class _DeckScreenState extends ConsumerState<DeckScreen>
    with SingleTickerProviderStateMixin {
  List<Flashcard>? _cards;
  int _index = 0;
  bool _flipped = false;

  Offset _drag = Offset.zero;
  bool _flinging = false;

  late final AnimationController _flingController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
  );
  Animation<Offset>? _flingAnimation;

  late final ConfettiController _confetti =
      ConfettiController(duration: const Duration(seconds: 2));

  final _ratingCounts = <Rating, int>{};

  @override
  void initState() {
    super.initState();
    _load();
    _flingController.addStatusListener((status) {
      if (status == AnimationStatus.completed) _advance();
    });
  }

  Future<void> _load() async {
    final cards = await ref
        .read(contentRepositoryProvider)
        .dueFlashcards(widget.subject.id);
    cards.shuffle();
    if (mounted) setState(() => _cards = cards);
  }

  @override
  void dispose() {
    _flingController.dispose();
    _confetti.dispose();
    super.dispose();
  }

  void _rate(Rating rating) {
    if (_flinging || _cards == null || _index >= _cards!.length) return;
    final card = _cards![_index];
    ref
        .read(contentRepositoryProvider)
        .rateFlashcard(card: card, rating: rating);
    _ratingCounts[rating] = (_ratingCounts[rating] ?? 0) + 1;

    switch (rating) {
      case Rating.again:
        Haptics.error();
      case Rating.hard:
        Haptics.light();
      case Rating.good:
      case Rating.easy:
        Haptics.success();
    }

    final width = MediaQuery.sizeOf(context).width;
    final direction = rating == Rating.again || rating == Rating.hard ? -1 : 1;
    final target = Offset(direction * width * 1.4, _drag.dy - 60);
    _flingAnimation = Tween(begin: _drag, end: target).animate(
      CurvedAnimation(parent: _flingController, curve: Curves.easeInCubic),
    );
    setState(() => _flinging = true);
    _flingController.forward(from: 0);
  }

  void _advance() {
    setState(() {
      _index++;
      _flipped = false;
      _drag = Offset.zero;
      _flinging = false;
    });
    _flingController.reset();
    if (_cards != null && _index >= _cards!.length) {
      Haptics.celebrate();
      _confetti.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cards = _cards;
    final accent = hexColor(widget.subject.colorHex);

    return AuroraScaffold(
      title: widget.subject.name,
      headerTrailing: cards != null && _index < cards.length
          ? GlassChip(
              label: '${_index + 1} / ${cards.length}',
              color: accent,
            )
          : null,
      body: cards == null
          ? const Center(child: AuroraSpinner())
          : cards.isEmpty
              ? _EmptyDeck(subject: widget.subject)
              : _index >= cards.length
                  ? _SessionComplete(
                      confetti: _confetti,
                      counts: _ratingCounts,
                      total: cards.length,
                      onAgain: () {
                        setState(() {
                          _index = 0;
                          _ratingCounts.clear();
                          _cards = null;
                        });
                        _load();
                      },
                    )
                  : _buildDeck(cards, accent),
    );
  }

  Widget _buildDeck(List<Flashcard> cards, Color accent) {
    final card = cards[_index];
    final next = _index + 1 < cards.length ? cards[_index + 1] : null;
    final dragX = _drag.dx;
    final tilt = (dragX / 400).clamp(-0.35, 0.35);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Column(
        children: [
          GlassProgressBar(
            value: _index / cards.length,
            colors: [accent, AppColors.accent],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (next != null)
                  Positioned.fill(
                    child: AnimatedScale(
                      scale: _drag.dx.abs() > 20 || _flinging ? 0.97 : 0.92,
                      duration: const Duration(milliseconds: 200),
                      child: Opacity(
                        opacity: 0.5,
                        child: IgnorePointer(
                          child: FlipCard(
                            front: next.front,
                            back: next.back,
                            topic: next.topic,
                            accent: accent,
                            flipped: false,
                            onTap: () {},
                          ),
                        ),
                      ),
                    ),
                  ),
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _flingController,
                    builder: (context, child) {
                      final offset = _flinging && _flingAnimation != null
                          ? _flingAnimation!.value
                          : _drag;
                      return Transform.translate(
                        offset: offset,
                        child: Transform.rotate(
                          angle: _flinging
                              ? (offset.dx / 400).clamp(-0.5, 0.5)
                              : tilt,
                          child: child,
                        ),
                      );
                    },
                    child: GestureDetector(
                      onPanUpdate: _flipped && !_flinging
                          ? (details) =>
                              setState(() => _drag += details.delta)
                          : null,
                      onPanEnd: _flipped && !_flinging
                          ? (details) {
                              if (_drag.dx > 110) {
                                _rate(Rating.good);
                              } else if (_drag.dx < -110) {
                                _rate(Rating.again);
                              } else {
                                setState(() => _drag = Offset.zero);
                              }
                            }
                          : null,
                      child: FlipCard(
                        front: card.front,
                        back: card.back,
                        topic: card.topic,
                        accent: accent,
                        flipped: _flipped,
                        onTap: () {
                          if (_flinging) return;
                          Haptics.tap();
                          setState(() => _flipped = !_flipped);
                        },
                      ),
                    ),
                  ),
                ),
                if (dragX.abs() > 40 && _flipped && !_flinging)
                  Positioned(
                    top: 24,
                    left: dragX > 0 ? 24 : null,
                    right: dragX < 0 ? 24 : null,
                    child: _SwipeBadge(good: dragX > 0)
                        .animate()
                        .fadeIn(duration: 120.ms)
                        .scale(
                          begin: const Offset(0.7, 0.7),
                          end: const Offset(1, 1),
                        ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween(
                  begin: const Offset(0, 0.5),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
            child: _flipped
                ? Row(
                    key: const ValueKey('ratings'),
                    children: [
                      _RatingButton(
                        label: 'Again',
                        color: AppColors.error,
                        icon: Icons.replay_rounded,
                        onTap: () => _rate(Rating.again),
                      ),
                      _RatingButton(
                        label: 'Hard',
                        color: AppColors.warning,
                        icon: Icons.trending_down_rounded,
                        onTap: () => _rate(Rating.hard),
                      ),
                      _RatingButton(
                        label: 'Good',
                        color: AppColors.success,
                        icon: Icons.thumb_up_alt_rounded,
                        onTap: () => _rate(Rating.good),
                      ),
                      _RatingButton(
                        label: 'Easy',
                        color: AppColors.primarySoft,
                        icon: Icons.bolt_rounded,
                        onTap: () => _rate(Rating.easy),
                      ),
                    ],
                  )
                : SizedBox(
                    key: const ValueKey('hint'),
                    height: 74,
                    child: Center(
                      child: Text(
                        'Tap the card to reveal the answer',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                                color: context.aurora.textSecondary),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _SwipeBadge extends StatelessWidget {
  final bool good;

  const _SwipeBadge({required this.good});

  @override
  Widget build(BuildContext context) {
    final color = good ? AppColors.success : AppColors.error;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
        boxShadow: auroraGlow(color, alpha: 0.5),
      ),
      child: Text(
        good ? 'GOOD' : 'AGAIN',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

class _RatingButton extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _RatingButton({
    required this.label,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.aurora;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Pressable(
          onTap: onTap,
          pressedScale: 0.92,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Color.alphaBlend(
                color.withValues(alpha: tokens.isDark ? 0.14 : 0.12),
                tokens.glassFill,
              ),
              border: Border.all(color: color.withValues(alpha: 0.35)),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.18),
                  blurRadius: 12,
                  spreadRadius: -2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(icon, color: color, size: 22),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyDeck extends StatelessWidget {
  final Subject subject;

  const _EmptyDeck({required this.subject});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.celebration_rounded,
              size: 64, color: AppColors.success),
          const SizedBox(height: 16),
          Text('All caught up!',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'No cards due in ${subject.name} right now.\nCome back later — spaced repetition works best with rest.',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: context.aurora.textSecondary),
          ),
        ],
      ).animate().fadeIn(duration: 400.ms).scale(
            begin: const Offset(0.9, 0.9),
            end: const Offset(1, 1),
            curve: Curves.easeOutBack,
          ),
    );
  }
}

class _SessionComplete extends StatelessWidget {
  final ConfettiController confetti;
  final Map<Rating, int> counts;
  final int total;
  final VoidCallback onAgain;

  const _SessionComplete({
    required this.confetti,
    required this.counts,
    required this.total,
    required this.onAgain,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.emoji_events_rounded,
                        size: 72, color: AppColors.warning)
                    .animate()
                    .scale(
                      begin: const Offset(0, 0),
                      end: const Offset(1, 1),
                      duration: 500.ms,
                      curve: Curves.elasticOut,
                    ),
                const SizedBox(height: 16),
                Text('Session complete!',
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text('$total cards reviewed',
                    style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    GlassChip(
                        label: 'Again · ${counts[Rating.again] ?? 0}',
                        color: AppColors.error),
                    GlassChip(
                        label: 'Hard · ${counts[Rating.hard] ?? 0}',
                        color: AppColors.warning),
                    GlassChip(
                        label: 'Good · ${counts[Rating.good] ?? 0}',
                        color: AppColors.success),
                    GlassChip(
                        label: 'Easy · ${counts[Rating.easy] ?? 0}',
                        color: AppColors.primarySoft),
                  ],
                ).animate().fadeIn(delay: 300.ms),
                const SizedBox(height: 32),
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
                      label: 'Review again',
                      icon: Icons.refresh_rounded,
                      onPressed: onAgain,
                    ),
                  ],
                ).animate().fadeIn(delay: 450.ms),
              ],
            ),
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
