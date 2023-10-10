abstract class PredictionState {}

class Progress extends PredictionState {}

class PredictionView extends PredictionState {
  PredictionView({
    required this.result,
    required this.selectedImage,
  });

  final String result;
  final String selectedImage;
}

class ExceptionMessage extends PredictionState {
  ExceptionMessage(this.message);

  final String message;
}
