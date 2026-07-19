import 'dart:convert';
import 'dart:io';

const approvalStatuses = {
  'approved-binding',
  'approved-supporting',
  'superseded',
  'unclear',
  'non-authoritative',
};

const implementationStatuses = {
  'not-started',
  'foundation-only',
  'in-progress',
  'implemented',
  'validated',
  'not-applicable',
};

final class DesignReference {
  DesignReference(this.values);

  final Map<String, Object?> values;

  String get id => values['id'] as String? ?? '';
  String get title => values['title'] as String? ?? '';
  String get path => values['path'] as String? ?? '';
  String get feature => values['feature'] as String? ?? '';
  String get surface => values['surface'] as String? ?? '';
  String get approvalStatus => values['approval_status'] as String? ?? '';
  String get implementationStatus =>
      values['implementation_status'] as String? ?? '';
}

final class DesignReferenceManifest {
  DesignReferenceManifest({required this.root, required this.references});

  final Directory root;
  final List<DesignReference> references;

  static const requiredFields = {
    'id',
    'title',
    'path',
    'category',
    'surface',
    'feature',
    'screen',
    'state',
    'locale',
    'direction',
    'approval_status',
    'authority',
    'version',
    'dimensions',
    'source_original_path',
    'implementation_status',
    'related_components',
    'related_flow',
    'duplicate_of',
    'supersedes',
    'notes',
  };

  factory DesignReferenceManifest.load(Directory root) {
    final file = File('${root.path}/design-references/manifest.yaml');
    final decoded = jsonDecode(file.readAsStringSync()) as Map<String, Object?>;
    final records = decoded['references'] as List<Object?>? ?? const [];
    return DesignReferenceManifest(
      root: root,
      references: [
        for (final record in records)
          DesignReference(Map<String, Object?>.from(record! as Map)),
      ],
    );
  }

  List<String> validate() {
    final failures = <String>[];
    final ids = <String>{};
    for (final reference in references) {
      final missing = requiredFields.difference(reference.values.keys.toSet());
      if (missing.isNotEmpty) {
        failures.add('${reference.id}: missing fields ${missing.join(', ')}');
      }
      if (reference.id.isEmpty) failures.add('A reference has an empty ID.');
      if (!ids.add(reference.id)) failures.add('Duplicate ID: ${reference.id}');
      if (!approvalStatuses.contains(reference.approvalStatus)) {
        failures.add(
          '${reference.id}: invalid approval status '
          '${reference.approvalStatus}',
        );
      }
      if (!implementationStatuses.contains(reference.implementationStatus)) {
        failures.add(
          '${reference.id}: invalid implementation status '
          '${reference.implementationStatus}',
        );
      }
      final referencedFile = File('${root.path}/${reference.path}');
      if (!referencedFile.existsSync()) {
        failures.add('${reference.id}: missing file ${reference.path}');
      }
      if (reference.approvalStatus.startsWith('approved-') &&
          reference.path.contains('/archive/')) {
        failures.add('${reference.id}: approved reference is under archive');
      }
      final generatedPath = RegExp(r'(^|/)(build|generated|\.dart_tool)(/|$)');
      if (reference.approvalStatus == 'approved-binding' &&
          generatedPath.hasMatch(reference.path)) {
        failures.add('${reference.id}: binding reference is generated output');
      }
    }
    if (references.isEmpty) failures.add('Manifest has no references.');
    for (final rootName in ['components', 'foundations', 'flows']) {
      final imageRoot = Directory('${root.path}/design-references/$rootName');
      if (!imageRoot.existsSync()) continue;
      for (final entity in imageRoot.listSync(recursive: true)) {
        if (entity is! Directory) continue;
        final hasImage = entity
            .listSync(recursive: true)
            .whereType<File>()
            .any((file) => file.path.toLowerCase().endsWith('.png'));
        if (!hasImage) {
          failures.add(
            'Empty image directory: '
            '${entity.path.substring(root.path.length + 1)}',
          );
        }
      }
    }
    return failures;
  }
}
