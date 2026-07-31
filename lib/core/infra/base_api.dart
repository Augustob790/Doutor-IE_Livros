import 'base_response.dart';

abstract class BaseApi {
  Future<BaseResponse<Map<String, dynamic>>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });

  Future<BaseResponse<Map<String, dynamic>>> post(
    String path,
    dynamic body, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });

  Future<BaseResponse<Map<String, dynamic>>> put(
    String path,
    dynamic body, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });

  Future<BaseResponse<Map<String, dynamic>>> patch(
    String path,
    dynamic body, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });

  Future<BaseResponse<Map<String, dynamic>>> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });
}
