import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/agent_rules_validator.dart';

void main() {
  late Directory root;

  setUp(() {
    root = Directory.systemTemp.createTempSync('agent-rules-');
  });

  tearDown(() {
    root.deleteSync(recursive: true);
  });

  test('reports high-confidence violations with file and line', () {
    _write(
      root,
      'lib/features/payment/page.dart',
      [
        "import '../../../api/client.dart';",
        'void unsafe() {',
        "  print('otp');",
        "  final dio = Dio();",
        '  const color = Color(0xFF000000);',
        '  const padding = EdgeInsets.only(top: 4, left: 8);',
        '}',
      ].join('\n'),
    );

    final violations = AgentRulesValidator(root: root).scan();

    expect(
      violations.map((item) => item.rule),
      containsAll({
        AgentRule.siblingImport,
        AgentRule.printCall,
        AgentRule.credentialLogging,
        AgentRule.directDio,
        AgentRule.rawColor,
        AgentRule.physicalInsets,
      }),
    );
    expect(
      violations.singleWhere((item) => item.rule == AgentRule.directDio).line,
      4,
    );
  });

  test(
    'default allowlist and generated-file exclusion prevent false reports',
    () {
      _write(root, 'lib/core/api/api_client.dart', 'final dio = Dio();');
      _write(
        root,
        'lib/core/theme/tokens.dart',
        'const color = Color(0xFF000000);',
      );
      _write(
        root,
        'lib/app/localization/generated/messages.dart',
        'void generated() { print("generated"); }',
      );

      final violations = AgentRulesValidator(
        root: root,
        allowlist: defaultAgentRuleAllowlist(),
      ).scan();

      expect(violations, isEmpty);
    },
  );

  test('supports an explicit path and rule allowlist', () {
    _write(root, 'lib/features/debug_probe.dart', 'void probe() { print(1); }');

    final violations = AgentRulesValidator(
      root: root,
      allowlist: AgentRuleAllowlist({
        'lib/features/debug_probe.dart': {AgentRule.printCall},
      }),
    ).scan();

    expect(violations, isEmpty);
  });

  test('finds merge markers outside Dart files', () {
    final marker = List.filled(7, '<').join();
    _write(root, 'docs/note.md', '$marker branch\ncontent');

    final violations = AgentRulesValidator(root: root).scan();

    expect(violations.single.rule, AgentRule.mergeConflict);
    expect(violations.single.line, 1);
  });

  test('reports a retired temp directory', () {
    Directory('${root.path}/temp').createSync();

    final violations = AgentRulesValidator(root: root).scan();

    expect(
      violations
          .singleWhere((item) => item.rule == AgentRule.designReference)
          .path,
      'temp',
    );
  });
}

void _write(Directory root, String relativePath, String content) {
  final file = File('${root.path}/$relativePath');
  file.parent.createSync(recursive: true);
  file.writeAsStringSync(content);
}
