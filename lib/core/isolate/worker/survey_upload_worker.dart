import 'package:polaris_assignment/view_model/service/upload_survey_form_service.dart';

class SurveyUploadWorker {
  /// Starts to [doWork] in the background
  Future<void> doWork(Map<dynamic, dynamic>? formData) async {
    if (formData != null) {
      await UploadSurveyFormService().postSurveyFormData(formData);
    }
  }
}
