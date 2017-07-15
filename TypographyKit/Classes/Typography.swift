//
//  Typography.swift
//  TypographyKit
//
//  Created by Ross Butler on 5/16/17.
//
//

public struct Typography {
    public let fontName: String?
    public let pointSize: Float? // base point size for font
    public var letterCase: LetterCase?
    public var textColor: UIColor?
    private static let contentSizeCategoryMap: [UIContentSizeCategory: Float] = [
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

    public init?(for textStyle: UIFontTextStyle) {
        if let typographyStyle = TypographyKit.fontTextStyles[textStyle.rawValue] {
            fontName = typographyStyle.fontName
            pointSize = typographyStyle.pointSize
            letterCase = typographyStyle.letterCase
            textColor = typographyStyle.textColor
        } else {
            return nil
        }
    }

    public init(fontName: String? = nil,
                fontSize: Float? = nil,
                letterCase: LetterCase? = nil,
                textColor: UIColor? = nil) {
        self.fontName = fontName
        self.pointSize = fontSize
        self.letterCase = letterCase
        self.textColor = textColor
    }

    public func font(_ contentSizeCategory: UIContentSizeCategory) -> UIFont? {
        guard let fontName = self.fontName,
            var pointSize = self.pointSize,
            let contentSizeCategoryStepMultiplier = type(of: self).contentSizeCategoryMap[contentSizeCategory] else {
            return nil
        }
        pointSize += (TypographyKit.pointStepSize
            * contentSizeCategoryStepMultiplier
            * TypographyKit.pointStepMultiplier)
        return UIFont(name: fontName, size: CGFloat(pointSize))
    }
}
