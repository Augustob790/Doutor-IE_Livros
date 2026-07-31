// ignore_for_file: constant_identifier_names

class BaseResponse<T> {
  T? data;
  String? message;
  ResponseError? error;
  ResponseStatus status = ResponseStatus.none;
  int? statusCode;

  bool get isLoading => status == ResponseStatus.loading;
  bool get isError => status == ResponseStatus.error;
  bool get isSuccess => status == ResponseStatus.success;
  bool get isNone => status == ResponseStatus.none;

  BaseResponse.none() : status = ResponseStatus.none;
  BaseResponse.loading() : status = ResponseStatus.loading;
  BaseResponse.success({this.data, this.statusCode})
      : status = ResponseStatus.success;
  BaseResponse.error(this.statusCode, {this.error})
      : status = ResponseStatus.error;

  BaseResponse.genericError()
      : status = ResponseStatus.error,
        error = ResponseError(
          errorCode: ResponseErrorCodes.GENERIC_ERROR,
          message: "Erro genérico",
        );

  BaseResponse.connectionError()
      : status = ResponseStatus.error,
        error = ResponseError(
          errorCode: ResponseErrorCodes.NETWORK_ERROR,
          message: "Erro de conexão",
        );

  static BaseResponse<T> handleResponse<T>(
    BaseResponse<Map<String, dynamic>> response, {
    required T Function(Map<String, dynamic>) fromJson,
  }) {
    if (response.isSuccess) {
      return BaseResponse<T>.success(
        statusCode: response.statusCode,
        data: fromJson(response.data ?? <String, dynamic>{}),
      );
    }

    if (response.data != null && response.data!.containsKey('error')) {
      return BaseResponse<T>.error(response.statusCode, error: response.error);
    }

    return BaseResponse<T>.error(response.statusCode, error: response.error);
  }
}

enum ResponseStatus { none, loading, success, error }

class ResponseError {
  final String errorCode;
  final String message;
  final StackTrace? stackTrace;
  final dynamic error;

  ResponseError({
    required this.errorCode,
    required this.message,
    this.stackTrace,
    this.error,
  });
}

class ResponseErrorCodes {
  static const String GENERIC_ERROR = "GENERIC_ERROR";
  static const String NETWORK_ERROR = "NETWORK_ERROR";
  static const String TIMEOUT_ERROR = "TIMEOUT_ERROR";
  static const String UNAUTHORIZED_ERROR = "UNAUTHORIZED_ERROR";
  static const String NOT_FOUND_ERROR = "NOT_FOUND_ERROR";
  static const String FORBIDDEN_ERROR = "FORBIDDEN_ERROR";
  static const String BAD_REQUEST_ERROR = "BAD_REQUEST_ERROR";
  static const String SERVER_ERROR = "SERVER_ERROR";
}
