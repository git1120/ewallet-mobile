import 'dart:io';

import 'design_reference_manifest.dart';

enum AgentRule {
  directDio('direct-dio'),
  printCall('print'),
  debugPrintCall('debug-print'),
  sharedPreferences('shared-preferences'),
  physicalInsets('physical-insets'),
  physicalAlignment('physical-alignment'),
  rawColor('raw-color'),
  authorizationLogging('authorization-logging'),
  credentialLogging('credential-logging'),
  developmentUrl('development-url'),
  siblingImport('sibling-import'),
  mergeConflict('merge-conflict'),
  designReference('design-reference');

  const AgentRule(this.id);
  final String id;

  static AgentRule? fromId(String value) {
    for (final rule in values) {
      if (rule.id == value) return rule;
    }
    return null;
  }
}

final class AgentRuleViolation {
  const AgentRuleViolation({
    required this.rule,
    required this.path,
    required this.line,
    required this.message,
  });

  final AgentRule rule;
  final String path;
  final int line;
  final String message;

  @override
  String toString() => '$path:$line [${rule.id}] $message';
}

final class AgentRuleAllowlist {
  AgentRuleAllowlist([Map<String, Set<AgentRule>> entries = const {}])
    : _entries = {
        for (final entry in entries.entries)
          _normalize(entry.key): Set<AgentRule>.of(entry.value),
      };

  final Map<String, Set<AgentRule>> _entries;

  bool allows(String path, AgentRule rule) {
    final normalized = _normalize(path);
    return _entries.entries.any(
      (entry) =>
          (normalized == entry.key || normalized.startsWith('${entry.key}/')) &&
          entry.value.contains(rule),
    );
  }

  static String _normalize(String value) =>
      value.replaceAll(Platform.pathSeparator, '/').replaceFirst('./', '');
}

final class AgentRulesValidator {
  AgentRulesValidator({required this.root, AgentRuleAllowlist? allowlist})
    : allowlist = allowlist ?? AgentRuleAllowlist();

  final Directory root;
  final AgentRuleAllowlist allowlist;

  static final _generatedPath = RegExp(
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
    '.kt',
    '.kts',
    '.gradle',
    '.properties',
  };

  List<AgentRuleViolation> scan() {
    final violations = <AgentRuleViolation>[];
    _scanDesignReferences(violations);
    for (final entity in root.listSync(recursive: true, followLinks: false)) {
      if (entity is! File) continue;
      final path = _relativePath(entity.path);
      if (_generatedPath.hasMatch(path) || !_isTextFile(path)) continue;
      final source = entity.readAsStringSync();
      _scanMergeConflicts(path, source, violations);
      if (path.startsWith('lib/') && path.endsWith('.dart')) {
        _scanDart(path, source, violations);
      }
    }
    violations.sort((a, b) {
      final pathOrder = a.path.compareTo(b.path);
      return pathOrder != 0 ? pathOrder : a.line.compareTo(b.line);
    });
    return violations;
  }

  void _scanDesignReferences(List<AgentRuleViolation> violations) {
    if (Directory('${root.path}/temp').existsSync()) {
      _add(
        AgentRule.designReference,
        'temp',
        1,
        'Migrate approved designs to design-references; temp must not exist.',
        violations,
      );
    }
    final manifestFile = File('${root.path}/design-references/manifest.yaml');
    if (!manifestFile.existsSync()) return;
    try {
      final manifest = DesignReferenceManifest.load(root);
      for (final failure in manifest.validate()) {
        _add(
          AgentRule.designReference,
          'design-references/manifest.yaml',
          1,
          failure,
          violations,
        );
      }
    } on Object catch (error) {
      _add(
        AgentRule.designReference,
        'design-references/manifest.yaml',
        1,
        'Manifest cannot be parsed: $error',
        violations,
      );
    }
    final allowedProvenanceFiles = {
      'design-references/manifest.yaml',
      'design-references/migration-inventory.md',
      'design-references/migration-report.md',
      'tool/agent_rules_validator.dart',
    };
    for (final entity in root.listSync(recursive: true, followLinks: false)) {
      if (entity is! File) continue;
      final path = _relativePath(entity.path);
      if (!_isTextFile(path) || allowedProvenanceFiles.contains(path)) continue;
      final source = entity.readAsStringSync();
      if (source.contains('temp/')) {
        _add(
          AgentRule.designReference,
          path,
          1,
          'Do not reference the retired temp design path.',
          violations,
        );
      }
    }
  }

