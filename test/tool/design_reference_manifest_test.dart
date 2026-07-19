import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/design_reference_manifest.dart';

void main() {
  late Directory root;

  setUp(() {
    root = Directory.systemTemp.createTempSync('design-manifest-');
    Directory('${root.path}/design-references').createSync();
  });

  tearDown(() => root.deleteSync(recursive: true));

  test('accepts a complete manifest whose image exists', () {
    _writeReference(root, id: 'sample-v1');

    expect(DesignReferenceManifest.load(root).validate(), isEmpty);
  });

  test('reports duplicate IDs, invalid enums, archive, and missing files', () {
    final record = _record(id: 'duplicate', path: 'design-references/lost.png');
    record['approval_status'] = 'approved-binding';
    record['implementation_status'] = 'finished';
    _writeManifest(root, [record, Map<String, Object?>.from(record)]);

    final failures = DesignReferenceManifest.load(root).validate();

    expect(failures, contains('Duplicate ID: duplicate'));
    expect(
      failures,
      contains('duplicate: invalid implementation status finished'),
    );
    expect(
      failures.where((failure) => failure.contains('missing file')),
      hasLength(2),
    );
  });
}

void _writeReference(Directory root, {required String id}) {
  final path = 'design-references/sample.png';
  File('${root.path}/$path').writeAsBytesSync([0]);
  _writeManifest(root, [_record(id: id, path: path)]);
}

Map<String, Object?> _record({required String id, required String path}) => {
  'id': id,
  'title': 'Sample',
  'path': path,
  'category': 'approved screen reference',
  'surface': 'customer',
  'feature': 'home',
  'screen': 'dashboard',
  'state': 'default',
  'locale': 'en',
  'direction': 'ltr',
  'approval_status': 'approved-binding',
  'authority': 'test',
  'version': '1',
  'dimensions': '1x1',
  'source_original_path': 'incoming/sample.png',
  'implementation_status': 'not-started',
  'related_components': <String>[],
  'related_flow': null,
  'duplicate_of': null,
  'supersedes': null,
  'notes': 'test',
};

void _writeManifest(Directory root, List<Map<String, Object?>> references) {
  File('${root.path}/design-references/manifest.yaml').writeAsStringSync(
    jsonEncode({'schema_version': 1, 'references': references}),
  );
}
