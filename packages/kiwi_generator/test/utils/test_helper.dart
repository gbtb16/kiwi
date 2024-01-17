import 'dart:async';

import 'package:kiwi_generator/kiwi_generator.dart';
import 'package:test/test.dart';

import 'analysis.dart';

final KiwiInjectorGenerator _injectorGenerator = const KiwiInjectorGenerator();

Future<void> testKiwi(
  String fileName,
  String? output,
) async {
  try {
    String inputFilePath = './test/inputs/$fileName.dart';

    final library = await resolveCompilationUnit(inputFilePath);

    String? actual = _injectorGenerator.generate(library, null);
    expect(actual, output);
  } catch (genericError) {
    print('Its not possible to find inputs file.');
    print('Error: $genericError');

    rethrow;
  }
}

Future<void> testKiwiException(
  String fileName,
  dynamic matcher,
) async {
  try {
    String inputFilePath = './test/inputs/$fileName.dart';

    final library = await resolveCompilationUnit(inputFilePath);

    expect(() => _injectorGenerator.generate(library, null), throwsA(matcher));
  } catch (genericError) {
    print('Its not possible to test kiwi exceptions.');
    print('Error: $genericError');

    rethrow;
  }
}
