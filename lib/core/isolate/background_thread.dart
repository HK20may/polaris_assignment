import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:hive/hive.dart';
import 'package:polaris_assignment/core/database/database_sync_service.dart';
import 'package:polaris_assignment/core/helpers/constants.dart';
import 'package:polaris_assignment/core/utils/globals.dart';
import 'package:polaris_assignment/core/utils/shared_preference/shared_preference_helper.dart';

Future<void> backgroundThread(String task) async {
  switch (task) {
    case Constants.DATABASE_SYNC_SERVICE:
      await Hive.box('survey_form_database').close();
      final ReceivePort port = ReceivePort();
      Map<String, dynamic> args = {
        "path": Globals.databasePath ?? "",
        "port": port.sendPort
      };
      port.listen((message) async {
        if (message == true) {
          await Hive.openBox('survey_form_database');
        }
      });
      await FlutterIsolate.spawn(databaseSyncService, args);
      break;
  }
  return;
}

@pragma('vm:entry-point')
databaseSyncService(Map<String, dynamic> args) async {
  await PreferenceHelper.getInstance();

  await DatabaseSyncService().doWork(args["path"], args["port"]).then((value) {
    debugPrint("Database Sync Service Done");
  });
}
