import 'package:dio/dio.dart';
import 'dio_client.dart';

class ApiService {
  final Dio _dio = DioClient.instance;

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return _dio.get(path, queryParameters: queryParameters);
  }
}
