import 'dart:convert';

import 'package:age_gender_prediction/models/response.dart';
import 'package:http/http.dart' as http;
import 'package:tflite/tflite.dart';

import '../config.dart';

class PredictionRepository {
  Future<Response> scan(String imageUrl) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'x-rapidapi-key': "df4d41b324msh0c443f959f5b566p1e5336jsn55c8f18e2b64",
        'x-rapidapi-host': "luxand-cloud-face-recognition.p.rapidapi.com"
      },
      body: {
        "photo": imageUrl,
      },
    );

    return Response.fromJson(jsonDecode(response.body)[0]);
  }

  Future<int> getAge(String path) async {

    final loaded = await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/labels.txt",
      numThreads: 1,
      isAsset: true,
    );

    print(loaded);

    var recognitions = await Tflite.runModelOnImage(
      path: path,
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 2,
      threshold: 0.2,
      asynch: true,
    );

    print(recognitions);

    return 0;
  }
}
