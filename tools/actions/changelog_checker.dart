import 'dart:io';

import 'package:yaml/yaml.dart';

void main() {
  checkIfChangelogHasBeenUpdated('kiwi');
  checkIfChangelogHasBeenUpdated('kiwi_generator');
}

String getVersion(String path) {
  final pubspec = File('$path/pubspec.yaml');
  final pubspecContent = pubspec.readAsStringSync();
  return loadYaml(pubspecContent)['version'];
}

void checkIfChangelogHasBeenUpdated(String path) {
  final version = getVersion(path);
  final changelog = File('$path/CHANGELOG.md');
  final changelogContent = changelog.readAsStringSync();
  if (changelogContent.startsWith('# $version')) {
    print('Changelog for $path has been updated');
  } else {
    print('Changelog for $path has not been updated');
    exit(-1);
  }
}
