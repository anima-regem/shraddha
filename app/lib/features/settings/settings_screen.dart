import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/app_links.dart';
import '../../core/haptics.dart';
import '../../core/theme.dart';
import '../../data/providers.dart';
import '../ads/watch_ads_screen.dart';
import '../../ui/aurora_route.dart';
import '../../ui/glass_button.dart';
import '../../ui/glass_dialog.dart';
import '../../ui/glass_field.dart';
import '../../ui/glass_panel.dart';
import '../../ui/glass_progress.dart';
import '../../ui/glass_slider.dart';
import '../../ui/glass_toast.dart';
import '../../ui/glass_toggle.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late final TextEditingController _repoController;
  bool _syncing = false;

  @override
  void initState() {
    super.initState();
    _repoController = TextEditingController(
      text: ref.read(syncServiceProvider).repoUrl ?? '',
    );
  }

  @override
  void dispose() {
    _repoController.dispose();
    super.dispose();
  }

  Future<void> _syncNow() async {
    final sync = ref.read(syncServiceProvider);
    Haptics.light();
    setState(() => _syncing = true);
    try {
      await sync.setRepoUrl(_repoController.text);
      final result = await sync.syncFromGithub();
      if (result.updated) Haptics.celebrate();
      if (mounted) {
        showGlassToast(
          context,
          result.message,
          icon: result.updated
              ? Icons.cloud_done_rounded
              : Icons.cloud_sync_rounded,
          color: result.updated ? AppColors.success : AppColors.primarySoft,
        );
      }
      ref.invalidate(subjectsProvider);
      ref.invalidate(dueCountsProvider);
    } catch (e) {
      Haptics.error();
      if (mounted) {
        showGlassToast(
          context,
          'Sync failed: $e',
          icon: Icons.cloud_off_rounded,
          color: AppColors.error,
        );
      }
    } finally {
      if (mounted) setState(() => _syncing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final goal = ref.watch(dailyGoalProvider);
    final dark = ref.watch(themeModeProvider);
    final sync = ref.watch(syncServiceProvider);
    final tokens = context.aurora;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
      children: [
        Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineLarge,
        ).animate().fadeIn(duration: 300.ms),
        const SizedBox(height: 20),
        _Section(
          title: 'Content repository',
          icon: Icons.cloud_sync_rounded,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Point to a GitHub repo with your UPSC content '
                '(github.com/user/repo or a raw URL).',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              GlassField(
                controller: _repoController,
                hint: 'https://github.com/you/upsc-content',
                icon: Icons.link_rounded,
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 12),
              GlassButton(
                expand: true,
                label: _syncing ? 'Syncing…' : 'Sync now',
                icon: _syncing ? null : Icons.sync_rounded,
                leading: _syncing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: AuroraSpinner(size: 18, strokeWidth: 2.4),
                      )
                    : null,
                onPressed: _syncing ? null : _syncNow,
              ),
              if (sync.lastSync != null) ...[
                const SizedBox(height: 10),
                Text(
                  'Last sync: ${DateFormat('d MMM yyyy, h:mm a').format(sync.lastSync!)} '
                  '· content v${sync.contentVersion}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ).animate().fadeIn(delay: 80.ms).slideY(begin: 0.1, end: 0),
        const SizedBox(height: 14),
        _Section(
          title: 'Daily goal',
          icon: Icons.flag_rounded,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$goal reviews per day',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              GlassSlider(
                value: goal.toDouble(),
                min: 5,
                max: 100,
                divisions: 19,
                onChanged: (v) {
                  if (v.round() != goal) {
                    Haptics.tap();
                    ref.read(dailyGoalProvider.notifier).set(v.round());
                  }
                },
              ),
            ],
          ),
        ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.1, end: 0),
        const SizedBox(height: 14),
        _Section(
          title: 'Appearance',
          icon: Icons.palette_rounded,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dark ? 'Dark aurora' : 'Daylight frost',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      dark
                          ? 'Deep-space glass for late-night study'
                          : 'Soft frosted glass for daytime',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              GlassToggle(
                value: dark,
                onChanged: (_) {
                  Haptics.tap();
                  ref.read(themeModeProvider.notifier).toggle();
                },
              ),
            ],
          ),
        ).animate().fadeIn(delay: 220.ms).slideY(begin: 0.1, end: 0),
        const SizedBox(height: 14),
        _Section(
          title: 'Support Shraddha',
          icon: Icons.volunteer_activism_rounded,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Support the project in the way that suits you. Ads are '
                'optional and never appear while you study.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              GlassButton(
                expand: true,
                variant: GlassButtonVariant.glass,
                icon: Icons.code_rounded,
                label: 'View source code',
                onPressed: () => _openLink(AppLinks.sourceCode),
              ),
              const SizedBox(height: 10),
              GlassButton(
                expand: true,
                variant: GlassButtonVariant.glass,
                icon: Icons.coffee_rounded,
                label: 'Buy me a coffee',
                onPressed: () => _openLink(AppLinks.buyMeACoffee),
              ),
              const SizedBox(height: 10),
              GlassButton(
                expand: true,
                variant: GlassButtonVariant.glass,
                icon: Icons.policy_outlined,
                label: 'Privacy policy',
                onPressed: () => _openLink(AppLinks.privacyPolicy),
              ),
              const SizedBox(height: 10),
              GlassButton(
                expand: true,
                variant: GlassButtonVariant.glass,
                icon: Icons.ondemand_video_rounded,
                label: 'Watch optional ads',
                onPressed: () {
                  Haptics.light();
                  Navigator.of(
                    context,
                  ).push(auroraRoute(const WatchAdsScreen()));
                },
              ),
            ],
          ),
        ).animate().fadeIn(delay: 290.ms).slideY(begin: 0.1, end: 0),
        const SizedBox(height: 14),
        _Section(
          title: 'Danger zone',
          icon: Icons.warning_amber_rounded,
          child: GlassButton(
            expand: true,
            variant: GlassButtonVariant.danger,
            icon: Icons.delete_forever_rounded,
            label: 'Reset all progress',
            onPressed: () => _confirmReset(context),
          ),
        ).animate().fadeIn(delay: 360.ms).slideY(begin: 0.1, end: 0),
        const SizedBox(height: 24),
        Center(
          child: Text(
            'Shraddha · Made for the journey to LBSNAA 🏔️',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: tokens.textSecondary),
          ),
        ).animate().fadeIn(delay: 470.ms),
      ],
    );
  }

  Future<void> _openLink(Uri uri) async {
    Haptics.light();
    final opened = await AppLinks.open(uri);
    if (!opened && mounted) {
      showGlassToast(
        context,
        'Could not open that link.',
        icon: Icons.open_in_new_rounded,
        color: AppColors.error,
      );
    }
  }

  void _confirmReset(BuildContext context) {
    Haptics.error();
    showGlassDialog<void>(
      context: context,
      title: 'Reset all progress?',
      message:
          'Heatmap, streaks, SRS schedules and mock history will be wiped. '
          'Content stays. This cannot be undone.',
      actions: [
        Builder(
          builder: (dialogContext) => GlassButton(
            label: 'Cancel',
            variant: GlassButtonVariant.glass,
            expand: true,
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
        ),
        Builder(
          builder: (dialogContext) => GlassButton(
            label: 'Reset',
            variant: GlassButtonVariant.danger,
            expand: true,
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await ref.read(contentRepositoryProvider).resetProgress();
              ref.invalidate(dueCountsProvider);
              if (context.mounted) {
                showGlassToast(
                  context,
                  'Progress reset.',
                  icon: Icons.restart_alt_rounded,
                  color: AppColors.warning,
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _Section({
    required this.title,
    required this.icon,
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
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primarySoft),
              const SizedBox(width: 8),
              Text(title, style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
