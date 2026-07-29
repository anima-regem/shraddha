import 'package:url_launcher/url_launcher.dart';

/// Public destinations surfaced by the optional support section.
abstract final class AppLinks {
  static final sourceCode = Uri.parse(
    'https://github.com/anima-regem/shraddha',
  );
  static final buyMeACoffee = Uri.parse('https://buymeacoffee.com/vichukartha');
  static final privacyPolicy = Uri.parse(
    'https://anima-regem.github.io/shraddha/privacy-policy/',
  );

  static Future<bool> open(Uri uri) {
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
