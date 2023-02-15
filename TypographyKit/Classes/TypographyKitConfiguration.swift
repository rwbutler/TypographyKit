//
//  TypographyKitConfiguration.swift
//  TypographyKit
//
//  Created by Ross Butler on 7/15/17.
//
//

import UIKit

public struct TypographyKitConfiguration: Codable {
    public static var `default`: TypographyKitConfiguration = {
#if DEBUG
let developmentColor = TypographyColor.red
let isDevelopment = true
#else
let developmentColor = TypographyColor.clear
let isDevelopment = false
#endif
        let configurationName = "TypographyKit"
        let configurationType = TypographyKit.configurationType(configurationName: configurationName)
        let configurationURL = TypographyKit.bundledConfigurationURL(name: configurationName, type: configurationType)
        return Self.init(
            buttons: ButtonSettings(titleColorApplyMode: .whereUnspecified),
            configurationName: configurationName,
            configurationType: configurationType,
            configurationURL: configurationURL,
            developmentColor: developmentColor,
            isDevelopment: isDevelopment,
            fallbackColor: .clear,
            labels: LabelSettings(lineBreakMode: .byWordWrapping),
            minPointSize: nil,
            maxPointSize: nil,
            pointStepMultiplier: 1.0,
            pointStepSize: 2.0,
            scalingMode: "uifontmetrics-with-fallback",
            shouldCrashIfColorNotFound: false,
            shouldUseDevelopmentColors: false
        )
    }()
    let buttons: ButtonSettings
    let configurationName: String
    let configurationType: ConfigurationType
    let configurationURL: URL?
    let developmentColor: TypographyColor
    let fallbackColor: TypographyColor
    let isDevelopment: Bool
    let labels: LabelSettings
    let minimumPointSize: Float?
    let maximumPointSize: Float?
    let pointStepMultiplier: Float
    let pointStepSize: Float
    let scalingMode: ScalingMode
    let shouldCrashIfColorNotFound: Bool
    let shouldUseDevelopmentColors: Bool
    
    init(
        buttons: ButtonSettings,
        configurationName: String,
        configurationType: ConfigurationType,
        configurationURL: URL?,
        developmentColor: TypographyColor,
        isDevelopment: Bool,
        fallbackColor: TypographyColor,
        labels: LabelSettings,
        minPointSize: Float? = nil,
        maxPointSize: Float? = nil,
        pointStepMultiplier: Float,
        pointStepSize: Float,
        scalingMode: String,
        shouldCrashIfColorNotFound: Bool,
        shouldUseDevelopmentColors: Bool
    ) {
        self.buttons = buttons
        self.configurationName = configurationName
        self.configurationType = configurationType
        self.configurationURL = configurationURL
        self.developmentColor = developmentColor
        self.isDevelopment = isDevelopment
        self.fallbackColor = fallbackColor
        self.labels = labels
        self.minimumPointSize = minPointSize
        self.maximumPointSize = maxPointSize
        self.pointStepSize = pointStepSize
        self.pointStepMultiplier = pointStepMultiplier
        self.scalingMode = ScalingMode(rawValue: scalingMode) ?? ScalingMode.default
        self.shouldCrashIfColorNotFound = shouldCrashIfColorNotFound
        self.shouldUseDevelopmentColors = shouldUseDevelopmentColors
    }
    
