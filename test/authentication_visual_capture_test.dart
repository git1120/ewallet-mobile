import 'dart:io';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iba_ewallet/app/session/access_token_store.dart';
import 'package:iba_ewallet/app/session/authentication_session_manager.dart';
import 'package:iba_ewallet/app/session/refresh_coordinator.dart';
import 'package:iba_ewallet/core/api/api_client.dart';
import 'package:iba_ewallet/core/config/environment.dart';
import 'package:iba_ewallet/core/logging/safe_logger.dart';
import 'package:iba_ewallet/core/storage/secure_storage.dart';
import 'package:iba_ewallet/features/authentication/application/authentication_controller.dart';
import 'package:iba_ewallet/features/authentication/domain/authentication_repository.dart';
import 'package:iba_ewallet/features/authentication/domain/authentication_session.dart';
import 'package:iba_ewallet/features/authentication/presentation/authentication_login_page.dart';

import 'test_helpers.dart';

const _captureVisuals = bool.fromEnvironment('CAPTURE_AUTH_VISUALS');
const _sessionId = '123e4567-e89b-42d3-a456-426614174000';
const _session = AuthenticationSession(
  accessToken: 'access',
  refreshToken: 'refresh',
  tokenType: 'Bearer',
  sessionId: _sessionId,
);

void main() {
  _captureCase(
    name: 'capture mobile EN LTR evidence',
    locale: const Locale('en'),
    pinEntry: false,
    filename: 'mobile-entry-412x915-en-ltr.png',
  );
  _captureCase(
    name: 'capture PIN EN LTR evidence',
    locale: const Locale('en'),
    pinEntry: true,
    filename: 'pin-entry-412x915-en-ltr.png',
  );
  _captureCase(
    name: 'capture mobile FA RTL evidence',
    locale: const Locale('fa'),
    pinEntry: false,
    filename: 'mobile-entry-412x915-fa-rtl.png',
  );
  _captureCase(
    name: 'capture PIN FA RTL evidence',
    locale: const Locale('fa'),
    pinEntry: true,
    filename: 'pin-entry-412x915-fa-rtl.png',
  );
}

void _captureCase({
  required String name,
  required Locale locale,
  required bool pinEntry,
  required String filename,
}) {
  testWidgets(name, (tester) async {
    tester.view.physicalSize = const Size(412, 915);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await _loadFonts();
    await _capture(
      tester,
      locale: locale,
      pinEntry: pinEntry,
      filename: filename,
    );
  }, skip: !_captureVisuals);
}

var _fontsLoaded = false;

Future<void> _loadFonts() async {
  if (_fontsLoaded) return;
  final inter = FontLoader('Inter')
    ..addFont(rootBundle.load('assets/fonts/Inter-Variable.ttf'));
  final naskh = FontLoader('NotoNaskhArabic')
    ..addFont(rootBundle.load('assets/fonts/NotoNaskhArabic-Variable.ttf'));
  final icons = FontLoader('MaterialIcons')
    ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
  await Future.wait([inter.load(), naskh.load(), icons.load()]);
  _fontsLoaded = true;
}

Future<void> _capture(
  WidgetTester tester, {
  required Locale locale,
  required bool pinEntry,
  required String filename,
}) async {
  final boundaryKey = GlobalKey();
  final controller = await _controller();
  await tester.pumpWidget(
    testApp(
      RepaintBoundary(
        key: boundaryKey,
        child: AuthenticationLoginPage(controller: controller),
      ),
      locale: locale,
      wrapInScaffold: false,
    ),
  );
  await tester.pumpAndSettle();

  if (pinEntry) {
    await tester.enterText(
      find.byKey(const ValueKey('auth-mobile-field')),
      '0702468109',
    );
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('auth-continue')));
    await tester.pumpAndSettle();
  }

  final boundary =
      boundaryKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  boundary.markNeedsPaint();
  await tester.pump();
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 1);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    final directory = Directory(
      'artifacts/visual-validation/authentication/flow-auth-entry-v1/'
      'implementation',
    );
    await directory.create(recursive: true);
    await File(
      '${directory.path}/$filename',
    ).writeAsBytes(bytes!.buffer.asUint8List(), flush: true);
  });
}

Future<AuthenticationController> _controller() async {
  final repository = _VisualRepository();
  final tokens = AccessTokenStore();
  final coordinator = RefreshCoordinator();
  final manager = AuthenticationSessionManager(
    secureStore: _VisualSecureStore(),
    accessTokens: tokens,
    refreshCoordinator: coordinator,
    repository: repository,
  );
  final controller = AuthenticationController(
    repository: repository,
    sessionManager: manager,
    apiClient: ApiClient(
      config: EnvironmentConfig.forEnvironment(AppEnvironment.development),
      accessTokenSource: tokens,
      refreshCoordinator: coordinator,
      logger: SafeLogger(enabled: false),
      dio: Dio(),
    ),
  );
  await controller.restore();
  return controller;
}

final class _VisualRepository implements AuthenticationRepository {
  @override
  Future<bool> confirmSession({
    required String sessionId,
    CancelToken? cancelToken,
  }) async => true;

  @override
  Future<AuthenticationSession> login({
    required String mobileNumber,
    required String pin,
    CancelToken? cancelToken,
  }) async => _session;

  @override
  Future<void> logout({CancelToken? cancelToken}) async {}

  @override
  Future<AuthenticationSession> refresh({
    required String refreshToken,
    CancelToken? cancelToken,
  }) async => _session;
}

// Kept local so capture evidence never reads a platform credential store.
final class _VisualSecureStore implements SecureStore {
  final values = <String, String>{};

  @override
  Future<void> clear() async => values.clear();

  @override
  Future<void> delete(String key) async => values.remove(key);

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async => values[key] = value;
}
