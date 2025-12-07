import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:jobsit_mobile/core/error/auth/auth_exceptions.dart';
import 'package:jobsit_mobile/core/error/auth/auth_failures.dart';
import 'package:jobsit_mobile/core/error/network/network_failures.dart';
import 'package:jobsit_mobile/features/auth/data/data_sources/auth_data_source.dart';
import 'package:jobsit_mobile/features/auth/data/models/login_request_model.dart';
import 'package:jobsit_mobile/features/auth/data/models/login_response_model.dart';
import 'package:jobsit_mobile/features/auth/data/models/register_request_model.dart';
import 'package:jobsit_mobile/features/auth/data/models/register_response_model.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource dataSource;

  AuthRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, LoginResponseModel>> login(
      {required String email, required String password}) async {
    try {
      final request = LoginRequestModel(email: email, password: password);

      final result = await dataSource.login(request: request);

      return Right(result);
    } on Failure catch (failure) {
      return Left(failure);
    } on AccountNotFoundException {
      return Left(AccountNotFoundFailure());
    } on IncorrectPasswordException {
      return Left(IncorrectPasswordFailure());
    } on AccountNotActiveException {
      return Left(AccountNotActiveFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RegisterResponseModel>> register(
      {required String email,
      required String password,
      required String firstName,
      required String lastName,
      required String phone}) async {
    try {
      final request = RegisterRequestModel(
          email: email,
          password: password,
          firstName: firstName,
          lastName: lastName,
          phone: phone);

      final responseModel = await dataSource.register(request: request);

      return Right(responseModel);
    } on Failure catch (failure) {
      return Left(failure);
    } on InvalidInfoException {
      return Left(InvalidInfoFailure());
    } on EmailIsUsedException {
      return Left(EmailIsUsedFailure());
    } on PhoneIsUsedException {
      return Left(PhoneIsUsedFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
