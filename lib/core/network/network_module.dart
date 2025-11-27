import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

@module // Báo cho injectable biết đây là nơi cung cấp các class thuốc về thư viện ngoài
abstract class NetworkModule {
  
  @lazySingleton
  Dio get dio {
    final dio = Dio();
    
    // Setup thuộc tính
    dio.options.baseUrl = 'https://jobsit.onrender.com/';
    dio.options.receiveTimeout = const Duration(seconds: 10);
    dio.options.headers = {'Content-Type': 'application/json'};

    dio.interceptors.add(LogInterceptor(responseBody: true));

    return dio;
  }

  @lazySingleton
  InternetConnection get internetConnection => InternetConnection();
}