import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Client-visible AdMob configuration. The live unit is used only in release
/// builds; all development builds load Google's official Android test banner.
abstract final class AdConfig {
  static const androidAppId = 'ca-app-pub-7103481995341644~6531764656';
  static const _productionBannerUnitId =
      'ca-app-pub-7103481995341644/6060991364';
  static const _testBannerUnitId = 'ca-app-pub-3940256099942544/9214589741';

  static String bannerUnitIdFor({required bool isRelease}) {
    return isRelease ? _productionBannerUnitId : _testBannerUnitId;
  }

  static String get bannerUnitId => bannerUnitIdFor(isRelease: kReleaseMode);
}

class AdsReadiness {
  final bool canRequestAds;
  final bool privacyOptionsRequired;

  const AdsReadiness({
    required this.canRequestAds,
    required this.privacyOptionsRequired,
  });
}

/// Keeps consent and Mobile Ads setup local to the opt-in ad surface.
abstract final class AdsService {
  static Future<AdsReadiness> prepareBannerAds() async {
    try {
      await _updateConsentInformation();
      await _showConsentFormIfRequired();

      final consentInformation = ConsentInformation.instance;
      final canRequestAds = await consentInformation.canRequestAds();
      final privacyOptionsRequired =
          await consentInformation.getPrivacyOptionsRequirementStatus() ==
          PrivacyOptionsRequirementStatus.required;

      if (canRequestAds) {
        await MobileAds.instance.initialize();
      }

      return AdsReadiness(
        canRequestAds: canRequestAds,
        privacyOptionsRequired: privacyOptionsRequired,
      );
    } catch (_) {
      return const AdsReadiness(
        canRequestAds: false,
        privacyOptionsRequired: false,
      );
    }
  }

  static Future<bool> showPrivacyOptions() async {
    final completer = Completer<FormError?>();
    await ConsentForm.showPrivacyOptionsForm(completer.complete);
    return (await completer.future) == null;
  }

  static Future<void> _updateConsentInformation() {
    final completer = Completer<void>();
    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      completer.complete,
      completer.completeError,
    );
    return completer.future;
  }

  static Future<void> _showConsentFormIfRequired() {
    final completer = Completer<FormError?>();
    ConsentForm.loadAndShowConsentFormIfRequired(completer.complete);
    return completer.future.then((error) {
      if (error != null) throw error;
    });
  }
}
