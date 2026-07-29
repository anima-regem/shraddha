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

    test(
      'uses Google test units in development and production units in release',
      () {
        expect(
          AdConfig.bannerUnitIdFor(isRelease: false),
          'ca-app-pub-3940256099942544/9214589741',
        );
        expect(
          AdConfig.bannerUnitIdFor(isRelease: true),
          'ca-app-pub-7103481995341644/6060991364',
        );
        expect(
          AdConfig.rewardedUnitIdFor(isRelease: false),
          'ca-app-pub-3940256099942544/5224354917',
        );
        expect(
          AdConfig.rewardedUnitIdFor(isRelease: true),
          'ca-app-pub-7103481995341644/9832715411',
        );
        expect(
          AdConfig.nativeUnitIdFor(isRelease: false),
          'ca-app-pub-3940256099942544/2247696110',
        );
        expect(
          AdConfig.nativeUnitIdFor(isRelease: true),
          'ca-app-pub-7103481995341644/2668541260',
        );
      },
    );
  });
}
