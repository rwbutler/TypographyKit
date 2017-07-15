
![TypographyKit](TypographyKit.png)

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

### Typography Styles
Typography styles you define in TypographyKit.plist can optionally include a text color and a letter case.

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

### Color Palettes
Android has from the start provided developers with the means to define a color palette for an app in the form of the colors.xml file. Colors.xml also allows developers to define colors by their hex values. TypographyKit allows developers to define a color palette for an app by creating an entry in the TypographyKit.plist.

    <key>typography-colors</key>
    <dict>
        <key>blueGem</key>
        <string>#2C0E8C</string>
    </dict>

Colors can be defined using hex values, RGB values or simple colors by using their names e.g. 'blue'.

	<key>typography-colors</key>
    <dict>
        <key>blueGem</key>
        <string>rgb(44, 14, 140)</string>
    </dict>
    
Create a UIColor extension to use the newly-defined colors throughout your app:

```
extension UIColor {
    static let blueGem: UIColor = TypographyKit.colors["blueGem"]!
}
```    
    
Or:
   
```
extension UIColor {
	static let fallback: UIColor = .black
	static let blueGem: UIColor = TypographyKit.colors["blueGem"] ?? fallback
}
```    
 
 Your named colors can be used when defining your typography styles in TypographyKit.plist.
 
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
	
	
It is also possible override the text color of a typography style on a case-by-case basis:

```
myLabel.text("hello world", style: .heading, textColor: .blue)
```

### Letter Casing

Useful String additions are provided to easily convert letter case. 

```
let pangram = "The quick brown fox jumps over the lazy dog"
let upperCamelCased = pangram.letterCase(.upperCamel)
print(upperCamelCased)
// prints TheQuickBrownFoxJumpsOverTheLazyDog
```
With numerous convenience functions:

```
let upperCamelCased = pangram.upperCamelCased()
// prints TheQuickBrownFoxJumpsOverTheLazyDog

let kebabCased = pangram.kebabCased()
// prints the-quick-brown-fox-jumps-over-the-lazy-dog
```

Typography styles can be assigned a default letter casing.

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

However occasionally, you may need to override the default letter casing of a typography style:

```
myLabel.text("hello world", style: .heading, letterCase: .capitalized)
```

## Author

Ross Butler

## License

TypographyKit is available under the MIT license. See the [LICENSE file](./LICENSE) for more info.
