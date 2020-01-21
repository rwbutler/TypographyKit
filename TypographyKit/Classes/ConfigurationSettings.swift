//
//  ConfigurationSettings.swift
//  TypographyKit
//
//  Created by Ross Butler on 7/15/17.
//
//

struct ConfigurationSettings {
    
    /// Settings which apply specifically to labels.
    let labels: LabelSettings
    let minimumPointSize: Float?
    let maximumPointSize: Float?
    let pointStepSize: Float
    let pointStepMultiplier: Float
    let scalingMode: ScalingMode?
    
    init(labels: LabelSettings, minPointSize: Float? = nil, maxPointSize: Float? = nil,
         pointStepSize: Float = 2.0, pointStepMultiplier: Float = 1.0, scalingMode: String? = nil) {
        self.labels = labels
        self.minimumPointSize = minPointSize
        self.maximumPointSize = maxPointSize
        self.pointStepSize = pointStepSize
        self.pointStepMultiplier = pointStepMultiplier
        if let scalingModeStr = scalingMode {
            self.scalingMode = ScalingMode(rawValue: scalingModeStr)
        } else {
            self.scalingMode = nil
        }
    }
    
}
