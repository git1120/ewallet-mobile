import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:iba_ewallet/app/app.dart';
import 'package:iba_ewallet/core/config/environment.dart';
import 'package:iba_ewallet/core/storage/preferences_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> bootstrap() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      final config = EnvironmentConfig.fromDefines();
      final preferences = SharedPreferencesStore(
        await SharedPreferences.getInstance(),
      );
      FlutterError.onError = FlutterError.presentError;
      runApp(IbaApp(config: config, preferences: preferences));
    },
    (error, stackTrace) {
      // A crash reporter can be attached here. Never include sensitive state.
      FlutterError.reportError(
        FlutterErrorDetails(exception: error, stack: stackTrace),
      );
    },
  );
}
