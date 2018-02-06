# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Added ability to order by an association column
- Implemented the `action` option for the `Policy` macro

### Changed

- Pipetrees have been normalized to use strings and no exclamation marks

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

[Unreleased]: https://github.com/pragmarb/pragma/compare/v2.1.1...HEAD
[2.1.1]: https://github.com/pragmarb/pragma/compare/v2.1.0...v2.1.1
[2.1.0]: https://github.com/pragmarb/pragma/compare/v2.0.0...v2.1.0
[2.0.0]: https://github.com/pragmarb/pragma/compare/v1.2.6...v2.0.0
