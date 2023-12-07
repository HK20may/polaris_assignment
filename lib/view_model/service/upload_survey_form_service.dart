import 'package:flutter/material.dart';
import 'package:polaris_assignment/core/utils/api/api_call_helper.dart';
import 'package:polaris_assignment/core/utils/shared_preference/shared_preference_constant.dart';
import 'package:polaris_assignment/core/utils/shared_preference/shared_preference_helper.dart';
import 'package:polaris_assignment/core/utils/toast.dart';

class UploadSurveyFormService {
  final String baseUrl =
      'https://chatbot-api.grampower.com/flutter-assignment/push';
  final _apiCallHelper = ApiCallHelper();

  Future<dynamic> postSurveyFormData(Map<String, dynamic> requestBody) async {
    final response = await _apiCallHelper.post(baseUrl, {
      "data": [requestBody]
    });

    if (response.isNotEmpty) {
      PreferenceHelper.setBool(
          SharedPreferenceConstant.CAPTURE_IMAGE_DATA, true);
      Toast.info("Form Submitted successfully");
      debugPrint('POST request successful');
      debugPrint('Response: $response');
    } else {
      throw Exception('Failed to fetch data');
    }
  }
}
