import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:jobsit_mobile/core/error/failures.dart';
import 'package:jobsit_mobile/features/auth/domain/repositories/auth_repository.dart';

@LazySingleton()
class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call({required String email, required String password}) {
    return repository.login(email: email, password: password);
  }
}