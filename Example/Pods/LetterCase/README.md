![LetterCase](https://github.com/rwbutler/LetterCase/raw/master/docs/images/letter-case-banner.png)

[![CI Status](https://img.shields.io/travis/rwbutler/LetterCase.svg?style=flat)](https://travis-ci.org/rwbutler/LetterCase)
[![Version](https://img.shields.io/cocoapods/v/LetterCase.svg?style=flat)](https://cocoapods.org/pods/LetterCase)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Frwbutler%2FLetterCase%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/rwbutler/LetterCase)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Frwbutler%2FLetterCase%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/rwbutler/LetterCase)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/LetterCase.svg?style=flat)](https://cocoapods.org/pods/LetterCase)
[![Twitter](https://img.shields.io/badge/twitter-@ross_w_butler-blue.svg?style=flat)](https://twitter.com/ross_w_butler)

Lightweight library written in Swift for converting the letter case of a String. For more information take a look at the [blog post](https://medium.com/@rwbutler/supercharge-codable-by-implementing-a-json-key-decoding-strategy-a46fedacabc4) or the table of contents below:

- [Features](#features)
- [Installation](#installation)
	- [Cocoapods](#cocoapods)
	- [Carthage](#carthage)
	- [Swift Package Manager](#swift-package-manager)
- [Letter Cases](#letter-cases)
- [Usage](#usage)
- [Author](#author)
- [License](#license)
- [Additional Software](#additional-software)
	- [Frameworks](#frameworks)
	- [Tools](#tools)

## Features

- [x] Converts Strings to a variety of supported cases including: capitalized, kebab case, lower case, lower camel case, macro case, snake case, upper case and upper camel case.
- [x] Provides conversion from any letter case to another e.g. `"the-quick-brown-fox-jumped-over-the-lazy-dog".convert(from: .kebab, to: .macro)` prints THE_QUICK_BROWN_FOX_JUMPED_OVER_THE_LAZY_DOG
- [x] Implementations of `JSONDecoder.KeyDecodingStrategy` and `JSONEncoder.KeyEncodingStrategy` for decoding / encoding of JSON using `Codable` keys in just about any letter case.
- [x] Provides convenience methods on `String` for each of the supported cases e.g. `"The Quick Brown Fox".kebabCased()` emits "the-quick-brown-fox".

## Installation

### Cocoapods

[CocoaPods](http://cocoapods.org) is a dependency manager which integrates dependencies into your Xcode workspace. To install it using [Ruby gems](https://rubygems.org/) run:

```bash
gem install cocoapods
```

To install LetterCase using Cocoapods, simply add the following line to your Podfile:

```ruby
pod "LetterCase"
```

Then run the command:

```ruby
pod install
```

For more information [see here](https://cocoapods.org/#getstarted).

### Carthage

Carthage is a dependency manager which produces a binary for manual integration into your project. It can be installed via [Homebrew](https://brew.sh/) using the commands:

```bash
brew update
brew install carthage
```

In order to integrate LetterCase into your project via Carthage, add the following line to your project's Cartfile:

```ogdl
github "rwbutler/LetterCase"
```

From the macOS Terminal run `carthage update --platform iOS` to build the framework then drag `LetterCase.framework` into your Xcode project.

For more information [see here](https://github.com/Carthage/Carthage#quick-start).

### Swift Package Manager

Once you have your Swift package set up, adding LetterCase as a dependency is as easy as adding it to the dependencies value of your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/rwbutler/LetterCase", from: "1.6.1")
]
```

##### Using Xcode package list:

Xcode 11 includes support for [Swift Package Manager](https://swift.org/package-manager/). In order to add LetterCase to your project using Xcode, from the `File` menu select `Swift Packages` and then select `Add Package Dependency`.

A dialogue will request the package repository URL which is:

```
https://github.com/rwbutler/LetterCase
```

After verifying the URL, Xcode will prompt you to select whether to pull a specific branch, commit or versioned release into your project. 

<div align="center">
    <img src="https://github.com/rwbutler/Connectivity/raw/main/docs/images/package-options.png" alt="Xcode 11 Package Options">
</div>

Proceed to the next step by where you will be asked to select the package product to integrate into a target. There will be a single package product named `LetterCase` which should be pre-selected. Ensure that your main app target is selected from the rightmost column of the dialog then click Finish to complete the integration.

<div align="center">
    <img src="https://github.com/rwbutler/Connectivity/raw/main/docs/images/add-package.png" alt="Xcode 11 Add Package">
</div>

## Letter Cases

    case regular                     // No transformation applied.
    case capitalized                 // e.g. Capitalized Case
    case kebab                       // e.g. kebab-case
    case lower                       // e.g. lower case
    case lowerCamel                  // e.g. lowerCamelCase
    case macro                       // e.g. MACRO_CASE
    case snake                       // e.g. snakecase
    case upper                       // e.g. UPPER CASE
    case upperCamel                  // e.g. UpperCamelCase
    
## Usage

In order to use LetterCase first import it using:
`import LetterCase`. Then invoke one the convenience methods on `String` as follows:

```swift
let exampleString = "The quick brown fox jumped over the lazy dog."
let result = exampleString.letterCase(.kebab)
print(result)
```

Results in the following being printed:

`the-quick-brown-fox-jumped-over-the-lazy-dog`

Alternatively:

```swift
let exampleString = "The quick brown fox jumped over the lazy dog."
let result = exampleString.kebabCased()
print(result)
```

### LetterCase Conversion

Use the convert function to convert from one letter case to another as follows:

```swift
let input = "the-quick-brown-fox-jumped-over-the-lazy-dog"
let result = input.convert(from: .kebab, to: .capitalized)
print(result) // Prints "The Quick Brown Fox Jumped Over The Lazy Dog"
```

### JSON Decoding

To decode JSON with keys in [kebab case](https://en.wikipedia.org/wiki/Letter_case#Special_case_styles) e.g.

```json
{
    "vehicles": [{
        "name": "car",
        "travels-on": "road",
        "number-of-wheels": 4
    }, {
        "name": "boat",
        "travels-on": "water",
        "number-of-wheels": 0
    }, {
        "name": "train",
        "travels-on": "rail",
        "number-of-wheels": 80
    }, {
        "name": "plane",
        "travels-on": "air",
        "number-of-wheels": 18
    }]
}
```

Specify the `keyDecodingStrategy` as follows:

```swift
let jsonData = try Data(contentsOf: jsonResourceURL)
let decoder = JSONDecoder()
decoder.keyDecodingStrategy = .convertFromKebabCase
let vehicles try decoder.decode(Vehicles.self, from: jsonData)
```

Available strategies include:

- convertFromCapitalized
- convertFromDashCase
- convertFromKebabCase
- convertFromLispCase
- convertFromLowerCase
- convertFromLowerCamelCase
- convertFromMacroCase
- convertFromScreamingSnakeCase
- convertFromTrainCase
- convertFromUpperCase
- convertFromUpperCamelCase

### JSON Encoding

To encode a Swift structure to JSON with keys in [kebab case](https://en.wikipedia.org/wiki/Letter_case#Special_case_styles) specify the `keyEncodingStrategy` as follows:

```swift
let encoder = JSONEncoder()
encoder.keyEncodingStrategy = .convertToKebabCase
let jsonData = try encoder.encode(vehicles)
```

Available strategies include:

- convertToCapitalized
- convertToDashCase
- convertToKebabCase
- convertToLispCase
- convertToLowerCase
- convertToLowerCamelCase
- convertToMacroCase
- convertToScreamingSnakeCase
- convertToTrainCase
- convertToUpperCase
- convertToUpperCamelCase

## Author

[Ross Butler](https://github.com/rwbutler)

## License

LetterCase is available under the MIT license. See the [LICENSE file](./LICENSE) for more info.

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
* [LetterCase](https://github.com/rwbutler/LetterCase) - Lightweight library written in Swift for converting the letter case of a String.
* [Skylark](https://github.com/rwbutler/Skylark) - Fully Swift BDD testing framework for writing Cucumber scenarios using Gherkin syntax.
* [TailorSwift](https://github.com/rwbutler/TailorSwift) - A collection of useful Swift Core Library / Foundation framework extensions.
* [TypographyKit](https://github.com/rwbutler/TypographyKit) - Consistent & accessible visual styling on iOS with Dynamic Type support.
* [Updates](https://github.com/rwbutler/Updates) - Automatically detects app updates and gently prompts users to update.

|[Cheats](https://github.com/rwbutler/Cheats) |[Connectivity](https://github.com/rwbutler/Connectivity) | [FeatureFlags](https://github.com/rwbutler/FeatureFlags) | [Skylark](https://github.com/rwbutler/Skylark) | [TypographyKit](https://github.com/rwbutler/TypographyKit) | [Updates](https://github.com/rwbutler/Updates) |
|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|
|[![Cheats](https://raw.githubusercontent.com/rwbutler/Cheats/master/docs/images/cheats-logo.png)](https://github.com/rwbutler/Cheats) |[![Connectivity](https://github.com/rwbutler/Connectivity/raw/main/ConnectivityLogo.png)](https://github.com/rwbutler/Connectivity) | [![FeatureFlags](https://raw.githubusercontent.com/rwbutler/FeatureFlags/master/docs/images/feature-flags-logo.png)](https://github.com/rwbutler/FeatureFlags) | [![Skylark](https://github.com/rwbutler/Skylark/raw/master/SkylarkLogo.png)](https://github.com/rwbutler/Skylark) | [![TypographyKit](https://raw.githubusercontent.com/rwbutler/TypographyKit/master/docs/images/typography-kit-logo.png)](https://github.com/rwbutler/TypographyKit) | [![Updates](https://raw.githubusercontent.com/rwbutler/Updates/master/docs/images/updates-logo.png)](https://github.com/rwbutler/Updates)

### Tools

* [Clear DerivedData](https://github.com/rwbutler/ClearDerivedData) - Utility to quickly clear your DerivedData directory simply by typing `cdd` from the Terminal.
* [Config Validator](https://github.com/rwbutler/ConfigValidator) - Config Validator validates & uploads your configuration files and cache clears your CDN as part of your CI process.
* [IPA Uploader](https://github.com/rwbutler/IPAUploader) - Uploads your apps to TestFlight & App Store.
* [Palette](https://github.com/rwbutler/TypographyKitPalette) - Makes your [TypographyKit](https://github.com/rwbutler/TypographyKit) color palette available in Xcode Interface Builder.

|[Config Validator](https://github.com/rwbutler/ConfigValidator) | [IPA Uploader](https://github.com/rwbutler/IPAUploader) | [Palette](https://github.com/rwbutler/TypographyKitPalette)|
|:-------------------------:|:-------------------------:|:-------------------------:|
|[![Config Validator](https://raw.githubusercontent.com/rwbutler/ConfigValidator/master/docs/images/config-validator-logo.png)](https://github.com/rwbutler/ConfigValidator) | [![IPA Uploader](https://raw.githubusercontent.com/rwbutler/IPAUploader/master/docs/images/ipa-uploader-logo.png)](https://github.com/rwbutler/IPAUploader) | [![Palette](https://raw.githubusercontent.com/rwbutler/TypographyKitPalette/master/docs/images/typography-kit-palette-logo.png)](https://github.com/rwbutler/TypographyKitPalette)

