# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- Moved `Pragma::Decorator::Error` to [pragma-decorator](https://github.com/pragmarb/pragma-decorator)
- Moved `Pragma::AssociationIncluder` to [pragma-decorator](https://github.com/pragmarb/pragma-decorator)
- Moved macros to [pragma-resource](https://github.com/pragmarb/pragma-resource)
- Moved CRUD operations to [pragma-resource](https://github.com/pragmarb/pragma-resource)

### Removed

- Removed filtering functionality with no replacement (use Ransack or similar instead)

## [2.5.0]

### Added

- Expose `type` property for API errors
- Expanded associations are now eager-loaded automatically
- Calling macros whose support classes are undefined will now raise a `MissingSkillError`

### Fixed

- Fixed computation of classes for nested operations

## [2.4.0]

### Added

- Implemented `Boolean` scope
- Added support for additional policy context via `policy.context`

### Fixed

- Added support for different capitalizations of API namespace
- Fixed an issue where each filter would override the previous one
 
## [2.3.0]

### Added

- Added support for Kaminari in `Pagination` macro

### Changed

- Dropped runtime dependency on will_paginate

### Fixed

- Fixed constant loading in Ruby 2.5

## [2.2.0]

### Added

- Added ability to order by an association column
- Implemented the `action` option for the `Policy` macro
- Implemented the `Where` filter
- Implemented the `Scope` filter

### Changed

- Pipetrees have been normalized to use strings and no exclamation marks
- Move macros to `Pragma::Macro` namespace and provide BC-compatibility
- Default name of `Contract::Build` steps is now `contract.[name].build`
- Default name of `Contract::Persist` steps is now `contract.[name].[method]`

### Fixed

- Fixed handling of validation errors in `Contract::Validate`
- Fixed handling of validation errors in `Contract::Persist`

## [2.1.1]

### Fixed

- Fixed root-level model class computation

## [2.1.0]

### Added

- Implemented `expand.limit` and `expand.enabled`
- Implemented the `Ordering` macro
- Implemented the `Filtering` macro

### Fixed

- Fixed automatic lookup of nested model classes

## [2.0.0]

First Pragma 2 release.

[Unreleased]: https://github.com/pragmarb/pragma/compare/v2.5.0...HEAD
[2.5.0]: https://github.com/pragmarb/pragma/compare/v2.4.0...v2.5.0
[2.4.0]: https://github.com/pragmarb/pragma/compare/v2.3.0...v2.4.0
[2.3.0]: https://github.com/pragmarb/pragma/compare/v2.2.0...v2.3.0
[2.2.0]: https://github.com/pragmarb/pragma/compare/v2.1.1...v2.2.0
[2.1.1]: https://github.com/pragmarb/pragma/compare/v2.1.0...v2.1.1
[2.1.0]: https://github.com/pragmarb/pragma/compare/v2.0.0...v2.1.0
[2.0.0]: https://github.com/pragmarb/pragma/compare/v1.2.6...v2.0.0
