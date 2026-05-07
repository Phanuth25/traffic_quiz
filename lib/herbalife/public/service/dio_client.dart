import 'package:dio/dio.dart';
import 'package:project2/herbalife/public/constants/constants.dart';
import 'package:project2/herbalife/public/provider/data_provider.dart';

class DioClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: accounturl,
      contentType: 'application/json',
    ),
  );

  static Dio get instance {
    _dio.interceptors.clear();
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Automatically attach token to every request
          final storage = SecureStorageProvider();
          final token = await storage.readSecureData('token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          print('API Error: ${error.message}');
          return handler.next(error);
        },
      ),
    );
    return _dio;
  }
}