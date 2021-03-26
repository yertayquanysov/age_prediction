import 'dart:io';

import 'package:age_gender_prediction/components/base_progress_bar.dart';
import 'package:age_gender_prediction/components/scan_result.dart';
import 'package:age_gender_prediction/repository/prediction_repository.dart';
import 'package:age_gender_prediction/repository/storage_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:superellipse_shape/superellipse_shape.dart';

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
        primaryColor: Colors.redAccent,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File _image;
  final picker = ImagePicker();
  String ageRange;

  bool _isLoading = false;

  final StorageRepository _storageRepository = StorageRepository();
  final PredictionRepository _predictionRepository = PredictionRepository();

  void getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _isLoading = true;
        _image = File(pickedFile.path);
      });

      _storageRepository.uploadImage(_image).then((value) {
        _predictionRepository.scan(value).then((value) {
          setState(() {
            ageRange = value.age;
            _isLoading = false;
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Age Prediction"),
      ),
      body: _isLoading
          ? BaseProgressBar()
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Builder(
                    builder: (_) {
                      if (_image != null) {
                        return Container(
                          width: 200,
                          height: 200,
                          decoration: ShapeDecoration(
                            image: DecorationImage(
                              image: AssetImage(_image.path),
                            ),
                            shape: SuperellipseShape(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        );
                      }

                      return Container(
                        width: 200,
                        height: 200,
                        color: Colors.black12,
                      );
                    },
                  ),
                  RaisedButton(
                    onPressed: () => getImage(),
                    shape: SuperellipseShape(
                        borderRadius: BorderRadius.circular(18)),
                    color: Colors.redAccent,
                    textColor: Colors.white,
                    child: const Text("Select photo"),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ScanResult(age: ageRange),
                ],
              ),
            ),
    );
  }
}
