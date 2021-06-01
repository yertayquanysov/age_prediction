import 'package:age_gender_prediction/bloc/prediction_cubit.dart';
import 'package:age_gender_prediction/components/base_progress_bar.dart';
import 'package:age_gender_prediction/repository/ads_repository.dart';
import 'package:age_gender_prediction/repository/file_repository.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:superellipse_shape/superellipse_shape.dart';

import 'components/preview_image.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      theme: ThemeData(
        primaryColor: Colors.white,
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
  final _adsRepository = AdsRepositoryImpl();

  @override
  void initState() {
    super.initState();

    FacebookAudienceNetwork.init();

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
          if (state is ShowAds) {
            _adsRepository.showInterstitialAds(delay: 5);
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
                        return PreviewImage(
                          state.selectedImage,
                        );
                      } else {
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
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  MaterialButton(
                    child: const Text("Select photo"),
                    color: Colors.redAccent,
                    elevation: 3,
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
