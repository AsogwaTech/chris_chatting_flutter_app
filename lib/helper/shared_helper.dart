import 'package:shared_preferences/shared_preferences.dart';

class SharedHelper{

  static String sharedPreferenceLoggedInKey = 'ISLOGGEDIN';
  static String sharedPreferenceUserNameKey = 'USERNAMEKEY';
  static String sharedPreferenceUserEmailKey = 'USEREMAILKEY';

  //saving data to shared preferences
  //isUserLoggedIn is the value to check wether the user is logged in or not
static Future<bool> saveUserLoggedInPreferences(bool isUserLoggedIn)async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return await preferences.setBool(sharedPreferenceLoggedInKey, isUserLoggedIn);
}

  static Future<bool> saveUserNamePreferences(String userName)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
     return await preferences.setString(sharedPreferenceUserNameKey, userName);
  }

  static Future<bool> saveUserEmailPreferences(String userEmail)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
     return await preferences.setString(sharedPreferenceUserEmailKey, userEmail);
  }

  // getting data from shared preferences

  static Future<bool?> getUserLoggedInPreferences()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(sharedPreferenceLoggedInKey);
  }
  static Future<String?> getUserNamePreferences()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceUserNameKey);
  }

  static Future<String?> getUserEmailPreferences()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceUserEmailKey);
  }
}