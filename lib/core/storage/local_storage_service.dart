import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class LocalStorageService {
  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  Future<void> saveToken(String token) async {
    await _prefs.setString(AppConstants.tokenKey, token);
  }

  String? getToken() {
    return _prefs.getString(AppConstants.tokenKey);
  }

  Future<void> saveUser(Map<String, dynamic> userMap) async {
    await _prefs.setString(AppConstants.userKey, jsonEncode(userMap));
  }

  Map<String, dynamic>? getUser() {
    final userString = _prefs.getString(AppConstants.userKey);
    if (userString == null) return null;
    try {
      return jsonDecode(userString) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<void> clearAuth() async {
    await _prefs.remove(AppConstants.tokenKey);
    await _prefs.remove(AppConstants.userKey);
  }
}
