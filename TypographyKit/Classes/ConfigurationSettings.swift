//
//  ConfigurationSettings.swift
//  TypographyKit
//
//  Created by Ross Butler on 7/15/17.
//
//

struct ConfigurationSettings {
    let minimumPointSize: Float?
    let maximumPointSize: Float?
    let pointStepSize: Float
    let pointStepMultiplier: Float

    init(minimumPointSize: Float? = nil, maximumPointSize: Float? = nil,
         pointStepSize: Float = 2.0, pointStepMultiplier: Float = 1.0) {
        self.minimumPointSize = minimumPointSize
        self.maximumPointSize = maximumPointSize
        self.pointStepSize = pointStepSize
        self.pointStepMultiplier = pointStepMultiplier
    }
}
