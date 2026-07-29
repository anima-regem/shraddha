import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../core/ads_service.dart';
import '../../core/haptics.dart';
import '../../core/theme.dart';
import '../../data/providers.dart';
import '../../ui/aurora_scaffold.dart';
import '../../ui/glass_button.dart';
import '../../ui/glass_panel.dart';

enum _AdLoadState { preparing, loading, ready, unavailable }

/// The app's sole advertising surface. Ads are created only after the user
/// explicitly opens this route from Settings and are disposed on exit.
class WatchAdsScreen extends ConsumerStatefulWidget {
  const WatchAdsScreen({super.key});

  @override
  ConsumerState<WatchAdsScreen> createState() => _WatchAdsScreenState();
}

class _WatchAdsScreenState extends ConsumerState<WatchAdsScreen> {
  static const _supporterMomentsKey = 'supporter_moments';

  BannerAd? _banner;
  NativeAd? _nativeAd;
  RewardedAd? _rewardedAd;
  _AdLoadState _bannerState = _AdLoadState.preparing;
  _AdLoadState _nativeState = _AdLoadState.preparing;
  _AdLoadState _rewardedState = _AdLoadState.preparing;
  bool _privacyOptionsRequired = false;
  bool _showingRewarded = false;
  int _supporterMoments = 0;
  int _requestGeneration = 0;

  @override
  void initState() {
    super.initState();
    _supporterMoments =
        ref.read(sharedPrefsProvider).getInt(_supporterMomentsKey) ?? 0;
    _prepareAndLoad();
  }

  @override
  void dispose() {
    _requestGeneration++;
    _disposeAds();
    super.dispose();
  }

  void _disposeAds() {
    _banner?.dispose();
    _banner = null;
    _nativeAd?.dispose();
    _nativeAd = null;
    _rewardedAd?.dispose();
    _rewardedAd = null;
  }

  Future<void> _prepareAndLoad() async {
    if (_showingRewarded) return;

    final generation = ++_requestGeneration;
    _disposeAds();
    if (mounted) {
      setState(() {
        _bannerState = _AdLoadState.preparing;
        _nativeState = _AdLoadState.preparing;
        _rewardedState = _AdLoadState.preparing;
      });
    }

    final readiness = await AdsService.prepareBannerAds();
    if (!mounted || generation != _requestGeneration) return;

    setState(() {
      _privacyOptionsRequired = readiness.privacyOptionsRequired;
      final state = readiness.canRequestAds
          ? _AdLoadState.loading
          : _AdLoadState.unavailable;
      _bannerState = state;
      _nativeState = state;
      _rewardedState = state;
    });

    if (readiness.canRequestAds) {
      _loadBanner(generation);
      _loadNative(generation);
      _loadRewarded(generation);
    }
  }

