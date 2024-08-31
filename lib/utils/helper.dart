class Helper {
  static String getString(Map<String, dynamic> map, String key, {String defaultValue = ""}) => map[key] ?? defaultValue;

  static int? getInt(Map<String, dynamic> map, String key, {int? defaultValue}) => map[key] ?? defaultValue;

  static bool getBool(Map<String, dynamic> map, String key, {bool defaultValue = false}) => map[key] ?? defaultValue;

  static bool isExpired(int microseconds) {
    DateTime now = DateTime.now();
    DateTime expiry = DateTime.fromMicrosecondsSinceEpoch(microseconds);
    return expiry.isBefore(now);
  }
}
