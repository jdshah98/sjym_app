import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageProvider {
  StorageProvider._internal();

  static final StorageProvider _instance = StorageProvider._internal();

  factory StorageProvider() => _instance;

  final Reference _ref = FirebaseStorage.instance.ref("advertisement");

  Future<TaskSnapshot> uploadAdvertisment(String filepath, File file) async {
    UploadTask uploadTask = _ref.child(filepath).putFile(file);
    return await uploadTask.whenComplete(() => null);
  }

  Future<TaskSnapshot> downloadAdvertisementToLocal(String filepath, File file) async {
    DownloadTask downloadTask = _ref.child(filepath).writeToFile(file);
    return await downloadTask.whenComplete(() => null);
  }
}
