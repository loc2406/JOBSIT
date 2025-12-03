// features/auth/data/models/register_request_model.dart
class RegisterRequestModel {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String phone;

  const RegisterRequestModel(
      {required this.email,
      required this.password,
      required this.firstName,
      required this.lastName,
      required this.phone});

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
      "firstName": firstName,
      "lastName": lastName,
      "phone": phone,
    };
  }
}