  void _loadBanner(int generation) {
    final banner = BannerAd(
      size: AdSize.banner,
      adUnitId: AdConfig.bannerUnitId,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted || generation != _requestGeneration) {
            ad.dispose();
            return;
          }
          setState(() => _bannerState = _AdLoadState.ready);
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('Banner ad failed to load: $error');
          ad.dispose();
          if (mounted && generation == _requestGeneration) {
            setState(() {
              _banner = null;
              _bannerState = _AdLoadState.unavailable;
            });
          }
        },
      ),
    );
    _banner = banner;
    banner.load();
  }

  void _loadNative(int generation) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? const Color(0xFF202731) : Colors.white;
    final text = isDark ? const Color(0xFFF1F4F7) : const Color(0xFF19212B);
    final secondary = isDark
        ? const Color(0xFFB5C0CD)
        : const Color(0xFF526171);
    final nativeAd = NativeAd(
      adUnitId: AdConfig.nativeUnitId,
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium,
        mainBackgroundColor: background,
        cornerRadius: 18,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: Colors.white,
          backgroundColor: AppColors.primary,
          style: NativeTemplateFontStyle.normal,
          size: 14,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: text,
          backgroundColor: background,
          style: NativeTemplateFontStyle.bold,
          size: 16,
        ),
        secondaryTextStyle: NativeTemplateTextStyle(
          textColor: secondary,
          backgroundColor: background,
          style: NativeTemplateFontStyle.normal,
          size: 13,
        ),
        tertiaryTextStyle: NativeTemplateTextStyle(
          textColor: secondary,
          backgroundColor: background,
          style: NativeTemplateFontStyle.normal,
          size: 12,
        ),
      ),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          if (!mounted || generation != _requestGeneration) {
            ad.dispose();
            return;
          }
          setState(() => _nativeState = _AdLoadState.ready);
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('Native ad failed to load: $error');
          ad.dispose();
          if (mounted && generation == _requestGeneration) {
            setState(() {
              _nativeAd = null;
              _nativeState = _AdLoadState.unavailable;
            });
          }
        },
      ),
    );
    _nativeAd = nativeAd;
    nativeAd.load();
  }

  void _loadRewarded(int generation) {
    RewardedAd.load(
      adUnitId: AdConfig.rewardedUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          if (!mounted || generation != _requestGeneration) {
            ad.dispose();
            return;
          }
          _rewardedAd = ad;
          setState(() => _rewardedState = _AdLoadState.ready);
        },
        onAdFailedToLoad: (error) {
          debugPrint('Rewarded ad failed to load: $error');
          if (mounted && generation == _requestGeneration) {
            setState(() => _rewardedState = _AdLoadState.unavailable);
          }
        },
      ),
    );
  }

  void _showRewardedAd() {
    Haptics.light();
    final ad = _rewardedAd;
    if (ad == null) {
      _loadRewarded(_requestGeneration);
      return;
    }

    var earnedReward = false;
    setState(() {
      _rewardedAd = null;
      _showingRewarded = true;
      _rewardedState = _AdLoadState.loading;
    });
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _finishRewardedPresentation();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('Rewarded ad failed to show: $error');
        ad.dispose();
        _finishRewardedPresentation();
      },
    );
    ad.show(
      onUserEarnedReward: (ad, reward) {
        if (earnedReward) return;
        earnedReward = true;
        _recordSupporterMoment();
      },
    );
  }

  void _finishRewardedPresentation() {
    if (!mounted) return;
    setState(() => _showingRewarded = false);
    _loadRewarded(_requestGeneration);
  }

  void _recordSupporterMoment() {
    if (!mounted) return;
    final next = _supporterMoments + 1;
    setState(() => _supporterMoments = next);
    unawaited(ref.read(sharedPrefsProvider).setInt(_supporterMomentsKey, next));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thank you for supporting Shraddha.')),
    );
  }

  Future<void> _showPrivacyOptions() async {
    Haptics.light();
    try {
      await AdsService.showPrivacyOptions();
    } catch (_) {
      // This page remains optional if the platform privacy form is unavailable.
    }
    if (mounted) await _prepareAndLoad();
  }

  @override
  Widget build(BuildContext context) {
    return AuroraScaffold(
      title: 'Watch ads',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
        children: [
          GlassPanel(
            radius: 24,
            strong: true,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.volunteer_activism_rounded,
                      color: AppColors.primarySoft,
                    ),
                    SizedBox(width: 10),
                    Text('Support Shraddha'),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Choose any option below. Ads are completely optional, '
                  'never unlock study features, and never appear outside this page.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (_supporterMoments > 0) ...[
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 18,
                        color: AppColors.warning,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        '$_supporterMoments supporter ${_supporterMoments == 1 ? 'moment' : 'moments'}',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SupportSection(
            icon: Icons.view_day_outlined,
            title: 'Quick support',
            description: 'A small banner from Google.',
            child: _BannerContent(
              state: _bannerState,
              banner: _banner,
              onRetry: _prepareAndLoad,
            ),
          ),
          const SizedBox(height: 16),
          _SupportSection(
            icon: Icons.ondemand_video_rounded,
            title: 'Watch a short video',
            description:
                'You choose whether to watch. Completing it adds one '
                'cosmetic Supporter moment—nothing study-related is affected.',
            child: _RewardedContent(
              state: _rewardedState,
              isShowing: _showingRewarded,
              onWatch: _showRewardedAd,
              onRetry: () => _loadRewarded(_requestGeneration),
            ),
          ),
          const SizedBox(height: 16),
          _SupportSection(
            icon: Icons.campaign_outlined,
            title: 'Sponsored discovery',
            description: 'A clearly labelled sponsored card from Google.',
            child: _NativeContent(
              state: _nativeState,
              nativeAd: _nativeAd,
              onRetry: () => _loadNative(_requestGeneration),
            ),
          ),
          if (_privacyOptionsRequired) ...[
            const SizedBox(height: 16),
            GlassButton(
              expand: true,
              variant: GlassButtonVariant.glass,
              icon: Icons.privacy_tip_outlined,
              label: 'Privacy choices',
              onPressed: _showPrivacyOptions,
            ),
          ],
        ],
      ),
    );
  }
}

