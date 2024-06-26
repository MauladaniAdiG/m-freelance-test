import 'package:app/network/http_base.dart';

class UserListResponse extends ResponseModelList {
  List<UserResponse> userList;
  UserListResponse({this.userList = const []});

  @override
  ApiModelResponse fromList(List json) {
    userList = json.map((e) => UserResponse.fromJson(e)).toList();
    return this;
  }
}

class UserResponse extends ResponseModelMap {
  int id;
  String email;
  String firstName;
  String lastName;
  UserResponse({
    this.id = -1,
    this.email = '',
    this.firstName = '',
    this.lastName = '',
  });

  @override
  ApiModelResponse fromJson(Map<String, dynamic> json) => UserResponse.fromJson(json);

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'] ?? -1,
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
    );
  }
}
