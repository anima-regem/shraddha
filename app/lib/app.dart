import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/haptics.dart';
import 'core/theme.dart';
import 'data/providers.dart';
import 'features/home/home_screen.dart';
import 'features/progress/progress_screen.dart';
import 'features/settings/settings_screen.dart';
import 'ui/aurora_background.dart';
import 'ui/glass_nav_dock.dart';
import 'ui/glass_panel.dart';

class ShraddhaApp extends ConsumerWidget {
  const ShraddhaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = ref.watch(themeModeProvider);
    return MaterialApp(
      title: 'Shraddha',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(dark ? Brightness.dark : Brightness.light),
      home: const _Bootstrapper(),
    );
  }
}

/// Seeds bundled content on first run, then shows the nav shell.
class _Bootstrapper extends ConsumerStatefulWidget {
  const _Bootstrapper();

  @override
  ConsumerState<_Bootstrapper> createState() => _BootstrapperState();
}

class _BootstrapperState extends ConsumerState<_Bootstrapper> {
  late final Future<void> _seeding;

  @override
  void initState() {
    super.initState();
    _seeding = ref.read(syncServiceProvider).seedIfNeeded();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _seeding,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _SplashScreen();
        }
        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: context.aurora.bg,
            body: Center(
              child: Text('Failed to load content:\n${snapshot.error}'),
            ),
          );
        }
        return const NavShell();
      },
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.aurora.bg,
      body: Stack(
        children: [
          const Positioned.fill(child: AuroraBackground()),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GlassPanel(
                  blur: true,
                  strong: true,
                  radius: 32,
                  padding: const EdgeInsets.all(26),
                  glow: auroraGlow(AppColors.primary, alpha: 0.5),
                  child: const Icon(
                    Icons.auto_stories_rounded,
                    size: 56,
                    color: AppColors.primarySoft,
                  ),
                )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1.07, 1.07),
                      duration: 900.ms,
                      curve: Curves.easeInOut,
                    ),
                const SizedBox(height: 24),
                Text('Shraddha',
                        style: Theme.of(context).textTheme.headlineLarge)
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: 0.3, end: 0),
                const SizedBox(height: 6),
                Text('quiet dedication, luminous results',
                        style: Theme.of(context).textTheme.bodySmall)
                    .animate()
                    .fadeIn(delay: 250.ms, duration: 600.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NavShell extends StatefulWidget {
  const NavShell({super.key});

  @override
  State<NavShell> createState() => _NavShellState();
}

class _NavShellState extends State<NavShell> {
  int _index = 0;

  static const _screens = [HomeScreen(), ProgressScreen(), SettingsScreen()];

  static const _items = [
    GlassNavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Home',
    ),
    GlassNavItem(
      icon: Icons.insights_outlined,
      activeIcon: Icons.insights_rounded,
      label: 'Progress',
    ),
    GlassNavItem(
      icon: Icons.tune_rounded,
      activeIcon: Icons.tune_rounded,
      label: 'Settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.aurora.bg,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const Positioned.fill(child: AuroraBackground()),
          SafeArea(
            bottom: false,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween(
                    begin: const Offset(0, 0.015),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              ),
              child: KeyedSubtree(
                key: ValueKey(_index),
                child: _screens[_index],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: GlassNavDock(
                index: _index,
                items: _items,
                onChanged: (i) {
                  Haptics.tap();
                  setState(() => _index = i);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
