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

private enum CodingKeys {
    static let colorsEntry = "typography-colors"
    static let minimumPointSize = "minimum-point-size"
    static let maximumPointSize = "maximum-point-size"
    static let pointStepMultiplier = "point-step-multiplier"
    static let pointStepSize = "point-step-size"
    static let scalingMode = "scaling-mode"
    static let stylesEntry = "ui-font-text-styles"
    static let umbrellaEntry = "typography-kit"
}

extension ParsingService {
    
    // MARK: - Type definitions
    fileprivate typealias ColorEntries = [String: String]
    fileprivate typealias ExtendedTypographyStyleEntry = (existingStyleName: String, newStyle: Typography)
    fileprivate typealias FontTextStyleEntries = [String: [String: Any]]
    
    func parse(_ configEntries: [String: Any]) -> ParsingServiceResult? {
        var configuration = ConfigurationSettings()
        var typographyColors: TypographyColors = [:]
        var typographyStyles: TypographyStyles = [:]
        
        if let typographyKitConfig = configEntries[CodingKeys.umbrellaEntry] as? [String: Any],
            let stepSize = typographyKitConfig[CodingKeys.pointStepSize] as? Float,
            let stepMultiplier = typographyKitConfig[CodingKeys.pointStepMultiplier] as? Float {
            let minimumPointSize = typographyKitConfig[CodingKeys.minimumPointSize] as? Float
            let maximumPointSize = typographyKitConfig[CodingKeys.maximumPointSize] as? Float
            let scalingMode = typographyKitConfig[CodingKeys.scalingMode] as? String
            configuration = ConfigurationSettings(minPointSize: minimumPointSize, maxPointSize: maximumPointSize,
                                                  pointStepSize: stepSize, pointStepMultiplier: stepMultiplier,
                                                  scalingMode: scalingMode)
        }
        if let jsonColorEntries = configEntries[CodingKeys.colorsEntry] as? ColorEntries {
            typographyColors = parseColorEntries(jsonColorEntries)
        }
        if let fontTextStyles = configEntries[CodingKeys.stylesEntry] as? FontTextStyleEntries {
            typographyStyles = parseFontTextStyleEntries(fontTextStyles, colorEntries: typographyColors)
        }
        return ParsingServiceResult(settings: configuration, colors: typographyColors,
                                    styles: typographyStyles)
    }
    
}

private extension ParsingService {
    
    /// Extends the original Typography style with another style, replacing properties of the
    /// original with those of the new style where defined.
    private func extend(_ original: Typography, with modified: Typography) -> Typography {
        let newFace = modified.fontName ?? original.fontName
        let newSize = modified.pointSize ?? original.pointSize
        let newCase = modified.letterCase ?? original.letterCase
        let newColor = modified.textColor ?? original.textColor
        return Typography(name: modified.name, fontName: newFace, fontSize: newSize,
                          letterCase: newCase, textColor: newColor)
    }
    
    /// Parses a color represented as a `String`.
    private func parseColorString(_ colorString: String, colorEntries: TypographyColors = [:]) -> UIColor? {
        #if !TYPOGRAPHYKIT_UICOLOR_EXTENSION
        let shades = ["light", "lighter", "lightest", "dark", "darker", "darkest"]
        for shade in shades where colorString.contains(shade) {
            let withWhitespaces = [" \(shade)", "\(shade) "]
            for withWhitespace in withWhitespaces where colorString.contains(withWhitespace) {
                let colorValue = trimWhitespace(colorString.replacingOccurrences(of: withWhitespace, with: ""))
                if let color = colorEntries[colorValue] {
                    return color.shade(shade)
                }
                return TypographyColor(string: colorValue)?.uiColor.shade(shade)
            }
        }
        #endif
        if let color = colorEntries[colorString] {
            return color
        }
        return TypographyColor(string: colorString)?.uiColor
    }
    
    /// Parses color definitions from the configuration file.
    /// - parameter jsonColorEntries: A dictionary representing color names mapping to
    /// color values as defined in the configuration file.
    /// - returns: A dictionary mapping from the color name to the color value.
    private func parseColorEntries(_ colorEntries: ColorEntries) -> TypographyColors {
        var result: TypographyColors = [:]
        var extendedColors: [(colorKey: String, colorValue: String)] = [] // Keys which are synonyms for other colors.
        for (colorName, colorValue) in colorEntries {
            if let color = parseColorString(colorValue) {
                result[colorName] = color
            } else {
                extendedColors.append((colorName, colorValue))
            }
            for extendedColor in extendedColors {
                let colorValue = extendedColor.colorValue
                if let newColor = parseColorString(colorValue, colorEntries: result) {
                    result[extendedColor.colorKey] = newColor
                }
            }
            // Keep colors which cannot yet be parsed.
            extendedColors = extendedColors.filter { result[$0.colorKey] == nil }
        }
        for extendedColor in extendedColors {
            if let newColor = parseColorString(extendedColor.colorValue, colorEntries: result) {
                result[extendedColor.colorKey] = newColor
            }
        }
        return result
    }
    
    /// Parse UIFontTextStyle definitions from configuration file.
    private func parseFontTextStyleEntries(_ styleEntries: FontTextStyleEntries, colorEntries: TypographyColors)
        -> TypographyStyles {
            var typographyStyles: TypographyStyles = [:]
            // Typography objects which are extensions of existing styles.
            var extendedTypographyStyles: [ExtendedTypographyStyleEntry] = []
            for (fontTextStyleKey, fontTextStyle) in styleEntries {
                let fontName = fontTextStyle[ConfigurationKey.fontName.rawValue] as? String
                let pointSize = fontTextStyle[ConfigurationKey.pointSize.rawValue] as? Float
                var textColor: UIColor?
                if let textColorName = fontTextStyle[ConfigurationKey.textColor.rawValue] as? String {
                    if let color = colorEntries[textColorName] {
                        textColor = color
                    } else {
                        textColor = parseColorString(textColorName, colorEntries: colorEntries)
                    }
                }
                var letterCase: LetterCase?
                if let letterCaseName = fontTextStyle[ConfigurationKey.letterCase.rawValue] as? String {
                    letterCase = LetterCase(rawValue: letterCaseName)
                }
                
                if let existingStyleName = fontTextStyle[ConfigurationKey.extends.rawValue] as? String {
                    let newStyle = Typography(name: fontTextStyleKey, fontName: fontName, fontSize: pointSize,
                                              letterCase: letterCase, textColor: textColor)
                    if let existingStyle = typographyStyles[existingStyleName] {
                        typographyStyles[fontTextStyleKey] = extend(existingStyle, with: newStyle)
                    } else {
                        extendedTypographyStyles.append((existingStyleName, newStyle))
                    }
                } else {
                    let style = Typography(name: fontTextStyleKey, fontName: fontName, fontSize: pointSize,
                                           letterCase: letterCase, textColor: textColor)
                    typographyStyles[fontTextStyleKey] = style
                    
                    // Iterate to find out whether any previously-defined styles extend this newly-parsed style.
                    for extendedStyle in extendedTypographyStyles
                        where extendedStyle.existingStyleName == fontTextStyleKey {
                            let newStyleKey = extendedStyle.newStyle.name
                            typographyStyles[newStyleKey] = extend(style, with: extendedStyle.newStyle)
                    }
                }
            }
            return typographyStyles
    }
    
    /// Returns the provided the provided `String` with whitespace trimmed.
    /// - parameter string: The `String` to be trimmed.
    /// - returns: The original `String` with whitespace trimmed.
    private func trimWhitespace(_ string: String) -> String {
        return string.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
}
