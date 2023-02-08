import 'package:orison/src/models/user.dart';

class SignInResponse {
  int status;
  String token;
  int userId;
  User user;


  SignInResponse({this.status, this.token, this.userId});

  SignInResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    token = json['token'];
    userId = json['userid'];
    user = User(id: userId,token: token);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['token'] = this.token;
    data['userid'] = this.userId;
    return data;
  }
}
