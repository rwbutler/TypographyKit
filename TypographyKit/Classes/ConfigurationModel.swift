//
//  ParsingServiceResult.swift
//  TypographyKit
//
//  Created by Ross Butler on 7/15/17.
//
//

import UIKit

struct ConfigurationModel {
    let configurationSettings: TypographyKitConfiguration
    let typographyColors: TypographyKit.Colors
    let typographyStyles: [String: Typography]
    
    init(settings: TypographyKitConfiguration, colors: TypographyKit.Colors, styles: [String: Typography]) {
        self.configurationSettings = settings
        self.typographyColors = colors
        self.typographyStyles = styles
    }
}
