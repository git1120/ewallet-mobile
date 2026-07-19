import 'package:dio/dio.dart';
import 'package:iba_ewallet/core/api/api_client.dart';
import 'package:iba_ewallet/features/authentication/data/dto/authentication_dto.dart';

final class AuthenticationApi {
  const AuthenticationApi(this._client);

  final ApiClient _client;

  Future<JwtResponseDto> login(
    LoginRequestDto request, {
    CancelToken? cancelToken,
  }) async {
    final response = await _client.dio.post<Object?>(
      '/api/v1/auth/login',
      data: request.toJson(),
      cancelToken: cancelToken,
      options: Options(
        contentType: Headers.jsonContentType,
        extra: const {
          ApiRequestOptions.skipAuthorization: true,
          ApiRequestOptions.skipRefresh: true,
        },
      ),
    );
    return JwtResponseDto.fromEnvelope(response.data);
  }

  Future<JwtResponseDto> refresh(
    RefreshRequestDto request, {
    CancelToken? cancelToken,
  }) async {
    final response = await _client.dio.post<Object?>(
      '/api/v1/auth/refresh',
      data: request.toJson(),
      cancelToken: cancelToken,
      options: Options(
        contentType: Headers.jsonContentType,
        extra: const {
          ApiRequestOptions.skipAuthorization: true,
          ApiRequestOptions.skipRefresh: true,
        },
      ),
    );
    return JwtResponseDto.fromEnvelope(response.data);
  }

  Future<List<DeviceSessionDto>> devices({CancelToken? cancelToken}) async {
    final response = await _client.dio.get<Object?>(
      '/api/v1/auth/devices',
      cancelToken: cancelToken,
    );
    return parseDeviceSessions(response.data);
  }

  Future<void> logout({CancelToken? cancelToken}) async {
    await _client.dio.post<Object?>(
      '/api/v1/auth/logout',
      cancelToken: cancelToken,
      options: Options(extra: const {ApiRequestOptions.skipRefresh: true}),
    );
  }
}
