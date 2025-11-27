import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:jobsit_mobile/core/error/auth/auth_failures.dart';
import 'package:jobsit_mobile/core/error/network/network_failures.dart';
import 'package:jobsit_mobile/core/utils/logger/app_logger.dart';
import 'package:jobsit_mobile/features/auth/data/data_sources/auth_data_source.dart';
import 'package:jobsit_mobile/features/auth/domain/entities/candidate.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource dataSource;

  AuthRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, Map<String, dynamic>>> login(
      {required String email, required String password}) async {
    try {
      final responseData = await dataSource.login(email: email, password: password);

      final result = {
        'token': responseData['token'],
        'data': responseData['data'] 
      };

      return Right(result);
    } on Failure catch (failure) {
      return Left(failure);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final serverMess = e.response?.data['message'] ?? "Lỗi máy chủ";

      if (e.type == DioExceptionType.badResponse) {
        AppLogger.i('API Error: $statusCode === $serverMess');

        if (statusCode == 404) {
          return Left(AccountNotFoundFailure());
        }

        if (statusCode == 401) {
          return Left(IncorrectPasswordFailure());
        }
      }

      return Left(ServerFailure(serverMess.toString()));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }
}
