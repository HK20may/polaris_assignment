import 'package:polaris_assignment/data/models/form_data/form_data.dart';
import 'package:polaris_assignment/data/models/form_data_field/form_data_field.dart';
import 'package:polaris_assignment/domain/repository/survey_form_repository.dart';

class OnClickSubmit {
  final SurveyFormRepository _surveyFormRepository = SurveyFormRepository();
  Future<void> onExecute(String formName, Map<String, FormDataField> formFields,
      List<String> allFieldLabels) async {
    Map<String, FormDataField> orderedFormFields = {
      for (var label in allFieldLabels) label: formFields[label]!
    };
    formFields = orderedFormFields;

    List<FormDataField> submittedFields = formFields.values.toList();

    await _surveyFormRepository.saveData(
        FormData(formName: formName, submittedFields: submittedFields));
    if (await _surveyFormRepository.checkConnectivity()) {
      _surveyFormRepository.syncData();
    }
  }
}
