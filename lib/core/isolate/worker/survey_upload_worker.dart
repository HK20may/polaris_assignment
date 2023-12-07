import 'package:polaris_assignment/core/utils/shared_preference/shared_preference_constant.dart';
import 'package:polaris_assignment/core/utils/shared_preference/shared_preference_helper.dart';
import 'package:polaris_assignment/view_model/service/upload_survey_form_service.dart';

class SurveyUploadWorker {
  /// Starts to [doWork] in the background
  Future<void> doWork() async {
    if (PreferenceHelper.getJson(
            SharedPreferenceConstant.SURVEY_FORM_DATA, "") !=
        "") {
      Map<String, dynamic> storedData = PreferenceHelper.getJson(
          SharedPreferenceConstant.SURVEY_FORM_DATA, "");
      await UploadSurveyFormService().postSurveyFormData(storedData);
    }
  }
}
