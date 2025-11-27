import 'package:jobsit_mobile/core/error/failures.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, Map<String, dynamic>>> login(
      {required String email, required String password});
}
