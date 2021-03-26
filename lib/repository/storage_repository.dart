import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageRepository {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload file to images folder

  Future<String> uploadImage(File file) async {
    final String fileName = Uuid().v4() + ".jpg";
    var response = await _storage.ref("images/" + fileName).putFile(file);
    return await response.ref.getDownloadURL();
  }
}
