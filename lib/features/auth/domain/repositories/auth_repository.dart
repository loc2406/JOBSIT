import 'package:jobsit_mobile/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:jobsit_mobile/features/auth/data/models/register_response_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, Map<String, dynamic>>> login(
      {required String email, required String password});

  Future<Either<Failure, RegisterResponseModel>> register(
      {required String email,
      required String password,
      required String firstName,
      required String lastName,
      required String phone});
}
