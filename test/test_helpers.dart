import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:iba_ewallet/app/localization/cupertino_fallback_delegate.dart';
import 'package:iba_ewallet/app/localization/generated/app_localizations.dart';
import 'package:iba_ewallet/core/storage/preferences_store.dart';
import 'package:iba_ewallet/core/theme/iba_theme.dart';

class MemoryPreferences implements PreferencesStore {
  final values = <String, String>{};

  @override
  String? getString(String key) => values[key];

  @override
  Future<void> setString(String key, String value) async {
    values[key] = value;
  }
}

Widget testApp(
  Widget child, {
  Locale locale = const Locale('en'),
  double textScale = 1,
}) => MaterialApp(
  locale: locale,
  supportedLocales: const [Locale('en'), Locale('fa'), Locale('ps')],
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    CupertinoFallbackDelegate(),
  ],
  theme: IbaTheme.light(locale: locale),
  builder: (context, appChild) => MediaQuery(
    data: MediaQuery.of(
      context,
    ).copyWith(textScaler: TextScaler.linear(textScale)),
    child: appChild!,
  ),
  home: Scaffold(body: SingleChildScrollView(child: child)),
);
