class BaseServices{
  static const url = 'https://jobsit.onrender.com';
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