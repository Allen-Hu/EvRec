import 'dart:convert';

import 'package:EvRec/providers/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FacebookModel extends ChangeNotifier {
  bool isLoggedIn = false;
  String accessToken;
  DateTime lastEventUpdate;
  SharedPreferences preferences;
  Map miningResult;

  Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
    final token = preferences.getString("accessToken");
    print(token);
    if (token != null) {
      isLoggedIn = true;
      accessToken = token;
      startEvRecService();
    }
    final timestamp = preferences.getInt("lastEventUpdate");
    if (timestamp != null) {
      lastEventUpdate = DateTime.fromMillisecondsSinceEpoch(timestamp);
    } else {
      lastEventUpdate = DateTime(1900);
    }
  }

  Future<FacebookLoginStatus> login() async {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email', 'user_posts']);
    if (result.status == FacebookLoginStatus.loggedIn) {
      // save access token given
      accessToken = result.accessToken.token;
      // mark logged in
      isLoggedIn = true;
      loginAsyncTasks();
      notifyListeners();
    }
    return result.status;
  }

  void logout() {
    preferences.clear();
    isLoggedIn = false;
    notifyListeners();
  }

  Future<void> loginAsyncTasks() async {
    // replace accessToken with longLiveToken
    accessToken = await getLongLivedToken();
    // re-save token
    preferences.setString("accessToken", accessToken);
    // get user feed
    final userFeed = await getUserFeed();
    // text mining
    miningResult = await textMining(userFeed);
    // start EvRec service
    startEvRecService();
  }

  Future<String> getLongLivedToken() async {
    // if successful
    // accessToken = longLiveAccessToken
    return accessToken;
  }

  Future<Map> getUserFeed() async {
    final response = await http.get(
        'https://graph.facebook.com/v9.0/me/feed?fields=message&access_token=${accessToken}');
    final decoded = jsonDecode(response.body);
    print(decoded);
    return decoded;
  }

  Future<Map> textMining(feed) async {
    return Map();
  }

  Future<void> startEvRecService() async {
    locationService.start(locationCallback);
  }

  void locationCallback() async {
    final now = DateTime.now();
    preferences.setInt("lastEventUpdate", now.millisecondsSinceEpoch);
    if (now.add(Duration(days: -1)).isAfter(lastEventUpdate)) {
      await getEvents();
    }
  }

  Future<Map> getEvents() async {}

  Future<Map<String, String>> getUserProfile() async {
    final response = await http.get(
        'https://graph.facebook.com/v9.0/me?fields=name,picture&access_token=${accessToken}');
    final decoded = jsonDecode(response.body);
    return {
      'name': decoded['name'],
      'pictureUrl': decoded['picture']['data']['url']
    };
  }
}
