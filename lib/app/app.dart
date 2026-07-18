import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:iba_ewallet/app/localization/cupertino_fallback_delegate.dart';
import 'package:iba_ewallet/app/localization/generated/app_localizations.dart';
import 'package:iba_ewallet/core/config/environment.dart';
import 'package:iba_ewallet/core/storage/preferences_store.dart';
import 'package:iba_ewallet/core/theme/iba_theme.dart';
import 'package:iba_ewallet/design_system/navigation/iba_navigation.dart';
import 'package:iba_ewallet/features/component_gallery/component_gallery_page.dart';

class IbaApp extends StatefulWidget {
  const IbaApp({required this.config, required this.preferences, super.key});

  final EnvironmentConfig config;
  final PreferencesStore preferences;

  @override
  State<IbaApp> createState() => _IbaAppState();
}

class _IbaAppState extends State<IbaApp> {
  static const _localeKey = 'preferred_locale';
  static const supportedLocales = [Locale('en'), Locale('fa'), Locale('ps')];

  late Locale _locale;
  var _largeText = false;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    final saved = widget.preferences.getString(_localeKey);
    _locale = supportedLocales.firstWhere(
      (locale) => locale.languageCode == saved,
      orElse: () => const Locale('en'),
    );
    _router = GoRouter(
      initialLocation: widget.config.enableComponentGallery ? '/gallery' : '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const _FoundationPage(),
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

class _FoundationPage extends StatelessWidget {
  const _FoundationPage();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return IbaPageScaffold(
      title: l10n.appName,
      body: Center(child: Text(l10n.foundationReady)),
    );
  }
}
