//
//  ParsingServiceResult.swift
//  TypographyKit
//
//  Created by Ross Butler on 7/15/17.
//
//

import UIKit

struct ConfigurationModel {
    let configurationSettings: ConfigurationSettings
    let typographyColors: [String: UIColor]
    let typographyStyles: [String: Typography]
    
    init(settings: ConfigurationSettings, colors: [String: UIColor], styles: [String: Typography]) {
        self.configurationSettings = settings
        self.typographyColors = colors
        self.typographyStyles = styles
    }
}
