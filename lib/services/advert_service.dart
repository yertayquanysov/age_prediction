import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../config.dart';

class AdvertService {
  InterstitialAd? _interstitialAd;

  void loadInterstitialAd() async{
    InterstitialAd.load(
      adUnitId: interstitialAd,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          this._interstitialAd = ad;

          print("Show ads");

        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  void showAd() {

    loadInterstitialAd();

    Timer(Duration(seconds: 2), (){
      _interstitialAd?.show();
    });
  }
}
