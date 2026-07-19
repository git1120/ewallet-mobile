import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iba_ewallet/app/localization/cupertino_fallback_delegate.dart';
import 'package:iba_ewallet/app/localization/generated/app_localizations.dart';
import 'package:iba_ewallet/core/config/environment.dart';
import 'package:iba_ewallet/core/storage/preferences_store.dart';
import 'package:iba_ewallet/core/storage/secure_storage.dart';
import 'package:iba_ewallet/core/theme/iba_theme.dart';
import 'package:iba_ewallet/features/authentication/application/authentication_controller.dart';
import 'package:iba_ewallet/features/authentication/application/authentication_providers.dart';
import 'package:iba_ewallet/features/authentication/domain/authentication_state.dart';
import 'package:iba_ewallet/features/authentication/presentation/authentication_login_page.dart';
import 'package:iba_ewallet/features/authentication/presentation/authentication_state_pages.dart';
import 'package:iba_ewallet/features/component_gallery/component_gallery_page.dart';

class IbaApp extends StatelessWidget {
  const IbaApp({
    required this.config,
    required this.preferences,
    this.secureStore,
    this.dio,
    super.key,
  });

  final EnvironmentConfig config;
  final PreferencesStore preferences;
  final SecureStore? secureStore;
  final Dio? dio;

  @override
  Widget build(BuildContext context) => ProviderScope(
    overrides: [
      environmentProvider.overrideWithValue(config),
      preferencesProvider.overrideWithValue(preferences),
      if (secureStore != null)
        secureStoreProvider.overrideWithValue(secureStore!),
      if (dio != null) apiDioProvider.overrideWithValue(dio),
    ],
    child: _IbaAppView(config: config, preferences: preferences),
  );
}

class _IbaAppView extends ConsumerStatefulWidget {
  const _IbaAppView({required this.config, required this.preferences});

  final EnvironmentConfig config;
  final PreferencesStore preferences;

  @override
  ConsumerState<_IbaAppView> createState() => _IbaAppViewState();
}

class _IbaAppViewState extends ConsumerState<_IbaAppView> {
  static const _localeKey = 'preferred_locale';
  static const supportedLocales = [Locale('en'), Locale('fa'), Locale('ps')];

  late Locale _locale;
  var _largeText = false;
  late final AuthenticationController _authentication;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    final saved = widget.preferences.getString(_localeKey);
    _locale = supportedLocales.firstWhere(
      (locale) => locale.languageCode == saved,
      orElse: () => const Locale('en'),
    );
    _authentication = ref.read(authenticationControllerProvider);
    _router = GoRouter(
      initialLocation: '/',
      refreshListenable: _authentication,
      redirect: _redirect,
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const AuthenticationBootstrapPage(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) =>
              AuthenticationLoginPage(controller: _authentication),
        ),
        GoRoute(
          path: '/session-ended',
          builder: (context, state) =>
              AuthenticationTerminalPage(controller: _authentication),
        ),
        GoRoute(
          path: '/authenticated',
          builder: (context, state) =>
              AuthenticatedPlaceholderPage(controller: _authentication),
        ),
        if (widget.config.enableComponentGallery)
          GoRoute(
            path: '/gallery',
            builder: (context, state) => ComponentGalleryPage(
              locale: _locale,
              largeText: _largeText,
              onLocaleChanged: _setLocale,
              onLargeTextChanged: (value) {
                setState(() => _largeText = value);
              },
            ),
          ),
      ],
    );
    unawaited(Future<void>.microtask(_authentication.restore));
  }

  String? _redirect(BuildContext context, GoRouterState routerState) {
    final location = routerState.matchedLocation;
    if (widget.config.enableComponentGallery && location == '/gallery') {
      return null;
    }
    final state = _authentication.state;
    if (state.isBootstrapping) return location == '/' ? null : '/';
    if (state.session == SessionStatus.loggingOut) {
      return location == '/authenticated' ? null : '/authenticated';
    }
    if (state.session == SessionStatus.terminal) {
      return location == '/session-ended' ? null : '/session-ended';
    }
    if (state.isAuthenticated) {
      return location == '/authenticated' ? null : '/authenticated';
    }
    return location == '/login' ? null : '/login';
  }

  Future<void> _setLocale(Locale locale) async {
    setState(() => _locale = locale);
    await widget.preferences.setString(_localeKey, locale.languageCode);
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
    debugShowCheckedModeBanner: false,
    locale: _locale,
    supportedLocales: supportedLocales,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      CupertinoFallbackDelegate(),
    ],
    theme: IbaTheme.light(locale: _locale),
    routerConfig: _router,
    builder: (context, child) {
      final media = MediaQuery.of(context);
      return MediaQuery(
        data: media.copyWith(textScaler: TextScaler.linear(_largeText ? 2 : 1)),
        child: child!,
      );
    },
  );
}
