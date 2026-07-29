import 'package:flutter/services.dart';

/// Small wrapper so haptic intent reads clearly at call sites.
abstract final class Haptics {
  static void tap() => HapticFeedback.selectionClick();
  static void light() => HapticFeedback.lightImpact();
  static void success() => HapticFeedback.mediumImpact();
  static void error() => HapticFeedback.heavyImpact();
  static void celebrate() async {
    HapticFeedback.mediumImpact();
    await Future<void>.delayed(const Duration(milliseconds: 120));
    HapticFeedback.heavyImpact();
  }
}
