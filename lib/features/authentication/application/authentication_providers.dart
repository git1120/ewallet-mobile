import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:iba_ewallet/app/session/access_token_store.dart';
import 'package:iba_ewallet/app/session/authentication_session_manager.dart';
import 'package:iba_ewallet/app/session/refresh_coordinator.dart';
import 'package:iba_ewallet/core/api/api_client.dart';
import 'package:iba_ewallet/core/config/environment.dart';
import 'package:iba_ewallet/core/logging/safe_logger.dart';
import 'package:iba_ewallet/core/storage/preferences_store.dart';
import 'package:iba_ewallet/core/storage/secure_storage.dart';
import 'package:iba_ewallet/features/authentication/application/authentication_controller.dart';
import 'package:iba_ewallet/features/authentication/data/authentication_api.dart';
import 'package:iba_ewallet/features/authentication/data/authentication_repository_impl.dart';
import 'package:iba_ewallet/features/authentication/domain/authentication_repository.dart';

final environmentProvider = Provider<EnvironmentConfig>(
  (ref) => throw StateError('EnvironmentConfig must be overridden'),
);
final preferencesProvider = Provider<PreferencesStore>(
  (ref) => throw StateError('PreferencesStore must be overridden'),
);
final secureStoreProvider = Provider<SecureStore>(
  (ref) => PlatformSecureStore(),
);
final safeLoggerProvider = Provider<SafeLogger>(
  (ref) => SafeLogger(enabled: ref.watch(environmentProvider).enableLogging),
);
final accessTokenStoreProvider = Provider<AccessTokenStore>(
  (ref) => AccessTokenStore(),
);
final apiDioProvider = Provider<Dio?>((ref) => null);
final refreshCoordinatorProvider = Provider<RefreshCoordinator>(
  (ref) => RefreshCoordinator(),
);
final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(
    config: ref.watch(environmentProvider),
    accessTokenSource: ref.watch(accessTokenStoreProvider),
    refreshCoordinator: ref.watch(refreshCoordinatorProvider),
    logger: ref.watch(safeLoggerProvider),
    dio: ref.watch(apiDioProvider),
  ),
);
final authenticationRepositoryProvider = Provider<AuthenticationRepository>(
  (ref) => AuthenticationRepositoryImpl(
    AuthenticationApi(ref.watch(apiClientProvider)),
  ),
);
final authenticationSessionManagerProvider =
    Provider<AuthenticationSessionManager>(
      (ref) => AuthenticationSessionManager(
        secureStore: ref.watch(secureStoreProvider),
        accessTokens: ref.watch(accessTokenStoreProvider),
        refreshCoordinator: ref.watch(refreshCoordinatorProvider),
        repository: ref.watch(authenticationRepositoryProvider),
      ),
    );
final authenticationControllerProvider = Provider<AuthenticationController>((
  ref,
) {
  final controller = AuthenticationController(
    repository: ref.watch(authenticationRepositoryProvider),
    sessionManager: ref.watch(authenticationSessionManagerProvider),
    apiClient: ref.watch(apiClientProvider),
  );
  ref.onDispose(controller.dispose);
  return controller;
});
