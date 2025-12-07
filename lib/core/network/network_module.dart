import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:jobsit_mobile/core/utils/logger/app_logger.dart';
import 'package:jobsit_mobile/data/datasources/shared_prefs.dart';

@module // Báo cho injectable biết đây là nơi cung cấp các class thuốc về thư viện ngoài
abstract class NetworkModule {
  
  @lazySingleton
  Dio get dio {
    final dio = Dio();
    
    dio.options.baseUrl = 'https://jobsit.onrender.com/';
    dio.options.connectTimeout = const Duration(seconds: 5);
    dio.options.receiveTimeout = const Duration(seconds: 3);
    dio.options.headers = {'Content-Type': 'application/json'};

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        String? accessToken = SharedPrefs.getCandidateToken(); 

        AppLogger.i("Đang gửi request đến: ${options.path} --- Token: $accessToken");

        if (accessToken != null && accessToken.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }

        return handler.next(options);
      },

      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          AppLogger.i("Lỗi 401: Token hết hạn hoặc không hợp lệ!");
          // Xử lý logic logout hoặc refresh token ở đây
        }
        return handler.next(e);
      },
    ));

    return dio;
  }

  @lazySingleton
  InternetConnection get internetConnection => InternetConnection();
}