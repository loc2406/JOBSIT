// features/auth/data/models/register_request_model.dart
import 'package:jobsit_mobile/features/auth/domain/entities/candidate.dart';

class RegisterResponseModel extends Candidate {
  RegisterResponseModel(
      {required super.id,
      required super.email,
      required super.firstName,
      required super.lastName,
      required super.phone,
      required super.isActive})
     ;

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
        id: json["id"],
        email: json["email"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        phone: json["phone"],
        isActive: json["isActive"]);
  }
}
