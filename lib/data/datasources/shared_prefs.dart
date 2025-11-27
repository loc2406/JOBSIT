import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs{

  static const candidateIdKey = 'candidateId';
  static const candidateTokenKey = 'candidateToken';
  static const languageKey = 'languageKey';

  static late SharedPreferences _instance;

  static Future<void> initSharedPrefs() async {
     _instance = await SharedPreferences.getInstance();
  }

  static saveCandidateId(int id) async {
    await _instance.setInt(candidateIdKey, id);
  }

  static int? getCandidateId() {
    return _instance.getInt(candidateIdKey);
  }

  static Future<void> removeCandidateId() async {
    await _instance.remove(candidateIdKey);
  }

  static saveCandidateToken(String token) async {
    await _instance.setString(candidateTokenKey, token);
  }

  static String? getCandidateToken() {
    return _instance.getString(candidateTokenKey);
  }

  static Future<void> removeCandidateToken() async {
    await _instance.remove(candidateTokenKey);
  }

  static setLanguageCode(String code) async {
    await _instance.setString(languageKey, code);
  }

  static String getLanguageCode() {
    return _instance.getString(languageKey) ?? 'vi';
  }

  static Future<void> removeLanguageCode() async {
    await _instance.remove(languageKey);
  }
}