  void _scanDart(
    String path,
    String source,
    List<AgentRuleViolation> violations,
  ) {
    _matches(
      path,
      source,
      RegExp(r'\bDio\s*\('),
      AgentRule.directDio,
      'Construct Dio only in the centralized API infrastructure.',
      violations,
    );
    _matches(
      path,
      source,
      RegExp(r'\bprint\s*\('),
      AgentRule.printCall,
      'Use SafeLogger instead of print.',
      violations,
    );
    _matches(
      path,
      source,
      RegExp(r'\bdebugPrint\s*\('),
      AgentRule.debugPrintCall,
      'Use the approved SafeLogger boundary.',
      violations,
    );
    _matches(
      path,
      source,
      RegExp(r'\bSharedPreferences(?:\s*\.|\s*\(|\s+[A-Za-z_])'),
      AgentRule.sharedPreferences,
      'Access SharedPreferences only through preference infrastructure.',
      violations,
    );
    _matches(
      path,
      source,
      RegExp(r'EdgeInsets\.only\s*\([^)]*\b(?:left|right)\s*:', dotAll: true),
      AgentRule.physicalInsets,
      'Use EdgeInsetsDirectional for direction-aware layout.',
      violations,
    );
    _matches(
      path,
      source,
      RegExp(r'Alignment\.center(?:Left|Right)\b'),
      AgentRule.physicalAlignment,
      'Use AlignmentDirectional for direction-aware UI.',
      violations,
    );
    _matches(
      path,
      source,
      RegExp(r'\bColor\s*\(\s*0x[0-9a-fA-F]+\s*\)'),
      AgentRule.rawColor,
      'Use semantic colors from the theme/token files.',
      violations,
    );
    _scanLines(path, source, violations);
  }

  void _scanLines(
    String path,
    String source,
    List<AgentRuleViolation> violations,
  ) {
    final logCall = RegExp(
      r'\b(?:print|debugPrint|log|logger\.(?:event|info|warning|error))\s*\(',
      caseSensitive: false,
    );
    final authorization = RegExp(
      r'\b(?:authorization|bearer|access[_ ]?token|refresh[_ ]?token)\b',
      caseSensitive: false,
    );
    final credential = RegExp(
      r'\b(?:pin|otp|password)\b',
      caseSensitive: false,
    );
    final devUrl = RegExp(
      r"""https?://(?:localhost|127(?:\.\d+){3}|10\.0\.2\.2)(?=[:/'"]|$)""",
      caseSensitive: false,
    );
    final siblingImport = RegExp(
      r'''^\s*import\s+['"][^'"]*(?:\.\./)+(?:api|web)/''',
    );

    final lines = source.split('\n');
    for (var index = 0; index < lines.length; index++) {
      final line = lines[index];
      if (logCall.hasMatch(line) && authorization.hasMatch(line)) {
        _add(
          AgentRule.authorizationLogging,
          path,
          index + 1,
          'Do not log authorization headers or tokens.',
          violations,
        );
      }
      if (logCall.hasMatch(line) && credential.hasMatch(line)) {
        _add(
          AgentRule.credentialLogging,
          path,
          index + 1,
          'Do not log PIN, OTP, or password values.',
          violations,
        );
      }
      if (devUrl.hasMatch(line)) {
        _add(
          AgentRule.developmentUrl,
          path,
          index + 1,
          'Keep development URLs in environment configuration.',
          violations,
        );
      }
      if (siblingImport.hasMatch(line)) {
        _add(
          AgentRule.siblingImport,
          path,
          index + 1,
          'Do not import code from sibling repositories.',
          violations,
        );
      }
    }
  }

  void _scanMergeConflicts(
    String path,
    String source,
    List<AgentRuleViolation> violations,
  ) {
    final markers = [
      List.filled(7, '<').join(),
      List.filled(7, '=').join(),
      List.filled(7, '>').join(),
    ];
    final lines = source.split('\n');
    for (var index = 0; index < lines.length; index++) {
      if (markers.any(lines[index].startsWith)) {
        _add(
          AgentRule.mergeConflict,
          path,
          index + 1,
          'Resolve merge-conflict markers.',
          violations,
        );
      }
    }
  }

  void _matches(
    String path,
    String source,
    RegExp pattern,
    AgentRule rule,
    String message,
    List<AgentRuleViolation> violations,
  ) {
    for (final match in pattern.allMatches(source)) {
      _add(rule, path, _lineAt(source, match.start), message, violations);
    }
  }

  void _add(
    AgentRule rule,
    String path,
    int line,
    String message,
    List<AgentRuleViolation> violations,
  ) {
    if (!allowlist.allows(path, rule)) {
      violations.add(
        AgentRuleViolation(
          rule: rule,
          path: path,
          line: line,
          message: message,
        ),
      );
    }
  }

  int _lineAt(String source, int offset) =>
      1 + '\n'.allMatches(source.substring(0, offset)).length;

  bool _isTextFile(String path) {
    final name = path.split('/').last;
    if (name == 'AGENTS.md' || name == 'CLAUDE.md') return true;
    return _textExtensions.any(path.endsWith);
  }

  String _relativePath(String path) {
    final rootPath = root.absolute.path;
    final absolute = File(path).absolute.path;
    return absolute
        .substring(rootPath.length)
        .replaceFirst(RegExp(r'^[/\\]'), '')
        .replaceAll(Platform.pathSeparator, '/');
  }
}

AgentRuleAllowlist defaultAgentRuleAllowlist() => AgentRuleAllowlist({
  'lib/core/api': {AgentRule.directDio},
  'lib/core/logging': {AgentRule.debugPrintCall},
  'lib/core/storage/preferences_store.dart': {AgentRule.sharedPreferences},
  'lib/app/bootstrap.dart': {AgentRule.sharedPreferences},
  'lib/core/theme': {AgentRule.rawColor},
  'lib/core/config': {AgentRule.developmentUrl},
});
