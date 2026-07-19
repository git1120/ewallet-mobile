enum AppEnvironment { development, staging, production }

final class EnvironmentConfig {
  const EnvironmentConfig._({
    required this.environment,
    required this.apiBaseUrl,
    required this.connectTimeout,
    required this.receiveTimeout,
    required this.enableLogging,
    required this.enableComponentGallery,
  });

  factory EnvironmentConfig.fromDefines() {
    const name = String.fromEnvironment('APP_ENV', defaultValue: 'development');
    const url = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://74.118.81.141',
    );
    final environment = AppEnvironment.values.firstWhere(
      (value) => value.name == name,
      orElse: () => throw ArgumentError.value(name, 'APP_ENV'),
    );
    return EnvironmentConfig.forEnvironment(environment, apiBaseUrl: url);
  }

  factory EnvironmentConfig.forEnvironment(
    AppEnvironment environment, {
    String? apiBaseUrl,
  }) {
    final url =
        apiBaseUrl ??
        switch (environment) {
          AppEnvironment.development => 'http://74.118.81.141',
          AppEnvironment.staging => 'https://staging-api.iba.example',
          AppEnvironment.production => 'https://api.iba.example',
        };
    final parsed = Uri.tryParse(url);
    if (parsed == null || !parsed.hasScheme || !parsed.hasAuthority) {
      throw ArgumentError.value(url, 'apiBaseUrl', 'Must be an absolute URL');
    }
    if (environment == AppEnvironment.production &&
        (parsed.scheme != 'https' ||
            parsed.host == 'localhost' ||
            parsed.host.startsWith('127.') ||
            parsed.host == '74.118.81.141' ||
            parsed.host.contains('staging') ||
            parsed.host.contains('dev'))) {
      throw StateError('Production requires a production HTTPS API URL.');
    }
    return EnvironmentConfig._(
      environment: environment,
      apiBaseUrl: parsed,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      enableLogging: environment != AppEnvironment.production,
      enableComponentGallery: environment == AppEnvironment.development,
    );
  }

  final AppEnvironment environment;
  final Uri apiBaseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final bool enableLogging;
  final bool enableComponentGallery;
}
