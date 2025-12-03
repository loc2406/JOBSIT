import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:jobsit_mobile/core/error/failures.dart';
import 'package:jobsit_mobile/features/auth/data/models/register_response_model.dart';
import 'package:jobsit_mobile/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class RegisterUseCase {
  final AuthRepository repo;

  const RegisterUseCase(this.repo);

  Future<Either<Failure, RegisterResponseModel>> call(
      {required String email,
      required String password,
      required String firstName,
      required String lastName,
      required String phone}) {
        
    return repo.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phone: phone);
  }
}
