import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iba_ewallet/app/app.dart';
import 'package:iba_ewallet/core/config/environment.dart';
import 'package:iba_ewallet/design_system/buttons/iba_buttons.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('Dari and Pashto use RTL', (tester) async {
    for (final locale in const [Locale('fa'), Locale('ps')]) {
      await tester.pumpWidget(testApp(const Text('متن'), locale: locale));
      await tester.pump();
      expect(
        Directionality.of(tester.element(find.text('متن'))),
        TextDirection.rtl,
      );
    }
  });

  testWidgets('English uses LTR', (tester) async {
    await tester.pumpWidget(testApp(const Text('Text')));
    expect(
      Directionality.of(tester.element(find.text('Text'))),
      TextDirection.ltr,
    );
  });

  testWidgets('components remain usable at 200 percent text scale', (
    tester,
  ) async {
    await tester.pumpWidget(
      testApp(
        IbaButton(
          label: 'A deliberately long accessible label',
          onPressed: () {},
        ),
        textScale: 2,
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.text('A deliberately long accessible label'), findsOneWidget);
  });

  testWidgets('development app opens localized login', (tester) async {
    await tester.pumpWidget(
      IbaApp(
        config: EnvironmentConfig.forEnvironment(AppEnvironment.development),
        preferences: MemoryPreferences(),
        secureStore: MemorySecureStore(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('production has no gallery route', (tester) async {
    await tester.pumpWidget(
      IbaApp(
        config: EnvironmentConfig.forEnvironment(AppEnvironment.production),
        preferences: MemoryPreferences(),
        secureStore: MemorySecureStore(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Component gallery'), findsNothing);
    expect(find.text('Welcome back'), findsOneWidget);
  });
}
