import 'package:flutter/material.dart';

import '../core/haptics.dart';
import '../core/theme.dart';
import 'glass_panel.dart';
import 'pressable.dart';

/// Custom in-flow header replacing AppBar: frosted back chip + display
/// title + optional trailing widget.
class GlassHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final bool showBack;
  final VoidCallback? onBack;

  const GlassHeader({
    super.key,
    required this.title,
    this.trailing,
    this.showBack = true,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
      child: Row(
        children: [
          if (showBack) ...[
            Pressable(
              onTap: () {
                Haptics.tap();
                (onBack ?? () => Navigator.of(context).maybePop())();
              },
              child: GlassPanel(
                radius: 16,
                strong: true,
                padding: const EdgeInsets.all(10),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: context.aurora.textPrimary,
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
