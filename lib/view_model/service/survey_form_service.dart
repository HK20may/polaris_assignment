import 'package:polaris_assignment/core/utils/api/api_call_helper.dart';
import 'package:polaris_assignment/models/survey_form_model.dart';

class SurveyFormService {
  final String baseUrl = 'https://chatbot-api.grampower.com/flutter-assignment';
  final _apiCallHelper = ApiCallHelper();

  Future<dynamic> fetchSurveyForm() async {
    final response = await _apiCallHelper.get(baseUrl);

    if (response.isNotEmpty) {
      return SurveyForm.fromJson(response);
    } else {
      throw Exception('Failed to fetch data');
    }
  }
}
