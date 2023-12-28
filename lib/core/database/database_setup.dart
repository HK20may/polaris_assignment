import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DatabaseSetup {
  static Future<void> setUpHive(String? path) async {
    try {
      Hive.init(path);
      if (!Hive.isBoxOpen("survey_form_database")) {
        await Hive.openBox("survey_form_database");
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }
}
