//
//  Typography.swift
//  TypographyKit
//
//  Created by Ross Butler on 5/16/17.
//
//

import Foundation

enum TypographyKitPropertyAdditionsKey {
    static var fontTextStyle: UInt8 = 0
    static var typography: UInt8 = 1
    static var letterCase: UInt8 = 2
}

enum TypographyKitConfigType: String {
    case plist
    case json
}

enum TypographyKitConfigKey: String {
    case fontName = "font-name"
    case pointSize = "point-size"
    case textColor = "text-color"
    case letterCase = "letter-case"
}

public struct TypographyKit {
    static let configName: String = "TypographyKit"
    static let configType: TypographyKitConfigType = .plist
    static var pointStepSize: Float = 2.0
    static var pointStepMultiplier: Float = 1.0
}

public struct Typography {
    let fontName: String?
    let pointSize: Float? // base point size for font
    var letterCase: LetterCase?
    var textColor: UIColor?
    
    public init?(for textStyle: UIFontTextStyle) {
        if let configFileURL = Bundle.main.url(forResource: TypographyKit.configName,
                                               withExtension: TypographyKitConfigType.plist.rawValue),
            let data = try? Data(contentsOf: configFileURL),
            let result = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any],
            let fontTextStyles = result?["ui-font-text-styles"] as? [String: [String: Any]],
            let fontTextStyle = fontTextStyles[textStyle.rawValue] {
            
            if let typographyKitConfig = result?["typography-kit"] as? [String: Float],
                let pointStepSize = typographyKitConfig["point-step-size"],
                let pointStepMultiplier = typographyKitConfig["point-step-multiplier"] {
                TypographyKit.pointStepSize = pointStepSize
                TypographyKit.pointStepMultiplier = pointStepMultiplier
            }
            
            self.fontName = fontTextStyle[TypographyKitConfigKey.fontName.rawValue] as? String
            self.pointSize = fontTextStyle[TypographyKitConfigKey.pointSize.rawValue] as? Float
            if let textColor = fontTextStyle[TypographyKitConfigKey.textColor.rawValue] as? String {
                self.textColor = TypographyColor(string: textColor)?.uiColor
            } else {
                self.textColor = nil
            }
            if let letterCase = fontTextStyle[TypographyKitConfigKey.letterCase.rawValue] as? String {
                self.letterCase = LetterCase(rawValue: letterCase)
            } else {
                self.letterCase = nil
            }
        } else {
            return nil
        }
    }
    
    public init(fontName: String = "", fontSize: Float = 12.0, letterCase: LetterCase = .regular, textColor: UIColor = .black) {
        self.fontName = fontName
        self.pointSize = fontSize
        self.letterCase = letterCase
        self.textColor = textColor
    }
    
    public func font(_ contentSizeCategory: UIContentSizeCategory) -> UIFont? {
        guard let fontName = self.fontName,
            var pointSize = self.pointSize else {
                return nil
        }
        
        let contentSizeCategoryMap: [UIContentSizeCategory: Float] = [
            UIContentSizeCategory.extraSmall: -2,
            UIContentSizeCategory.small: -1,
            UIContentSizeCategory.medium: 0,
            UIContentSizeCategory.large: 1,
            UIContentSizeCategory.extraLarge: 2,
            UIContentSizeCategory.extraExtraLarge: 3,
            UIContentSizeCategory.extraExtraExtraLarge: 4,
            UIContentSizeCategory.accessibilityMedium: 5,
            UIContentSizeCategory.accessibilityLarge: 6,
            UIContentSizeCategory.accessibilityExtraLarge: 7,
            UIContentSizeCategory.accessibilityExtraExtraLarge: 8,
            UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 9
        ]
        
        guard let contentSizeCategoryStepMultiplier = contentSizeCategoryMap[contentSizeCategory] else {
            return nil
        }
        
        pointSize += (TypographyKit.pointStepSize * contentSizeCategoryStepMultiplier * TypographyKit.pointStepMultiplier)
        return UIFont(name: fontName, size: CGFloat(pointSize))
    }
}
