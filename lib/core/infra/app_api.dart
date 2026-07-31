import 'package:doutor_ie_test/app_env.dart';
import 'package:doutor_ie_test/core/infra/login_session_storage.dart';
import 'package:doutor_ie_test/core/iod.dart';
import 'package:doutor_ie_test/core/navigator/app_navigator.dart';
import 'package:doutor_ie_test/core/utils/log.dart';
import 'package:dio/dio.dart';

import 'base_api.dart';
import 'base_response.dart';

class AppApi implements BaseApi {
  static final AppApi _instance = AppApi._internal();
  factory AppApi() => _instance;
  AppApi._internal();

  Dio? _dio;
  String? _baseUrl;

  static String _resolveBaseUrl() {
    final String envBaseUrl = AppEnv.apiBaseUrl;
    final String normalized = envBaseUrl.endsWith('/')
        ? envBaseUrl.substring(0, envBaseUrl.length - 1)
        : envBaseUrl;
    return normalized;
  }

  Future<Dio> setupDio() async {
    _baseUrl = _resolveBaseUrl();
    _dio = Dio(
      BaseOptions(
        contentType: 'application/json',
        responseType: ResponseType.json,
        headers: <String, dynamic>{'Content-Type': 'application/json'},
        baseUrl: _baseUrl!,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
      ),
    );

    _dio!.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        try {
          final token = await LoginSessionStorage().getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        } catch (e) {
          logDebug('Error injecting token: $e');
        }

        logDebug(
          'Request [${options.method}] ${options.uri} query=${options.queryParameters}',
        );
        return handler.next(options);
      },
    ));

    return _dio!;
  }

  BaseResponse<Map<String, dynamic>> processSuccess(
      Response<dynamic> response) {
    final dynamic data = response.data;
    Map<String, dynamic> payload;

    if (data is Map<String, dynamic>) {
      payload = data;
    } else if (data is Map) {
      payload = Map<String, dynamic>.from(data);
    } else {
      payload = <String, dynamic>{'data': data};
    }

    logDebug(
      'Request Success [${response.statusCode}] ${response.requestOptions.method} '
      '${response.requestOptions.path}',
    );
    return BaseResponse<Map<String, dynamic>>.success(
        statusCode: response.statusCode, data: payload);
  }

  void _redirectProtectedFlowIfNeeded(String errorCode) {
    final String? path = switch (errorCode) {
      'ACCOUNT_EXPORT_WINDOW_EXPIRED' => '/account/closure-expired',
      'ACCOUNT_ACCESS_RESTRICTED' => '/account/closure',
      'LEGAL_CONSENT_REQUIRED' => '/home',
      _ => null,
    };
    if (path == null) return;

    try {
      if (!IoD.instance.isRegistered<AppNavigator>()) return;
      Future<void>.microtask(() => IoD.instance.get<AppNavigator>().go(path));
    } catch (e) {
      logDebug('Erro ao redirecionar fluxo protegido: $e');
    }
  }

  BaseResponse<Map<String, dynamic>> processError(DioException exception) {
    final int? statusCode = exception.response?.statusCode;
    final String requestPath = exception.requestOptions.path;
    final dynamic responseData = exception.response?.data;
    final String fallbackErrorCode = statusCode == 400
        ? ResponseErrorCodes.BAD_REQUEST_ERROR
        : statusCode == 401
            ? ResponseErrorCodes.UNAUTHORIZED_ERROR
            : statusCode == 403
                ? ResponseErrorCodes.FORBIDDEN_ERROR
                : statusCode == 404
                    ? ResponseErrorCodes.NOT_FOUND_ERROR
                    : statusCode != null && statusCode >= 500
                        ? ResponseErrorCodes.SERVER_ERROR
                        : exception.type == DioExceptionType.connectionError ||
                                exception.type ==
                                    DioExceptionType.connectionTimeout ||
                                exception.type ==
                                    DioExceptionType.receiveTimeout ||
                                exception.type == DioExceptionType.sendTimeout
                            ? ResponseErrorCodes.NETWORK_ERROR
                            : ResponseErrorCodes.GENERIC_ERROR;

    String errorCode = fallbackErrorCode;
    String message = 'Erro na requisição';
    if (responseData is Map) {
      final dynamic nestedError = responseData['error'];
      if (nestedError is Map) {
        errorCode = nestedError['code']?.toString() ?? fallbackErrorCode;
        message = (nestedError['message'] ??
                responseData['message'] ??
                'Erro na requisição')
            .toString();
      } else {
        errorCode = responseData['code']?.toString() ?? fallbackErrorCode;
        message = (responseData['message'] ??
                responseData['error'] ??
                'Erro na requisição')
            .toString();
      }
    } else if (exception.message != null) {
      message = exception.message!;
    }

    if (statusCode == 401) {
      LoginSessionStorage().clear();
    }

    _redirectProtectedFlowIfNeeded(errorCode);

    logDebug(
        'Request Error [$statusCode] ${exception.requestOptions.method} $requestPath: $message');

    return BaseResponse<Map<String, dynamic>>.error(
      statusCode,
      error: ResponseError(
        errorCode: errorCode,
        message: message,
        error: exception.response?.data,
        stackTrace: exception.stackTrace,
      ),
    );
  }

  @override
  Future<BaseResponse<Map<String, dynamic>>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    _dio ??= await setupDio();

    final String url = '$_baseUrl$path';

    try {
      final Response<dynamic> response = await _dio!.get(
        url,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      );

      return processSuccess(response);
    } on DioException catch (e) {
      return processError(e);
    }
  }

  @override
  Future<BaseResponse<Map<String, dynamic>>> post(
    String path,
    body, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    _dio ??= await setupDio();

    final String url = '$_baseUrl$path';

    try {
      final Response<dynamic> response = await _dio!.post(
        url,
        data: body,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      );

      return processSuccess(response);
    } on DioException catch (e) {
      return processError(e);
    }
  }

  @override
  Future<BaseResponse<Map<String, dynamic>>> put(
    String path,
    body, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    _dio ??= await setupDio();

    final String url = '$_baseUrl$path';

    try {
      final Response<dynamic> response = await _dio!.put(
        url,
        data: body,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      );

      return processSuccess(response);
    } on DioException catch (e) {
      return processError(e);
    }
  }

  @override
  Future<BaseResponse<Map<String, dynamic>>> patch(
    String path,
    body, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    _dio ??= await setupDio();

    final String url = '$_baseUrl$path';

    try {
      final Response<dynamic> response = await _dio!.patch(
        url,
        data: body,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      );

      return processSuccess(response);
    } on DioException catch (e) {
      return processError(e);
    }
  }

  @override
  Future<BaseResponse<Map<String, dynamic>>> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    _dio ??= await setupDio();

    final String url = '$_baseUrl$path';

    try {
      final Response<dynamic> response = await _dio!.delete(
        url,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      );

      return processSuccess(response);
    } on DioException catch (e) {
      return processError(e);
    }
  }
}
