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
    static let developmentColor = "development-color"
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
            let developmentColorKey = typographyKitConfig[CodingKeys.developmentColor] as? String
            let isDevelopmentConfig = typographyKitConfig[CodingKeys.isDevelopment] as? Bool
            let labelsConfig = typographyKitConfig[CodingKeys.labels] as? [String: String]
            let buttonSettings = self.buttonSettings(buttonsConfig)
            let labelSettings = self.labelSettings(labelsConfig)
            let minimumPointSize = typographyKitConfig[CodingKeys.minimumPointSize] as? Float
            let maximumPointSize = typographyKitConfig[CodingKeys.maximumPointSize] as? Float
            let pointStepMultiplier = (typographyKitConfig[CodingKeys.pointStepMultiplier] as? Float) ?? 1.0
            let pointStepSize = (typographyKitConfig[CodingKeys.pointStepSize] as? Float) ?? 2.0
            let scalingMode = typographyKitConfig[CodingKeys.scalingMode] as? String
            let shouldCrashIfColorNotFound = (typographyKitConfig[CodingKeys.shouldCrashIfColorNotFound] as? Bool)
                ?? false
            /*
             Determine whether should be set to inDevelopment from config or whether to apply default logic.
             */
            let isDevelopment: Bool
            if let _isDevelopment = isDevelopmentConfig {
                isDevelopment = _isDevelopment
            } else {
#if DEBUG
                isDevelopment = true
#else
                isDevelopment = false
#endif
            }
            
            /*
             Determine whether a development color should be set from config
             or whether to fallback to defaults.
             */
            let developmentColor: TypographyColor
            if let developmentColorKey = developmentColorKey,
               let _developmentColor = typographyColors[developmentColorKey] {
                developmentColor = _developmentColor
            } else {
                developmentColor = isDevelopment ? .red : .clear
            }
            
            configuration = TypographyKitConfiguration(
                buttons: buttonSettings,
                developmentColor: developmentColor,
                isDevelopment: isDevelopment,
                labels: labelSettings,
                minPointSize: minimumPointSize,
                maxPointSize: maximumPointSize,
                pointStepMultiplier: pointStepMultiplier,
                pointStepSize: pointStepSize,
                scalingMode: scalingMode,
                shouldCrashIfColorNotFound: shouldCrashIfColorNotFound
            )
        } else {
            // Could not parse TypographyKit configuration file - fallback to sensible defaults.
            let isDevelopment: Bool
            let developmentColor: TypographyColor
#if DEBUG
            developmentColor = .red
            isDevelopment = true
#else
            developmentColor = .clear
            isDevelopment = false
#endif
            configuration = TypographyKitConfiguration(
                buttons: ButtonSettings(),
                developmentColor: developmentColor,
                isDevelopment: isDevelopment,
                labels: LabelSettings(),
                pointStepMultiplier: 1.0,
                pointStepSize: 2.0,
                shouldCrashIfColorNotFound: false,
                shouldUseDevelopmentColors: false
            )
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
