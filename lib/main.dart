import 'dart:io';

import 'package:age_gender_prediction/repository/prediction_repository.dart';
import 'package:age_gender_prediction/repository/storage_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  final StorageRepository _storageRepository = StorageRepository();
  final PredictionRepository _predictionRepository = PredictionRepository();

  void getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      _storageRepository.uploadImage(_image).then((value) {
        _predictionRepository.scan(value).then((value) {
          setState(() {
            ageRange = value.age;
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Age Gender Prediction"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Builder(builder: (_) {
              if (_image != null) {
                return Container(
                  width: 200,
                  height: 200,
                  child: Image.file(_image),
                );
              }

              return Container(
                width: 200,
                height: 200,
                color: Colors.black12,
              );
            }),
            Visibility(
              visible: ageRange != null,
              child: Text("Age range: " + ageRange.toString() ?? ""),
            ),
            FlatButton(
              onPressed: () => getImage(),
              child: const Text("Select photo"),
            ),
          ],
        ),
      ),
    );
  }
}
