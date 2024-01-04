import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';
import 'package:polaris_assignment/core/constants/constants.dart';
import 'package:polaris_assignment/core/isolate/background_task.dart';
import 'package:polaris_assignment/core/utils/globals.dart';
import 'package:polaris_assignment/data/datasources/survey_form_source.dart';
import 'package:polaris_assignment/data/models/form_data/form_data.dart';
import 'package:polaris_assignment/data/models/survey_form_model.dart';

class SurveyFormRepository {
  Future<SurveyForm> getSurveyFormData() async {
    return await SurveyFormService().fetchSurveyForm();
  }

  Future<void> saveData(FormData currentFormData) async {
    if (!Hive.isBoxOpen("survey_form_database")) {
      await Hive.openBox("survey_form_database");
    }
    var surveyFormDb = Hive.box("survey_form_database");
    await surveyFormDb.add(currentFormData);
  }

  Future<bool> checkConnectivity() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    return (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi);
  }

  void syncData() {
    if (!Globals.dbSyncServiceInProgress) {
      Globals.dbSyncServiceInProgress = true;
      BackgroundTask.doWork(Constants.DATABASE_SYNC_SERVICE);
    }
  }
}
