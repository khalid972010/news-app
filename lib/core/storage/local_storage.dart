import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  LocalStorage._();

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static List<String> getStringList(String key) {
    return _prefs?.getStringList(key) ?? [];
  }

  static Future<bool> setStringList(String key, List<String> value) async {
    return _prefs?.setStringList(key, value) ?? Future.value(false);
  }
}
