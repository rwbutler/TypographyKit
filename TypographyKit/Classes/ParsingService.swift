//
//  ParsingService.swift
//  TypographyKit
//
//  Created by Ross Butler on 7/15/17.
//
//

protocol ParsingService {
    func parse(_ data: Data) -> ParsingServiceResult?
}

extension ParsingService {
    func parse(_ configEntries: [String: Any]) -> ParsingServiceResult? {
        var configuration: ConfigurationSettings = ConfigurationSettings(pointStepSize: 2.0,
                                                                         pointStepMultiplier: 1.0)
        var typographyColors: [String: UIColor] = [:]
        var typographyStyles: [String: Typography] = [:]

        if let typographyKitConfig = configEntries["typography-kit"] as? [String: Float],
            let pointStepSize = typographyKitConfig["point-step-size"],
            let pointStepMultiplier = typographyKitConfig["point-step-multiplier"] {
            configuration = ConfigurationSettings(pointStepSize: pointStepSize,
                                                  pointStepMultiplier: pointStepMultiplier)
        }
        if let typographyColorNames = configEntries["typography-colors"] as? [String: String] {
            for (key, value) in typographyColorNames {
                typographyColors[key] = TypographyColor(string: value)?.uiColor
            }
        }
        if let fontTextStyles = configEntries["ui-font-text-styles"] as? [String: [String: Any]] {
            for (fontTextStyleKey, fontTextStyle) in fontTextStyles {
                let fontName = fontTextStyle[ConfigurationKey.fontName.rawValue] as? String
                let pointSize = fontTextStyle[ConfigurationKey.pointSize.rawValue] as? Float
                var textColor: UIColor? = nil
                if let textColorName = fontTextStyle[ConfigurationKey.textColor.rawValue] as? String {
                    if let color = typographyColors[textColorName] {
                        textColor = color
                    } else {
                        textColor = TypographyColor(string: textColorName)?.uiColor
                    }
                }
                var letterCase: LetterCase? = nil
                if let letterCaseName = fontTextStyle[ConfigurationKey.letterCase.rawValue] as? String {
                    letterCase = LetterCase(rawValue: letterCaseName)
                }
                typographyStyles[fontTextStyleKey] = Typography(fontName: fontName,
                                                                fontSize: pointSize,
                                                                letterCase: letterCase,
                                                                textColor: textColor)
            }
        }
        return (configurationSettings: configuration,
                typographyColors: typographyColors,
                typographyStyles: typographyStyles)
    }
}
