import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iba_ewallet/core/theme/tokens.dart';
import 'package:iba_ewallet/design_system/inputs/iba_fields.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('text field exposes disabled, read-only, and error states', (
    tester,
  ) async {
    await tester.pumpWidget(
      testApp(
        const Column(
          children: [
            IbaTextField(label: 'Read', readOnly: true),
            IbaTextField(label: 'Disabled', enabled: false),
            IbaTextField(label: 'Error', errorText: 'Invalid'),
          ],
        ),
      ),
    );
    expect(find.text('Invalid'), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField).at(0)).readOnly,
      true,
    );
    expect(
      tester.widget<TextField>(find.byType(TextField).at(1)).enabled,
      false,
    );
  });

  testWidgets('phone field keeps digits and limits length', (tester) async {
    final controller = TextEditingController();
    await tester.pumpWidget(
      testApp(IbaPhoneField(label: 'Phone', controller: controller)),
    );
    await tester.enterText(find.byType(TextField), '+93 (702) 468-109999');
    expect(controller.text, '937024681099');
  });

  testWidgets(
    'external phone label and country indicator keep one focus ring',
    (tester) async {
      await tester.pumpWidget(
        testApp(
          const IbaPhoneField(
            label: 'Phone',
            externalLabel: true,
            countryIndicator: Icon(Icons.flag_outlined),
          ),
        ),
      );

      expect(find.text('Phone'), findsOneWidget);
      expect(find.byIcon(Icons.flag_outlined), findsOneWidget);
      await tester.tap(find.byType(TextField));
      await tester.pump();
      expect(tester.testTextInput.hasAnyClients, isTrue);
      final theme = Theme.of(tester.element(find.byType(TextField)));
      final border =
          theme.inputDecorationTheme.focusedBorder! as OutlineInputBorder;
      expect(border.borderSide.color, IbaColors.green);
      expect(border.borderSide.width, 2);
    },
  );

  testWidgets('amount field allows two decimal places', (tester) async {
    final controller = TextEditingController();
    await tester.pumpWidget(
      testApp(IbaAmountField(label: 'Amount', controller: controller)),
    );
    await tester.enterText(find.byType(TextField), '123.456');
    expect(controller.text, '123.45');
  });

  testWidgets('PIN is obscured and numeric', (tester) async {
    final controller = TextEditingController();
    await tester.pumpWidget(
      testApp(IbaPinField(label: 'PIN', controller: controller)),
    );
    expect(tester.widget<TextField>(find.byType(TextField)).obscureText, true);
    await tester.enterText(find.byType(TextField), '24a68109');
    expect(controller.text, '246810');
  });

  testWidgets('OTP calls completion after all cells are entered', (
    tester,
  ) async {
    String? completed;
    await tester.pumpWidget(
      testApp(
        IbaOtpInput(
          label: 'OTP',
          length: 4,
          onCompleted: (value) => completed = value,
        ),
      ),
    );
    for (var index = 0; index < 4; index++) {
      await tester.enterText(
        find.byKey(ValueKey('otp-$index')),
        '${index + 1}',
      );
    }
    expect(completed, '1234');
  });
}
