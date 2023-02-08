import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesDataProvider {
  static const String TOKEN = 'authorization_token';
  static const String USER_ID = 'user_id';
  static const String USER_NAME = 'user_name';
  static const String USER_MAIL = 'user_mail';

  Future<bool> saveAccessToken({@required String accessToken}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(TOKEN, accessToken);
    return true;
  }

  Future<String> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString(TOKEN) ?? '';
    return accessToken;
  }

  Future<bool> saveUserId(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(USER_ID, id);
    return true;
  }

  Future<int> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int id = prefs.getInt(USER_ID) ?? 0;
    return id;
  }

  Future<bool> saveUserName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(USER_NAME, name);
    return true;
  }

  Future<String> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString(USER_NAME) ?? '';
    return name;
  }


  Future<bool> saveUserMail(String mail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(USER_MAIL, mail);
    return true;
  }

  Future<String> getUserMail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mail = prefs.getString(USER_MAIL) ?? '';
    return mail;
  }

}
