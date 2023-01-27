//
//  TypographyColor.swift
//  TypographyKit
//
//  Created by Ross Butler on 5/20/17.
//
//

#if canImport(SwiftUI)
import SwiftUI
#endif
import UIKit

public indirect enum TypographyColor {
    
    // MARK: - Type definitions
    private struct RegEx {
        static let hexColor1 = "#[a-zA-Z0-9]{6}"
        static let hexColor2 = "[a-zA-Z0-9]{6}"
        // swiftlint:disable:next line_length
        static let rgbColor1 = "rgb\\(([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5]),([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5]),([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\\)"
        // swiftlint:disable:next line_length
        static let rgbColor2 = "\\(([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5]),([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5]),([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\\)"
    }
    
    // MARK: - Cases
    case black
    case darkGray
    case lightGray
    case white
    case gray
    case red
    case green
    case blue
    case cyan
    case yellow
    case magenta
    case orange
    case purple
    case brown
    case clear
    case hex(string: String)
    case named(string: String)
    case rgb(red: Float, green: Float, blue: Float)
    case rgba(red: Float, green: Float, blue: Float, alpha: Float)
    case dynamicColor(colors: [TypographyInterfaceStyle: TypographyColor])
    case shade(shade: String, color: TypographyColor)
    
    // MARK: - Properties
    static var colorNameMap: [String: UIColor] {
        return ["black": .black,
                "darkGray": .darkGray,
                "lightGray": .lightGray,
                "white": .white,
                "gray": .gray,
                "red": .red,
                "green": .green,
                "blue": .blue,
                "cyan": .cyan,
                "yellow": .yellow,
                "magenta": .magenta,
                "orange": .orange,
                "purple": .purple,
                "brown": .brown,
                "clear": .clear]
    }
    
    public var cgColor: CGColor {
        return self.uiColor.cgColor
    }
    
    public var ciColor: CIColor {
        return self.uiColor.ciColor
    }
    
    @available(iOS 13.0, *)
    public var color: Color {
        Color(uiColor)
    }
    
    @available(iOS 13.0, *)
    public var swiftUI: Color {
        color
    }
    
    public var uiColor: UIColor {
        switch self {
        case .black:
            return .black
        case .darkGray:
            return .darkGray
        case .lightGray:
            return .lightGray
        case .white:
            return .white
        case .gray:
            return .gray
        case .red:
            return .red
        case .green:
            return .green
        case .blue:
            return .blue
        case .cyan:
            return .cyan
        case .yellow:
            return .yellow
        case .magenta:
            return .magenta
        case .orange:
            return .orange
        case .purple:
            return .purple
        case .brown:
            return .brown
        case .clear:
            return .clear
        case .named(let colorName):
            if let color = UIColor(named: colorName) {
                return color
            }
            return TypographyColor.colorNameMap[colorName]! // Previously validated
        case .hex(let hexString):
            return TypographyColor.parseHex(hexString: hexString)!.uiColor // Previously validated
        case .rgb(let red, let green, let blue):
            return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1.0)
        case .rgba(let red, let green, let blue, let alpha):
            return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
        case .dynamicColor(let colorDictionary):
            guard #available(iOS 13, *) else {
                return colorDictionary[.light]?.uiColor ?? .black
            }
            
            return UIColor { (traitCollection) -> UIColor in
                let key = TypographyInterfaceStyle(style: traitCollection.userInterfaceStyle)
                let color = colorDictionary[key] ?? colorDictionary[.light]
                return color!.uiColor
            }
        case .shade(let shade, let color):
            return color.uiColor.shade(shade)
        }
    }
    
    // MARK: - Initializer
    public init?(string: String) {
        let isInColorMap = TypographyColor.colorNameMap[string] != nil
        if UIColor(named: string) != nil || isInColorMap { // Validate a color is returned
            self = .named(string: string)
            return
        }
        
        switch string {
        case RegEx.hexColor1, RegEx.hexColor2:
            guard TypographyColor.parseHex(hexString: string) != nil else { // Check can be converted to a color
                return nil
            }
            self = .hex(string: string)
        case RegEx.rgbColor1, RegEx.rgbColor2:
            let rgbValues = type(of: self).rgbValues(from: string)
            guard rgbValues.count == 3, let red = Float(rgbValues[0]), let green = Float(rgbValues[1]),
                let blue = Float(rgbValues[2]) else {
                    return nil
            }
            self = .rgb(red: red / 255.0, green: green / 255.0, blue: blue / 255.0)
        default:
            return nil
        }
    }
    
}

// Private API
private extension TypographyColor {
    
    /// Parses a hexadecimal string to a color if possible
    private static func parseHex(hexString: String) -> TypographyColor? {
        let unparsed = hexString.hasPrefix("#")
            ? String(hexString[hexString.index(after: hexString.startIndex)...])
            : hexString
        
        let redComponentIdx = unparsed.startIndex,
        greenComponentIdx = unparsed.index(unparsed.startIndex, offsetBy: 2),
        blueComponentIdx = unparsed.index(unparsed.startIndex, offsetBy: 4)
        
        let redComponent = unparsed[redComponentIdx..<greenComponentIdx],
        greenComponent = unparsed[greenComponentIdx..<blueComponentIdx],
        blueComponent = unparsed[blueComponentIdx..<unparsed.endIndex]
        
        if let rValue = UInt(redComponent, radix: 16), let gValue = UInt(greenComponent, radix: 16),
            let bValue = UInt(blueComponent, radix: 16) {
            let red = Float(rValue) / 255.0
            let green = Float(gValue) / 255.0
            let blue = Float(bValue) / 255.0
            return .rgb(red: red, green: green, blue: blue)
        }
        return nil
    }
    
    private static func rgbValues(from string: String) -> [String] {
        var colorValues: [String] = []
        do {
            let colorComponentPattern = "[01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5]"
            let colorComponentRegEx = try NSRegularExpression(pattern: colorComponentPattern,
                                                              options: .dotMatchesLineSeparators)
            let matches = colorComponentRegEx.matches(in: string,
                                                      options: [],
                                                      range: NSRange(location: 0, length: string.count))
            for match in matches {
                let matchEndIndex = match.range.location + match.range.length
                let startIdx = string.index(string.startIndex, offsetBy: match.range.location)
                let endIdx = string.index(string.startIndex, offsetBy: matchEndIndex)
                let range = startIdx..<endIdx
                colorValues.append(String(string[range]))
            }
        } catch {} // Just return empty array
        return colorValues
    }
    
}
