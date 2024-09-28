import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Helper {
  static final DateFormat _dateformatter = DateFormat("dd-MM-yyyy");
  static final Random random = Random();

  // 256 KB
  static const int imageThumbnailThreshold = 262144;

  static const List<Color> cardColors = [
    Colors.red,
    Colors.teal,
    Colors.pink,
    Colors.green,
    Colors.purple,
    Colors.blue,
    Colors.indigo,
  ];

  static Color getRandomColor() => cardColors[random.nextInt(cardColors.length)];

  static String getRandomImageName() => const Uuid().v4();

  static String getString(Map<String, dynamic> map, String key, {String defaultValue = ''}) => map[key] ?? defaultValue;

  static int? getInt(Map<String, dynamic> map, String key) => map[key];

  static bool getBool(Map<String, dynamic> map, String key, {bool defaultValue = false}) => map[key] ?? defaultValue;

  static Uint8List decodeImage(String base64String) => base64.decode(base64String);

  static String encodeImage(Uint8List bytes) => base64.encode(bytes);

  static DateTime getDate(int? microseconds) =>
      microseconds == null ? DateTime(1970, 1, 1) : DateTime.fromMicrosecondsSinceEpoch(microseconds);

  static bool isExpired(int microseconds) => getDate(microseconds).isBefore(DateTime.now());

  static String? getFormattedDate({int? microseconds, DateTime? datetime}) {
    if (microseconds != null) {
      return _dateformatter.format(getDate(microseconds));
    }
    if (datetime != null) {
      return _dateformatter.format(datetime);
    }
    return null;
  }

  static DateTime? parseDate(String formattedDate) {
    if (formattedDate.isEmpty) {
      return null;
    }
    if (formattedDate.compareTo('NA') == 0) {
      return null;
    }
    return _dateformatter.parse(formattedDate);
  }

  static Future<Uint8List> generateThumbnail(
    File imageFile,
    int width,
    int height,
  ) async {
    final Uint8List imageBytes = await imageFile.readAsBytes();

    if (imageBytes.length > imageThumbnailThreshold) {
      final ui.Codec codec = await ui.instantiateImageCodec(imageBytes);
      final ui.FrameInfo info = await codec.getNextFrame();
      final double ratio = info.image.width / info.image.height;
      debugPrint("Original Image Ratio: ${ratio.toString()}");

      Uint8List? compressedBytes = await FlutterImageCompress.compressWithFile(
        imageFile.path,
        minWidth: width,
        minHeight: height,
      );

      if (compressedBytes != null) {
        return compressedBytes;
      }
    }
    return imageBytes;
  }
}
