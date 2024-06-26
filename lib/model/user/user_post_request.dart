import 'package:app/config/app_config.dart';
import 'package:app/network/http_base.dart';
import 'package:app/network/http_map.dart';

class UserPostRequest extends ServiceRequest {
  final String name;
  final String job;
  UserPostRequest({
    required this.name,
    required this.job,
  });
  @override
  HttpMethod get method => HttpMethod.POST;

  @override
  String get path => '${AppConfig.baseUrl}/users';

  @override
  Map<String, dynamic> toJson() => {'name': name, 'job': job};
}
