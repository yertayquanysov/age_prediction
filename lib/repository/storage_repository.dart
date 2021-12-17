import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageRepository {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage(File file) async {
    final String fileName =
        DateTime.now().microsecondsSinceEpoch.toString() + ".jpg";
    var response = await _storage.ref("images/" + fileName).putFile(file);
    return await response.ref.getDownloadURL();
  }
}
