import 'package:app/network/http_base.dart';
import 'package:app/network/response_map.dart';
import 'package:http/http.dart';
// ignore: depend_on_referenced_packages
import 'package:logger/logger.dart';

class CustomHttpSession {
  final Client _client;
  const CustomHttpSession(this._client);

  Future<ApiDataResponse> request({
    required HttpService service,
    ApiModelResponse Function(Map<String, dynamic> json)? fromJson,
    ApiModelResponse Function(List json)? fromList,
    bool isMultipartFile = false,
  }) async {
    try {
      BaseRequest httpRequest = HttpRequest(service);
      if (isMultipartFile) {
        httpRequest = HttpRequestMultipart(service);
      }
      final response = await _client.send(httpRequest);
      final data = await response.stream.bytesToString();
      final logger = Logger();
      Map<String, dynamic> parameter = {};
      if (httpRequest is HttpRequestMultipart) {
        parameter = httpRequest.service.parameter ?? {};
      } else if (httpRequest is HttpRequest) {
        parameter = httpRequest.service.parameter ?? {};
      }
      logger.d('''
Request service -> ${service.runtimeType}
api url -> ${service.method.name} ${service.path}
body -> $parameter
response -> $data
          ''');

      if (response.statusCode < 300) {
        if (fromJson != null) {
          return ApiDataResponse.fromJson(
            data: data,
            statusCode: response.statusCode,
            fromJsonModel: fromJson,
          );
        }
        if (fromList != null) {
          return ApiDataResponse.fromList(
            data: data,
            statusCode: response.statusCode,
            fromListModel: fromList,
          );
        }
        return ApiDataResponse.fromJson(
          data: data,
          statusCode: response.statusCode,
        );
      }
      return ApiDataResponse.error();
    } catch (_) {
      return ApiDataResponse.error();
    }
  }
}
