import 'dart:io';

class ImagePickerResponse {
  File? localFile;
  String? thumbnail;
  String? filename;

  ImagePickerResponse({
    this.localFile,
    this.thumbnail,
    this.filename,
  });
}
