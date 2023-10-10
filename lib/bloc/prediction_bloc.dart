import 'dart:io';

import 'package:age_gender_prediction/bloc/prediction_state.dart';
import 'package:age_gender_prediction/repository/prediction_repository.dart';
import 'package:age_gender_prediction/repository/storage_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/file_repository.dart';

class PredictionBloc extends Cubit<PredictionState> {
  PredictionBloc(
    this._predictionRepository,
    this._storageRepository,
    this._fileRepository,
  ) : super(Progress());

  final StorageRepository _storageRepository;
  final PredictionRepository _predictionRepository;
  final FileRepository _fileRepository;

  void predict() async {
    emit(Progress());

    final selectedImage = await _fileRepository.getImage();
    final imageUrl = await _storageRepository.uploadImage(selectedImage);
    final predictionResult = await _predictionRepository.scan(imageUrl);

    emit(
      PredictionView(
        result: predictionResult.age,
        selectedImage: imageUrl,
      ),
    );
  }
}
