import 'package:shared_preferences/shared_preferences.dart';

class AppConfigs {
  static const appBaseUrl = 'https://resumate-backend-6dis.onrender.com/api';
  static const int timeoutDuration = 55;

  static Future<Map<String, String>> authorizedHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('USER_TOKEN');

    headers['Authorization'] = 'Bearer $token';
    return headers;
  }

  static final headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
