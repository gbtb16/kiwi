import 'dart:async';
import 'dart:io';

import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:kiwi_generator/kiwi_generator.dart';
import 'package:source_gen/source_gen.dart';

const String pkgName = 'a';

final SharedPartBuilder builder = new SharedPartBuilder(const [
  const InjectorGenerator(),
], 'kiwi');

Future<String> _generate(String sourceCode) async {
  final Map<String, String> source = <String, String>{
    '$pkgName|lib/test.dart': sourceCode
  };

  final InMemoryAssetWriter writer = InMemoryAssetWriter();
  await testBuilder(builder, source, rootPackage: pkgName, writer: writer);
  return new String.fromCharCodes(
      writer.assets[AssetId(pkgName, 'lib/test.kiwi.g.dart')] ?? []);
}

Future<String> _generateForFile(File file) async {
  return _generate(await file.readAsString());
}

Future<Map<String, String>> generateForDirectory(String directoryPath) async {
  final Map<String, String> result = <String, String>{};
  await for (FileSystemEntity fse in Directory(directoryPath).list()) {
    if (fse is File) {
      result[fse.path] = await _generateForFile(fse);
    }
  }
  return result;
}
