import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHelper {
  static PreferenceHelper? _instance;
  static late SharedPreferences _preferences;

  PreferenceHelper._();

  static Future<PreferenceHelper?> getInstance() async {
    if (_instance == null) {
      final prefInit = PreferenceHelper._();
      _preferences = await SharedPreferences.getInstance();
      _instance = prefInit;
    }
    return _instance;
  }

  static Future<bool> setBool(String key, bool value) async {
    return _preferences.setBool(key, value);
  }

  static bool getBool(String key, bool defValue) {
    return _preferences.getBool(key) ?? defValue;
  }

  static Future<bool> setString(String key, String value) async {
    return _preferences.setString(key, value);
  }

  static String getString(String key, String defValue) {
    return _preferences.getString(key) ?? defValue;
  }

  static Future<bool> setJson(String key, dynamic value) async {
    return _preferences.setString(key, json.encode(value));
  }

  static dynamic getJson(String key, dynamic defValue) {
    if (_preferences.getString(key) != null) {
      return json.decode(_preferences.getString(key) ?? "") ?? defValue;
    } else {
      return "";
    }
  }

  static Future<bool> setInt(String key, int value) async {
    return _preferences.setInt(key, value);
  }

  static int getInt(String key, int value) {
    return _preferences.getInt(key) ?? value;
  }

  static Future<bool> setDouble(String key, double value) async {
    return _preferences.setDouble(key, value);
  }

  static double getDouble(String key, double value) {
    return _preferences.getDouble(key) ?? value;
  }

  static Future<bool> setStringList(String key, List<String> value) async {
    return _preferences.setStringList(key, value);
  }

  static List<String> getStringList(String key, List<String> value) {
    return _preferences.getStringList(key) ?? value;
  }

  static Future<bool> setMap(String tag, Map<String, dynamic> data) async {
    return _preferences.setString(tag, jsonEncode(data));
  }

  static Map<String, dynamic> getMap(String tag) {
    return jsonDecode(_preferences.getString(tag) ?? '{}');
  }

  static Future<bool> setList(String tag, List<dynamic> data) async {
    return _preferences.setString(tag, jsonEncode(data));
  }

  static List<dynamic> getList(String tag) {
    return jsonDecode(_preferences.getString(tag) ?? '[]');
  }

  static Future clearPref() async {
    return _preferences.clear();
  }

  static Future removeValues(String key) async {
    return _preferences.remove(key);
  }
}
