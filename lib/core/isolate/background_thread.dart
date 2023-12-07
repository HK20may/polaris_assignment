import 'package:flutter/foundation.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:polaris_assignment/core/helpers/constants.dart';
import 'package:polaris_assignment/core/isolate/worker/image_upload_worker.dart';
import 'package:polaris_assignment/core/isolate/worker/survey_upload_worker.dart';
import 'package:polaris_assignment/core/utils/shared_preference/shared_preference_helper.dart';

Future<void> backgroundThread(String task) async {
  switch (task) {
    case Constants.IMAGE_UPLOAD_WORKER:
      await FlutterIsolate.spawn(
          imageUploadWorker, Constants.IMAGE_UPLOAD_WORKER);
      break;
    case Constants.SURVEY_UPLOAD_WORKER:
      await FlutterIsolate.spawn(
          surveyUploadWorker, Constants.SURVEY_UPLOAD_WORKER);
      break;
  }
  return;
}

@pragma('vm:entry-point')
imageUploadWorker(String workerName) async {
  if (kDebugMode) {
    debugPrint(" $workerName initialized");
  }
  await PreferenceHelper.getInstance();

  await ImageUploadWorker().doWork().then((value) {
    debugPrint("ImageUploadWorker done");
  });
}

@pragma('vm:entry-point')
surveyUploadWorker(String workerName) async {
  if (kDebugMode) {
    debugPrint("$workerName initialized");
  }
  await PreferenceHelper.getInstance();

  await SurveyUploadWorker()
      .doWork()
      .then((value) => debugPrint("SurveyUploadWorker done"));
}
