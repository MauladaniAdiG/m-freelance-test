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
  String id;
  String email;
  String firstName;
  String lastName;
  String name;
  UserResponse({
    this.id = '',
    this.email = '',
    this.firstName = '',
    this.lastName = '',
    this.name = '',
  });

  @override
  ApiModelResponse fromJson(Map<String, dynamic> json) => UserResponse.fromJson(json);

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'].toString(),
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
