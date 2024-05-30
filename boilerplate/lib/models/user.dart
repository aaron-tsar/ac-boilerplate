import 'package:boilerplate/services/api_service/decoder.dart';
import 'package:boilerplate/services/api_service/interceptors/auth_interceptor.dart';

class User extends Decoder<User>{
  AuthToken? authToken;
  bool init = false;
  User.getInit({
    this.init = true,
  });

  String? username;

  User({this.username,});

  User.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    init = false;
    authToken = AuthToken.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    return data;
  }

  @override
  User decode(Map<String, dynamic> json) {
    return User.fromJson(json);
  }
}

class SignUpResponse extends Decoder<SignUpResponse> {
  int? id;

  SignUpResponse({this.id});
  SignUpResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  @override
  SignUpResponse decode(Map<String, dynamic> json) {
    return SignUpResponse.fromJson(json);
  }
}