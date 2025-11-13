import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs{

  static const candidateIdKey = 'candidateId';
  static const candidateTokenKey = 'candidateToken';

  static late SharedPreferences _instance;

  static Future<void> initSharedPrefs() async {
     _instance = await SharedPreferences.getInstance();
  }

  static saveCandidateId(int id) async {
    await _instance.setInt(candidateIdKey, id);
  }

  static Future<int?> getCandidateId() async {
    return await _instance.getInt(candidateIdKey);
  }

  static saveCandidateToken(String token) async {
    await _instance.setString(candidateTokenKey, token);
  }

  static Future<String?> getCandidateToken() async {
    return await _instance.getString(candidateTokenKey);
  }
}