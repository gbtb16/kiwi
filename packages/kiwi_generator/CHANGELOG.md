# 4.2.1

- kiwi version has been updated to `5.0.1`.

# 4.2.0

Now Kiwi it's a Brazilian package! 🇧🇷 ♥

Thank you ([@vanlooverenkoen](https://github.com/vanlooverenkoen)) for your contribution and trust in our work.
He continued his active and dedicated work on the Kiwi Generator package up to version `4.2.0`.

- BREAKING: kiwi version has been updated to `5.0.0`.
- refactor: the package structure has been refactored to be in line with the market. ([PR #106](https://github.com/gbtb16/kiwi/pull/106))
- refactor: implemented new dart format rule for line length (160) of package development. ([PR #106](https://github.com/gbtb16/kiwi/pull/106))
- refactor: github actions have been updated. ([PR #106](https://github.com/gbtb16/kiwi/pull/106))
- refactor: github project labels have been updated. ([PR #106](https://github.com/gbtb16/kiwi/pull/106))
- refactor: the Dart CLI tools in the package have been updated. ([PR #106](https://github.com/gbtb16/kiwi/pull/106))
- fix: build_runner version has been updated. ([PR #102](https://github.com/gbtb16/kiwi/pull/102))
- fix: typedefs have been updated. ([PR #106](https://github.com/gbtb16/kiwi/pull/106))
- fix: pub.dev points now sound great (150/150). ([PR #106](https://github.com/gbtb16/kiwi/pull/106))
- fix: dependabot has been updated. ([PR #107](https://github.com/gbtb16/kiwi/pull/107))
- chore: other minimalist changes.
- chore: update `analyzer` dependency to `6.0.0`.

# 4.1.0
### Updated
- Dependencies
- Moved from travis to github actions

# 4.0.3
## Updated
- Dependencies

# 4.0.2
## Updated
- Dependencies

# 4.0.1
## Fixed
- Dart constraint issue for kiwi

# 4.0.0
## BREAKING
- Updated to analyzer 2.0.0
- Dart 2.14 min requirement
## Updated dependencies

# 3.0.1
## Updated
- Generated core is now using the cascade operator
## Fixed
- Using build_runner 2.0.4 with kiwi

# 3.0.0
## Added
- Nullsafety codebase migration
## Updated dependencies
- Updated dependencies to make sure we can still build with new dependencies.

# 2.1.1
## Updated
- Kiwi version to 2.1.1

# 2.1.0
## Updated
- Updated the documentation for the use of subclasses & subclasses with generics
- Updated dependencies
## Added
- No response bot to git
- Android v2 embedding for the example project
## Fixed
- \#44 Fixed a bug where the @override was never generated
- \#45 Fixed a bug where a file that contained a abstract void method without @register would be skipped. This is not the case anymore. 

# 2.0.1
## Fixed
- \#49 Fixed a bug that prepares for nullability. In this release we do not yet support nullability. But #51 is tracking nullability support

# 2.0.0
## BREAKING CHANGE
- \#9 Removed the unused T generic for some functions
## Added
- \#19 added support for scopes with the kiwi_generator

# 1.0.0
## BREAKING CHANGE
- renamed `Container` to `KiwiContainer` so it is easier for Flutter devs to import the KiwiContainer (kiwi: 1.0.0 required)

# 0.5.2
## Fixed
- Updated homepage

# 0.5.1
### Fixed
- Fixed pub.dev score

# 0.5.0
## Fixed
- Upgrade dependencies
- Fixed formatting errors
- Fixed pub.dev score

# 0.4.0
- Upgrade dependencies

# 0.3.1
## Fixed
- Upgrade dependencies and fix a deprecated error.

# 0.3.0
## Fixed
- Upgrade dependencies

# 0.2.0
## Fixed
- Upgrade dependencies

# 0.1.1
### Fixed
- The generator no longer generates a `.g.dart` file for abstract classes without abstract methods.

# 0.1.0
- Initial Open Source release.
