import 'package:flutter/material.dart';

import '../core/theme.dart';
import 'glass_panel.dart';
import 'pressable.dart';

class GlassNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const GlassNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

/// Floating frosted pill dock replacing NavigationBar.
class GlassNavDock extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;
  final List<GlassNavItem> items;

  const GlassNavDock({
    super.key,
    required this.index,
    required this.onChanged,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.aurora;
    return GlassPanel(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      radius: 28,
      blur: true,
      strong: true,
      padding: const EdgeInsets.all(6),
      glow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: tokens.isDark ? 0.35 : 0.10),
          blurRadius: 24,
          offset: const Offset(0, 10),
        ),
      ],
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++)
            Expanded(
              child: Pressable(
                onTap: () => onChanged(i),
                pressedScale: 0.92,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: i == index
                        ? LinearGradient(
                            colors: [
                              AppColors.primary
                                  .withValues(alpha: tokens.isDark ? 0.55 : 0.85),
                              AppColors.accent
                                  .withValues(alpha: tokens.isDark ? 0.45 : 0.75),
                            ],
                          )
                        : null,
                    boxShadow: i == index
                        ? auroraGlow(AppColors.primary, alpha: 0.35)
                        : null,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        i == index ? items[i].activeIcon : items[i].icon,
                        size: 23,
                        color: i == index
                            ? Colors.white
                            : tokens.textSecondary,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        items[i].label,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                          color: i == index
                              ? Colors.white
                              : tokens.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
