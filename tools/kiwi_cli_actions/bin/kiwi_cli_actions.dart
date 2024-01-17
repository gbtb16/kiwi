// ignore_for_file: unused_local_variable

import 'package:kiwi_cli_actions/changelog_checker.dart';

void main() {
  const rootPath = '../..';
  const examplesBasePath = '$rootPath/examples';
  const packagesBasePath = '$rootPath/packages';
  const toolsBasePath = '$rootPath/tools';

  // Check the changelogs of all Kiwi packages.
  const changelogChecker = ChangelogChecker();

  changelogChecker.checkIfChangelogHasBeenUpdated(
    absolutePath: '$packagesBasePath/kiwi',
  );

  changelogChecker.checkIfChangelogHasBeenUpdated(
    absolutePath: '$packagesBasePath/kiwi_generator',
  );
}
