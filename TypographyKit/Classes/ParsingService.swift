//
//  ParsingService.swift
//  TypographyKit
//
//  Created by Ross Butler on 7/15/17.
//
//

import Foundation
import UIKit

typealias ConfigurationParsingResult = Result<ConfigurationModel, ConfigurationParsingError>

protocol ConfigurationParsingService {
    func parse(_ data: Data) -> ConfigurationParsingResult
}

private enum CodingKeys {
    static let buttons = "buttons"
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

extension ConfigurationParsingService {
    
    // MARK: - Type definitions
    fileprivate typealias ExtendedTypographyStyleEntry = (existingStyleName: String, newStyle: Typography)
    
    func parse(_ configEntries: [String: Any]) -> ConfigurationParsingResult {
        let configuration: TypographyKitConfiguration
        if let typographyKitConfig = configEntries[CodingKeys.umbrellaEntry] as? [String: Any],
           let stepSize = typographyKitConfig[CodingKeys.pointStepSize] as? Float,
           let stepMultiplier = typographyKitConfig[CodingKeys.pointStepMultiplier] as? Float {
            let buttonsConfig = typographyKitConfig[CodingKeys.buttons] as? [String: String]
            let labelsConfig = typographyKitConfig[CodingKeys.labels] as? [String: String]
            let buttonSettings = self.buttonSettings(buttonsConfig)
            let labelSettings = self.labelSettings(labelsConfig)
            let minimumPointSize = typographyKitConfig[CodingKeys.minimumPointSize] as? Float
            let maximumPointSize = typographyKitConfig[CodingKeys.maximumPointSize] as? Float
            let scalingMode = typographyKitConfig[CodingKeys.scalingMode] as? String
            configuration = TypographyKitConfiguration(
                buttons: buttonSettings,
                labels: labelSettings,
                minPointSize: minimumPointSize,
                maxPointSize: maximumPointSize,
                pointStepSize: stepSize,
                pointStepMultiplier: stepMultiplier,
                scalingMode: scalingMode
            )
        } else {
            configuration = TypographyKitConfiguration(buttons: ButtonSettings(), labels: LabelSettings())
        }
        
        // Colors
        let colorEntries = configEntries[CodingKeys.colorsEntry] as? ColorEntries ?? [:]
        var colorParser = ColorParser(colors: colorEntries)
        let typographyColors = colorParser.parseColors()
        
        // Fonts
        let fontTextStyles = configEntries[CodingKeys.stylesEntry] as? FontTextStyleEntries ?? [:]
        var fontParser = FontTextStyleParser(textStyles: fontTextStyles, colorEntries: typographyColors)
        let typographyStyles = fontParser.parseFonts()
        let config = ConfigurationModel(settings: configuration, colors: typographyColors, styles: typographyStyles)
        return .success(config)
    }
    
    /// Translates a dictionary of configuration settings into a `ButtonSettings` model object.
    private func buttonSettings(_ config: [String: String]?) -> ButtonSettings {
        guard let config = config,
              let lineBreakConfig = config["title-color-apply"],
              let applyMode = UIButton.TitleColorApplyMode(string: lineBreakConfig) else {
            return ButtonSettings()
        }
        return ButtonSettings(titleColorApplyMode: applyMode)
    }
    
    /// Translates a dictionary of configuration settings into a `LabelSettings` model object.
    private func labelSettings(_ config: [String: String]?) -> LabelSettings {
        guard let config = config, let lineBreakConfig = config["line-break"],
              let lineBreakMode = NSLineBreakMode(string: lineBreakConfig) else {
            return LabelSettings()
        }
        return LabelSettings(lineBreakMode: lineBreakMode)
    }
    
}
