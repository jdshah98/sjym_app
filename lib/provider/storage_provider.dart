import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageProvider {
  StorageProvider._internal();

  static final StorageProvider _instance = StorageProvider._internal();

  factory StorageProvider() => _instance;

  final Reference _advertisementRef = FirebaseStorage.instance.ref('advertisement');
  final Reference _profileRef = FirebaseStorage.instance.ref('profile');

  Future<TaskSnapshot> uploadAdvertisment(String filepath, File file) async {
    UploadTask uploadTask = _advertisementRef.child(filepath).putFile(file);
    return await uploadTask.whenComplete(() => null);
  }

  Future<TaskSnapshot> downloadAdvertisementToLocal(String filepath, File file) async {
    DownloadTask downloadTask = _advertisementRef.child(filepath).writeToFile(file);
    return await downloadTask.whenComplete(() => null);
  }

  Future<String> getDownloadUrl(String imageFilepath) async {
    return _profileRef.child(imageFilepath).getDownloadURL();
  }

  Future<TaskSnapshot> uploadImage(File localFile, String imageFilepath) async {
    UploadTask uploadTask = _profileRef.child(imageFilepath).putFile(localFile);
    return await uploadTask.whenComplete(() => null);
  }
}
