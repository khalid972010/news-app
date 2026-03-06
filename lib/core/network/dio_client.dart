import 'package:dio/dio.dart';
import '../constants/constants.dart';

class DioClient {
  DioClient._();

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      responseType: ResponseType.json,
    ),
  );

  static Dio get instance => _dio;
}
