import 'dart:async';
import 'dart:io';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/src/string_source.dart';
import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:kiwi_generator/kiwi_generator.dart';
import 'package:test/test.dart';
import 'package:source_gen/source_gen.dart';
import 'package:path/path.dart' as p;

import 'utils/analysis.dart';
import 'utils/test_file.dart';

LibraryReader _library;
InjectorGenerator _injectorGenerator = const InjectorGenerator();

void main() async {
  _library = await resolveCompilationUnit('./test/src/');
  var result = await _injectorGenerator.generate(_library, null);

  group('A group of tests', () {});
}
