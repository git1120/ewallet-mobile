import 'package:dio/dio.dart';
import 'package:iba_ewallet/features/authentication/domain/authentication_session.dart';

abstract interface class AuthenticationRepository {
  Future<AuthenticationSession> login({
    required String mobileNumber,
    required String pin,
    CancelToken? cancelToken,
  });

  Future<AuthenticationSession> refresh({
    required String refreshToken,
    CancelToken? cancelToken,
  });

  Future<bool> confirmSession({
    required String sessionId,
    CancelToken? cancelToken,
  });

  Future<void> logout({CancelToken? cancelToken});
}
