class BaseServices{
  static const url = 'http://192.168.101.209:8000';
  static const headers = {
    'Content-Type': 'application/json; charset=UTF-8'
  };

  static Map<String, String> getHeaderWithToken(String token){
    return {
      "Authorization": "Bearer $token",
      'Content-Type': 'application/json; charset=UTF-8'
    };
  }
}