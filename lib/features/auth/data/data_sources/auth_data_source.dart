import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:jobsit_mobile/core/error/auth/auth_exceptions.dart';
import 'package:jobsit_mobile/core/network/dio_client.dart';
import 'package:jobsit_mobile/core/utils/logger/app_logger.dart';
import 'package:jobsit_mobile/features/auth/data/models/candidate_model.dart';
import 'package:jobsit_mobile/features/auth/data/models/get_candidate_detail_request_model.dart';
import 'package:jobsit_mobile/features/auth/data/models/login_request_model.dart';
import 'package:jobsit_mobile/features/auth/data/models/login_response_model.dart';
import 'package:jobsit_mobile/features/auth/data/models/register_request_model.dart';
import 'package:jobsit_mobile/features/auth/data/models/register_response_model.dart';

abstract class AuthDataSource {
  Future<LoginResponseModel> login({required LoginRequestModel request});

  Future<RegisterResponseModel> register(
      {required RegisterRequestModel request});

  Future<CandidateModel> getDetail(
      {required GetCandidateDetailRequestModel request});
}

@LazySingleton(as: AuthDataSource)
class AuthDataSourceImpl extends AuthDataSource {
  final _loginApi = '/auth/login';
  final _registerApi = '/auth/register';
  final _getDetail = '/candidates/';

  final DioClient _dio;
  final String _defaultErr = "Đã có lỗi xảy ra!";

  AuthDataSourceImpl(this._dio);

  @override
  Future<LoginResponseModel> login({required LoginRequestModel request}) async {
    try {
      final response = await _dio.post(
        _loginApi,
        data: request.toJson(),
      );

      return LoginResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final serverMess = (e.response?.data is Map<String, dynamic> &&
              e.response?.data['detail'] != null)
          ? e.response?.data['detail']
          : "Đã có lỗi xảy ra!";

      AppLogger.e('API Error: $statusCode === $serverMess');

      if (statusCode == 404) {
        throw AccountNotFoundException();
      }

      if (statusCode == 401) {
        throw IncorrectPasswordException();
      }

      if (statusCode == 403) {
        throw AccountNotActiveException();
      }

      throw ServerException(_defaultErr);
    } catch (e) {
      AppLogger.e('API Login Candidate Error: $e');
      throw ServerException(_defaultErr);
    }
  }

  @override
  Future<RegisterResponseModel> register(
      {required RegisterRequestModel request}) async {
    try {
      final response = await _dio.post(
        _registerApi,
        data: request.toJson(),
      );

      return RegisterResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;
      final serverMess = data?['detail'] ?? _defaultErr;

      AppLogger.e('API Error: $statusCode === $serverMess');

      if (statusCode == 422 && serverMess is List) {
        throw InvalidInfoException();
      }

      if (statusCode == 409 && serverMess is String) {
        if (serverMess.compareTo("Email này đã được sử dụng!") == 0) {
          throw EmailIsUsedException();
        } else if (serverMess.compareTo("Số điện thoại này đã được sử dụng!") ==
            0) {
          throw PhoneIsUsedException();
        }
      }

      throw ServerException(_defaultErr);
    } catch (e) {
      AppLogger.e('API Resgister Candidate Error: $e');
      throw ServerException(_defaultErr);
    }
  }
  
  @override
  Future<CandidateModel> getDetail({required GetCandidateDetailRequestModel request}) async {
    try {
      final response = await _dio.get(
        '$_getDetail${request.candidateId}',
      );

      return CandidateModel.fromJson(response.data);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;
      final serverMess = data?['detail'] ?? _defaultErr;

      AppLogger.e('API Error: $statusCode === $serverMess');

      if (statusCode == 404) {
        throw CandidateNotFoundException();
      }

      throw ServerException(_defaultErr);
    } catch (e) {
      AppLogger.e('API Get Detail Candidate Error: $e');
      throw ServerException(_defaultErr);
    }
  }
}
