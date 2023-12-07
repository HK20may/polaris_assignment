import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:polaris_assignment/core/utils/api/cubit/api_logger_cubit.dart';

class APILoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    dynamic requestBody = options.data ?? options.queryParameters;
    if (requestBody is FormData) {
      requestBody = "${requestBody.fields}\n${requestBody.files}";
    } else {
      requestBody = _prettyJson(requestBody);
    }
    log(
      "${options.method} => ${options.path}",
      error: requestBody,
      name: "⏳ Request",
    );
    log(
      "",
      error: json.encode(options.headers),
      name: "💀 Headers-Request",
    );

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _setLogger("✅", response.requestOptions, response);
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _setLogger("❌", err.requestOptions, err.response);
    return super.onError(err, handler);
  }

  void _setLogger(String type, RequestOptions request, Response? response) {
    final apiLoggerModel = _getApiLoggerModel(request, response);
    final String logHeader =
        "${request.method} =>  $type ${response?.statusCode} : ${request.path}${request.queryParameters}";
    log(
      logHeader,
      name: "$type Response",
      error: apiLoggerModel.responseData,
    );
    apiLoggerModel.stringified = _prettyJson({
      "👉 Info": logHeader,
      if (request.data != null) "👉 Request": request.data,
      "👉 Response": response?.data,
    });
    ApiLoggerCubit().addApiLogger(apiLoggerModel);
  }

  ApiLoggerModel _getApiLoggerModel(
    RequestOptions requestOptions,
    Response? response,
  ) {
    dynamic requestJson = requestOptions.data ?? requestOptions.queryParameters;
    if (requestJson is FormData) {
      requestJson = requestJson.fields.toList().toString();
    }
    return ApiLoggerModel(
      requestMethod: requestOptions.method,
      statusCode: response?.statusCode ?? 0,
      pathURL: requestOptions.path,
      requestData: _prettyJson(requestJson),
      responseData: _prettyJson(response?.data),
      logTime:
          "${DateFormat('dd MMM').format(DateTime.now())} ${DateFormat('hh:mm a').format(DateTime.now())}",
    );
  }

  String _prettyJson(dynamic json, {int indent = 2}) {
    final spaces = ' ' * indent;
    final encoder = JsonEncoder.withIndent(spaces);
    return encoder.convert(json);
  }
}

class ApiLoggerModel {
  String requestMethod;
  int statusCode;
  String pathURL;
  String requestData;
  String responseData;
  String logTime;
  String stringified;

  ApiLoggerModel({
    required this.requestMethod,
    required this.statusCode,
    required this.pathURL,
    required this.requestData,
    required this.responseData,
    required this.logTime,
    this.stringified = "",
  });

  ApiLoggerModel.fromJson(Map<String, dynamic> json)
      : requestMethod = json['request_method'],
        statusCode = json['status_code'],
        pathURL = json['path_url'],
        requestData = json['request_data'],
        responseData = json['response_data'],
        logTime = json['log_time'],
        stringified = json['stringified'];

  Map<String, dynamic> toJson() => {
        'request_method': requestMethod,
        'status_code': statusCode,
        'path_url': pathURL,
        'request_data': requestData,
        'response_data': responseData,
        'log_time': logTime,
        'stringified': stringified,
      };
}
