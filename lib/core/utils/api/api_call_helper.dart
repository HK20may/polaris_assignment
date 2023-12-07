import 'dart:io';

import 'package:dio/dio.dart';
import 'package:polaris_assignment/core/utils/api/api_logging_interceptor.dart';
import 'package:polaris_assignment/core/utils/toast.dart';

class ApiCallHelper {
  factory ApiCallHelper() {
    return _singleton;
  }
  ApiCallHelper._() {
    _addInterceptors(_dio);
  }
  static final ApiCallHelper _singleton = ApiCallHelper._();

  static final Dio _dio = Dio();

  Future<Map<String, dynamic>> get(String url) async {
    try {
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        Toast.error("Something went wrong");
        throw Exception('Failed to make GET request: ${response.statusCode}');
      }
    } catch (dioError) {
      if (dioError is DioException) {
        if (dioError.error is SocketException) {
          Toast.error("No Internet Connection");
        } else {
          Toast.error("Something went wrong");
        }
      }
      Toast.error("Something went wrong");
      throw Exception('Failed to make GET request: $dioError');
    }
  }

  Future<dynamic> post(String url, dynamic requestBody) async {
    try {
      final response = await _dio.post(url, data: requestBody);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        Toast.error("Something went wrong");
        throw Exception('Failed to make Post request: ${response.statusCode}');
      }
    }
    // on DioException catch (_) {
    //   rethrow;
    // }
    catch (dioError) {
      if (dioError is DioException) {
        if (dioError.error is SocketException) {
          Toast.error("No Internet Connection");
        } else {
          Toast.error("Something went wrong");
        }
      }
      Toast.error("Something went wrong");
      throw Exception('Failed to make GET request: $dioError');
    }
  }

  void _addInterceptors(Dio dio) {
    dio.interceptors.add(APILoggingInterceptor());
  }
}
