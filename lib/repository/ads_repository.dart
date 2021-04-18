import 'package:facebook_audience_network/ad/ad_interstitial.dart';

abstract class AdsRepository {
  void showInterstitialAds({int delay = 3});
}

class AdsRepositoryImpl implements AdsRepository {
  @override
  void showInterstitialAds({int delay = 3}) {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: "223214319254272_223214732587564",
      listener: (result, value) {
        if (result == InterstitialAdResult.LOADED) {
          FacebookInterstitialAd.showInterstitialAd(delay: delay);
        }
      },
    );
  }
}
