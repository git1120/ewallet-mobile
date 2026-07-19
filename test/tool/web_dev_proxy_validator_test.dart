import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/web_dev_proxy_validator.dart';

void main() {
  late Directory root;

  setUp(() {
    root = Directory.systemTemp.createTempSync('web-dev-proxy-');
  });

  tearDown(() {
    root.deleteSync(recursive: true);
  });

  test('accepts the restricted approved proxy', () {
    _write(root, 'web_dev_config.yaml', '''
server:
  host: "127.0.0.1"
  port: 8080
  proxy:
    - target: "http://74.118.81.141/"
      prefix: "/api/"
''');

    expect(WebDevProxyValidator(root).validate(), isEmpty);
  });

  test('rejects missing, arbitrary, duplicate, and unsafe proxy setup', () {
    expect(WebDevProxyValidator(root).validate(), hasLength(1));
    _write(root, 'web_dev_config.yaml', '''
server:
  proxy:
    - target: "http://unapproved.example/"
      prefix: "/"
    - target: "http://74.118.81.141/"
      regex: ".*"
''');
    _write(
      root,
      'tool/unsafe.sh',
      [
        'chrome ',
        ['--disable', '-web-security'].join(),
      ].join(),
    );

    final violations = WebDevProxyValidator(root).validate();
    expect(violations, hasLength(4));
    expect(
      violations.map((violation) => violation.message),
      contains('Unsafe browser-security flags are prohibited.'),
    );
  });
}

void _write(Directory root, String relativePath, String content) {
  final file = File('${root.path}/$relativePath');
  file.parent.createSync(recursive: true);
  file.writeAsStringSync(content);
}
