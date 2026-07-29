import 'package:flutter/material.dart';

import '../core/theme.dart';
import 'aurora_background.dart';
import 'glass_header.dart';

/// Screen shell for pushed routes: aurora backdrop + glass header + body,
/// with an optional in-flow bottom bar (e.g. the mock question palette).
class AuroraScaffold extends StatelessWidget {
  final Widget body;
  final String? title;
  final Widget? headerTrailing;
  final bool showBack;
  final VoidCallback? onBack;
  final Widget? bottomBar;
  final bool resizeToAvoidBottomInset;

  const AuroraScaffold({
    super.key,
    required this.body,
    this.title,
    this.headerTrailing,
    this.showBack = true,
    this.onBack,
    this.bottomBar,
    this.resizeToAvoidBottomInset = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.aurora.bg,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: Stack(
        children: [
          const Positioned.fill(child: AuroraBackground()),
          SafeArea(
            child: Column(
              children: [
                if (title != null)
                  GlassHeader(
                    title: title!,
                    trailing: headerTrailing,
                    showBack: showBack,
                    onBack: onBack,
                  ),
                Expanded(child: body),
                ?bottomBar,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
