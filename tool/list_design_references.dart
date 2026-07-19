import 'dart:io';

import 'design_reference_manifest.dart';

void main(List<String> arguments) {
  final root = _projectRoot();
  final manifest = DesignReferenceManifest.load(root);
  final failures = manifest.validate();
  if (failures.isNotEmpty) {
    stderr.writeln('Design-reference manifest integrity failures:');
    for (final failure in failures) {
      stderr.writeln('- $failure');
    }
    exitCode = 1;
    return;
  }

  final filters = <String, String>{};
  for (final argument in arguments) {
    final match = RegExp(
      r'^--(feature|surface|status|id)=(.+)$',
    ).firstMatch(argument);
    if (match == null) {
      stderr.writeln(
        'Usage: dart run tool/list_design_references.dart '
        '[--feature=value] [--surface=value] [--status=value] [--id=value]',
      );
      exitCode = 64;
      return;
    }
    filters[match.group(1)!] = match.group(2)!;
  }

  final matches = manifest.references.where((reference) {
    return (filters['feature'] == null ||
            reference.feature == filters['feature']) &&
        (filters['surface'] == null ||
            reference.surface == filters['surface']) &&
        (filters['status'] == null ||
            reference.approvalStatus == filters['status']) &&
        (filters['id'] == null || reference.id == filters['id']);
  }).toList();

  if (matches.isEmpty) {
    stdout.writeln('No design references matched.');
    return;
  }
  for (final reference in matches) {
    stdout
      ..writeln('${reference.id}: ${reference.title}')
      ..writeln(
        '  ${reference.surface}/${reference.feature} '
        '[${reference.approvalStatus}; ${reference.implementationStatus}]',
      )
      ..writeln('  ${reference.path}');
  }
}

Directory _projectRoot() {
  var current = Directory.current.absolute;
  while (true) {
    if (File('${current.path}/pubspec.yaml').existsSync()) return current;
    final parent = current.parent;
    if (parent.path == current.path) {
      throw StateError('Could not find the Flutter project root.');
    }
    current = parent;
  }
}
