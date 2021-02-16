import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FacebookModel extends ChangeNotifier {
  bool isLoggedIn = false;
  String accessToken;
  SharedPreferences preferences;

  Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
    final token = preferences.getString("accessToken");
    if (token != null) {
      isLoggedIn = true;
      accessToken = token;
    }
  }

  Future<FacebookLoginStatus> login() async {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email']);
    if (result.status == FacebookLoginStatus.loggedIn) {
      accessToken = result.accessToken.token;
      isLoggedIn = true;
      getLongLivedToken();
      notifyListeners();
    }
    return result.status;
  }

  Future<void> getLongLivedToken() async {
    // if successful
    // accessToken = longLiveAccessToken
    preferences.setString("accessToken", accessToken);
  }

  void logout() {
    preferences.remove("accessToken");
    isLoggedIn = false;
    notifyListeners();
  }
}
