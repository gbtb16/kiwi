// ignore_for_file: unused_local_variable

import 'package:kiwi_cli_actions/changelog_checker.dart';

void main() {
  const examplesBasePath = '/examples';
  const packagesBasePath = '/packages';
  const toolsBasePath = '/tools';

  // Check the changelogs of all Kiwi packages.
  const changelogChecker = ChangelogChecker();

  changelogChecker.checkIfChangelogHasBeenUpdated(
    path: '$packagesBasePath/kiwi',
  );

  changelogChecker.checkIfChangelogHasBeenUpdated(
    path: '$packagesBasePath/kiwi_generator',
  );
}
