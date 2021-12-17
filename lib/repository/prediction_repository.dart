import 'dart:convert';

import 'package:age_gender_prediction/models/response.dart';
import 'package:http/http.dart' as http;

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
}
