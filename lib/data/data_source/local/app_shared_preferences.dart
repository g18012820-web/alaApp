import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter_bloc_template/base/constants/local/app_storage_keys.dart';
import 'package:shared_preferences/shared_preferences.dart' as sp;

class AppSharedPreferences {
  final sp.SharedPreferences prefs;

  AppSharedPreferences({
    required this.prefs,
  }) : _encryptedSharedPreferences = EncryptedSharedPreferences(prefs: prefs);

  final EncryptedSharedPreferences _encryptedSharedPreferences;

  Object? get(String key) => prefs.get(key);

  bool? getBool(String key) => prefs.getBool(key);

  int? getInt(String key) => prefs.getInt(key);

  double? getDouble(String key) => prefs.getDouble(key);

  String? getString(String key) => prefs.getString(key);

  bool containsKey(String key) => prefs.containsKey(key);

  Future<bool> setBool(String key, bool value) => prefs.setBool(key, value);

  Future<bool> setInt(String key, int value) => prefs.setInt(key, value);

  Future<bool> setDouble(String key, double value) => prefs.setDouble(key, value);

  Future<bool> setString(String key, String value) => prefs.setString(key, value);

  Future<bool> setStringList(String key, List<String> value) => prefs.setStringList(key, value);

  Future<bool> remove(String key) => prefs.remove(key);

  Future<bool> clear() => prefs.clear();

  Future<String> get accessToken {
    return _encryptedSharedPreferences.getString(AppStorageKeys.accessToken);
  }

  Future<String> get refreshToken {
    return _encryptedSharedPreferences.getString(AppStorageKeys.refreshToken);
  }

  Future<bool> saveAccessToken(String token) async {
    return await _encryptedSharedPreferences.setString(
      AppStorageKeys.accessToken,
      token,
    );
  }

  Future<bool> saveRefreshToken(String token) async {
    return await _encryptedSharedPreferences.setString(
      AppStorageKeys.refreshToken,
      token,
    );
  }

  Future<void> clearCurrentUserData() async {
    await Future.wait(
      [
        prefs.remove(AppStorageKeys.accessToken),
        prefs.remove(AppStorageKeys.refreshToken),
      ],
    );
  }
}
