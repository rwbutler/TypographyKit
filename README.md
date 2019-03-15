
![TypographyKit](https://raw.githubusercontent.com/rwbutler/TypographyKit/master/docs/images/typography-kit-banner.png)

[![CI Status](http://img.shields.io/travis/rwbutler/TypographyKit.svg?style=flat)](https://travis-ci.org/rwbutler/TypographyKit)
[![Version](https://img.shields.io/cocoapods/v/TypographyKit.svg?style=flat)](http://cocoapods.org/pods/TypographyKit)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/TypographyKit.svg?style=flat)](http://cocoapods.org/pods/TypographyKit)
[![Platform](https://img.shields.io/cocoapods/p/TypographyKit.svg?style=flat)](http://cocoapods.org/pods/TypographyKit)
[![Twitter](https://img.shields.io/badge/twitter-@TypographyKit-blue.svg?style=flat)](https://twitter.com/TypographyKit)
[![Swift 4.2](https://img.shields.io/badge/Swift-4.2-orange.svg?style=flat)](https://swift.org/)

TypographyKit makes it easy to define typography styles and colour palettes in your iOS app helping you achieve visual consistency in your design as well as supporting [Dynamic Type](https://developer.apple.com/ios/human-interface-guidelines/visual-design/typography/) even when using custom fonts. [[Summary]](https://medium.com/@rwbutler/typographykit-an-ios-framework-to-help-you-support-dynamic-type-and-enable-visual-consistency-bce7e4a82c30) [[Detailed]](https://medium.com/@rwbutler/dynamic-type-in-ios-with-typographykit-9ed0ac5dbf64)

## Features

- [x] Dynamic Type support for UILabel, UIButton, UITextField and UITextView as well as some support for NSAttributedString.
- [x] Dynamic Type support for custom fonts prior to iOS 11 (iOS 8 onwards).
- [x] Optionally support Dynamic Type using *zero code* (by setting the `fontTextStyleName` key path String to the name of your typography style in IB). 
- [x] Helps make your app visually consistent across all screen by allowing you to define all of your typography styles and app color scheme in a single location.
- [x] Host and update your font styles and color schemes [remotely](#remote-configuration). [[Details]](https://medium.com/@rwbutler/remotely-configured-colour-palettes-in-typographykit-e565c927e2b4)
- [x] Use [Palette](https://github.com/rwbutler/TypographyKitPalette) to make the same colour scheme used programmatically available for use in Interface Builder. [[Details]](https://medium.com/@rwbutler/palette-for-typographykit-fd724f324c52)
- [x] Define letter case as part of typography styles with [simple letter case conversion available](#letter-casing).
- [x] Use either a PList or JSON to define your TypographyKit configuration. 

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

Include a TypographyKit.plist as part of your app project ([example](./Example/TypographyKit/TypographyKit.plist)) in which you define your typography styles.

```xml
	<key>ui-font-text-styles</key>
	<dict>
		<key>heading</key>
		<dict>
			<key>font-name</key>
			<string>Avenir-Medium</string>
			<key>point-size</key>
			<integer>36</integer>
		</dict>
	</dict>
```

Or if you prefer to use JSON you may include a TypographyKit.json ([example](./Example/TypographyKit/TypographyKit.json)) instead.

Define additional UIFontTextStyles within your app matching those defined in your .plist:

```swift
extension UIFontTextStyle
{
    static let heading = UIFontTextStyle(rawValue: "heading")
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

Or where your text has been set through IB simply set the UIFontTextStyle programmatically:
```swift
self.titleLabel.fontTextStyle = .heading
```

If you are happy to use strings, an alternative means of setting the `fontTextStyle` property is to set the key path `fontTextStyleName` on your UIKit element to the string value representing your fontTextStyle - in the example above, this would be 'heading'.

![Setting the fontTextStyleName key path in Interface Builder](https://github.com/rwbutler/TypographyKit/raw/master/key-path.png)

Using this method it is possible to support Dynamic Type in your application with *zero code*.

Your UILabel and UIButton elements will automatically respond to changes in the Dynamic Type setting on iOS on setting a UIFontTextStyle with no further work needed.

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

### iOS 11
TypographyKit also supports definition of colors via asset catalogs  available from iOS 11 onwards. Simply include the name of the color as part of your style in ```TypographyKit.plist``` and if the color is found in your asset catalog it will automatically be applied.

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

You may specify your own point step size and multiplier by inclusion of a dictionary with key ```typography-kit``` as part of your ```TypographyKit.plist``` file.

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
* [Skylark](https://github.com/rwbutler/Skylark) - Fully Swift BDD testing framework for writing Cucumber scenarios using Gherkin syntax.
* [TailorSwift](https://github.com/rwbutler/TailorSwift) - A collection of useful Swift Core Library / Foundation framework extensions.
* [TypographyKit](https://github.com/rwbutler/TypographyKit) - Consistent & accessible visual styling on iOS with Dynamic Type support.
* [Updates](https://github.com/rwbutler/Updates) - Automatically detects app updates and gently prompts users to update.

|[Cheats](https://github.com/rwbutler/Cheats) |[Connectivity](https://github.com/rwbutler/Connectivity) | [FeatureFlags](https://github.com/rwbutler/FeatureFlags) | [Skylark](https://github.com/rwbutler/Skylark) | [TypographyKit](https://github.com/rwbutler/TypographyKit) | [Updates](https://github.com/rwbutler/Updates) |
|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|
|[![Cheats](https://raw.githubusercontent.com/rwbutler/Cheats/master/docs/images/cheats-logo.png)](https://github.com/rwbutler/Cheats) |[![Connectivity](https://github.com/rwbutler/Connectivity/raw/master/ConnectivityLogo.png)](https://github.com/rwbutler/Connectivity) | [![FeatureFlags](https://raw.githubusercontent.com/rwbutler/FeatureFlags/master/docs/images/feature-flags-logo.png)](https://github.com/rwbutler/FeatureFlags) | [![Skylark](https://github.com/rwbutler/Skylark/raw/master/SkylarkLogo.png)](https://github.com/rwbutler/Skylark) | [![TypographyKit](https://raw.githubusercontent.com/rwbutler/TypographyKit/master/docs/images/typography-kit-logo.png)](https://github.com/rwbutler/TypographyKit) | [![Updates](https://raw.githubusercontent.com/rwbutler/Updates/master/docs/images/updates-logo.png)](https://github.com/rwbutler/Updates)

### Tools

* [Config Validator](https://github.com/rwbutler/ConfigValidator) - Config Validator validates & uploads your configuration files and cache clears your CDN as part of your CI process.
* [IPA Uploader](https://github.com/rwbutler/IPAUploader) - Uploads your apps to TestFlight & App Store.
* [Palette](https://github.com/rwbutler/TypographyKitPalette) - Makes your [TypographyKit](https://github.com/rwbutler/TypographyKit) color palette available in Xcode Interface Builder.

|[Config Validator](https://github.com/rwbutler/ConfigValidator) | [IPA Uploader](https://github.com/rwbutler/IPAUploader) | [Palette](https://github.com/rwbutler/TypographyKitPalette)|
|:-------------------------:|:-------------------------:|:-------------------------:|
|[![Config Validator](https://raw.githubusercontent.com/rwbutler/ConfigValidator/master/docs/images/config-validator-logo.png)](https://github.com/rwbutler/ConfigValidator) | [![IPA Uploader](https://raw.githubusercontent.com/rwbutler/IPAUploader/master/docs/images/ipa-uploader-logo.png)](https://github.com/rwbutler/IPAUploader) | [![Palette](https://raw.githubusercontent.com/rwbutler/TypographyKitPalette/master/docs/images/typography-kit-palette-logo.png)](https://github.com/rwbutler/TypographyKitPalette)