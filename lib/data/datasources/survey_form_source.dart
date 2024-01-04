import 'package:polaris_assignment/core/database/shared_preference/shared_preference_constant.dart';
import 'package:polaris_assignment/core/database/shared_preference/shared_preference_helper.dart';
import 'package:polaris_assignment/core/utils/api/api_call_helper.dart';
import 'package:polaris_assignment/data/models/survey_form_model.dart';

class SurveyFormService {
  final String baseUrl = 'https://chatbot-api.grampower.com/flutter-assignment';
  final _apiCallHelper = ApiCallHelper();

  Future<dynamic> fetchSurveyForm() async {
    final response;
    if (PreferenceHelper.getJson(
            SharedPreferenceConstant.SURVEY_FORM_FIELDS, "") ==
        "") {
      response = await _apiCallHelper.get(baseUrl);
      PreferenceHelper.setJson(
          SharedPreferenceConstant.SURVEY_FORM_FIELDS, response);
    } else {
      response = PreferenceHelper.getJson(
          SharedPreferenceConstant.SURVEY_FORM_FIELDS, "");
    }

    if (response.isNotEmpty) {
      return SurveyForm.fromJson(response);
    } else {
      throw Exception('Failed to fetch data');
    }
  }
}
