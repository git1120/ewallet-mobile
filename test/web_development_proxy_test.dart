import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../tool/web_dev_proxy_validator.dart';

void main() {
  test('repository proxy is deterministic, local, and API-only', () {
    final root = Directory.current;
    final config = File('${root.path}/web_dev_config.yaml');
    expect(config.existsSync(), isTrue);
    expect(WebDevProxyValidator(root).validate(), isEmpty);

    final source = config.readAsStringSync();
    expect(source, contains('host: "127.0.0.1"'));
    expect(source, contains('port: 8080'));
    expect(source, contains('target: "http://74.118.81.141/"'));
    expect(source, contains('prefix: "/api/"'));
    expect(source, isNot(contains('replace:')));
    expect(source, contains('value: "no-cache, no-store, must-revalidate"'));
  });
}
