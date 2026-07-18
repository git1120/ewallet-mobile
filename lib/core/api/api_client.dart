import 'package:dio/dio.dart';
import 'package:iba_ewallet/app/session/refresh_coordinator.dart';
import 'package:iba_ewallet/core/config/environment.dart';
import 'package:iba_ewallet/core/error/app_failure.dart';
import 'package:iba_ewallet/core/logging/safe_logger.dart';
import 'package:iba_ewallet/core/storage/secure_storage.dart';

final class ApiClient {
  ApiClient({
    required EnvironmentConfig config,
    required SecureStore secureStore,
    required this.refreshCoordinator,
    required SafeLogger logger,
    Dio? dio,
  }) : dio =
           dio ??
           Dio(
             BaseOptions(
               baseUrl: config.apiBaseUrl.toString(),
               connectTimeout: config.connectTimeout,
               receiveTimeout: config.receiveTimeout,
               headers: const {'Accept': 'application/json'},
             ),
           ) {
    this.dio.interceptors.addAll([
      AuthorizationInterceptor(secureStore),
      SanitizedLoggingInterceptor(logger),
      FailureInterceptor(),
    ]);
    // Refresh is deliberately coordinated but the refresh endpoint is deferred
    // until authentication contracts are implemented.
  }

  final Dio dio;
  final RefreshCoordinator refreshCoordinator;

  CancelToken cancellationToken() => CancelToken();
}

final class AuthorizationInterceptor extends Interceptor {
  AuthorizationInterceptor(this._store);
  final SecureStore _store;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _store.read(SecretKeys.accessToken);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}

final class SanitizedLoggingInterceptor extends Interceptor {
  SanitizedLoggingInterceptor(this._logger);
  final SafeLogger _logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.event(
      'api.request',
      fields: {
        'method': options.method,
        'path': options.path,
        'headers': options.headers,
      },
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.event(
      'api.response',
      fields: {
        'path': response.requestOptions.path,
        'status': response.statusCode,
        'requestId': response.headers.value('x-request-id'),
      },
    );
    handler.next(response);
  }
}

final class FailureInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final response = err.response;
    final data = response?.data;
    final code = data is Map ? data['code']?.toString() : null;
    final requestId =
        response?.headers.value('x-request-id') ??
        (data is Map ? data['requestId']?.toString() : null);
    final failure = switch (err.type) {
      DioExceptionType.connectionError ||
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.sendTimeout => AppFailure(
        kind: FailureKind.network,
        messageKey: 'networkError',
        requestId: requestId,
      ),
      _ => AppFailure.fromBackend(code: code, requestId: requestId),
    };
    handler.reject(err.copyWith(error: failure));
  }
}
