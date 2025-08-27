import 'package:shared_preferences/shared_preferences.dart';

class AppConfigs {
  static const appBaseUrl = 'https://kenic.east80.co.ke';
  static const int timeoutDuration = 55;

  static final Map<String, String> _baseHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Future<Map<String, String>> authorizedHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('USER_TOKEN');

    final headers = Map<String, String>.from(_baseHeaders);
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    } else {
      print('Warning: No auth token found in SharedPreferences');
    }
    return headers;
  }
}
