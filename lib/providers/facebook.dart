import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FacebookModel extends ChangeNotifier {
  bool isLoggedIn = false;
  String accessToken;
  SharedPreferences preferences;

  Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
    final token = preferences.getString("accessToken");
    print(token);
    if (token != null) {
      isLoggedIn = true;
      accessToken = token;
    }
  }

  Future<FacebookLoginStatus> login() async {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email', 'user_posts']);
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

  Future<Map<String, String>> getUserProfile() async {
    final response = await http.get(
        'https://graph.facebook.com/v9.0/me?fields=name,picture&access_token=${accessToken}');
    final decoded = jsonDecode(response.body);
    return {
      'name': decoded['name'],
      'pictureUrl': decoded['picture']['data']['url']
    };
  }

  Future<void> getUserFeed() async {
    final response = await http.get(
        'https://graph.facebook.com/v9.0/me/feed?fields=message&access_token=${accessToken}');
    final decoded = jsonDecode(response.body);
    print(decoded);
  }
}
