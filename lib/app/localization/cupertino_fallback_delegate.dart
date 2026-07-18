import 'package:flutter/cupertino.dart';

/// Flutter does not ship Pashto Cupertino strings. The application uses
/// Material components, so this delegate supplies Cupertino's neutral fallback
/// while declaring all app locales supported.
class CupertinoFallbackDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const CupertinoFallbackDelegate();

  @override
  bool isSupported(Locale locale) =>
      const {'en', 'fa', 'ps'}.contains(locale.languageCode);

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      DefaultCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(CupertinoFallbackDelegate old) => false;
}
