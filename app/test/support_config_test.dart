import 'package:flutter_test/flutter_test.dart';
import 'package:shraddha/core/ads_service.dart';
import 'package:shraddha/core/app_links.dart';

void main() {
  group('support configuration', () {
    test('publishes the intended external support links', () {
      expect(
        AppLinks.sourceCode.toString(),
        'https://github.com/anima-regem/shraddha',
      );
      expect(
        AppLinks.buyMeACoffee.toString(),
        'https://buymeacoffee.com/vichukartha',
      );
      expect(
        AppLinks.privacyPolicy.toString(),
        'https://anima-regem.github.io/shraddha/privacy-policy/',
      );
    });

    test('uses test ads in development and the supplied unit in release', () {
      expect(
        AdConfig.bannerUnitIdFor(isRelease: false),
        'ca-app-pub-3940256099942544/9214589741',
      );
      expect(
        AdConfig.bannerUnitIdFor(isRelease: true),
        'ca-app-pub-7103481995341644/6060991364',
      );
    });
  });
}
