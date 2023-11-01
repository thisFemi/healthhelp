import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user.dart';

class Prefs {
  static Future<void> saveUserInfoToPrefs(UserInfo userInfo) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonUserInfo = userInfo.toJson();
    final jsonString = jsonEncode(jsonUserInfo);
    await prefs.setString('user_info', jsonString);
    print('saved');
  }

  static Future<UserInfo?> getUserInfoFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('user_info');
    if (jsonString != null) {
      final jsonUserInfo = jsonDecode(jsonString);
      return UserInfo.fromJson(jsonUserInfo);
    } else {
      return null;
    }
  }
}