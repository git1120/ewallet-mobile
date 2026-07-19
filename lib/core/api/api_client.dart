import 'package:dio/dio.dart';
import 'package:iba_ewallet/app/session/access_token_store.dart';
import 'package:iba_ewallet/app/session/refresh_coordinator.dart';
import 'package:iba_ewallet/core/config/environment.dart';
import 'package:iba_ewallet/core/error/app_failure.dart';
import 'package:iba_ewallet/core/logging/safe_logger.dart';
import 'package:uuid/uuid.dart';

typedef RefreshHandler = Future<String?> Function();

abstract final class ApiRequestOptions {
  static const skipAuthorization = 'iba.skipAuthorization';
  static const skipRefresh = 'iba.skipRefresh';
  static const refreshRetried = 'iba.refreshRetried';
}

final class ApiClient {
  ApiClient({
    required EnvironmentConfig config,
    required AccessTokenSource accessTokenSource,
    required this.refreshCoordinator,
    required SafeLogger logger,
    Dio? dio,
  }) : dio =
           dio ??
           Dio(
             BaseOptions(
               baseUrl: config.dioBaseUrl,
               connectTimeout: config.connectTimeout,
               receiveTimeout: config.receiveTimeout,
               headers: const {'Accept': 'application/json'},
             ),
           ) {
    this.dio.options
      ..baseUrl = config.dioBaseUrl
      ..connectTimeout = config.connectTimeout
      ..receiveTimeout = config.receiveTimeout
      ..headers.putIfAbsent('Accept', () => 'application/json');
    this.dio.interceptors.addAll([
      RequestTraceInterceptor(),
      AuthorizationInterceptor(accessTokenSource),
      SanitizedLoggingInterceptor(logger),
      RefreshRetryInterceptor(
        dio: this.dio,
        accessTokenSource: accessTokenSource,
        refresh: () => _refreshHandler?.call() ?? Future.value(),
      ),
      FailureInterceptor(),
    ]);
  }

  final Dio dio;
  final RefreshCoordinator refreshCoordinator;
  RefreshHandler? _refreshHandler;

  void configureRefresh(RefreshHandler handler) => _refreshHandler = handler;

  CancelToken cancellationToken() => CancelToken();
}

final class RequestTraceInterceptor extends Interceptor {
  RequestTraceInterceptor({Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final Uuid _uuid;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.putIfAbsent('X-Trace-Id', () => _uuid.v4());
    handler.next(options);
  }
}

final class AuthorizationInterceptor extends Interceptor {
  AuthorizationInterceptor(this._source);
  final AccessTokenSource _source;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.extra[ApiRequestOptions.skipAuthorization] != true) {
      final token = _source.accessToken;
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
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
        'traceId': options.headers['X-Trace-Id'],
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
        'traceId': response.headers.value('x-trace-id'),
      },
    );
    handler.next(response);
  }
}

final class RefreshRetryInterceptor extends Interceptor {
  RefreshRetryInterceptor({
    required Dio dio,
    required AccessTokenSource accessTokenSource,
    required RefreshHandler refresh,
  }) : _dio = dio,
       _accessTokenSource = accessTokenSource,
       _refresh = refresh;

  final Dio _dio;
  final AccessTokenSource _accessTokenSource;
  final RefreshHandler _refresh;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;
    final shouldRefresh =
        err.response?.statusCode == 401 &&
        options.method.toUpperCase() == 'GET' &&
        options.extra[ApiRequestOptions.skipRefresh] != true &&
        options.extra[ApiRequestOptions.refreshRetried] != true &&
        !(options.cancelToken?.isCancelled ?? false);
    if (!shouldRefresh) {
      handler.next(err);
      return;
    }

    try {
      final token = await _refresh();
      if (token == null || options.cancelToken?.isCancelled == true) {
        handler.next(err);
        return;
      }
      options.extra[ApiRequestOptions.refreshRetried] = true;
      options.headers['Authorization'] =
          'Bearer ${_accessTokenSource.accessToken ?? token}';
      handler.resolve(await _dio.fetch<Object?>(options));
    } on DioException catch (refreshError) {
      handler.next(refreshError);
    } catch (_) {
      handler.next(err);
    }
  }
}

final class FailureInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.error is AppFailure) {
      handler.next(err);
      return;
    }
    handler.reject(err.copyWith(error: parseFailure(err)));
  }
}

AppFailure parseFailure(DioException error) {
  final response = error.response;
  final data = response?.data;
  final body = data is Map ? data : const <Object?, Object?>{};
  final errorBody = body['error'];
  final errorMap = errorBody is Map ? errorBody : const <Object?, Object?>{};
  final metaBody = body['meta'];
  final meta = metaBody is Map ? metaBody : const <Object?, Object?>{};
  final details = errorMap['details'];
  final validationIssues = <ValidationIssue>[
    if (details is List)
      for (final detail in details)
        if (detail is Map && detail['field'] is String)
          ValidationIssue(
            field: detail['field'] as String,
            code: detail['code']?.toString(),
          ),
  ];
  final traceId =
      response?.headers.value('x-trace-id') ?? meta['traceId']?.toString();

  return switch (error.type) {
    DioExceptionType.cancel => AppFailure(
      kind: FailureKind.cancelled,
      messageKey: 'genericError',
      traceId: traceId,
    ),
    DioExceptionType.connectionTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.sendTimeout => AppFailure(
      kind: FailureKind.timeout,
      messageKey: 'networkError',
      traceId: traceId,
    ),
    DioExceptionType.connectionError => AppFailure(
      kind: FailureKind.network,
      messageKey: 'networkError',
      traceId: traceId,
    ),
    _ => AppFailure.fromBackend(
      code: errorMap['code']?.toString(),
      traceId: traceId,
      httpStatus: response?.statusCode,
      validationIssues: validationIssues,
    ),
  };
}
