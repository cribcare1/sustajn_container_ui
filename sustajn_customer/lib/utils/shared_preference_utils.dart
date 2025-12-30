import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/login_model.dart';
class SharedPreferenceUtils{
  static saveDataInSF(String key, dynamic value) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    if (value is bool) {
      sharedPrefs.setBool(key, value);
    } else if (value is String) {
      sharedPrefs.setString(key, value);
    } else if (value is int) {
      sharedPrefs.setInt(key, value);
    } else if (value is double) {
      sharedPrefs.setDouble(key, value);
    } else if (value is List<String>) {
      sharedPrefs.setStringList(key, value);
    }
  }
  static saveBoolDataInSF(String key, bool value) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setBool(key, value);
  }
  static  getStringValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? stringValue = prefs.containsKey(key)? prefs.getString(key):"";
    return stringValue;
  }
  static Future<bool?> getBoolValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool? boolValue = prefs.containsKey(key)? prefs.getBool(key): false;
    return boolValue;
  }
  static getIntValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    int? intValue = prefs.containsKey(key)? prefs.getInt(key):-1;
    return intValue;
  }
  static getDoubleValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return double
    double? doubleValue = prefs.containsKey(key)? prefs.getDouble(key):-1;
    return doubleValue;
  }
  static removeValueFromSF(String key) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.remove(key);
  }
  static deleteValueFromSF() async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.clear();
  }

  static Future<Map<String, dynamic>?> getMapFromSF(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final String? value = prefs.getString(key);

    if (value == null || value.isEmpty) return null;

    return jsonDecode(value) as Map<String, dynamic>;
  }



}