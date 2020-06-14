import 'dart:async';

import 'package:kiwi_generator/kiwi_generator.dart';
import 'package:test/test.dart';

import 'analysis.dart';

final KiwiInjectorGenerator _injectorGenerator = const KiwiInjectorGenerator();

Future<void> testKiwi(
  String fileName,
  String output,
) async {
  String inputFilePath = './test/inputs/$fileName.dart';

  final library = await resolveCompilationUnit(inputFilePath);

  String actual = _injectorGenerator.generate(library, null);
  expect(actual, output);
}

Future<void> testKiwiException(
  String fileName,
  dynamic matcher,
) async {
  String inputFilePath = './test/inputs/$fileName.dart';

  final library = await resolveCompilationUnit(inputFilePath);

  expect(() => _injectorGenerator.generate(library, null), throwsA(matcher));
}
