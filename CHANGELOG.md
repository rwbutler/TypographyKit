# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.4] - 2019-06-26
### Changed
- Fixed an issue whereby color definitions referencing other color definitions could fail to be parsed correctly.

## [1.1.3] - 2019-06-18
### Added
- It is now possible to extend existing typography styles to create a new one using the `extends` keyword as part of the style definition in the TypographyKit configuration file.

## [1.1.2] - 2019-05-24
### Changed
- `UIButton` no longer gets title set for every `UIControlState` automatically.

## [1.1.1] - 2019-03-15

### Added
- Added `refreshWithData(_:)` for refreshing configuration data from a configuration file which has already been downloaded.

### Changed
- After updating the `configurationURL` property, configuration is reloaded from the new URL.
- Prioritizes JSON configuration files over property lists should both exist in an app's bundle.

## [1.1.0] - 2018-12-21
### Changed
- Added the ability to specify presentation options for TypographyKitViewController.

## [1.0.1] - 2018-09-21

## [1.0.0] - 2018-09-20

## [0.4.5] - 2018-09-19

## [0.4.4] - 2018-09-11
### Added
- Invoking `TypographyKit.presentTypographyStyles()` will now present a TypographyKitViewController modally for listing all the typography styles in your app with an option to export to PDF.

## [0.4.3] - 2018-09-10
### Changed
- Fixed a minor bug retrieving colors defined in asset catalogs on iOS 11 and above.

## [0.4.2] - 2018-09-07
### Added
Allows the font point size to be clamped to a lower and / or upper bound by optionally defining the minimum-point-size / maximum-point-size in the TypographyKit configuration file.

## [0.4.1] - 2018-07-27
### Added
This release introduces support for integration using the Carthage dependency manager. In order to integrate TypographyKit into your project via Carthage, add the following line to your project's Cartfile:

```
github "rwbutler/TypographyKit"
```

This release is unavailable through Cocoapods as it introduces no functional changes from the previous release for developers who have already integrated v0.4.0.

## [0.4.0] - 2018-07-23
### Added
Support for recursive color definitions and obtaining lighter / darker shades of colors. More information is available in this [blog post](https://medium.com/@rwbutler/remotely-configured-colour-palettes-in-typographykit-e565c927e2b4).

## [0.3.0] - 2018-07-05
### Added
- Support for Swift 4.1

## [0.2.1] - 2018-03-02
## [0.2.0] - 2018-03-02
## [0.1.0] - 2017-09-07
## [0.0.9] - 2017-07-27
## [0.0.8] - 2017-07-17
## [0.0.7] - 2017-07-15
## [0.0.6] - 2017-07-15
## [0.0.5] - 2017-06-13
## [0.0.4] - 2017-06-13
## [0.0.3] - 2017-06-13
## [0.0.2] - 2017-06-13
## [0.0.1] - 2017-06-13
Initial release.