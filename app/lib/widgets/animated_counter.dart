import 'package:flutter/material.dart';

/// Counts up/down to [value] with an ease-out tween.
class AnimatedCounter extends StatelessWidget {
  final num value;
  final TextStyle? style;
  final String Function(num v)? format;
  final Duration duration;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.style,
    this.format,
    this.duration = const Duration(milliseconds: 900),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.toDouble()),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, v, _) {
        final text = format?.call(v) ?? v.round().toString();
        return Text(text, style: style);
      },
    );
  }
}
