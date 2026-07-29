import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A deliberately restrained palette: one blue-slate accent plus muted
/// semantic feedback colors. The UI stays calm even when multiple surfaces
/// overlap the glass background.
abstract final class AppColors {
  static const primary = Color(0xFF536A96);
  static const primarySoft = Color(0xFF9AAAC7);
  static const accent = Color(0xFF7184A5);
  static const teal = Color(0xFF5D8E8B);
  static const success = Color(0xFF56886F);
  static const error = Color(0xFFC06D73);
  static const warning = Color(0xFFB78D50);
}

/// Design tokens for the aurora glass design system.
/// Registered as a ThemeExtension so theme switches cross-fade for free.
class AuroraTokens extends ThemeExtension<AuroraTokens> {
  final bool isDark;
  final Color bg;
  final Color surfaceSolid; // opaque fallback (tooltips, toasts on busy bg)
  final Color glassFill;
  final Color glassFillStrong;
  final Color strokeTop; // refraction border, light edge
  final Color strokeBottom; // refraction border, shaded edge
  final Color textPrimary;
  final Color textSecondary;
  final Color orb1;
  final Color orb2;
  final Color orb3;
  final double orbOpacity;
  final double blurSigma;
  final Color heatEmpty;
  final List<Color> heatScale;

  const AuroraTokens({
    required this.isDark,
    required this.bg,
    required this.surfaceSolid,
    required this.glassFill,
    required this.glassFillStrong,
    required this.strokeTop,
    required this.strokeBottom,
    required this.textPrimary,
    required this.textSecondary,
    required this.orb1,
    required this.orb2,
    required this.orb3,
    required this.orbOpacity,
    required this.blurSigma,
    required this.heatEmpty,
    required this.heatScale,
  });

  static const dark = AuroraTokens(
    isDark: true,
    bg: Color(0xFF101318),
    surfaceSolid: Color(0xFF202731),
    glassFill: Color(0xCC1B222B),
    glassFillStrong: Color(0xE6212934),
    strokeTop: Color(0x3ADCE3EC),
    strokeBottom: Color(0x50101720),
    textPrimary: Color(0xFFF1F4F7),
    textSecondary: Color(0xFFB5C0CD),
    orb1: Color(0xFF405169),
    orb2: Color(0xFF465968),
    orb3: Color(0xFF556274),
    orbOpacity: 0.11,
    blurSigma: 16,
    heatEmpty: Color(0x141F2A35),
    heatScale: [
      Color(0xFF27313D),
      Color(0xFF34445A),
      Color(0xFF425977),
      Color(0xFF5C7599),
      Color(0xFF8EA4C2),
    ],
  );

  static const light = AuroraTokens(
    isDark: false,
    bg: Color(0xFFF3F5F7),
    surfaceSolid: Color(0xFFFFFFFF),
    glassFill: Color(0xCFFFFFFF),
    glassFillStrong: Color(0xE8FFFFFF),
    strokeTop: Color(0xF7FFFFFF),
    strokeBottom: Color(0x1F263342),
    textPrimary: Color(0xFF19212B),
    textSecondary: Color(0xFF526171),
    orb1: Color(0xFFB7C2D0),
    orb2: Color(0xFFC0C8D2),
    orb3: Color(0xFFB3C0CB),
    orbOpacity: 0.16,
    blurSigma: 16,
    heatEmpty: Color(0x12263342),
    heatScale: [
      Color(0xFFDCE3EB),
      Color(0xFFB9C7D8),
      Color(0xFF91A8C2),
      Color(0xFF6C86A7),
      Color(0xFF4C668E),
    ],
  );

  @override
  AuroraTokens copyWith({
    bool? isDark,
    Color? bg,
    Color? surfaceSolid,
    Color? glassFill,
    Color? glassFillStrong,
    Color? strokeTop,
    Color? strokeBottom,
    Color? textPrimary,
    Color? textSecondary,
    Color? orb1,
    Color? orb2,
    Color? orb3,
    double? orbOpacity,
    double? blurSigma,
    Color? heatEmpty,
    List<Color>? heatScale,
  }) {
    return AuroraTokens(
      isDark: isDark ?? this.isDark,
      bg: bg ?? this.bg,
      surfaceSolid: surfaceSolid ?? this.surfaceSolid,
      glassFill: glassFill ?? this.glassFill,
      glassFillStrong: glassFillStrong ?? this.glassFillStrong,
      strokeTop: strokeTop ?? this.strokeTop,
      strokeBottom: strokeBottom ?? this.strokeBottom,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      orb1: orb1 ?? this.orb1,
      orb2: orb2 ?? this.orb2,
      orb3: orb3 ?? this.orb3,
      orbOpacity: orbOpacity ?? this.orbOpacity,
      blurSigma: blurSigma ?? this.blurSigma,
      heatEmpty: heatEmpty ?? this.heatEmpty,
      heatScale: heatScale ?? this.heatScale,
    );
  }

