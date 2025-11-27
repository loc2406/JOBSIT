import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:jobsit_mobile/core/network/dio_client.dart';

abstract class AuthDataSource {
  Future<Map<String, dynamic>> login(
      {required String email, required String password});
}

@LazySingleton(as: AuthDataSource)
class AuthDataSourceImpl extends AuthDataSource {
  final DioClient dio;

  AuthDataSourceImpl(this.dio);

  @override
  Future<Map<String, dynamic>> login(
      {required String email, required String password}) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      return response.data;
    } on DioException {
      rethrow;
    }
  }
}
