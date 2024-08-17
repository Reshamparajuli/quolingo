import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static late SharedPreferences sharedPref;
  static final SharedPref _instance = SharedPref._();

  factory SharedPref() {
    return _instance;
  }

  SharedPref._();
  static Future<void> init() async {
    sharedPref = await SharedPreferences.getInstance();
  }
}
