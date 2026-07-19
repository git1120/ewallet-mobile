import 'package:dio/dio.dart';
import 'package:iba_ewallet/features/authentication/data/authentication_api.dart';
import 'package:iba_ewallet/features/authentication/data/dto/authentication_dto.dart';
import 'package:iba_ewallet/features/authentication/domain/authentication_repository.dart';
import 'package:iba_ewallet/features/authentication/domain/authentication_session.dart';

final class AuthenticationRepositoryImpl implements AuthenticationRepository {
  const AuthenticationRepositoryImpl(this._api);

  final AuthenticationApi _api;

  @override
  Future<AuthenticationSession> login({
    required String mobileNumber,
    required String pin,
    CancelToken? cancelToken,
  }) async => (await _api.login(
    LoginRequestDto(mobileNumber: mobileNumber, pin: pin),
    cancelToken: cancelToken,
  )).toDomain();

  @override
  Future<AuthenticationSession> refresh({
    required String refreshToken,
    CancelToken? cancelToken,
  }) async => (await _api.refresh(
    RefreshRequestDto(refreshToken: refreshToken),
    cancelToken: cancelToken,
  )).toDomain();

  @override
  Future<bool> confirmSession({
    required String sessionId,
    CancelToken? cancelToken,
  }) async {
    final sessions = await _api.devices(cancelToken: cancelToken);
    return sessions.any(
      (session) => session.sessionId == sessionId && session.status == 'ACTIVE',
    );
  }

  @override
  Future<void> logout({CancelToken? cancelToken}) =>
      _api.logout(cancelToken: cancelToken);
}
