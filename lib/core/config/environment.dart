import 'package:flutter/foundation.dart';

import 'environment_defaults_native.dart'
    if (dart.library.js_interop) 'environment_defaults_web.dart'
    as platform_defaults;

enum AppEnvironment { development, staging, production }

final class EnvironmentConfig {
  const EnvironmentConfig._({
    required this.environment,
    required this.apiBaseUrl,
    required this.connectTimeout,
    required this.receiveTimeout,
    required this.enableLogging,
    required this.enableComponentGallery,
    required this.usesWebDevelopmentProxy,
  });

  factory EnvironmentConfig.fromDefines() {
    const name = String.fromEnvironment('APP_ENV', defaultValue: 'development');
    const url = String.fromEnvironment('API_BASE_URL');
    final environment = AppEnvironment.values.firstWhere(
      (value) => value.name == name,
      orElse: () => throw ArgumentError.value(name, 'APP_ENV'),
    );
    return EnvironmentConfig.forEnvironment(
      environment,
      apiBaseUrl: url.isEmpty ? null : url,
      isWeb: kIsWeb,
    );
  }

  factory EnvironmentConfig.forEnvironment(
    AppEnvironment environment, {
    String? apiBaseUrl,
    bool isWeb = false,
  }) {
    final usesWebDevelopmentProxy =
        environment == AppEnvironment.development &&
        isWeb &&
        apiBaseUrl == null;
    final url = switch ((environment, usesWebDevelopmentProxy, apiBaseUrl)) {
      (AppEnvironment.development, true, null) => '',
      (AppEnvironment.development, false, null) =>
        platform_defaults.developmentApiBaseUrl,
      (_, _, final String explicitUrl) => explicitUrl,
      _ => throw StateError(
        '${environment.name} requires an explicit HTTPS API URL.',
      ),
    };
    final parsed = Uri.tryParse(url);
    if (usesWebDevelopmentProxy) {
      return EnvironmentConfig._(
        environment: environment,
        apiBaseUrl: Uri(),
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        enableLogging: true,
        enableComponentGallery: true,
        usesWebDevelopmentProxy: true,
      );
    }
    if (parsed == null ||
        !parsed.hasScheme ||
        !parsed.hasAuthority ||
        (parsed.path.isNotEmpty && parsed.path != '/') ||
        parsed.hasQuery ||
        parsed.hasFragment) {
      throw ArgumentError.value(url, 'apiBaseUrl', 'Must be an absolute URL');
    }
    if (environment != AppEnvironment.development) {
      _validateSecureRemoteUrl(environment, parsed);
    }
    return EnvironmentConfig._(
      environment: environment,
      apiBaseUrl: parsed.replace(path: ''),
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      enableLogging: environment != AppEnvironment.production,
      enableComponentGallery: environment == AppEnvironment.development,
      usesWebDevelopmentProxy: false,
    );
  }

  final AppEnvironment environment;
  final Uri apiBaseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final bool enableLogging;
  final bool enableComponentGallery;
  final bool usesWebDevelopmentProxy;

  String get dioBaseUrl => apiBaseUrl.toString();

  Uri resolveApiEndpoint(String endpoint) {
    if (!endpoint.startsWith('/api/')) {
      throw ArgumentError.value(
        endpoint,
        'endpoint',
        'API endpoints must start with /api/',
      );
    }
    return Uri.parse('$dioBaseUrl$endpoint');
  }

  static void _validateSecureRemoteUrl(AppEnvironment environment, Uri parsed) {
    final host = parsed.host.toLowerCase();
    final isLoopback =
        host == 'localhost' ||
        host == '::1' ||
        host == '0:0:0:0:0:0:0:1' ||
        host.startsWith('127.');
    final isProductionLabel =
        !host.contains('staging') && !host.contains('dev');
    if (parsed.scheme != 'https' ||
        isLoopback ||
        _isDeployedDevelopmentHost(host) ||
        (environment == AppEnvironment.production && !isProductionLabel)) {
      throw StateError(
        '${environment.name} requires a secure remote HTTPS API URL.',
      );
    }
  }

  static bool _isDeployedDevelopmentHost(String host) {
    final segments = host.split('.');
    return segments.length == 4 &&
        segments[0] == '74' &&
        segments[1] == '118' &&
        segments[2] == '81' &&
        segments[3] == '141';
  }
}
