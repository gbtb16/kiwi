## [4.0.2] - 2022-02-19
### Updated
- Dependencies

## [4.0.1] - 2021-10-13
### Fixed
- Dart constraint issue for kiwi

## [4.0.0] - 2021-10-13
### BREAKING
- Updated to analyzer 2.0.0
- Dart 2.14 min requirement
### Updated dependencies

## [3.0.1] - 2021-07-15
### Updated
- Generated core is now using the cascade operator
### Fixed
- Using build_runner 2.0.4 with kiwi

## [3.0.0] - 2021-06-01
### Added
- Nullsafety codebase migration
### Updated dependencies
- Updated dependencies to make sure we can still build with new dependencies.

## [2.1.1] - 2020-10-24
### Updated
- Kiwi version to 2.1.1

## [2.1.0] - 2020-10-24
### Updated
- Updated the documentation for the use of subclasses & subclasses with generics
- Updated dependencies
### Added
- No response bot to git
- Android v2 embedding for the example project
### Fixed
- \#44 Fixed a bug where the @override was never generated
- \#45 Fixed a bug where a file that contained a abstract void method without @register would be skipped. This is not the case anymore. 

## [2.0.1]
### Fixed
- \#49 Fixed a bug that prepares for nullability. In this release we do not yet support nullability. But #51 is tracking nullability support

## [2.0.0]
### BREAKING CHANGE
- \#9 Removed the unused T generic for some functions
### Added
- \#19 added support for scopes with the kiwi_generator

## [1.0.0]
### BREAKING CHANGE
- renamed `Container` to `KiwiContainer` so it is easier for Flutter devs to import the KiwiContainer (kiwi: 1.0.0 required)

## [0.5.2]
### Fixed
- Updated homepage

## [0.5.1]
### Fixed
- Fixed pub.dev score

## [0.5.0]
### Fixed
- Upgrade dependencies
- Fixed formatting errors
- Fixed pub.dev score

## [0.4.0]
- Upgrade dependencies

## [0.3.1]
### Fixed
- Upgrade dependencies and fix a deprecated error.

## [0.3.0]
### Fixed
- Upgrade dependencies

## [0.2.0]
### Fixed
- Upgrade dependencies

## [0.1.1]
### Fixed
- The generator no longer generates a `.g.dart` file for abstract classes without abstract methods.

## [0.1.0]
- Initial Open Source release.
