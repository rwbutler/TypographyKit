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

    init(minPointSize: Float? = nil, maxPointSize: Float? = nil,
         pointStepSize: Float = 2.0, pointStepMultiplier: Float = 1.0) {
        self.minimumPointSize = minPointSize
        self.maximumPointSize = maxPointSize
        self.pointStepSize = pointStepSize
        self.pointStepMultiplier = pointStepMultiplier
    }
}
