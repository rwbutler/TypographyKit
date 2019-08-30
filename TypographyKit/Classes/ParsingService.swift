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
typealias FontTextStyleEntries = [String: [String: Any]]
typealias ColorEntries = [String: Any]

extension ParsingService {
    
    // MARK: - Type definitions
    fileprivate typealias ExtendedTypographyStyleEntry = (existingStyleName: String, newStyle: Typography)
    
    func parse(_ configEntries: [String: Any]) -> ParsingServiceResult? {
        var configuration = ConfigurationSettings()
        
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
        
        let colorEntries = configEntries[CodingKeys.colorsEntry] as? ColorEntries ?? [:]
        var colorParser = ColorParser(colors: colorEntries)
        let typographyColors = colorParser.parseColors()
        let uiColors = typographyColors.mapValues { $0.uiColor }
        
        let fontTextStyles = configEntries[CodingKeys.stylesEntry] as? FontTextStyleEntries ?? [:]
        var fontParser = FontTextStyleParser(textStyles: fontTextStyles, colorEntries: typographyColors)
        let typographyStyles = fontParser.parseFonts()
        
        return ParsingServiceResult(settings: configuration, colors: uiColors,
                                    styles: typographyStyles)
    }    
}
