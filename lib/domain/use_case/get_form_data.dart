import 'package:polaris_assignment/data/models/survey_form_model.dart';
import 'package:polaris_assignment/domain/repository/survey_form_repository.dart';

class GetFormData {
  final SurveyFormRepository _surveyFormRepository = SurveyFormRepository();
  Future<SurveyForm> onExecute() async {
    return await _surveyFormRepository.getSurveyFormData();
  }
}
