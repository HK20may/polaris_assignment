import 'package:polaris_assignment/data/datasources/upload_survey_form_source.dart';

class SurveyUploadWorker {
  /// Starts to [doWork] ie post data to server in the background
  Future<void> doWork(Map<dynamic, dynamic>? formData) async {
    if (formData != null) {
      await UploadSurveyFormService().postSurveyFormData(formData);
    }
  }
}
