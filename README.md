
![TypographyKit](https://raw.githubusercontent.com/rwbutler/TypographyKit/master/docs/images/typography-kit-banner.png)

[![Build Status](https://app.travis-ci.com/rwbutler/TypographyKit.svg?branch=master)](https://app.travis-ci.com/rwbutler/TypographyKit)
[![Version](https://img.shields.io/cocoapods/v/TypographyKit.svg?style=flat)](http://cocoapods.org/pods/TypographyKit)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/TypographyKit.svg?style=flat)](http://cocoapods.org/pods/TypographyKit)
[![Platform](https://img.shields.io/cocoapods/p/TypographyKit.svg?style=flat)](http://cocoapods.org/pods/TypographyKit)
[![Twitter](https://img.shields.io/badge/twitter-@ross_w_butler-blue.svg?style=flat)](https://twitter.com/ross_w_butler)
[![Swift 5.0](https://img.shields.io/badge/Swift-5.0-orange.svg?style=flat)](https://swift.org/)
[![Reviewed by Hound](https://img.shields.io/badge/Reviewed_by-Hound-8E64B0.svg)](https://houndci.com)

TypographyKit makes it easy to define typography styles and colour palettes in your iOS app helping you achieve visual consistency in your design as well as supporting [Dynamic Type](https://developer.apple.com/ios/human-interface-guidelines/visual-design/typography/) even when using custom fonts. [[Summary]](https://medium.com/@rwbutler/typographykit-an-ios-framework-to-help-you-support-dynamic-type-and-enable-visual-consistency-bce7e4a82c30) [[Detailed]](https://medium.com/@rwbutler/dynamic-type-in-ios-with-typographykit-9ed0ac5dbf64)

To learn more about how to use TypographyKit, take a look at the table of contents below:

- [Features](#features)
- [Roadmap](#roadmap)
- [What's New in TypographyKit 5.0.0?](#whats-new-in-typographykit-500)
- [What's New in TypographyKit 4.0.0?](#whats-new-in-typographykit-400)
- [Installation](#installation)
	- [Cocoapods](#cocoapods)
	- [Carthage](#carthage)
- [Example App](#example-app)
- [Usage](#usage)
	- [Configuration](#configuration)
	- [Swift UI](#swift-ui)
		- [Colors](#colors)
		- [Typography (Fonts)](#typography-fonts)
	- [UI Kit](#ui-kit)
		- [Typography Styles](#typography-styles)
		- [Extending Styles](#extending-styles)
		- [Color Palettes](#color-palettes)
		- [UIColor(named:)](#uicolornamed)
		- [Letter Casing](#letter-casing)
		- [Dynamic Type Configuration](#dynamic-type-configuration)
		- [Remote Configuration](#remote-configuration)
- [Author](#author)
- [License](#license)
- [Additional Software](#additional-software)
	- [Controls](#controls)
	- [Frameworks](#frameworks)
	- [Tools](#tools)

## Features

- [x] Dynamic Type support for SwiftUI.
- [x] Helps keep your app visually consistent across all screens by allowing you to define all of your typography styles and app color scheme in a single location.
- [x] Host and update your font styles and color schemes [remotely](#remote-configuration). [[Details]](https://medium.com/@rwbutler/remotely-configured-colour-palettes-in-typographykit-e565c927e2b4)
- [x] Dynamic Type support for UIKit (including UILabel, UIButton, UITextField and UITextView as well as some support for NSAttributedString).
	- [x] Support for Dynamic Type using *zero code* (by setting the `fontTextStyleName` key path String to the name of your typography style in Interface Builder). 
- [x] Use either JSON or Property List (.plist) to define your TypographyKit configuration. 
- [x] Use [Palette](https://github.com/rwbutler/TypographyKitPalette) to make the same colour scheme used programmatically available for use in Interface Builder. [[Details]](https://medium.com/@rwbutler/palette-for-typographykit-fd724f324c52)
- [x] Define letter case as part of typography styles with [simple letter case conversion available](#letter-casing).


## What's new in TypographyKit 5.0.0?

TypographyKit 5.0.0 drops support for iOS 9.0, updating the deployment target to 11.0 in line with Xcode 14.

## What's new in TypographyKit 4.0.0?

TypographyKit 4.0.0 introduces support for SwiftUI. In order to make use of TypographyKit with SwiftUI, create a TypographyKit configuration file (either JSON or PList) and an extension on `UIFont.TextStyle` as described in the [Usage](#usage) section, then simply apply your typography style to a SwiftUI `Text` view as follows:

```swift
Text("An example using TypographyKit with SwiftUI")
.typography(style: .interactive)
```

A letter case may be applied directly to the String as follows:

```swift
"An example using TypographyKit with SwiftUI"
.letterCase(style: .interactive)
```

This results in the letter case defined for the specified typography style (in config) being applied.

## Installation

### Cocoapods

[CocoaPods](http://cocoapods.org) is a dependency manager which integrates dependencies into your Xcode workspace. To install it using [RubyGems](https://rubygems.org/) run:

```bash
gem install cocoapods
```

To install TypographyKit using Cocoapods, simply add the following line to your Podfile:

```ruby
pod "TypographyKit"
```

Then run the command:

```bash
pod install
```

For more information [see here](https://cocoapods.org/#getstarted).

### Carthage

Carthage is a dependency manager which produces a binary for manual integration into your project. It can be installed via [Homebrew](https://brew.sh/) using the commands:

```bash
brew update
brew install carthage
```

In order to integrate TypographyKit into your project via Carthage, add the following line to your project's Cartfile:

```ogdl
github "rwbutler/TypographyKit"
```

From the macOS Terminal run `carthage update --platform iOS` to build the framework then drag `TypographyKit.framework` into your Xcode project.

For more information [see here](https://github.com/Carthage/Carthage#quick-start).

## Example App

An example app exists in the [Example directory](https://github.com/rwbutler/TypographyKit/tree/master/Example) to provide some pointers on getting started.

## Usage
### Configuration
Include a TypographyKit.json ([example](https://github.com/rwbutler/TypographyKit/blob/master/Example/TypographyKit/TypographyKit.json)) or TypographyKit.plist ([example](./Example/TypographyKit/TypographyKit.plist)) as part of your app project in which you define your typography styles:

```json
{
	"typography-colors": {
		"background": {
			"dark": "dark royal-blue",
			"light": "lightest gray"
    },
		"gold": "#FFAB01",
		"royal-blue": "#08224C"
	},
	"typography-kit": {
		"labels": {
	    "line-break": "word-wrap"
    },
		"minimum-point-size": 10,
		"maximum-point-size": 100,
		"point-step-size": 2,
		"point-step-multiplier": 1,
		"scaling-mode": "uifontmetrics-with-fallback"
	},
	"ui-font-text-styles": {
		"heading": {
			"font-name": "Avenir-Medium",
			"point-size": 36,
			"text-color": "text",
			"letter-case": "regular"
		}
	}
}
```


### Swift UI
#### Colors
#### Typography (Fonts)
Define additional UIFont.TextStyles within your app matching those defined in your .plist:

```swift
extension UIFont.TextStyle
{
    static let heading = UIFont.TextStyle(rawValue: "heading")
}
```

Where you would usually set the text on a UILabel e.g.
```swift
self.titleLabel.text = "My label text"
```

Use TypographyKit's UIKit additions:
```swift
self.titleLabel.text("My label text", style: .heading)
```

Or where your text has been set through IB simply set the UIFont.TextStyle programmatically:
```swift
self.titleLabel.fontTextStyle = .heading
```

If you are happy to use strings, an alternative means of setting the `fontTextStyle` property is to set the key path `fontTextStyleName` on your UIKit element to the string value representing your fontTextStyle - in the example above, this would be 'heading'.

![Setting the fontTextStyleName key path in Interface Builder](https://github.com/rwbutler/TypographyKit/raw/master/key-path.png)

Using this method it is possible to support Dynamic Type in your application with *zero code*.

Your UILabel and UIButton elements will automatically respond to changes in the Dynamic Type setting on iOS on setting a UIFont.TextStyle with no further work needed.

### Typography Styles
Typography styles you define in TypographyKit.plist can optionally include a text color and a letter case.

```xml
	<key>ui-font-text-styles</key>
	<dict>
		<key>heading</key>
		<dict>
			<key>font-name</key>
			<string>Avenir-Medium</string>
			<key>point-size</key>
			<integer>36</integer>
			<key>text-color</key>
			<string>#2C0E8C</string>
			<key>letter-case</key>
			<string>upper</string>
		</dict>
	</dict>
```

### Extending Styles
From version 1.1.3 onwards it is possible to use an existing typography style to create a new one. For example, imagine you would like to create a new style based on an existing one but changing the text color. We can use the `extends` keyword to extend a style that exists already and then specify which properties of the that style to override e.g. the `text-color` property.

We can create a new typography style called `interactive-text` based on a style we have defined already called `paragraph` as follows:

*PLIST*

```xml
<key>paragraph</key>
<dict>
	<key>font-name</key>
	<string>Avenir-Medium</string>
	<key>point-size</key>
	<integer>16</integer>
	<key>text-color</key>
	<string>text</string>
	<key>letter-case</key>
	<string>regular</string>
</dict>
<key>interactive-text</key>
<dict>
	<key>extends</key>
	<string>paragraph</string>
	<key>text-color</key>
	<string>purple</string>
</dict>
```

*JSON*

```json
"paragraph": {
	"font-name": "Avenir-Medium",
	"point-size": 16,
	"text-color": "text",
	"letter-case": "regular"
},
"interactive-text": {
	"extends": "paragraph",
	"text-color": "purple"
}        
```

### Color Palettes
Android has from the start provided developers with the means to define a color palette for an app in the form of the colors.xml file. Colors.xml also allows developers to define colors by their hex values. TypographyKit allows developers to define a color palette for an app by creating an entry in the TypographyKit.plist.

```xml
    <key>typography-colors</key>
    <dict>
        <key>blueGem</key>
        <string>#2C0E8C</string>
    </dict>
```

Colors can be defined using hex values, RGB values or simple colors by using their names e.g. 'blue'.

```xml	
	<key>typography-colors</key>
    <dict>
        <key>blueGem</key>
        <string>rgb(44, 14, 140)</string>
    </dict>
```

Create a UIColor extension to use the newly-defined colors throughout your app:

```swift
extension UIColor {
    static let blueGem: UIColor = TypographyKit.colors["blueGem"]!
}
```    
    
Or:
   
```swift
extension UIColor {
	static let fallback: UIColor = .black
	static let blueGem: UIColor = TypographyKit.colors["blueGem"] ?? fallback
}
```    
 
Your named colors can be used when defining your typography styles in TypographyKit.plist.
 
```xml
 	<key>ui-font-text-styles</key>
	<dict>
		<key>heading</key>
		<dict>
			<key>font-name</key>
			<string>Avenir-Medium</string>
			<key>point-size</key>
			<integer>36</integer>
			<key>text-color</key>
			<string>blueGem</string>
		</dict>
	</dict>
```
	
It is also possible override the text color of a typography style on a case-by-case basis:

```swift
myLabel.text("hello world", style: .heading, textColor: .blue)
```

### UIColor(named:)
TypographyKit also supports definition of colors via asset catalogs available from iOS 11 onwards. Simply include the name of the color as part of your style in the configuration file and if the color is found in your asset catalog it will automatically be applied.

### Letter Casing

Useful String additions are provided to easily convert letter case. 

```swift
let pangram = "The quick brown fox jumps over the lazy dog"
let upperCamelCased = pangram.letterCase(.upperCamel)
print(upperCamelCased)
// prints TheQuickBrownFoxJumpsOverTheLazyDog
```
With numerous convenience functions:

```swift
let upperCamelCased = pangram.upperCamelCased()
// prints TheQuickBrownFoxJumpsOverTheLazyDog

let kebabCased = pangram.kebabCased()
// prints the-quick-brown-fox-jumps-over-the-lazy-dog
```

Typography styles can be assigned a default letter casing.

```xml
	<key>ui-font-text-styles</key>
	<dict>
		<key>heading</key>
		<dict>
			<key>font-name</key>
			<string>Avenir-Medium</string>
			<key>point-size</key>
			<integer>36</integer>
			<key>letter-case</key>
			<string>upper</string>
		</dict>
	</dict>
```

However occasionally, you may need to override the default letter casing of a typography style:

```swift
myLabel.text("hello world", style: .heading, letterCase: .capitalized)
```

### Dynamic Type Configuration
By default, your font point size will increase by 2 points for each notch on the Larger Text slider in the iOS accessibility settings however you may optionally specify how your UIKit elements react to changes in UIContentSizeCategory. 

You may specify your own point step size and multiplier by inclusion of a dictionary with key ```typography-kit``` as part of your ```TypographyKit.json``` (or ```TypographyKit.plist``` if preferred) file.

```xml
<key>typography-kit</key>
<dict>
    <key>minimum-point-size</key>
    <integer>10</integer>
    <key>maximum-point-size</key>
    <integer>100</integer>
    <key>point-step-size</key>
    <integer>2</integer>
    <key>point-step-multiplier</key>
    <integer>1</integer>
</dict>
```

Optionally, you may clamp the font point size to a lower and / or upper bound using the `minimum-point-size` and `maximum-point-size` properties.

### Remote Configuration
TypographyKit also allows you to host your configuration remotely so that your colors and font styles can be updated dynamically. To do so, simply add the following line to your app delegate so that it is invoked when your app finishes launching:

```swift
TypographyKit.configurationURL = URL(string: "https://github.com/rwbutler/TypographyKit/blob/master/Example/TypographyKit/TypographyKit.plist")
```

Your typography styles and colors will be updated the next time your app is launched. However, should you need your styles to be updated sooner you may call ``` TypographyKit.refresh()```.

## Author

[Ross Butler](https://github.com/rwbutler)

## License

TypographyKit is available under the MIT license. See the [LICENSE file](./LICENSE) for more info.

## Additional Software

### Controls

* [AnimatedGradientView](https://github.com/rwbutler/AnimatedGradientView) - Powerful gradient animations made simple for iOS.

|[AnimatedGradientView](https://github.com/rwbutler/AnimatedGradientView) |
|:-------------------------:|
|[![AnimatedGradientView](https://raw.githubusercontent.com/rwbutler/AnimatedGradientView/master/docs/images/animated-gradient-view-logo.png)](https://github.com/rwbutler/AnimatedGradientView) 

### Frameworks

* [Cheats](https://github.com/rwbutler/Cheats) - Retro cheat codes for modern iOS apps.
* [Connectivity](https://github.com/rwbutler/Connectivity) - Improves on Reachability for determining Internet connectivity in your iOS application.
* [FeatureFlags](https://github.com/rwbutler/FeatureFlags) - Allows developers to configure feature flags, run multiple A/B or MVT tests using a bundled / remotely-hosted JSON configuration file.
* [FlexibleRowHeightGridLayout](https://github.com/rwbutler/FlexibleRowHeightGridLayout) - A UICollectionView grid layout designed to support Dynamic Type by allowing the height of each row to size to fit content.
* [Hash](https://github.com/rwbutler/Hash) - Lightweight means of generating message digests and HMACs using popular hash functions including MD5, SHA-1, SHA-256.
* [Skylark](https://github.com/rwbutler/Skylark) - Fully Swift BDD testing framework for writing Cucumber scenarios using Gherkin syntax.
* [TailorSwift](https://github.com/rwbutler/TailorSwift) - A collection of useful Swift Core Library / Foundation framework extensions.
* [TypographyKit](https://github.com/rwbutler/TypographyKit) - Consistent & accessible visual styling on iOS with Dynamic Type support.
* [Updates](https://github.com/rwbutler/Updates) - Automatically detects app updates and gently prompts users to update.

|[Cheats](https://github.com/rwbutler/Cheats) |[Connectivity](https://github.com/rwbutler/Connectivity) | [FeatureFlags](https://github.com/rwbutler/FeatureFlags) | [Skylark](https://github.com/rwbutler/Skylark) | [TypographyKit](https://github.com/rwbutler/TypographyKit) | [Updates](https://github.com/rwbutler/Updates) |
|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|
|[![Cheats](https://raw.githubusercontent.com/rwbutler/Cheats/master/docs/images/cheats-logo.png)](https://github.com/rwbutler/Cheats) |[![Connectivity](https://github.com/rwbutler/Connectivity/raw/master/ConnectivityLogo.png)](https://github.com/rwbutler/Connectivity) | [![FeatureFlags](https://raw.githubusercontent.com/rwbutler/FeatureFlags/master/docs/images/feature-flags-logo.png)](https://github.com/rwbutler/FeatureFlags) | [![Skylark](https://github.com/rwbutler/Skylark/raw/master/SkylarkLogo.png)](https://github.com/rwbutler/Skylark) | [![TypographyKit](https://raw.githubusercontent.com/rwbutler/TypographyKit/master/docs/images/typography-kit-logo.png)](https://github.com/rwbutler/TypographyKit) | [![Updates](https://raw.githubusercontent.com/rwbutler/Updates/master/docs/images/updates-logo.png)](https://github.com/rwbutler/Updates)

### Tools

* [Clear DerivedData](https://github.com/rwbutler/ClearDerivedData) - Utility to quickly clear your DerivedData directory simply by typing `cdd` from the Terminal.
* [Config Validator](https://github.com/rwbutler/ConfigValidator) - Config Validator validates & uploads your configuration files and cache clears your CDN as part of your CI process.
* [IPA Uploader](https://github.com/rwbutler/IPAUploader) - Uploads your apps to TestFlight & App Store.
* [Palette](https://github.com/rwbutler/TypographyKitPalette) - Makes your [TypographyKit](https://github.com/rwbutler/TypographyKit) color palette available in Xcode Interface Builder.

|[Config Validator](https://github.com/rwbutler/ConfigValidator) | [IPA Uploader](https://github.com/rwbutler/IPAUploader) | [Palette](https://github.com/rwbutler/TypographyKitPalette)|
|:-------------------------:|:-------------------------:|:-------------------------:|
|[![Config Validator](https://raw.githubusercontent.com/rwbutler/ConfigValidator/master/docs/images/config-validator-logo.png)](https://github.com/rwbutler/ConfigValidator) | [![IPA Uploader](https://raw.githubusercontent.com/rwbutler/IPAUploader/master/docs/images/ipa-uploader-logo.png)](https://github.com/rwbutler/IPAUploader) | [![Palette](https://raw.githubusercontent.com/rwbutler/TypographyKitPalette/master/docs/images/typography-kit-palette-logo.png)](https://github.com/rwbutler/TypographyKitPalette)
