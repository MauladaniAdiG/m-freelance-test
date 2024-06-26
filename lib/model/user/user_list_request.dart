import 'package:app/config/app_config.dart';
import 'package:app/network/http_base.dart';
import 'package:app/network/http_map.dart';

class UserListRequest extends ServiceRequest {
  final int page;
  final int limit;
  UserListRequest({
    this.page = 1,
    this.limit = 20,
  });

  @override
  HttpMethod get method => HttpMethod.GET;

  @override
  String get path => '${AppConfig.baseUrl}/users';

  @override
  Map<String, dynamic> toJson() {
    return {
      'page': '$page',
      'per_page': '$limit',
    };
  }
}
