import 'package:age_gender_prediction/bloc/prediction_cubit.dart';
import 'package:age_gender_prediction/components/base_progress_bar.dart';
import 'package:age_gender_prediction/config.dart';
import 'package:age_gender_prediction/repository/ads_repository.dart';
import 'package:age_gender_prediction/repository/file_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:superellipse_shape/superellipse_shape.dart';

import 'components/preview_image.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MobileAds.instance.initialize();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
        ),
        textTheme: GoogleFonts.ubuntuTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PredictionCubit _predictionCubit;
  final _fileRepository = FileRepositoryImpl();
  InterstitialAd? _interstitialAd;

  final BannerAd myBanner = BannerAd(
    adUnitId: admobBannerId,
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(
      onAdLoaded: (_) => print("Add loaded"),
      onAdFailedToLoad: (_, __) => print("Failed to load"),
    ),
  );

  @override
  void initState() {
    super.initState();

    InterstitialAd.load(
      adUnitId: interstitialAd,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          this._interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
        },
      ),
    );

    _predictionCubit = PredictionCubit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Age Prediction",
          style: GoogleFonts.ubuntu(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocConsumer(
        bloc: _predictionCubit,
        listener: (BuildContext context, state) {
          if (state is PredictionView) {
            _interstitialAd?.show();
          }
        },
        builder: (BuildContext context, state) {
          if (state is PredictionException) {
            return Text(state.message);
          }

          if (state is PredictionView) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Builder(
                    builder: (_) {
                      if (state.selectedImage.isNotEmpty) {
                        return PreviewImage(state.selectedImage);
                      }

                      return Container(
                        width: 200,
                        height: 200,
                        decoration: ShapeDecoration(
                          color: Colors.black12,
                          shape: SuperellipseShape(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  MaterialButton(
                    child: const Text("Select photo"),
                    color: Colors.redAccent,
                    elevation: 3,
                    textColor: Colors.white,
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 15,
                      bottom: 15,
                    ),
                    shape: SuperellipseShape(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    onPressed: () => _fileRepository
                        .getImage()
                        .then((value) => _predictionCubit.predict(value)),
                  ),
                  const SizedBox(height: 30),
                  Visibility(
                    visible: state.result.isNotEmpty,
                    child: Text(
                      "Age: " + state.result,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return BaseProgressBar();
        },
      ),
    );
  }
}
