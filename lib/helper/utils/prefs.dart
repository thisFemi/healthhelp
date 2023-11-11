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
static Future<bool> isFirstTime()async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return  prefs.getBool('first_time') ?? true;
}
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_info');
    print('User data cleared');
  }
  static Future<void> setFirstTime(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_time', value);
  }
}
