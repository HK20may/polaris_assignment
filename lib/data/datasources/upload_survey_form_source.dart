import 'package:flutter/material.dart';
import 'package:polaris_assignment/core/utils/api/api_call_helper.dart';

class UploadSurveyFormService {
  final String baseUrl =
      'https://chatbot-api.grampower.com/flutter-assignment/push';
  final _apiCallHelper = ApiCallHelper();

  Future<dynamic> postSurveyFormData(Map<dynamic, dynamic> requestBody) async {
    final response = await _apiCallHelper.post(baseUrl, {
      "data": [requestBody]
    });

    if (response.isNotEmpty) {
      debugPrint('POST request successful');
      debugPrint('Response: $response');
    } else {
      throw Exception('Failed to fetch data');
    }
  }
}
