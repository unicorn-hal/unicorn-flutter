import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  Future<SharedPreferences> get _instance async =>
      await SharedPreferences.getInstance();

  Future<bool> setString(String key, String value) async {
    final SharedPreferences prefs = await _instance;
    return prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    final SharedPreferences prefs = await _instance;
    return prefs.getString(key);
  }

  Future<bool> setBool(String key, bool value) async {
    final SharedPreferences prefs = await _instance;
    return prefs.setBool(key, value);
  }

  Future<bool?> getBool(String key) async {
    final SharedPreferences prefs = await _instance;
    return prefs.getBool(key);
  }

  Future<bool> setInt(String key, int value) async {
    final SharedPreferences prefs = await _instance;
    return prefs.setInt(key, value);
  }

  Future<int?> getInt(String key) async {
    final SharedPreferences prefs = await _instance;
    return prefs.getInt(key);
  }

  Future<bool> setDouble(String key, double value) async {
    final SharedPreferences prefs = await _instance;
    return prefs.setDouble(key, value);
  }

  Future<double?> getDouble(String key) async {
    final SharedPreferences prefs = await _instance;
    return prefs.getDouble(key);
  }

  Future<bool> setStringList(String key, List<String> value) async {
    final SharedPreferences prefs = await _instance;
    return prefs.setStringList(key, value);
  }

  Future<List<String>?> getStringList(String key) async {
    final SharedPreferences prefs = await _instance;
    return prefs.getStringList(key);
  }

  Future<bool> remove(String key) async {
    final SharedPreferences prefs = await _instance;
    return prefs.remove(key);
  }

  Future<bool> clear() async {
    final SharedPreferences prefs = await _instance;
    return prefs.clear();
  }
}