class _SupportSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Widget child;

  const _SupportSection({
    required this.icon,
    required this.title,
    required this.description,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      radius: 24,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primarySoft),
              const SizedBox(width: 10),
              Text(title, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 8),
          Text(description, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 18),
          Center(child: child),
        ],
      ),
    );
  }
}

class _BannerContent extends StatelessWidget {
  final _AdLoadState state;
  final BannerAd? banner;
  final VoidCallback onRetry;

  const _BannerContent({
    required this.state,
    required this.banner,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      _AdLoadState.preparing || _AdLoadState.loading => const SizedBox(
        height: 50,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      _AdLoadState.ready when banner != null => SizedBox(
        width: AdSize.banner.width.toDouble(),
        height: AdSize.banner.height.toDouble(),
        child: AdWidget(ad: banner!),
      ),
      _ => _UnavailableAdContent(
        message: 'No banner is available right now.',
        onRetry: onRetry,
      ),
    };
  }
}

class _RewardedContent extends StatelessWidget {
  final _AdLoadState state;
  final bool isShowing;
  final VoidCallback onWatch;
  final VoidCallback onRetry;

  const _RewardedContent({
    required this.state,
    required this.isShowing,
    required this.onWatch,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (isShowing ||
        state == _AdLoadState.loading ||
        state == _AdLoadState.preparing) {
      return const SizedBox(
        height: 48,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    if (state == _AdLoadState.ready) {
      return GlassButton(
        icon: Icons.play_circle_outline_rounded,
        label: 'Watch optional video',
        onPressed: onWatch,
      );
    }
    return _UnavailableAdContent(
      message: 'No video is available right now.',
      onRetry: onRetry,
    );
  }
}

class _NativeContent extends StatelessWidget {
  final _AdLoadState state;
  final NativeAd? nativeAd;
  final VoidCallback onRetry;

  const _NativeContent({
    required this.state,
    required this.nativeAd,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      _AdLoadState.preparing || _AdLoadState.loading => const SizedBox(
        height: 160,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      _AdLoadState.ready when nativeAd != null => ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 320,
          minHeight: 320,
          maxWidth: 400,
          maxHeight: 400,
        ),
        child: AdWidget(ad: nativeAd!),
      ),
      _ => _UnavailableAdContent(
        message: 'No sponsored card is available right now.',
        onRetry: onRetry,
      ),
    };
  }
}

class _UnavailableAdContent extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _UnavailableAdContent({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.info_outline_rounded, color: AppColors.primarySoft),
        const SizedBox(height: 8),
        Text(message, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 14),
        GlassButton(
          variant: GlassButtonVariant.glass,
          icon: Icons.refresh_rounded,
          label: 'Try again',
          onPressed: onRetry,
        ),
      ],
    );
  }
}
