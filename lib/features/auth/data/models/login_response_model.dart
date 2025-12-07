import 'package:jobsit_mobile/features/auth/data/models/candidate_model.dart';

class LoginResponseModel{
  final String token;
  final CandidateModel data;

  LoginResponseModel(
      {required this.token,
      required this.data,});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json["token"],
      data: CandidateModel.fromJson(json["data"]),
    );
  }
}
