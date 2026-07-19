import 'dart:io';

final class WebDevProxyViolation {
  const WebDevProxyViolation(this.path, this.message);

  final String path;
  final String message;

  @override
  String toString() => '$path:1 [web-development-proxy] $message';
}

final class WebDevProxyValidator {
  const WebDevProxyValidator(this.root);

  static const approvedTarget = 'http://74.118.81.141/';
  static const approvedPrefix = '/api/';

  final Directory root;

  List<WebDevProxyViolation> validate() {
    final violations = <WebDevProxyViolation>[];
    final config = File('${root.path}/web_dev_config.yaml');
    if (!config.existsSync()) {
      return const [
        WebDevProxyViolation(
          'web_dev_config.yaml',
          'The repository web development proxy configuration is missing.',
        ),
      ];
    }

    final source = config.readAsStringSync();
    final targets = _yamlValues(source, 'target');
    final prefixes = _yamlValues(source, 'prefix');
    final regexRules = _yamlValues(source, 'regex');
    if (targets.length != 1 || targets.singleOrNull != approvedTarget) {
      violations.add(
        const WebDevProxyViolation(
          'web_dev_config.yaml',
          'Exactly one proxy target must use the approved development backend.',
        ),
      );
    }
    if (prefixes.length != 1 || prefixes.singleOrNull != approvedPrefix) {
      violations.add(
        const WebDevProxyViolation(
          'web_dev_config.yaml',
          'Exactly one proxy prefix must be restricted to /api/.',
        ),
      );
    }
    if (regexRules.isNotEmpty ||
        prefixes.any((prefix) => prefix == '/' || prefix.contains('*'))) {
      violations.add(
        const WebDevProxyViolation(
          'web_dev_config.yaml',
          'Wildcard and arbitrary-path proxy rules are prohibited.',
        ),
      );
    }

    final unsafeFlag = ['--disable', '-web-security'].join();
    for (final entity in root.listSync(recursive: true, followLinks: false)) {
      if (entity is! File) continue;
      final relative = _relativePath(entity.path);
      if (_excludedPath.hasMatch(relative) || !_isTextFile(relative)) continue;
      if (entity.readAsStringSync().contains(unsafeFlag)) {
        violations.add(
          WebDevProxyViolation(
            relative,
            'Unsafe browser-security flags are prohibited.',
          ),
        );
      }
    }
    return violations;
  }

  static final _excludedPath = RegExp(
    r'(^|/)(build|\.dart_tool|\.git|generated)(/|$)',
  );
  static const _textExtensions = {
    '.dart',
    '.md',
    '.yaml',
    '.yml',
    '.json',
    '.arb',
    '.sh',
    '.xml',
  };

  static List<String> _yamlValues(String source, String key) {
    final pattern = RegExp(
      '^\\s*(?:-\\s*)?$key\\s*:\\s*["\\\']?([^"\\\'#\\s]+)["\\\']?\\s*\$',
      multiLine: true,
    );
    return [for (final match in pattern.allMatches(source)) match.group(1)!];
  }

  static bool _isTextFile(String path) =>
      _textExtensions.any(path.endsWith) ||
      path.endsWith('AGENTS.md') ||
      path.endsWith('CLAUDE.md');

  String _relativePath(String path) {
    return File(path).absolute.path
        .substring(root.absolute.path.length)
        .replaceFirst(RegExp(r'^[/\\]'), '')
        .replaceAll(Platform.pathSeparator, '/');
  }
}

extension<T> on List<T> {
  T? get singleOrNull => length == 1 ? single : null;
}
