import 'package:jobsit_mobile/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:jobsit_mobile/features/auth/data/models/candidate_model.dart';
import 'package:jobsit_mobile/features/auth/data/models/login_response_model.dart';
import 'package:jobsit_mobile/features/auth/data/models/register_response_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, LoginResponseModel>> login(
      {required String email, required String password});

  Future<Either<Failure, RegisterResponseModel>> register(
      {required String email,
      required String password,
      required String firstName,
      required String lastName,
      required String phone});

      Future<Either<Failure, CandidateModel>> getDetail(
      {required int candidateId});
}
