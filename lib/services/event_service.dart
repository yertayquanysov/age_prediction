import 'package:firebase_analytics/firebase_analytics.dart';

abstract class EventService {
  void interstitialAdClicked();

  void interstitialAdShowed();

  void showedPredictionResult();

  void selectPhotoClicked();
}

class EventServiceImpl implements EventService {
  final _analytic = FirebaseAnalytics.instance;

  @override
  void interstitialAdClicked() {
    _analytic.logEvent(name: "interstitialAdClicked");
  }

  @override
  void interstitialAdShowed() {
    _analytic.logEvent(name: "interstitialAdShowed");
  }

  @override
  void selectPhotoClicked() {
    _analytic.logEvent(name: "selectPhotoClicked");
  }

  @override
  void showedPredictionResult() {
    _analytic.logEvent(name: "showedPredictionResult");
  }
}
