import 'dart:io';

class ImagePickerResponse {
  File? localFile;
  String? thumbnail;
  String? filepath;

  ImagePickerResponse({
    this.localFile,
    this.thumbnail,
    this.filepath,
  });
}
