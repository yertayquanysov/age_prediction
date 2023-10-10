import 'package:age_gender_prediction/bloc/prediction_bloc.dart';
import 'package:age_gender_prediction/components/base_progress_bar.dart';
import 'package:age_gender_prediction/repository/file_repository.dart';
import 'package:age_gender_prediction/repository/prediction_repository.dart';
import 'package:age_gender_prediction/repository/storage_repository.dart';
import 'package:age_gender_prediction/services/advert_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'bloc/prediction_state.dart';
import 'components/preview_image.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await MobileAds.instance.initialize();

  final fileRepository = FileRepositoryImpl();
  final predictionRepository = PredictionRepository();
  final storageRepository = StorageRepository();
  final predictionBloc =
      PredictionBloc(predictionRepository, storageRepository, fileRepository);

  final advertService = AdvertService();
  advertService.loadInterstitialAd();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => predictionBloc),
      ],
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.ubuntuTextTheme(Theme.of(context).textTheme),
        colorScheme: ColorScheme.light(
          primary: Colors.redAccent,
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Age Prediction"),
      ),
      body: BlocBuilder(
        bloc: context.read<PredictionBloc>(),
        builder: (BuildContext context, state) {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  color: Colors.black12,
                ),
                const SizedBox(height: 20),
                MaterialButton(
                  child: const Text("Select photo"),
                  onPressed: () => context.read<PredictionBloc>().predict(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
