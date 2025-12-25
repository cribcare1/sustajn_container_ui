import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceUtils {
  /// ================= SAVE =================

  static Future<void> saveDataInSF(String key, dynamic value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is List<String>) {
      await prefs.setStringList(key, value);
    }
  }

  static Future<void> saveBoolDataInSF(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  /// ================= GET =================

  static Future<String?> getStringValuesSF(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<bool?> getBoolValuesSF(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  static Future<int?> getIntValuesSF(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  static Future<double?> getDoubleValuesSF(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key);
  }

  /// ================= JSON HELPERS =================

  /// Save Map<String, dynamic> as JSON
  static Future<void> saveMapInSF(
      String key, Map<String, dynamic> value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(value));
  }

  /// Get Map<String, dynamic> from JSON
  static Future<Map<String, dynamic>?> getMapFromSF(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final String? value = prefs.getString(key);

    if (value == null || value.isEmpty) return null;

    return jsonDecode(value) as Map<String, dynamic>;
  }

  /// ================= REMOVE =================

  static Future<void> removeValueFromSF(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
