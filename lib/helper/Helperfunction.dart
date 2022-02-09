import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction{
  String email="";
  static String sharedPreferenceUserLoggedInKey = "ISLOGGEDIN";
  static String sharedPreferenceUserNameKey = "USERNAMEKEY";
  static String sharedPreferenceUserEmailKey = "USEREMAILKEY";
  //Setting data
  static Future < void > saveUserLoggedInSharedPreference(bool isUerLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(sharedPreferenceUserLoggedInKey,isUerLoggedIn );
  }
  static Future < void > saveUserNameSharedPreference(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(sharedPreferenceUserNameKey,userName);
  }

  static Future < void > saveUserEmailSharedPreference(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(sharedPreferenceUserEmailKey,email);
  }
  //Getting data
  static Future < bool > getUserLoggedInSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getBool(sharedPreferenceUserLoggedInKey);
  }
  static Future < String > getUserNameSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(sharedPreferenceUserNameKey);
  }

  static Future < String > getUserEmailSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(sharedPreferenceUserEmailKey);
  }

}