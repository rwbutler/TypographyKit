# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [5.0.0] - 2023-01-27
## Added
- Properties `color` and `swiftUI` allow a SwiftUI `Color` to be obtained from a `TypographyKitColor`.
- All methods & properties previously accessed using `TypographyKit.` may now be accessed using the shortened form: `TK.`.
- Support for RGBA colour values e.g. rgba(255,255,255,255).
- Support for hexadecimal color values with transparency e.g. #FFFFFFFF.
- New configuration options may now be declared as part of the TypographyKit JSON configuration file:
	- `development-color`: If the app build is a development build and `should-use-development-colors` is `true` then when the value of a color hasn't been specified, TypographyKit will fallback to using the value of this color.
	- `fallback-color`: If the app build is *not* a development build -or- the app build is a development build but `should-use-development-colors` is `false` then this color will be used if the value of a color has not been set.
	- `is-development`: Can be used to set whether or not the build is a development build. If the value is not set, this is determined according to whether or not the build is debug.
	- `should-crash-if-color-not-found`: If the build is a development build and the value of this key is `true` then if the value of a color hasn't been specified then the app will crash. Default value: `false`.
	- `should-use-development-colors`: If the build is a development build and the value of this key is `true` then if the value of a color hasn't been specified then the specified `development-colour` will be used. Default value: `true`.

- All configuration options specified in the TypographyKit configuration file may also be specified via the `TypographyKit.Configuration` object when configuring the framework. Note: Settings specified in the TypographyKit configuration file override settings specified programmatically.


## Changed
- Deployment target updated to iOS 11.0 (dropped support for iOS 9.0 and 10.0 in-line with Xcode 14).
- `TypographyKit.colors` should no longer be used. Instead use:
	- For SwiftUI: `TypographyKit.color(named:)` or `TK.color(named:)`.
	- For UIKit: `TypographyKit.uiColor(named:)` or `TK.uiColor(named:)`.
	- Or: `TypographyKit.tkColor(named:).color` (for SwiftUI) or `TypographyKit.tkColor(named:).uiColor` (for UIKit).
- `ConfigurationSettings` renamed to `TypographyKitConfiguration`. This object contains the configuration values supplied by the developer (along with any default configuration values).
- `TypgraphyKitConfiguration` renamed to `TypographyKitSettings`. This object contains the current configuration as well as loaded colors and typography styles.

## [4.4.0] - 2022-08-16
## Changed
- When using the View modifier in SwiftUI, the scaling mode can be specified as a parameter e.g. `.typography(style: .interactive, scalingMode: .fontMetrics)`. By default the scaling mode specified in the configuration will be applied.

## [4.3.2] - 2022-03-16
## Changed
- Fixed an issue concerning font colors in SwiftUI.

## [4.3.1] - 2021-11-09
## Changed
- Allow Color and Font for typography styles in SwiftUI to be nullable.

## [4.3.0] - 2021-11-09
## Added
- Support for disabling font scaling either system-wide and/or per-font.
- Support for custom letter spacing in font styles plist.

## [4.2.2] - 2020-12-16
### Changed
- Removes a warning relating to iOS 8 being unsupported as a deployment target in Xcode 12 (thanks to @atrinh0).

## [4.2.1] - 2020-08-04
### Changed
- Fixed support for Swift Package Manager.

## [4.2.0] - 2020-05-09
### Added
- Support for posting a `UIContentSizeCategory.didChangeNotification` notification manually where scaling using `UIFontMetrics`.

## [4.1.0] - 2020-03-19
### Added
- Support for Swift Package Manager.

## [4.0.0] - 2020-02-23
### Added
- Support for SwiftUI. A typography style can be applied to a SwiftUI `Text` view as follows:

```swift
Text("A string").typography(style: .interactive) 
```

Letter casing can be applied directly to a String as follows:

```swift
"A string".letterCase(style: .interactive)
```

- Scaling mode may now be specified on a per typography style basis using the `scaling-mode` key.

## [4.0.0] - 2020-02-23
### Added
- Support for SwiftUI. A typography style can be applied to a SwiftUI `Text` view as follows:

```swift
Text("A string").typography(style: .interactive) 
```

Letter casing can be applied directly to a String as follows:

```swift
"A string".letterCase(style: .interactive)
```

- Scaling mode may now be specified on a per typography style basis using the `scaling-mode` key.

### Changed
- The default scaling mode (if one is not specified) is now `UIFontMetrics` with fallback to stepping prior to iOS 11.0.
- Improvements to scaling using `UIFontMetrics` including respecting minimum point size constraints.


## [3.3.0] - 2020-02-19
### Added
Added the ability to specify a minimum and / or maximum point size per typography style e.g.

```json
		"paragraph": {
			"font-name": "Avenir-Medium",
            "minimum-point-size": 12,
            "maximum-point-size": 24,
			"point-size": 18,
			"text-color": "text",
			"letter-case": "regular"
		}
``` 

## [3.2.0] - 2020-01-21
### Added
Added the ability to globally specify the line breaking mode for `UILabel` using the `line-break` property of `labels`. For an example, see the sample app.

## [3.1.0] - 2019-09-17
### Added
Added parameter `replacingDefaultTextColor` to function `attributedText(_ text:, style:,letterCase:, textColor: UIColor?)` allowing the most frequently occurring text color in an attributed string to be replaced with the value of the `textColor` parameter.

## [3.0.1] - 2019-09-11
### Changed
Resolved an issues with setting `NSAttributedString` on UILabel` updating all fonts to the specified typography style even where a font attribute was already set.

## [3.0.0] - 2019-09-03
### Added
Support for Xcode 11 and dark mode in iOS 13.

## [2.2.3] - 2019-09-03
### Changed
Fixed an issue whereby attributed text would not be updated correctly.

## [2.2.2] - 2019-09-02
### Changed
Fixed an issue whereby invoking `UIFont(name:, size:)` using the name of the system font (as part of setting a new font size for attributed text) causes the font to be set to Times New Roman.

## [2.2.1] - 2019-08-21
### Changed
- Fixed an issue whereby updating an element's attributed text only updated the font size and not the typeface.

## [2.2.0] - 2019-08-15
### Added
- Added `TKColorsViewController` for displaying all colors defined in TypographyKit configuration.

## [2.1.0] - 2019-08-08
### Added
- Convenience methods added on `Typography` to support Dynamic Type including `font()` and `lineHeight()`.

## [2.0.1] - 2019-07-02
### Added
- Added support for:
	-  `BoldSystem` -> `boldSystemFont(ofSize: CGFloat) -> UIFont`
	-  `ItalicSystem` -> `italicSystemFont(ofSize: CGFloat) -> UIFont`
	-  `MonospacedDigitSystem-Weight` -> `monospacedDigitSystemFont(ofSize: CGFloat, weight: UIFont.Weight) -> UIFont`.

## [2.0.0] - 2019-07-01
### Changed
- Added support for Swift 5.0.

## [1.1.5] - 2019-07-01 (Swift 4.2)
### Added
- Support for scaling using `UIFontMetrics` where iOS 11 using the `TypographyKit.scalingMode` property.
- Better support for using the system font by listing the font name as `System` or the font name and weight e.g. `System-Bold`.

### Changed
- Deployment target increased from 8.0 -> 8.2.

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
