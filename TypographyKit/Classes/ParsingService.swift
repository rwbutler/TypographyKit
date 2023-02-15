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
    func parse(_ data: Data, with existingConfig: TypographyKitConfiguration) -> ConfigurationParsingResult
}

private enum CodingKeys {
    static let buttons = "buttons"
    static let colorsEntry = "typography-colors"
    static let configurationName = "configuration-name"
    static let configurationType = "configuration-type"
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
    
    func parse(_ configEntries: [String: Any], with existingConfig: TypographyKitConfiguration) -> ConfigurationParsingResult {
        // Colors
        let typographyKitDevelopmentColorKey = "development-color"
        let typographyKitFallbackColorKey = "fallback-color"
        var colorEntries = configEntries[CodingKeys.colorsEntry] as? ColorEntries ?? [:]
        let typographyColors: TypographyColors
        
        // Configuration
        let configuration: TypographyKitConfiguration
        if let typographyKitConfig = configEntries[CodingKeys.umbrellaEntry] as? [String: Any] {
            let developmentColorKey = typographyKitConfig[CodingKeys.developmentColor] as? String
            if colorEntries[typographyKitDevelopmentColorKey] == nil {
                colorEntries[typographyKitDevelopmentColorKey] = developmentColorKey
            }
            let fallbackColorKey = typographyKitConfig[CodingKeys.fallbackColor] as? String
            if colorEntries[typographyKitFallbackColorKey] == nil {
                colorEntries[typographyKitFallbackColorKey] = fallbackColorKey
            }
            var colorParser = ColorParser(colors: colorEntries)
            typographyColors = colorParser.parseColors()
            let buttonsConfig = typographyKitConfig[CodingKeys.buttons] as? [String: String]
            let buttonSettings = self.buttonSettings(buttonsConfig)
            let configurationName = (typographyKitConfig[CodingKeys.configurationName] as? String) ?? "TypographyKit"
            let configurationType: ConfigurationType
            if let configTypeString = typographyKitConfig[CodingKeys.configurationType] as? String {
                configurationType = ConfigurationType(rawValue: configTypeString)
                ?? TypographyKit.configurationType(configurationName: configurationName)
            } else {
                configurationType = TypographyKit.configurationType(configurationName: configurationName)
            }
            
            let configurationURL: URL?
            if let parsedURL = typographyKitConfig[CodingKeys.configurationURL] as? URL {
                configurationURL = parsedURL
            } else {
                configurationURL = TypographyKit.bundledConfigurationURL(
                    name: configurationName,
                    type: configurationType
                )
            }
            let developmentColor = typographyColors[developmentColorKey ?? ""]
            let fallbackColor = typographyColors[fallbackColorKey ?? ""]
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
            
            configuration = existingConfig
                .setButtonSettings(buttonSettings)
                .setConfigurationName(configurationName)
                .setConfigurationType(configurationType)
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
            var colorParser = ColorParser(colors: colorEntries)
            typographyColors = colorParser.parseColors()
            configuration = existingConfig
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
