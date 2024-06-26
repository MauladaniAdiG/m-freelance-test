import 'package:app/network/http_base.dart';

abstract class RequestJsonBody extends HttpService {
  Map<String, dynamic> toJson();
}

abstract class ServiceRequest extends RequestJsonBody {
  @override
  Map<String, dynamic>? get parameter => toJson();
}
