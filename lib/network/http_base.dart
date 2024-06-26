import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

enum HttpMethod {
  GET,
  POST,
  DELETE,
  UPDATE,
}

extension HttpMethodExtension on HttpMethod {}

abstract class HttpService {
  String get path;
  HttpMethod get method;
  Map<String, dynamic>? get parameter;
  String get queryParameter {
    if (method == HttpMethod.GET && parameter != null) {
      if (parameter?.isEmpty ?? true) return '';
      final queryParam = Uri(queryParameters: parameter).query;
      return '?$queryParam';
    }
    return '';
  }

  List<File> get filesData => [];
  String get fileField => 'image';
}

class HttpRequest extends Request {
  HttpService service;
  HttpRequest(this.service) : super(service.method.name, Uri.parse(constructUrl(service)));

  static String constructUrl(HttpService service) {
    return '${service.path}${service.queryParameter}';
  }

  @override
  String get body {
    if (service.method == HttpMethod.GET) return '';
    return json.encode(service.parameter);
  }

  @override
  Map<String, String> get headers {
    final header = {'Content-type': 'application/json'};
    return header;
  }

  @override
  Uint8List get bodyBytes {
    if (service.method == HttpMethod.GET) return Uint8List(0);
    return Uint8List.fromList(const Utf8Codec().encode(body));
  }
}

class HttpRequestMultipart extends MultipartRequest {
  HttpService service;
  HttpRequestMultipart(this.service) : super(service.method.name, Uri.parse(constructUrl(service)));

  static String constructUrl(HttpService service) {
    return '${service.path}${service.queryParameter}';
  }

  @override
  List<MultipartFile> get files {
    if (service.filesData.isNotEmpty) {
      final data = service.filesData
          .map((e) => MultipartFile.fromBytes(
                service.fileField,
                File(e.path).readAsBytesSync(),
                filename: e.path.split('/').last,
              ))
          .toList();
      return data;
    }
    return [];
  }

  @override
  Map<String, String> get fields {
    if (service.parameter?.isNotEmpty ?? false) {
      final Map<String, String> convertMap = service.parameter?.map((key, value) => MapEntry(key, value.toString())) ?? {};
      return convertMap;
    }
    return {};
  }
}

abstract class ApiModelResponse {}

abstract class ResponseModelMap extends ApiModelResponse {
  ApiModelResponse fromJson(Map<String, dynamic> json);
}

abstract class ResponseModelList extends ApiModelResponse {
  ApiModelResponse fromList(List json);
}

class ApiModelWithoutResponse extends ApiModelResponse {
  final dynamic data;
  ApiModelWithoutResponse(this.data);
}
