import 'dart:io';

import 'package:yaml/yaml.dart';

final class ChangelogChecker {
  const ChangelogChecker();

  String getActualPubspecVersion(String path) {
    try {
      final pubspec = File('$path/pubspec.yaml');
      final pubspecContent = pubspec.readAsStringSync();
      final loadedYaml = loadYaml(pubspecContent);

      return loadedYaml['version'];
    } catch (genericError) {
      print('pubspec.yaml file not exists!');
      print('error: $genericError');

      rethrow;
    }
  }

  void checkIfChangelogHasBeenUpdated({required String absolutePath}) {
    try {
      final pubspecVersion = getActualPubspecVersion(absolutePath);
      final changelog = File('$absolutePath/CHANGELOG.md');
      final changelogContent = changelog.readAsStringSync();

      if (changelogContent.startsWith('# $pubspecVersion')) {
        print('Changelog for $absolutePath has been updated!');
      } else {
        print('Changelog for $absolutePath has not been updated.');
        exit(1);
      }
    } catch (genericError) {
      print('its not possible check if changelog has been updated.');
      print('error: $genericError');

      rethrow;
    }
  }
}
