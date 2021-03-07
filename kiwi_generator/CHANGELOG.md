## [3.0.0-nullsafety.1] - 2021-03-07
### Fixed
- Analyzer bumped to 0.41.1

## [3.0.0-nullsafety.0] - 2021-03-04
### Added
- Nullsafety support in a dev release (the kiwi_generator code is not yet nullsafe but the generator is)

### DISCLAIMER:
- A lot of dependencies still need to do the migration. until then we will stay in a dev release

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
