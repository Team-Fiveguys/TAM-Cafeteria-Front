import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class TokenManagerWithSP {
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', token);
  }

  static Future<String?> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static bool isExpiredToken(String token) {
    // if (token == null) return true;
    final parts = token.split('.');

    if (parts.length != 3) {
      throw Exception('Invalid token');
    }

    final payload = parts[1];
    var normalized = base64Url.normalize(payload);
    var decoded = utf8.decode(base64Url.decode(normalized));
    final payloadMap = json.decode(decoded);
    int currentUnixTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    // payloadMap['exp'] = currentUnixTimestamp;

    if (payloadMap['exp'] < currentUnixTimestamp) {
      // print("여기까지 오나?");
      return true;
    }

    return false;
  }
}
