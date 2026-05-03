import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceUtils {

  static Future<void> saveDataInSF(
      String key,
      dynamic value,
      ) async {

    final SharedPreferences sharedPrefs =
    await SharedPreferences.getInstance();

    if (value is bool) {
      await sharedPrefs.setBool(key, value);

    } else if (value is String) {
      await sharedPrefs.setString(key, value);

    } else if (value is int) {
      await sharedPrefs.setInt(key, value);

    } else if (value is double) {
      await sharedPrefs.setDouble(key, value);

    } else if (value is List<String>) {
      await sharedPrefs.setStringList(key, value);
    }
  }

  static Future<void> saveBoolDataInSF(
      String key,
      bool value,
      ) async {

    final SharedPreferences sharedPrefs =
    await SharedPreferences.getInstance();

    await sharedPrefs.setBool(key, value);
  }

  static Future<String?> getStringValuesSF(
      String key,
      ) async {

    SharedPreferences prefs =
    await SharedPreferences.getInstance();

    return prefs.getString(key);
  }

  static Future<bool?> getBoolValuesSF(
      String key,
      ) async {

    SharedPreferences prefs =
    await SharedPreferences.getInstance();

    return prefs.getBool(key);
  }

  static Future<int?> getIntValuesSF(
      String key,
      ) async {

    SharedPreferences prefs =
    await SharedPreferences.getInstance();

    return prefs.getInt(key);
  }

  static Future<double?> getDoubleValuesSF(
      String key,
      ) async {

    SharedPreferences prefs =
    await SharedPreferences.getInstance();

    return prefs.getDouble(key);
  }

  static Future<void> removeValueFromSF(
      String key,
      ) async {

    final SharedPreferences sharedPrefs =
    await SharedPreferences.getInstance();

    await sharedPrefs.remove(key);
  }

  static Future<void> deleteValueFromSF() async {

    final SharedPreferences sharedPrefs =
    await SharedPreferences.getInstance();

    await sharedPrefs.clear();
  }

  static Future<void> saveMapInSF(
      String key,
      Map<String, dynamic> value,
      ) async {

    final prefs =
    await SharedPreferences.getInstance();

    await prefs.setString(
      key,
      jsonEncode(value),
    );
  }

  static Future<Map<String, dynamic>?> getMapFromSF(
      String key,
      ) async {

    final prefs =
    await SharedPreferences.getInstance();

    final String? value =
    prefs.getString(key);

    if (value == null || value.isEmpty) {
      return null;
    }

    return jsonDecode(value)
    as Map<String, dynamic>;
  }

  static Future<void> clearAll() async {

    final prefs =
    await SharedPreferences.getInstance();

    await prefs.clear();
  }
}