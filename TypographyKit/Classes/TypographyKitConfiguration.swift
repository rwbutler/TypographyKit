//
//  TypographyKitConfiguration.swift
//  TypographyKit
//
//  Created by Ross Butler on 7/15/17.
//
//

import UIKit

public struct TypographyKitConfiguration {
    let buttons: ButtonSettings
    let developmentColor: TypographyColor
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
        buttons: ButtonSettings = ButtonSettings(),
        developmentColor: TypographyColor,
        isDevelopment: Bool,
        labels: LabelSettings = LabelSettings(),
        minPointSize: Float? = nil,
        maxPointSize: Float? = nil,
        pointStepMultiplier: Float,
        pointStepSize: Float,
        scalingMode: String? = nil,
        shouldCrashIfColorNotFound: Bool = false,
        shouldUseDevelopmentColors: Bool = false
    ) {
        self.buttons = buttons
        self.developmentColor = developmentColor
        self.isDevelopment = isDevelopment
        self.labels = labels
        self.minimumPointSize = minPointSize
        self.maximumPointSize = maxPointSize
        self.pointStepSize = pointStepSize
        self.pointStepMultiplier = pointStepMultiplier
        if let scalingModeStr = scalingMode {
            self.scalingMode = ScalingMode(rawValue: scalingModeStr) ?? ScalingMode.default
        } else {
            self.scalingMode = ScalingMode.default
        }
        self.shouldCrashIfColorNotFound = shouldCrashIfColorNotFound
        self.shouldUseDevelopmentColors = shouldUseDevelopmentColors
    }
    
    /// Allows a copy of the struct to be created, preserving the value of all instance variables
    /// whilst allowing one or more values to be overridden.
    private func copy(
        buttons: ButtonSettings? = nil,
        developmentColor: TypographyColor? = nil,
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
        let developmentColor: TypographyColor = developmentColor ?? self.developmentColor
        let isDevelopment: Bool = isDevelopment ?? self.isDevelopment
        let labels: LabelSettings = labels ?? self.labels
        let minimumPointSize: Float? = minimumPointSize ?? self.minimumPointSize
        let maximumPointSize: Float? = maximumPointSize ?? self.maximumPointSize
        let pointStepSize: Float = pointStepSize ?? self.pointStepSize
        let pointStepMultiplier: Float = pointStepMultiplier ?? self.pointStepMultiplier
        let scalingMode: ScalingMode? = scalingMode ?? self.scalingMode
        let shouldCrashIfColorNotFound: Bool = shouldCrashIfColorNotFound ?? self.shouldCrashIfColorNotFound
        let shouldUseDevelopmentColors: Bool = shouldUseDevelopmentColors ?? self.shouldUseDevelopmentColors
        return .init(
            buttons: buttons,
            developmentColor: developmentColor,
            isDevelopment: isDevelopment,
            labels: labels,
            minPointSize: minimumPointSize,
            maxPointSize: maximumPointSize,
            pointStepMultiplier: pointStepMultiplier,
            pointStepSize: pointStepSize,
            scalingMode: scalingMode?.rawValue,
            shouldCrashIfColorNotFound: shouldCrashIfColorNotFound,
            shouldUseDevelopmentColors: shouldUseDevelopmentColors
        )
    }
    
    func setButtonTitleColorApplyMode(_ value: ButtonTitleColorApplyMode) -> Self {
        copy(buttons: ButtonSettings(titleColorApplyMode: value))
    }
    
    func setDevelopmentColor(_ color: TypographyColor) -> Self {
        copy(developmentColor: color)
    }
    
    func setIsDevelopment(_ value: Bool) -> Self {
        copy(isDevelopment: value)
    }
    
    func setLinkBreakMode(_ mode: NSLineBreakMode) -> Self {
        copy(labels: LabelSettings(lineBreakMode: mode))
    }
    
    func setMinimumPointSize(_ size: Float) -> Self {
        copy(minimumPointSize: size)
    }
    
    func setMaximumPointSize(_ size: Float) -> Self {
        copy(maximumPointSize: size)
    }
    
    func setPointStepSize(_ stepSize: Float) -> Self {
        copy(pointStepSize: stepSize)
    }
    
    func setPointStepMultiplier(_ multiplier: Float) -> Self {
        copy(pointStepMultiplier: multiplier)
    }
    
    func setScalingMode(_ scalingMode: ScalingMode) -> Self {
        copy(scalingMode: scalingMode)
    }
    
    func shouldCrashIfColorNotFound(_ shouldCrash: Bool) -> Self {
        copy(shouldCrashIfColorNotFound: shouldCrash)
    }
    
    func shouldUseDevelopmentColors(_ value: Bool) -> Self {
        copy(shouldUseDevelopmentColors: value)
    }
}
