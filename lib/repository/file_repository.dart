import 'dart:io';

import 'package:image_picker/image_picker.dart';

abstract class FileRepository {
  Future<File> getImage();
}

class FileRepositoryImpl implements FileRepository {
  final picker = ImagePicker();

  @override
  Future<File> getImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 40,
    );

    return File(pickedFile!.path);
  }
}
