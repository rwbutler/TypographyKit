//
//  ParsingService.swift
//  TypographyKit
//
//  Created by Ross Butler on 7/15/17.
//
//

import Foundation
import UIKit

typealias ConfigurationParsingResult = Result<TypographyKitSettings, ConfigurationParsingError>

protocol ConfigurationParsingService {
    func parse(_ data: Data) -> ConfigurationParsingResult
}

private enum CodingKeys {
    static let buttons = "buttons"
    static let colorsEntry = "typography-colors"
    static let configurationURL = "configuration-url"
    static let developmentColor = "development-color"
    static let fallbackColor = "fallback-color"
    static let isDevelopment = "is-development"
    static let labels = "labels"
    static let minimumPointSize = "minimum-point-size"
    static let maximumPointSize = "maximum-point-size"
    static let pointStepMultiplier = "point-step-multiplier"
    static let pointStepSize = "point-step-size"
    static let scalingMode = "scaling-mode"
    static let shouldCrashIfColorNotFound = "should-crash-if-color-not-found"
    static let shouldUseDevelopmentColors = "should-use-development-colors"
    static let stylesEntry = "ui-font-text-styles"
    static let umbrellaEntry = "typography-kit"
}
typealias FontTextStyleEntries = [String: [String: Any]]
typealias ColorEntries = [String: Any]

extension ConfigurationParsingService {
    
    // MARK: - Type definitions
    fileprivate typealias ExtendedTypographyStyleEntry = (existingStyleName: String, newStyle: Typography)
    
    func parse(_ configEntries: [String: Any]) -> ConfigurationParsingResult {
        // Colors
        let colorEntries = configEntries[CodingKeys.colorsEntry] as? ColorEntries ?? [:]
        var colorParser = ColorParser(colors: colorEntries)
        let typographyColors = colorParser.parseColors()
        
        // Configuration
        let configuration: TypographyKitConfiguration
        if let typographyKitConfig = configEntries[CodingKeys.umbrellaEntry] as? [String: Any] {
            
            let buttonsConfig = typographyKitConfig[CodingKeys.buttons] as? [String: String]
            let buttonSettings = self.buttonSettings(buttonsConfig)
            let configurationURL = typographyKitConfig[CodingKeys.configurationURL] as? URL
            let developmentColor: TypographyColor?
            if let developmentColorKey = typographyKitConfig[CodingKeys.developmentColor] as? String {
                developmentColor = typographyColors[developmentColorKey]
            } else {
                developmentColor = nil
            }
            let fallbackColor: TypographyColor?
            if let fallbackColorKey = typographyKitConfig[CodingKeys.fallbackColor] as? String {
                fallbackColor = typographyColors[fallbackColorKey]
            } else {
                fallbackColor = nil
            }
            let isDevelopment = typographyKitConfig[CodingKeys.isDevelopment] as? Bool
            let labelsConfig = typographyKitConfig[CodingKeys.labels] as? [String: String]
            let labelSettings = self.labelSettings(labelsConfig)
            let minimumPointSize = typographyKitConfig[CodingKeys.minimumPointSize] as? Float
            let maximumPointSize = typographyKitConfig[CodingKeys.maximumPointSize] as? Float
            let pointStepMultiplier = typographyKitConfig[CodingKeys.pointStepMultiplier] as? Float
            let pointStepSize = typographyKitConfig[CodingKeys.pointStepSize] as? Float
            let scalingMode: ScalingMode?
            if let scalingModeKey = typographyKitConfig[CodingKeys.scalingMode] as? String {
                scalingMode = ScalingMode(rawValue: scalingModeKey)
            } else {
                scalingMode = nil
            }
            let shouldCrashIfColorNotFound = typographyKitConfig[CodingKeys.shouldCrashIfColorNotFound] as? Bool
            let shouldUseDevelopmentColors = typographyKitConfig[CodingKeys.shouldUseDevelopmentColors] as? Bool
            
            configuration = TypographyKitConfiguration.default
                .setButtonSettings(buttonSettings)
                .setConfigurationURL(configurationURL)
                .setDevelopmentColor(developmentColor)
                .setFallbackColor(fallbackColor)
                .setIsDevelopment(isDevelopment)
                .setLabelSettings(labelSettings)
                .setMinimumPointSize(minimumPointSize)
                .setMaximumPointSize(maximumPointSize)
                .setPointStepMultiplier(pointStepMultiplier)
                .setPointStepSize(pointStepSize)
                .setScalingMode(scalingMode)
                .setShouldCrashIfColorNotFound(shouldCrashIfColorNotFound)
                .setShouldUseDevelopmentColors(shouldUseDevelopmentColors)
        } else {
            configuration = TypographyKitConfiguration.default
        }
        
        // Fonts
        let fontTextStyles = configEntries[CodingKeys.stylesEntry] as? FontTextStyleEntries ?? [:]
        var fontParser = FontTextStyleParser(textStyles: fontTextStyles, colorEntries: typographyColors)
        let typographyStyles = fontParser.parseFonts()
        let config = TypographyKitSettings(
            colors: typographyColors,
            configuration: configuration,
            styles: typographyStyles
        )
        return .success(config)
    }
    
    /// Translates a dictionary of configuration settings into a `ButtonSettings` model object.
    private func buttonSettings(_ config: [String: String]?) -> ButtonSettings? {
        guard let config = config,
              let lineBreakConfig = config["title-color-apply-mode"],
              let applyMode = UIButton.TitleColorApplyMode(string: lineBreakConfig) else {
            return nil
        }
        return ButtonSettings(titleColorApplyMode: applyMode)
    }
    
    /// Translates a dictionary of configuration settings into a `LabelSettings` model object.
    private func labelSettings(_ config: [String: String]?) -> LabelSettings? {
        guard let config = config, let lineBreakConfig = config["line-break-mode"],
              let lineBreakMode = NSLineBreakMode(string: lineBreakConfig) else {
            return nil
        }
        return LabelSettings(lineBreakMode: lineBreakMode)
    }
    
}
