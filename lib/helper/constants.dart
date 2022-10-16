import 'package:flutter/material.dart';
import 'package:quizmaker/models/account.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Constants {
  static String sharedPreferenceUserLoggedInKey = "ISLOGGEDIN";
  static String sharedPreferenceUserNameKey = "USERNAMEKEY";
  static String sharedPreferenceUserEmailKey = "USEREMAIL";
  static String sharedPreferenceUserAccountKey = "USERACCOUNT";
  static Future<bool> saveUserLoggedInSharedPreference(
      bool isUserLoggedIn) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(
        Constants.sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserDetailsSharedPreference(
      List<String> value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setStringList(
        Constants.sharedPreferenceUserAccountKey, value);
  }

  static Future<List<String>> getUserDetailsSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.get(Constants.sharedPreferenceUserAccountKey) as List<String>;
  }

  static Future<Object?> getUerLoggedInSharedPreference() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.get(Constants.sharedPreferenceUserLoggedInKey);
  }
}