    /// Allows a copy of the struct to be created, preserving the value of all instance variables
    /// whilst allowing one or more values to be overridden.
    private func copy(
        buttons: ButtonSettings? = nil,
        configurationName: String? = nil,
        configurationType: ConfigurationType? = nil,
        configurationURL: URL? = nil,
        developmentColor: TypographyColor? = nil,
        fallbackColor: TypographyColor? = nil,
        isDevelopment: Bool? = nil,
        labels: LabelSettings? = nil,
        minimumPointSize: Float? = nil,
        maximumPointSize: Float? = nil,
        pointStepSize: Float? = nil,
        pointStepMultiplier: Float? = nil,
        scalingMode: ScalingMode? = nil,
        shouldCrashIfColorNotFound: Bool? = nil,
        shouldUseDevelopmentColors: Bool? = nil
    ) -> Self {
        let buttons: ButtonSettings = buttons ?? self.buttons
        let configurationName: String = configurationName ?? self.configurationName
        let configurationType: ConfigurationType = configurationType ?? self.configurationType
        let configurationURL: URL? = configurationURL ?? self.configurationURL
        let developmentColor: TypographyColor = developmentColor ?? self.developmentColor
        let fallbackColor: TypographyColor = fallbackColor ?? self.fallbackColor
        let isDevelopment: Bool = isDevelopment ?? self.isDevelopment
        let labels: LabelSettings = labels ?? self.labels
        let minimumPointSize: Float? = minimumPointSize ?? self.minimumPointSize
        let maximumPointSize: Float? = maximumPointSize ?? self.maximumPointSize
        let pointStepSize: Float = pointStepSize ?? self.pointStepSize
        let pointStepMultiplier: Float = pointStepMultiplier ?? self.pointStepMultiplier
        let scalingMode: ScalingMode = scalingMode ?? self.scalingMode
        let shouldCrashIfColorNotFound: Bool = shouldCrashIfColorNotFound ?? self.shouldCrashIfColorNotFound
        let shouldUseDevelopmentColors: Bool = shouldUseDevelopmentColors ?? self.shouldUseDevelopmentColors
        return .init(
            buttons: buttons,
            configurationName: configurationName,
            configurationType: configurationType,
            configurationURL: configurationURL,
            developmentColor: developmentColor,
            isDevelopment: isDevelopment,
            fallbackColor: fallbackColor,
            labels: labels,
            minPointSize: minimumPointSize,
            maxPointSize: maximumPointSize,
            pointStepMultiplier: pointStepMultiplier,
            pointStepSize: pointStepSize,
            scalingMode: scalingMode.rawValue,
            shouldCrashIfColorNotFound: shouldCrashIfColorNotFound,
            shouldUseDevelopmentColors: shouldUseDevelopmentColors
        )
    }
    
    public func setButtonSettings(_ value: ButtonSettings?) -> Self {
        copy(buttons: buttons)
    }
    
    public func setButtonTitleColorApplyMode(_ applyMode: ButtonTitleColorApplyMode?) -> Self {
        copy(buttons: buttons.setTitleColorApplyMode(titleColorApplyMode: applyMode))
    }
    
    public func setConfigurationName(_ name: String?) -> Self {
        let returnValue = copy(configurationName: name)
        if configurationURL == nil || configurationURL?.isFileURL == true {
            return returnValue.copy(
                configurationURL: TypographyKit.bundledConfigurationURL(
                    name: name ?? configurationName,
                    type: configurationType
                )
            )
        } else {
            return returnValue
        }
    }
    
    public func setConfigurationType(_ type: ConfigurationType?) -> Self {
        let returnValue = copy(configurationType: type)
        if configurationURL == nil || configurationURL?.isFileURL == true {
            return returnValue.copy(
                configurationURL: TypographyKit.bundledConfigurationURL(
                    name: configurationName,
                    type: type ?? configurationType
                )
            )
        } else {
            return returnValue
        }
    }
    
    public func setConfigurationURL(_ url: URL?) -> Self {
        copy(configurationURL: url)
    }
    
    public func setDevelopmentColor(_ color: TypographyColor?) -> Self {
        copy(developmentColor: color)
    }
    
    public func setIsDevelopment(_ value: Bool?) -> Self {
        copy(isDevelopment: value)
    }
    
    public func setFallbackColor(_ color: TypographyColor?) -> Self {
        copy(fallbackColor: color)
    }
    
    public func setLabelSettings(_ value: LabelSettings?) -> Self {
        copy(labels: labels)
    }
    
    public func setLineBreakMode(_ lineBreakMode: NSLineBreakMode?) -> Self {
        copy(labels: labels.setLineBreakMode(lineBreakMode))
    }
    
    public func setMinimumPointSize(_ size: Float?) -> Self {
        copy(minimumPointSize: size)
    }
    
    public func setMaximumPointSize(_ size: Float?) -> Self {
        copy(maximumPointSize: size)
    }
    
    public func setPointStepSize(_ stepSize: Float?) -> Self {
        copy(pointStepSize: stepSize)
    }
    
    public func setPointStepMultiplier(_ multiplier: Float?) -> Self {
        copy(pointStepMultiplier: multiplier)
    }
    
    public func setScalingMode(_ scalingMode: ScalingMode?) -> Self {
        copy(scalingMode: scalingMode)
    }
    
    public func setShouldCrashIfColorNotFound(_ shouldCrash: Bool?) -> Self {
        copy(shouldCrashIfColorNotFound: shouldCrash)
    }
    
    public func setShouldUseDevelopmentColors(_ value: Bool?) -> Self {
        copy(shouldUseDevelopmentColors: value)
    }
}

extension TypographyKitConfiguration: CustomStringConvertible {
    public var description: String {
        guard let jsonData = try? JSONEncoder().encode(self),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            return ""
        }
        return jsonString
    }
}

extension TypographyKitConfiguration: Equatable {
    public static func == (lhs: TypographyKitConfiguration, rhs: TypographyKitConfiguration) -> Bool {
        return true
    }
}
