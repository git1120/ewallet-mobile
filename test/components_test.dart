import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iba_ewallet/design_system/design_system.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('brand mark renders approved standard and white assets', (
    tester,
  ) async {
    await tester.pumpWidget(
      testApp(
        const Column(
          children: [
            IbaBrandMark(semanticLabel: 'IBA E-Wallet'),
            IbaBrandMark(
              variant: IbaBrandMarkVariant.white,
              semanticLabel: 'IBA E-Wallet white',
            ),
          ],
        ),
      ),
    );

    final images = tester.widgetList<Image>(find.byType(Image)).toList();
    expect(
      (images[0].image as AssetImage).assetName,
      IbaBrandMark.standardAsset,
    );
    expect((images[1].image as AssetImage).assetName, IbaBrandMark.whiteAsset);
    expect(images.every((image) => image.fit == BoxFit.contain), isTrue);
  });

  testWidgets('brand mark preserves aspect ratio and semantic intent', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      testApp(const IbaBrandMark(semanticLabel: 'IBA E-Wallet', width: 146.3)),
    );
    await tester.pumpAndSettle();

    final size = tester.getSize(find.byType(Image));
    expect(size.width / size.height, closeTo(1463 / 1447, 0.01));
    expect(find.bySemanticsLabel('IBA E-Wallet'), findsOneWidget);

    await tester.pumpWidget(
      testApp(const IbaBrandMark(width: 56, decorative: true)),
    );
    expect(find.bySemanticsLabel('IBA E-Wallet'), findsNothing);
    semantics.dispose();
  });

  testWidgets('button handles tap, loading, disabled, and touch size', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      testApp(
        Column(
          children: [
            IbaButton(label: 'Continue', onPressed: () => taps++),
            IbaButton(label: 'Loading', loading: true, onPressed: () {}),
            const IbaButton(label: 'Disabled', onPressed: null),
          ],
        ),
      ),
    );
    await tester.tap(find.text('Continue'));
    expect(taps, 1);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(
      tester.getSize(find.byType(FilledButton).first).height,
      greaterThanOrEqualTo(48),
    );
  });

  testWidgets('alerts combine semantic icon and message', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      testApp(
        const IbaAlertBanner(
          message: 'Attention required',
          status: IbaStatus.warning,
        ),
      ),
    );
    expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
    expect(find.text('Attention required'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('empty, error, and loading states render actions', (
    tester,
  ) async {
    await tester.pumpWidget(
      testApp(
        Column(
          children: [
            const IbaEmptyState(title: 'Empty', message: 'No items'),
            IbaErrorState(
              title: 'Error',
              message: 'Failed',
              actionLabel: 'Retry',
              onRetry: () {},
            ),
            const IbaLoadingState(label: 'Loading'),
          ],
        ),
      ),
    );
    expect(find.text('Empty'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('account card masks data supplied by caller and is tappable', (
    tester,
  ) async {
    var tapped = false;
    await tester.pumpWidget(
      testApp(
        IbaAccountCard(
          name: 'Account',
          maskedNumber: '•••• 1234',
          balance: '100.00',
          currency: 'AFN',
          onTap: () => tapped = true,
        ),
      ),
    );
    expect(find.text('•••• 1234'), findsOneWidget);
    await tester.tap(find.byType(InkWell));
    expect(tapped, isTrue);
  });

  testWidgets('transaction summary emphasizes total', (tester) async {
    await tester.pumpWidget(
      testApp(
        const IbaTransactionSummary(
          title: 'Transfer',
          rows: {'Amount': '100 AFN', 'Fee': '2 AFN'},
          totalLabel: 'Total',
          total: '102 AFN',
        ),
      ),
    );
    expect(find.text('102 AFN'), findsOneWidget);
    expect(
      tester.widget<Text>(find.text('102 AFN')).style?.fontWeight,
      FontWeight.w700,
    );
  });
}
