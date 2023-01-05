import 'package:age_gender_prediction/bloc/prediction_cubit.dart';
import 'package:age_gender_prediction/components/base_progress_bar.dart';
import 'package:age_gender_prediction/config.dart';
import 'package:age_gender_prediction/repository/file_repository.dart';
import 'package:age_gender_prediction/services/advert_service.dart';
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 5,
          shadowColor: Colors.black12,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
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
  final _fileRepository = FileRepositoryImpl();
  final _predictionCubit = PredictionCubit();
  final _advertService = AdvertService();

  @override
  void initState() {
    super.initState();

    _advertService.loadInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Age Prediction"),
      ),
      body: BlocConsumer(
        bloc: _predictionCubit,
        listener: (BuildContext context, state) {
          if (state is PredictionView) {
            _advertService.showAd();
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
