import 'package:unicorn_flutter/Model/Entity/User/user.dart';
import 'package:unicorn_flutter/Model/Entity/User/user_request.dart';

class UserData {
  static final UserData _instance = UserData._internal();
  factory UserData() => _instance;
  UserData._internal();

  User? _user;

  User? get user => _user;

  void setUser(User user) {
    _user = user;
  }

  // UserRequest型に変換
  UserRequest convertUserRequest() {
    return UserRequest.fromJson(_user!.toJson());
  }
}
