# TypographyKit

[![CI Status](http://img.shields.io/travis/rwbutler/TypographyKit.svg?style=flat)](https://travis-ci.org/rwbutler/TypographyKit)
[![Version](https://img.shields.io/cocoapods/v/TypographyKit.svg?style=flat)](http://cocoapods.org/pods/TypographyKit)
[![License](https://img.shields.io/cocoapods/l/TypographyKit.svg?style=flat)](http://cocoapods.org/pods/TypographyKit)
[![Platform](https://img.shields.io/cocoapods/p/TypographyKit.svg?style=flat)](http://cocoapods.org/pods/TypographyKit)

TypographyKit makes it easy to define typography styles in your iOS app helping you achieve visual consistency in your design as well as supporting [Dynamic Type](https://developer.apple.com/ios/human-interface-guidelines/visual-design/typography/) even where using custom fonts.
## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

TypographyKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "TypographyKit"
```

## Usage

Include a TypographyKit.plist as part of your app project ([example](./Example/TypographyKit/TypographyKit.plist)) in which you define your typography styles.

Define additional UIFontTextStyles within your app matching those defined in your .plist:

```
extension UIFontTextStyle
{
    static let heading = UIFontTextStyle(rawValue: "heading")
}
```

Where you would usually set the text on a UILabel e.g.
```
self.titleLabel.text = "My label text"
```

Use TypographyKit's UIKit additions:
```
self.titleLabel.text("My label text", style: .heading)
```

Or where your text has been set through IB simply set the UIFontTextStyle programmatically:
```
self.titleLabel.fontTextStyle = .heading
```

Your UILabel and UIButton elements will automatically respond to changes in the Dynamic Type setting on iOS on setting a UIFontTextStyle with no further work needed.

## Author

Ross Butler

## License

TypographyKit is available under the MIT license. See the LICENSE file for more info.
