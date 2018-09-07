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
    private func trimWhitespace(_ string: String) -> String {
        return string.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func parseColorValue(_ colorValue: String, existingColors: [String: UIColor]? = nil) -> UIColor? {
        #if !TYPOGRAPHYKIT_UICOLOR_EXTENSION
        let shades: [String] = ["light ", "lighter ", "lightest ", "dark ", "darker ", "darkest ",
                                " light", " lighter", " lightest", " dark", " darker", " darkest"]
        for shade in shades {
            if colorValue.contains(shade) {
                let colorValue = trimWhitespace(colorValue.replacingOccurrences(of: shade, with: ""))
                if let existingColors = existingColors,
                    let color = existingColors[colorValue] {
                    return color.shade(trimWhitespace(shade))
                }
                return TypographyColor(string: colorValue)?.uiColor.shade(trimWhitespace(shade))
            }
        }
        #endif
        if let existingColors = existingColors,
            let color = existingColors[colorValue] {
            return color
        }
        return TypographyColor(string: colorValue)?.uiColor
    }

    func parse(_ configEntries: [String: Any]) -> ParsingServiceResult? {
        var configuration: ConfigurationSettings = ConfigurationSettings()
        var typographyColors: [String: UIColor] = [:]
        var typographyStyles: [String: Typography] = [:]

        if let typographyKitConfig = configEntries["typography-kit"] as? [String: Float],
            let pointStepSize = typographyKitConfig["point-step-size"],
            let pointStepMultiplier = typographyKitConfig["point-step-multiplier"] {
            let minimumPointSize = typographyKitConfig["minimum-point-size"]
            let maximumPointSize = typographyKitConfig["maximum-point-size"]
            configuration = ConfigurationSettings(minimumPointSize: minimumPointSize,
                                                  maximumPointSize: maximumPointSize,
                                                  pointStepSize: pointStepSize,
                                                  pointStepMultiplier: pointStepMultiplier)
        }
        var colorAliases: [String: String] = [:] // keys which are synonyms for other colors
        if let typographyColorNames = configEntries["typography-colors"] as? [String: String] {
            for (key, value) in typographyColorNames {
                if let color = parseColorValue(value) {
                    typographyColors[key] = color
                } else {
                    colorAliases[key] = value
                }
            }
        }
        for (key, value) in colorAliases {
            typographyColors[key] = parseColorValue(value, existingColors: typographyColors)
        }
        if let fontTextStyles = configEntries["ui-font-text-styles"] as? [String: [String: Any]] {
            for (fontTextStyleKey, fontTextStyle) in fontTextStyles {
                let fontName = fontTextStyle[ConfigurationKey.fontName.rawValue] as? String
                let pointSize = fontTextStyle[ConfigurationKey.pointSize.rawValue] as? Float
                var textColor: UIColor?
                if let textColorName = fontTextStyle[ConfigurationKey.textColor.rawValue] as? String {
                    if let color = typographyColors[textColorName] {
                        textColor = color
                    } else {
                        textColor = TypographyColor(string: textColorName)?.uiColor
                    }
                }
                var letterCase: LetterCase?
                if let letterCaseName = fontTextStyle[ConfigurationKey.letterCase.rawValue] as? String {
                    letterCase = LetterCase(rawValue: letterCaseName)
                }
                typographyStyles[fontTextStyleKey] = Typography(fontName: fontName, fontSize: pointSize,
                                                                letterCase: letterCase, textColor: textColor)
            }
        }
        return (configurationSettings: configuration,
                typographyColors: typographyColors,
                typographyStyles: typographyStyles)
    }
}
