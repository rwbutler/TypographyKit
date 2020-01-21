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
    static let labels = "labels"
    static let minimumPointSize = "minimum-point-size"
    static let maximumPointSize = "maximum-point-size"
    static let pointStepMultiplier = "point-step-multiplier"
    static let pointStepSize = "point-step-size"
    static let scalingMode = "scaling-mode"
    static let stylesEntry = "ui-font-text-styles"
    static let umbrellaEntry = "typography-kit"
}
typealias FontTextStyleEntries = [String: [String: Any]]
typealias ColorEntries = [String: Any]

extension ParsingService {
    
    // MARK: - Type definitions
    fileprivate typealias ExtendedTypographyStyleEntry = (existingStyleName: String, newStyle: Typography)
    
    func parse(_ configEntries: [String: Any]) -> ParsingServiceResult? {
        let configuration: ConfigurationSettings
        if let typographyKitConfig = configEntries[CodingKeys.umbrellaEntry] as? [String: Any],
            let stepSize = typographyKitConfig[CodingKeys.pointStepSize] as? Float,
            let stepMultiplier = typographyKitConfig[CodingKeys.pointStepMultiplier] as? Float {
            let labelsConfig = typographyKitConfig[CodingKeys.labels] as? [String: String]
            let labelSettings = self.labelSettings(labelsConfig)
            let minimumPointSize = typographyKitConfig[CodingKeys.minimumPointSize] as? Float
            let maximumPointSize = typographyKitConfig[CodingKeys.maximumPointSize] as? Float
            let scalingMode = typographyKitConfig[CodingKeys.scalingMode] as? String
            configuration = ConfigurationSettings(labels: labelSettings, minPointSize: minimumPointSize,
                                                  maxPointSize: maximumPointSize, pointStepSize: stepSize,
                                                  pointStepMultiplier: stepMultiplier, scalingMode: scalingMode)
        } else {
            configuration = ConfigurationSettings(labels: LabelSettings())
        }
        
        // Colors
        let colorEntries = configEntries[CodingKeys.colorsEntry] as? ColorEntries ?? [:]
        var colorParser = ColorParser(colors: colorEntries)
        let typographyColors = colorParser.parseColors()
        let uiColors = typographyColors.mapValues { $0.uiColor }
        
        // Fonts
        let fontTextStyles = configEntries[CodingKeys.stylesEntry] as? FontTextStyleEntries ?? [:]
        var fontParser = FontTextStyleParser(textStyles: fontTextStyles, colorEntries: typographyColors)
        let typographyStyles = fontParser.parseFonts()
        
        return ParsingServiceResult(settings: configuration, colors: uiColors,
                                    styles: typographyStyles)
    }
    
    /// Translates a dictionary of configuration settings into a `LabelSettings` model object.
    private func labelSettings(_ config: [String: String]?) -> LabelSettings {
        guard let config = config, let lineBreakConfig = config["line-break"],
            let lineBreak = NSLineBreakMode(string: lineBreakConfig) else {
                return LabelSettings()
        }
        return LabelSettings(lineBreak: lineBreak)
    }
    
}
