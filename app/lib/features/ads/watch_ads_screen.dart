import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../core/ads_service.dart';
import '../../core/haptics.dart';
import '../../core/theme.dart';
import '../../ui/aurora_scaffold.dart';
import '../../ui/glass_button.dart';
import '../../ui/glass_panel.dart';

enum _AdPageState { preparing, loading, ready, unavailable }

/// The app's sole advertising surface. It is only created after the user
/// explicitly opens this route from Settings.
class WatchAdsScreen extends StatefulWidget {
  const WatchAdsScreen({super.key});

  @override
  State<WatchAdsScreen> createState() => _WatchAdsScreenState();
}

class _WatchAdsScreenState extends State<WatchAdsScreen> {
  BannerAd? _banner;
  _AdPageState _state = _AdPageState.preparing;
  bool _privacyOptionsRequired = false;

  @override
  void initState() {
    super.initState();
    _prepareAndLoad();
  }

  @override
  void dispose() {
    _banner?.dispose();
    super.dispose();
  }

  Future<void> _prepareAndLoad() async {
    _banner?.dispose();
    _banner = null;
    if (mounted) setState(() => _state = _AdPageState.preparing);

    final readiness = await AdsService.prepareBannerAds();
    if (!mounted) return;

    setState(() {
      _privacyOptionsRequired = readiness.privacyOptionsRequired;
      _state = readiness.canRequestAds
          ? _AdPageState.loading
          : _AdPageState.unavailable;
    });

    if (readiness.canRequestAds) _loadBanner();
  }

  void _loadBanner() {
    final banner = BannerAd(
      size: AdSize.banner,
      adUnitId: AdConfig.bannerUnitId,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted || !identical(_banner, ad)) {
            ad.dispose();
            return;
          }
          setState(() => _state = _AdPageState.ready);
        },
        onAdFailedToLoad: (ad, _) {
          ad.dispose();
          if (mounted && identical(_banner, ad)) {
            setState(() {
              _banner = null;
              _state = _AdPageState.unavailable;
            });
          }
        },
      ),
    );
    _banner = banner;
    banner.load();
  }

  Future<void> _showPrivacyOptions() async {
    Haptics.light();
    try {
      await AdsService.showPrivacyOptions();
    } catch (_) {
      // The ad page remains optional if the platform privacy form is unavailable.
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
                  'Ads are completely optional and only appear on this page. '
                  'Your study screens stay ad-free.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GlassPanel(
            radius: 24,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Advertisement',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(height: 14),
                _AdContent(
                  state: _state,
                  banner: _banner,
                  onRetry: _prepareAndLoad,
                ),
              ],
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

class _AdContent extends StatelessWidget {
  final _AdPageState state;
  final BannerAd? banner;
  final VoidCallback onRetry;

  const _AdContent({
    required this.state,
    required this.banner,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      _AdPageState.preparing || _AdPageState.loading => const SizedBox(
        height: 50,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      _AdPageState.ready when banner != null => SizedBox(
        width: AdSize.banner.width.toDouble(),
        height: AdSize.banner.height.toDouble(),
        child: AdWidget(ad: banner!),
      ),
      _ => Column(
        children: [
          const Icon(Icons.info_outline_rounded, color: AppColors.primarySoft),
          const SizedBox(height: 8),
          Text(
            'No ad is available right now.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 10),
          GlassButton(
            variant: GlassButtonVariant.glass,
            icon: Icons.refresh_rounded,
            label: 'Try again',
            onPressed: onRetry,
          ),
        ],
      ),
    };
  }
}
