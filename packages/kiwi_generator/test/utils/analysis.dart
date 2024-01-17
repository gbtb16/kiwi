import 'dart:async';
import 'dart:io';

import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:path/path.dart' as p;
import 'package:source_gen/source_gen.dart';

Future<LibraryReader> resolveCompilationUnit(String sourceFile) async {
  final files = [
    File(sourceFile),
  ];

  final fileMap = Map<String, String>.fromEntries(
    files.map(
      (f) => MapEntry(
        'a|lib/${p.basename(f.path)}',
        f.readAsStringSync(),
      ),
    ),
  );

  final library = await resolveSources(fileMap, (item) async {
    final assetId = AssetId.parse(fileMap.keys.first);
    return await item.libraryFor(assetId);
  });

  return LibraryReader(library);
}
