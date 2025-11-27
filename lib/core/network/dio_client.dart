import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:jobsit_mobile/core/error/network/network_failures.dart';
import 'package:jobsit_mobile/core/network/network_info.dart';

@lazySingleton
class DioClient {
  final Dio _dio;
  final NetworkInfo _networkInfo;

  DioClient(this._dio, this._networkInfo);

  Future<Response> get(String path,
      {Map<String, dynamic>? params,
      Map<String, dynamic>? data,
      Options? option}) async {
    if (!await _networkInfo.isConnected) {
      throw NoInternetFailure();
    }

    try {
      return await _dio.get(path,
          queryParameters: params, data: data, options: option);
    } on DioException catch (e) {
      _handleNetworkError(e);
      rethrow;
    }
  }

  Future<Response> post(String path,
      {Map<String, dynamic>? params,
      Map<String, dynamic>? data,
      Options? option}) async {
    if (!await _networkInfo.isConnected) {
      throw NoInternetFailure();
    }

    try {
      return await _dio.post(path,
          queryParameters: params, data: data, options: option);
    } on DioException catch (e) {
      _handleNetworkError(e);
      rethrow;
    }
  }

  void _handleNetworkError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      throw NetworkFailure();
    }
  }
}
