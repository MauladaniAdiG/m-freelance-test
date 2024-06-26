import 'package:app/model/user/user_list_request.dart';
import 'package:app/model/user/user_list_response.dart';
import 'package:app/model/user/user_post_request.dart';
import 'package:app/network/http_session.dart';
import 'package:app/network/response_map.dart';
import 'package:http/http.dart';

abstract class BaseUserService {
  Future<UserListResponse> requestLoadUserList(UserListRequest request);
  Future<UserResponse> requestAddUser(UserPostRequest request);
}

class UserService implements BaseUserService {
  final Client _client;
  const UserService(this._client);

  @override
  Future<UserListResponse> requestLoadUserList(UserListRequest request) async {
    final session = CustomHttpSession(_client);
    final response = await session.request(
      service: request,
      fromList: UserListResponse().fromList,
    );
    if (response.result is UserListResponse) {
      return response.result as UserListResponse;
    }
    return Future.error(ApiDataResponse.errorMessage);
  }

  @override
  Future<UserResponse> requestAddUser(UserPostRequest request) async {
    final session = CustomHttpSession(_client);
    final response = await session.request(
      service: request,
      fromJson: UserResponse().fromJson,
    );
    if (response.result is UserResponse) {
      return response.result as UserResponse;
    }
    return Future.error(ApiDataResponse.errorMessage);
  }
}
