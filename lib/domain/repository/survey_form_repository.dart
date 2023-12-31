import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:polaris_assignment/core/constants/constants.dart';
import 'package:polaris_assignment/core/isolate/background_task.dart';
import 'package:polaris_assignment/core/utils/globals.dart';
import 'package:polaris_assignment/data/datasources/save_data_local_source.dart';
import 'package:polaris_assignment/data/datasources/survey_form_source.dart';
import 'package:polaris_assignment/data/models/form_data/form_data.dart';
import 'package:polaris_assignment/data/models/survey_form_model.dart';

class SurveyFormRepository {
  Future<SurveyForm> getSurveyFormData() async {
    return await SurveyFormService().fetchSurveyForm();
  }

  Future<void> saveData(FormData currentFormData) async {
    await SaveDataLocalSource().saveData(currentFormData);
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
