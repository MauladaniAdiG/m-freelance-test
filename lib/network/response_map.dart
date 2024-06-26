import 'dart:convert';

import 'package:app/network/api_status_type.dart';
import 'package:app/network/http_base.dart';

class ApiDataResponse {
  int statusCode;
  ApiModelResponse? result;
  ApiStatusType statusType;
  String message;
  ApiDataResponse({
    required this.statusCode,
    required this.result,
    required this.statusType,
    required this.message,
  });

  ApiDataResponse.error({
    this.statusCode = 500,
    this.result,
    this.statusType = ApiStatusType.UNDEFINED,
    this.message = errorMessage,
  });

  static const String errorMessage = 'INTERNAL SERVER ERROR';

  factory ApiDataResponse.fromJson({
    required String data,
    required int statusCode,
    ApiModelResponse Function(Map<String, dynamic> json)? fromJsonModel,
  }) {
    if (data.isEmpty) {
      return ApiDataResponse.error();
    }
    final Map<String, dynamic> map = json.decode(data);
    final statusType = ApiStatusTypeExtension.fromString(map['status']);
    final message = map['message'] ?? '';
    final convertDataBody = fromJsonModel == null ? _defaultModel(map) : fromJsonModel(map['data'] ?? map);
    return ApiDataResponse(
      statusCode: statusCode,
      result: convertDataBody,
      statusType: statusType,
      message: message,
    );
  }

  factory ApiDataResponse.fromList({
    required String data,
    required int statusCode,
    ApiModelResponse Function(List json)? fromListModel,
  }) {
    if (data.isEmpty) {
      return ApiDataResponse.error();
    }
    final Map<String, dynamic> map = json.decode(data);
    final statusType = ApiStatusTypeExtension.fromString(map['status']);
    final message = map['message'] ?? '';
    final convertDataBody = fromListModel == null ? _defaultModel(map) : fromListModel(map['data']);
    return ApiDataResponse(
      statusCode: statusCode,
      result: convertDataBody,
      statusType: statusType,
      message: message,
    );
  }

  static ApiModelWithoutResponse _defaultModel(Map<String, dynamic> json) {
    return ApiModelWithoutResponse(json);
  }
}
