import 'dart:io';

import 'package:age_gender_prediction/repository/prediction_repository.dart';
import 'package:age_gender_prediction/repository/storage_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class PredictionState {}

class PredictionProgress extends PredictionState {}

class PredictionView extends PredictionState {
  final String result;
  final String selectedImage;

  PredictionView({this.result = "", this.selectedImage = ""});
}

class ShowAds extends PredictionState {}

class PredictionException extends PredictionState {
  final String message;

  PredictionException(this.message);
}

class PredictionCubit extends Cubit<PredictionState> {
  final StorageRepository _storageRepository = StorageRepository();
  final PredictionRepository _predictionRepository = PredictionRepository();

  PredictionCubit() : super(PredictionView());

  void predict(File image) async {
    try {
      emit(PredictionProgress());
      final uploadedImageURL = await _storageRepository.uploadImage(image);

      final predictionResult =
          await _predictionRepository.scan(uploadedImageURL);

      emit(PredictionView(
        result: predictionResult.age,
        selectedImage: uploadedImageURL,
      ));

    } catch (e) {
      emit(PredictionException(e.toString()));
    }
  }
}
