import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class Helper {
  static final Random random = Random();

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

  static String getString(Map<String, dynamic> map, String key, {String defaultValue = ''}) => map[key] ?? defaultValue;

  static int? getInt(Map<String, dynamic> map, String key, {int? defaultValue}) => map[key] ?? defaultValue;

  static bool getBool(Map<String, dynamic> map, String key, {bool defaultValue = false}) => map[key] ?? defaultValue;

  static Uint8List decodeImage(String base64String) => base64.decode(base64String);

  static bool isExpired(int microseconds) {
    DateTime now = DateTime.now();
    DateTime expiry = DateTime.fromMicrosecondsSinceEpoch(microseconds);
    return expiry.isBefore(now);
  }
}