  @override
  AuroraTokens lerp(AuroraTokens? other, double t) {
    if (other == null) return this;
    return AuroraTokens(
      isDark: t < 0.5 ? isDark : other.isDark,
      bg: Color.lerp(bg, other.bg, t)!,
      surfaceSolid: Color.lerp(surfaceSolid, other.surfaceSolid, t)!,
      glassFill: Color.lerp(glassFill, other.glassFill, t)!,
      glassFillStrong: Color.lerp(glassFillStrong, other.glassFillStrong, t)!,
      strokeTop: Color.lerp(strokeTop, other.strokeTop, t)!,
      strokeBottom: Color.lerp(strokeBottom, other.strokeBottom, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      orb1: Color.lerp(orb1, other.orb1, t)!,
      orb2: Color.lerp(orb2, other.orb2, t)!,
      orb3: Color.lerp(orb3, other.orb3, t)!,
      orbOpacity: lerpDouble(orbOpacity, other.orbOpacity, t),
      blurSigma: lerpDouble(blurSigma, other.blurSigma, t),
      heatEmpty: Color.lerp(heatEmpty, other.heatEmpty, t)!,
      heatScale: [
        for (var i = 0; i < heatScale.length; i++)
          Color.lerp(heatScale[i], other.heatScale[i], t)!,
      ],
    );
  }

  static double lerpDouble(double a, double b, double t) => a + (b - a) * t;
}

extension AuroraContext on BuildContext {
  AuroraTokens get aurora => Theme.of(this).extension<AuroraTokens>()!;
}

/// Minimal underlying ThemeData: MaterialApp plumbing only.
/// All visible surfaces are drawn by the custom ui/ components.
ThemeData buildTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final tokens = isDark ? AuroraTokens.dark : AuroraTokens.light;

  final body = GoogleFonts.manropeTextTheme(
    ThemeData(brightness: brightness).textTheme,
  );
  TextStyle display(double size, [FontWeight w = FontWeight.w700]) =>
      GoogleFonts.spaceGrotesk(
        fontSize: size,
        fontWeight: w,
        color: tokens.textPrimary,
      );

  final textTheme = body
      .copyWith(
        displayLarge: display(48),
        displayMedium: display(36),
        headlineLarge: display(30),
        headlineMedium: display(24),
        headlineSmall: display(20),
        titleLarge: display(18, FontWeight.w600),
        titleMedium: display(15, FontWeight.w600),
        titleSmall: display(13, FontWeight.w600),
      )
      .apply(bodyColor: tokens.textPrimary, displayColor: tokens.textPrimary);

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    extensions: [tokens],
    scaffoldBackgroundColor: tokens.bg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
      surface: tokens.bg,
    ),
    textTheme: textTheme.copyWith(
      bodySmall: textTheme.bodySmall?.copyWith(color: tokens.textSecondary),
      labelSmall: textTheme.labelSmall?.copyWith(color: tokens.textSecondary),
      labelMedium: textTheme.labelMedium?.copyWith(color: tokens.textSecondary),
    ),
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primary,
      selectionColor: AppColors.primary.withValues(alpha: 0.30),
      selectionHandleColor: AppColors.primary,
    ),
  );
}

/// Maps icon names used in the content repo to Material icons.
IconData subjectIcon(String name) => switch (name) {
  'account_balance' => Icons.account_balance_rounded,
  'castle' => Icons.castle_rounded,
  'public' => Icons.public_rounded,
  'trending_up' => Icons.trending_up_rounded,
  'eco' => Icons.eco_rounded,
  'rocket_launch' => Icons.rocket_launch_rounded,
  'newspaper' => Icons.newspaper_rounded,
  'menu_book' => Icons.menu_book_rounded,
  'gavel' => Icons.gavel_rounded,
  'psychology' => Icons.psychology_rounded,
  _ => Icons.school_rounded,
};

Color hexColor(String hex) {
  var h = hex.replaceFirst('#', '');
  if (h.length == 6) h = 'FF$h';
  return Color(int.parse(h, radix: 16));
}
