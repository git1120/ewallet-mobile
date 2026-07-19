import 'dart:io';

import 'agent_rules_validator.dart';
import 'web_dev_proxy_validator.dart';

void main(List<String> arguments) {
  var rootPath = Directory.current.path;
  final additions = <String, Set<AgentRule>>{};

  for (var index = 0; index < arguments.length; index++) {
    final argument = arguments[index];
    if (argument == '--root' && index + 1 < arguments.length) {
      rootPath = arguments[++index];
      continue;
    }
    if (argument.startsWith('--allow=')) {
      final value = argument.substring('--allow='.length);
      final separator = value.indexOf(':');
      if (separator <= 0 || separator == value.length - 1) {
        stderr.writeln('Invalid allowlist entry: $argument');
        exitCode = 64;
        return;
      }
      final rule = AgentRule.fromId(value.substring(0, separator));
      if (rule == null) {
        stderr.writeln(
          'Unknown allowlist rule: ${value.substring(0, separator)}',
        );
        exitCode = 64;
        return;
      }
      additions.putIfAbsent(value.substring(separator + 1), () => {}).add(rule);
      continue;
    }
    stderr.writeln(
      'Usage: dart run tool/validate_agent_rules.dart '
      '[--root PATH] [--allow=RULE:PATH]',
    );
    exitCode = 64;
    return;
  }

  final defaults = <String, Set<AgentRule>>{
    'lib/core/api': {AgentRule.directDio},
    'lib/core/logging': {AgentRule.debugPrintCall},
    'lib/core/storage/preferences_store.dart': {AgentRule.sharedPreferences},
    'lib/app/bootstrap.dart': {AgentRule.sharedPreferences},
    'lib/core/theme': {AgentRule.rawColor},
    'lib/core/config': {AgentRule.developmentUrl},
  };
  for (final entry in additions.entries) {
    defaults.putIfAbsent(entry.key, () => {}).addAll(entry.value);
  }

  final root = Directory(rootPath);
  if (!root.existsSync()) {
    stderr.writeln('Repository root does not exist: ${root.path}');
    exitCode = 66;
    return;
  }

  final violations = AgentRulesValidator(
    root: root,
    allowlist: AgentRuleAllowlist(defaults),
  ).scan();
  final proxyViolations = WebDevProxyValidator(root).validate();
  if (violations.isEmpty && proxyViolations.isEmpty) {
    stdout.writeln('Agent rules validator: no violations found.');
    return;
  }

  stderr.writeln(
    'Agent rules validator found '
    '${violations.length + proxyViolations.length} violation(s):',
  );
  for (final violation in violations) {
    stderr.writeln(violation);
  }
  for (final violation in proxyViolations) {
    stderr.writeln(violation);
  }
  exitCode = 1;
}
