//
//  Typography.swift
//  TypographyKit
//
//  Created by Ross Butler on 5/16/17.
//
//

public struct Typography {
    public let name: String
    public let fontName: String?
    public let pointSize: Float? // base point size for font
    public var letterCase: LetterCase?
    public var textColor: UIColor?
    private static let contentSizeCategoryMap: [UIContentSizeCategory: Float] = [
        UIContentSizeCategory.extraSmall: -3,
        UIContentSizeCategory.small: -2,
        UIContentSizeCategory.medium: -1,
        UIContentSizeCategory.large: 0,
        UIContentSizeCategory.extraLarge: 1,
        UIContentSizeCategory.extraExtraLarge: 2,
        UIContentSizeCategory.extraExtraExtraLarge: 3,
        UIContentSizeCategory.accessibilityMedium: 4,
        UIContentSizeCategory.accessibilityLarge: 5,
        UIContentSizeCategory.accessibilityExtraLarge: 6,
        UIContentSizeCategory.accessibilityExtraExtraLarge: 7,
        UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 8
    ]

    public init?(for textStyle: UIFont.TextStyle) {
        if let typographyStyle = TypographyKit.fontTextStyles[textStyle.rawValue] {
            name = typographyStyle.name
            fontName = typographyStyle.fontName
            pointSize = typographyStyle.pointSize
            letterCase = typographyStyle.letterCase
            textColor = typographyStyle.textColor
        } else {
            return nil
        }
    }

    public init(name: String,
                fontName: String? = nil,
                fontSize: Float? = nil,
                letterCase: LetterCase? = nil,
                textColor: UIColor? = nil) {
        self.name = name
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
        if let minimumPointSize = TypographyKit.minimumPointSize, pointSize < minimumPointSize {
            pointSize = minimumPointSize
        }
        if let maximumPointSize = TypographyKit.maximumPointSize, maximumPointSize < pointSize {
            pointSize = maximumPointSize
        }
        return UIFont(name: fontName, size: CGFloat(pointSize))
    }
}
