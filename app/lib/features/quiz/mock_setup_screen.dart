import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/haptics.dart';
import '../../core/theme.dart';
import '../../data/db/database.dart';
import '../../data/providers.dart';
import '../../ui/aurora_route.dart';
import '../../ui/aurora_scaffold.dart';
import '../../ui/glass_button.dart';
import '../../ui/glass_chip.dart';
import '../../ui/glass_panel.dart';
import '../../ui/glass_progress.dart';
import 'mock_screen.dart';

/// Configure a timed mock: question count and seconds per question.
/// [subject] == null runs a grand mock across all subjects.
class MockSetupScreen extends ConsumerStatefulWidget {
  final Subject? subject;

  const MockSetupScreen({super.key, this.subject});

  @override
  ConsumerState<MockSetupScreen> createState() => _MockSetupScreenState();
}

class _MockSetupScreenState extends ConsumerState<MockSetupScreen> {
  int _available = 0;
  int _count = 10;
  int _secondsPerQuestion = 60;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final questions = await ref
        .read(contentRepositoryProvider)
        .mcqsForSubject(widget.subject?.id);
    if (mounted) {
      setState(() {
        _available = questions.length;
        _count = _count.clamp(1, _available == 0 ? 1 : _available);
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.subject?.name ?? 'All subjects';
    final counts = [5, 10, 15, 20].where((c) => c <= _available).toList();
    if (counts.isEmpty && _available > 0) counts.add(_available);

    return AuroraScaffold(
      title: 'Timed Mock',
      body: _loading
          ? const Center(child: AuroraSpinner())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassPanel(
                    radius: 24,
                    tint: AppColors.warning,
                    strong: true,
                    padding: const EdgeInsets.all(20),
                    glow: auroraGlow(AppColors.warning, alpha: 0.2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.timer_rounded,
                                color: AppColors.warning),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'UPSC Prelims pattern: +2.0 per correct answer, '
                          '−0.67 per wrong answer, 0 for skipped.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.1, end: 0),
                  const SizedBox(height: 28),
                  Text('Questions',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (final c in counts)
                        GlassChip(
                          label: '$c',
                          selected: _count == c,
                          onTap: () {
                            Haptics.tap();
                            setState(() => _count = c);
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('Time per question',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (final s in const [30, 45, 60, 90])
                        GlassChip(
                          label: '${s}s',
                          selected: _secondsPerQuestion == s,
                          onTap: () {
                            Haptics.tap();
                            setState(() => _secondsPerQuestion = s);
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Icon(Icons.hourglass_bottom_rounded,
                          size: 18, color: AppColors.primarySoft),
                      const SizedBox(width: 8),
                      Text(
                        'Total time: ${_formatDuration(_count * _secondsPerQuestion)}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  const Spacer(),
                  GlassButton(
                    expand: true,
                    icon: Icons.play_arrow_rounded,
                    label: _available == 0
                        ? 'No questions available'
                        : 'Start mock',
                    onPressed: _available == 0
                        ? null
                        : () {
                            Haptics.light();
                            Navigator.of(context).pushReplacement(
                              auroraRoute(
                                MockScreen(
                                  subject: widget.subject,
                                  questionCount: _count,
                                  totalSeconds: _count * _secondsPerQuestion,
                                ),
                              ),
                            );
                          },
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3, end: 0),
                ],
              ),
            ),
    );
  }

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return s == 0 ? '$m min' : '$m min ${s}s';
  }
}
